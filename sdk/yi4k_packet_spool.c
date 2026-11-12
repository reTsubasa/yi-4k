#include "yi4k_packet_spool.h"

#define MAGIC UINT32_C(0x53504f4c)
#define HEADER 160u
#define COMMIT 24u

static void copy(uint8_t *d, const uint8_t *s, uint32_t n) {
    while (n--) *d++ = *s++;
}
static void zero(uint8_t *d, uint32_t n) { while (n--) *d++ = 0; }
static int same(const uint8_t *a, const uint8_t *b, uint32_t n) {
    while (n--) if (*a++ != *b++) return 0;
    return 1;
}
static int valid(const void *p, size_t n) {
    return p && n <= UINTPTR_MAX - (uintptr_t)p;
}
static int overlap(const void *p, size_t n, const void *q, size_t m) {
    return (uintptr_t)p < (uintptr_t)q + m && (uintptr_t)q < (uintptr_t)p + n;
}
static void put32(uint8_t *p, uint32_t v) {
    uint32_t i; for (i=0; i<4; ++i) { p[i]=(uint8_t)v; v>>=8; }
}
static void put64(uint8_t *p, uint64_t v) {
    put32(p,(uint32_t)v); put32(p+4,(uint32_t)(v>>32));
}
static uint32_t get32(const uint8_t *p) {
    return (uint32_t)p[0] | (uint32_t)p[1]<<8 | (uint32_t)p[2]<<16 | (uint32_t)p[3]<<24;
}
static uint64_t get64(const uint8_t *p) {
    return get32(p) | (uint64_t)get32(p+4)<<32;
}
static uint32_t crc(const uint8_t *p, uint32_t n) {
    static const uint32_t table[16]={
        0,0x1db71064,0x3b6e20c8,0x26d930ac,0x76dc4190,0x6b6b51f4,0x4db26158,0x5005713c,
        0xedb88320,0xf00f9344,0xd6d6a3e8,0xcb61b38c,0x9b64c2b0,0x86d3d2d4,0xa00ae278,0xbdbdf21c};
    uint32_t c=UINT32_MAX;
    while (n--) { c^=*p++; c=(c>>4)^table[c&15]; c=(c>>4)^table[c&15]; }
    return c^UINT32_MAX;
}
static int identity_valid(const yi4k_spool_identity *id) {
    uint32_t i,v=0;
    if (!valid(id,sizeof(*id)) || !id->session || !id->segment || !id->epoch) return 0;
    for(i=0;i<32;++i) v|=id->config_digest[i];
    return v!=0;
}
static int io_valid(const yi4k_spool_io *io) {
    return valid(io,sizeof(*io)) && io->size && io->read && io->write && io->sync;
}
static int32_t read_exact(const yi4k_spool_io *io,uint64_t at,uint8_t *p,uint32_t n) {
    uint32_t got=0;
    return io->read(io->context,at,p,n,&got)==0 && got==n ? 0 : YI4K_SPOOL_IO_FAILED;
}
static int32_t write_exact(const yi4k_spool_io *io,uint64_t at,const uint8_t *p,uint32_t n) {
    uint32_t got=0;
    return io->write(io->context,at,p,n,&got)==0 && got==n ? 0 : YI4K_SPOOL_IO_FAILED;
}
static int track_index(uint32_t kind) {
    if(kind==YI4K_EARLY_SOURCE_VIDEO) return 0;
    if(kind==YI4K_EARLY_SOURCE_AUDIO) return 1;
    return -1;
}
static int32_t sample_valid(const yi4k_spool_sample *s,uint32_t capacity,
                          const yi4k_spool_track *tracks) {
    const yi4k_1107_frame_desc *d=&s->packet.descriptor;
    int index=track_index(s->packet.source_kind);
    const yi4k_spool_track *t;
    if(index<0 || s->packet.is_end || d->flags!=1 ||
       (index==1 ? d->type!=8 : (d->type<1 || d->type>4)) ||
       !d->payload_size || d->payload_size>=UINT32_C(0xfffffe) ||
       !valid(s->packet.payload,d->payload_size) || !s->scale || !s->duration ||
       s->dts!=s->pts || d->corrected_pts!=s->pts) return YI4K_SPOOL_BAD_ARGUMENT;
    if(d->payload_size>capacity || s->pts>UINT64_MAX-s->duration) return YI4K_SPOOL_LIMIT;
    t=&tracks[index];
    if(t->seen && (t->sequence==UINT32_MAX || d->sequence!=t->sequence+1 ||
       s->scale!=t->scale || s->dts!=t->end)) return YI4K_SPOOL_MISMATCH;
    return 0;
}
static void track_record(yi4k_spool_track *tracks,const yi4k_spool_sample *s) {
    yi4k_spool_track *t=&tracks[track_index(s->packet.source_kind)];
    t->seen=1; t->sequence=s->packet.descriptor.sequence;
    t->scale=s->scale; t->end=s->pts+s->duration;
}
static void encode(uint8_t *h,const yi4k_spool_identity *id,uint64_t ordinal,
                   const yi4k_spool_sample *s) {
    const yi4k_1107_frame_desc *d=&s->packet.descriptor;
    zero(h,HEADER); copy(h,(const uint8_t *)"YI4KPS01",8);
    put32(h+8,1); put32(h+12,HEADER);
    put64(h+16,id->session); put64(h+24,id->segment); put64(h+32,id->epoch);
    put64(h+40,ordinal); put32(h+48,s->packet.source_kind); put32(h+52,s->scale);
    put64(h+56,s->dts); put64(h+64,s->pts); put32(h+72,s->duration); put32(h+76,d->payload_size);
    put32(h+80,d->sequence); put32(h+84,d->reserved_04); put64(h+88,d->corrected_pts);
    h[96]=d->type; h[97]=d->flags; h[98]=(uint8_t)d->reserved_12; h[99]=(uint8_t)(d->reserved_12>>8);
    put32(h+100,d->cpu_payload_address); put32(h+104,d->payload_size); put32(h+108,d->opaque_1c);
    copy(h+112,id->config_digest,32); put32(h+144,crc(s->packet.payload,d->payload_size));
    put32(h+148,crc(h,HEADER));
}
static int decode(uint8_t *h,const yi4k_spool_identity *id,uint64_t ordinal,
                  uint8_t *payload,yi4k_spool_sample *s) {
    yi4k_1107_frame_desc *d=&s->packet.descriptor;
    uint32_t stored=get32(h+148),actual;
    put32(h+148,0); actual=crc(h,HEADER); put32(h+148,stored);
    if(!same(h,(const uint8_t *)"YI4KPS01",8) || get32(h+8)!=1 || get32(h+12)!=HEADER ||
       stored!=actual || get64(h+16)!=id->session || get64(h+24)!=id->segment ||
       get64(h+32)!=id->epoch || get64(h+40)!=ordinal ||
       !same(h+112,id->config_digest,32) || get64(h+152)!=0 || get32(h+76)!=get32(h+104)) return 0;
    zero((uint8_t *)s,sizeof(*s));
    s->packet.source_kind=get32(h+48); s->packet.payload=payload;
    s->scale=get32(h+52); s->dts=get64(h+56); s->pts=get64(h+64); s->duration=get32(h+72);
    d->sequence=get32(h+80); d->reserved_04=get32(h+84); d->corrected_pts=get64(h+88);
    d->type=h[96]; d->flags=h[97]; d->reserved_12=(uint16_t)((uint16_t)h[98]|(uint16_t)h[99]<<8);
    d->cpu_payload_address=get32(h+100); d->payload_size=get32(h+104); d->opaque_1c=get32(h+108);
    return 1;
}
static int marker_valid(const uint8_t *m,uint64_t ordinal,uint32_t header_crc) {
    return same(m,(const uint8_t *)"Y4KCOM01",8) && get64(m+8)==ordinal &&
        get32(m+16)==header_crc && get32(m+20)==crc(m,20);
}
int32_t yi4k_spool_init(yi4k_packet_spool *c,const yi4k_spool_io *io,
    const yi4k_spool_identity *id,uint8_t *scratch,uint32_t capacity) {
    uint64_t size=0;
    if(!valid(c,sizeof(*c)) || (uintptr_t)c%_Alignof(yi4k_packet_spool) ||
       !io_valid(io) || !identity_valid(id) || !valid(scratch,capacity) || !capacity ||
       overlap(c,sizeof(*c),scratch,capacity) || overlap(c,sizeof(*c),io,sizeof(*io)) ||
       overlap(c,sizeof(*c),id,sizeof(*id)) || overlap(scratch,capacity,io,sizeof(*io)) ||
       overlap(scratch,capacity,id,sizeof(*id))) return YI4K_SPOOL_BAD_ARGUMENT;
    if(c->magic) return YI4K_SPOOL_BAD_STATE;
    if(io->size(io->context,&size)!=0) return YI4K_SPOOL_IO_FAILED;
    if(size!=0) return YI4K_SPOOL_BAD_STATE;
    zero((uint8_t *)c,sizeof(*c));
    c->magic=MAGIC; c->state=YI4K_SPOOL_READY; c->capacity=capacity; c->readback=scratch;
    copy((uint8_t *)&c->io,(const uint8_t *)io,sizeof(*io));
    copy((uint8_t *)&c->identity,(const uint8_t *)id,sizeof(*id));
    c->next_ordinal=1;
    return 0;
}
int32_t yi4k_spool_append(yi4k_packet_spool *c,const yi4k_spool_sample *s) {
    uint8_t h[HEADER],actual[HEADER],marker[COMMIT],check[COMMIT];
    uint64_t next,size=0; uint32_t length; int32_t result;
    if(!c || c->magic!=MAGIC || !valid(s,sizeof(*s))) return YI4K_SPOOL_BAD_ARGUMENT;
    if(c->state!=YI4K_SPOOL_READY) return YI4K_SPOOL_BAD_STATE;
    if(overlap(c,sizeof(*c),s,sizeof(*s)) || overlap(c->readback,c->capacity,s,sizeof(*s))) return YI4K_SPOOL_BAD_ARGUMENT;
    result=sample_valid(s,c->capacity,c->tracks);
    if(result) return result;
    length=s->packet.descriptor.payload_size;
    if(overlap(c,sizeof(*c),s->packet.payload,length) ||
       overlap(c->readback,c->capacity,s->packet.payload,length)) return YI4K_SPOOL_BAD_ARGUMENT;
    if(c->offset>UINT64_MAX-HEADER-COMMIT-length || c->next_ordinal==UINT64_MAX) return YI4K_SPOOL_LIMIT;
    next=c->offset+HEADER+length+COMMIT;
    encode(h,&c->identity,c->next_ordinal,s);
    copy(marker,(const uint8_t *)"Y4KCOM01",8); put64(marker+8,c->next_ordinal);
    put32(marker+16,get32(h+148)); put32(marker+20,crc(marker,20));
    c->state=YI4K_SPOOL_BUSY;
    result=YI4K_SPOOL_IO_FAILED;
    if(c->io.size(c->io.context,&size)!=0 || size!=c->offset ||
       write_exact(&c->io,c->offset,h,HEADER) ||
       write_exact(&c->io,c->offset+HEADER,s->packet.payload,length) ||
       c->io.sync(c->io.context)!=0 ||
       write_exact(&c->io,c->offset+HEADER+length,marker,COMMIT) ||
       c->io.sync(c->io.context)!=0 ||
       read_exact(&c->io,c->offset,actual,HEADER) ||
       read_exact(&c->io,c->offset+HEADER,c->readback,length) ||
       read_exact(&c->io,c->offset+HEADER+length,check,COMMIT) ||
       c->io.size(c->io.context,&size)!=0 || size!=next) goto failed;
    if(!same(h,actual,HEADER) || !same(s->packet.payload,c->readback,length) ||
       !same(marker,check,COMMIT)) { result=YI4K_SPOOL_MISMATCH; goto failed; }
    c->offset=next; ++c->next_ordinal; track_record(c->tracks,s);
    c->state=YI4K_SPOOL_READY;
    return 0;
failed:
    c->state=YI4K_SPOOL_FROZEN;
    return result;
}
int32_t yi4k_spool_scan(const yi4k_spool_io *io,const yi4k_spool_identity *id,
    uint8_t *scratch,uint32_t capacity,
    int32_t (*consume)(void *,uint64_t,const yi4k_spool_sample *),void *context,
    yi4k_spool_scan_result *report) {
    uint8_t h[HEADER],m[COMMIT]; yi4k_spool_sample s; yi4k_spool_track tracks[2];
    uint64_t size=0,at=0,ordinal=1,again=0,remaining;
    uint32_t length; int32_t result=0;
    if(!io_valid(io) || !identity_valid(id) || !valid(scratch,capacity) || !capacity ||
       !valid(report,sizeof(*report)) || !consume ||
       overlap(scratch,capacity,report,sizeof(*report)) ||
       overlap(scratch,capacity,io,sizeof(*io)) || overlap(scratch,capacity,id,sizeof(*id)) ||
       overlap(report,sizeof(*report),io,sizeof(*io)) || overlap(report,sizeof(*report),id,sizeof(*id))) return YI4K_SPOOL_BAD_ARGUMENT;
    zero((uint8_t *)report,sizeof(*report)); zero((uint8_t *)tracks,sizeof(tracks));
    if(io->size(io->context,&size)!=0) return YI4K_SPOOL_IO_FAILED;
    report->file_bytes=size;
    while(at<size) {
        remaining=size-at;
        if(remaining<HEADER) { result=YI4K_SPOOL_INCOMPLETE; break; }
        if(read_exact(io,at,h,HEADER)) { result=YI4K_SPOOL_IO_FAILED; break; }
        if(!decode(h,id,ordinal,scratch,&s)) { result=YI4K_SPOOL_MISMATCH; break; }
        length=s.packet.descriptor.payload_size;
        if(length>capacity) { result=YI4K_SPOOL_LIMIT; break; }
        if(remaining<(uint64_t)HEADER+length+COMMIT) { result=YI4K_SPOOL_INCOMPLETE; break; }
        if(read_exact(io,at+HEADER,scratch,length) || read_exact(io,at+HEADER+length,m,COMMIT)) { result=YI4K_SPOOL_IO_FAILED; break; }
        if(crc(scratch,length)!=get32(h+144) || !marker_valid(m,ordinal,get32(h+148)) || sample_valid(&s,capacity,tracks)) {
            result=YI4K_SPOOL_MISMATCH; break;
        }
        if(consume(context,ordinal,&s)!=0) { result=YI4K_SPOOL_BAD_STATE; break; }
        track_record(tracks,&s); at+=HEADER+length+COMMIT; ++ordinal;
        report->records=ordinal-1; report->committed_bytes=at;
    }
    if(io->size(io->context,&again)!=0 || again!=size) result=YI4K_SPOOL_IO_FAILED;
    report->trailing_bytes=(size-at)>UINT32_MAX ? UINT32_MAX : (uint32_t)(size-at);
    report->corrupt=result==YI4K_SPOOL_MISMATCH;
    return result;
}
