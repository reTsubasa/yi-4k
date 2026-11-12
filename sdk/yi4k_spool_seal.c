#include "yi4k_spool_seal.h"

#define MAGIC UINT32_C(0x53434f56)
#define BODY 256u
#define MARKER 24u
static void zero(void *p,size_t n){uint8_t *b=p;while(n--)*b++=0;}
static void copy(void *d,const void *s,size_t n){uint8_t *a=d;const uint8_t *b=s;while(n--)*a++=*b++;}
static int equal(const void *a,const void *b,size_t n){const uint8_t *p=a,*q=b;while(n--)if(*p++!=*q++)return 0;return 1;}
static int valid(const void *p,size_t n){return p && n<=UINTPTR_MAX-(uintptr_t)p;}
static int overlap(const void *a,size_t n,const void *b,size_t m){return (uintptr_t)a<(uintptr_t)b+m && (uintptr_t)b<(uintptr_t)a+n;}
static void put32(uint8_t *p,uint32_t v){uint32_t i;for(i=0;i<4;++i){p[i]=(uint8_t)v;v>>=8;}}
static void put64(uint8_t *p,uint64_t v){put32(p,(uint32_t)v);put32(p+4,(uint32_t)(v>>32));}
static uint32_t get32(const uint8_t *p){return (uint32_t)p[0]|(uint32_t)p[1]<<8|(uint32_t)p[2]<<16|(uint32_t)p[3]<<24;}
static uint32_t rotr(uint32_t v,uint32_t n){return (v>>n)|(v<<(32-n));}
static uint32_t crc(const uint8_t *p,uint32_t n){
    uint32_t c=UINT32_MAX,i;while(n--){c^=*p++;for(i=0;i<8;++i)c=(c>>1)^(UINT32_C(0xedb88320)&(0-(c&1)));}return c^UINT32_MAX;
}
static void sha_block(yi4k_seal_sha256 *c){
    static const uint32_t k[64]={
        0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2};
    uint32_t w[64],i,a,b,d,e,f,g,h,j,t1,t2,x,y;
    for(i=0;i<16;++i){const uint8_t *p=c->block+4*i;w[i]=(uint32_t)p[0]<<24|(uint32_t)p[1]<<16|(uint32_t)p[2]<<8|p[3];}
    for(i=16;i<64;++i){x=w[i-15];y=w[i-2];w[i]=w[i-16]+(rotr(x,7)^rotr(x,18)^(x>>3))+w[i-7]+(rotr(y,17)^rotr(y,19)^(y>>10));}
    a=c->words[0];b=c->words[1];j=c->words[2];d=c->words[3];e=c->words[4];f=c->words[5];g=c->words[6];h=c->words[7];
    for(i=0;i<64;++i){
        t1=h+(rotr(e,6)^rotr(e,11)^rotr(e,25))+((e&f)^((~e)&g))+k[i]+w[i];
        t2=(rotr(a,2)^rotr(a,13)^rotr(a,22))+((a&b)^(a&j)^(b&j));
        h=g;g=f;f=e;e=d+t1;d=j;j=b;b=a;a=t1+t2;
    }
    c->words[0]+=a;c->words[1]+=b;c->words[2]+=j;c->words[3]+=d;c->words[4]+=e;c->words[5]+=f;c->words[6]+=g;c->words[7]+=h;
}
static void sha_init(yi4k_seal_sha256 *c){
    static const uint32_t initial[8]={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19};
    zero(c,sizeof(*c));copy(c->words,initial,sizeof(initial));
}
static void sha_update(yi4k_seal_sha256 *c,const uint8_t *p,uint32_t n){
    c->bytes+=n;while(n--){c->block[c->used++]=*p++;if(c->used==64){sha_block(c);c->used=0;}}
}
static void sha_final(const yi4k_seal_sha256 *source,uint8_t *out){
    yi4k_seal_sha256 c;uint64_t bits;uint32_t i;copy(&c,source,sizeof(c));bits=c.bytes<<3;
    c.block[c.used++]=0x80;
    if(c.used>56){while(c.used<64)c.block[c.used++]=0;sha_block(&c);c.used=0;}
    while(c.used<56)c.block[c.used++]=0;
    for(i=0;i<8;++i)c.block[63-i]=(uint8_t)(bits>>(i*8));sha_block(&c);
    for(i=0;i<8;++i){uint32_t v=c.words[i];out[i*4]=(uint8_t)(v>>24);out[i*4+1]=(uint8_t)(v>>16);out[i*4+2]=(uint8_t)(v>>8);out[i*4+3]=(uint8_t)v;}
}
static int id_valid(const yi4k_spool_identity *id){uint32_t i,v=0;if(!valid(id,sizeof(*id))||!id->session||!id->segment||!id->epoch)return 0;for(i=0;i<32;++i)v|=id->config_digest[i];return v!=0;}
static int id_equal(const yi4k_spool_identity *a,const yi4k_spool_identity *b){return a->session==b->session&&a->segment==b->segment&&a->epoch==b->epoch&&equal(a->config_digest,b->config_digest,32);}
int32_t yi4k_coverage_init(yi4k_source_coverage *c,const yi4k_spool_identity *id){
    uint8_t prefix[64];
    if(!valid(c,sizeof(*c))||(uintptr_t)c%_Alignof(yi4k_source_coverage)||!id_valid(id)||overlap(c,sizeof(*c),id,sizeof(*id)))return YI4K_SEAL_BAD_ARGUMENT;
    if(c->magic)return YI4K_SEAL_BAD_STATE;
    zero(c,sizeof(*c));c->magic=MAGIC;c->state=YI4K_SEAL_OPEN;copy(&c->identity,id,sizeof(*id));sha_init(&c->transcript);
    copy(prefix,"YI4KCOV1",8);put64(prefix+8,id->session);put64(prefix+16,id->segment);put64(prefix+24,id->epoch);copy(prefix+32,id->config_digest,32);
    sha_update(&c->transcript,prefix,sizeof(prefix));return 0;
}
int32_t yi4k_coverage_add(yi4k_source_coverage *c,const yi4k_spool_sample *s){
    const yi4k_1107_frame_desc *d;yi4k_seal_track *t;uint8_t h[72];uint32_t index,n;
    if(!valid(c,sizeof(*c))||c->magic!=MAGIC||!valid(s,sizeof(*s))||overlap(c,sizeof(*c),s,sizeof(*s)))return YI4K_SEAL_BAD_ARGUMENT;
    if(c->state!=YI4K_SEAL_OPEN)return YI4K_SEAL_BAD_STATE;
    d=&s->packet.descriptor;n=d->payload_size;
    if(s->packet.source_kind==YI4K_EARLY_SOURCE_VIDEO)index=0;else if(s->packet.source_kind==YI4K_EARLY_SOURCE_AUDIO)index=1;else return YI4K_SEAL_BAD_ARGUMENT;
    if(s->packet.is_end||d->flags!=1||(index==1?d->type!=8:(d->type<1||d->type>4))||!n||n>=0xfffffe||
       !valid(s->packet.payload,n)||!s->scale||!s->duration||s->dts!=s->pts||d->corrected_pts!=s->pts||
       overlap(c,sizeof(*c),s->packet.payload,n))return YI4K_SEAL_BAD_ARGUMENT;
    if(c->records==UINT64_MAX||c->payload_bytes>UINT64_MAX-n||s->pts>UINT64_MAX-s->duration||
       c->transcript.bytes>(UINT64_MAX>>3)-sizeof(h)-n)return YI4K_SEAL_LIMIT;
    t=&c->tracks[index];
    if(t->records&&(t->last_sequence==UINT32_MAX||d->sequence!=t->last_sequence+1||s->scale!=t->scale||s->pts!=t->end_pts))return YI4K_SEAL_MISMATCH;
    zero(h,sizeof(h));put64(h,c->records+1);put32(h+8,s->packet.source_kind);put32(h+12,s->scale);put64(h+16,s->dts);put64(h+24,s->pts);
    put32(h+32,s->duration);put32(h+36,d->sequence);put64(h+40,d->corrected_pts);put32(h+48,d->reserved_04);
    h[52]=d->type;h[53]=d->flags;h[54]=(uint8_t)d->reserved_12;h[55]=(uint8_t)(d->reserved_12>>8);
    put32(h+56,d->cpu_payload_address);put32(h+60,n);put32(h+64,d->opaque_1c);
    sha_update(&c->transcript,h,sizeof(h));sha_update(&c->transcript,s->packet.payload,n);
    if(!t->records){t->first_sequence=d->sequence;t->first_pts=s->pts;t->scale=s->scale;}
    ++t->records;t->last_sequence=d->sequence;t->end_pts=s->pts+s->duration;++c->records;c->payload_bytes+=n;return 0;
}
static int track_equal(const yi4k_seal_track *a,const yi4k_seal_track *b){return a->records==b->records&&a->first_pts==b->first_pts&&a->end_pts==b->end_pts&&a->first_sequence==b->first_sequence&&a->last_sequence==b->last_sequence&&a->scale==b->scale&&a->reserved==b->reserved;}
static int request_valid(const yi4k_seal_request *r,uint64_t *bytes){
    uint32_t i;uint64_t count=0,n;
    if(!valid(r,sizeof(*r))||!id_valid(&r->identity)||!r->closure_id||!r->records||!r->payload_bytes||r->reserved||
       (r->scope!=YI4K_SEAL_SNAPSHOT_SET&&r->scope!=YI4K_SEAL_AV_SEGMENT))return 0;
    for(i=0;i<2;++i){const yi4k_seal_track *t=&r->tracks[i];
        if(t->reserved)return 0;
        if(!t->records){if(t->first_pts||t->end_pts||t->first_sequence||t->last_sequence||t->scale||r->scope==YI4K_SEAL_AV_SEGMENT)return 0;}
        else if(!t->scale||t->end_pts<=t->first_pts||t->records-1>UINT32_MAX-t->first_sequence||t->last_sequence!=t->first_sequence+t->records-1)return 0;
        if(count>UINT64_MAX-t->records)return 0;count+=t->records;
    }
    if(count!=r->records||count>UINT64_MAX/UINT64_C(184))return 0;
    n=count*184;if(r->payload_bytes>UINT64_MAX-n)return 0;*bytes=n+r->payload_bytes;return 1;
}
static int coverage_equal(const yi4k_source_coverage *c,const yi4k_seal_request *r){return id_equal(&c->identity,&r->identity)&&c->records==r->records&&c->payload_bytes==r->payload_bytes&&track_equal(&c->tracks[0],&r->tracks[0])&&track_equal(&c->tracks[1],&r->tracks[1]);}
static int io_valid(const yi4k_spool_io *io){return valid(io,sizeof(*io))&&io->size&&io->read&&io->write&&io->sync;}
static int io_arguments(const yi4k_seal_request *r,const yi4k_spool_io *spool,const yi4k_spool_io *seal,uint8_t *scratch,uint32_t capacity){
    return io_valid(spool)&&io_valid(seal)&&spool!=seal&&valid(scratch,capacity)&&capacity&&
        !overlap(scratch,capacity,r,sizeof(*r))&&!overlap(scratch,capacity,spool,sizeof(*spool))&&!overlap(scratch,capacity,seal,sizeof(*seal));
}
static int read_exact(const yi4k_spool_io *io,uint64_t at,uint8_t *p,uint32_t n){uint32_t got=0;return io->read(io->context,at,p,n,&got)==0&&got==n;}
static int write_exact(const yi4k_spool_io *io,uint64_t at,const uint8_t *p,uint32_t n){uint32_t got=0;return io->write(io->context,at,p,n,&got)==0&&got==n;}
static void encode(uint8_t *b,const yi4k_seal_request *r,uint64_t bytes,const uint8_t *digest){
    uint32_t i;zero(b,BODY);copy(b,"YI4KSE01",8);put32(b+8,1);put32(b+12,BODY);put64(b+16,r->identity.session);put64(b+24,r->identity.segment);put64(b+32,r->identity.epoch);copy(b+40,r->identity.config_digest,32);
    put64(b+72,r->closure_id);put32(b+80,r->scope);put64(b+88,r->records);put64(b+96,r->payload_bytes);put64(b+104,bytes);
    for(i=0;i<2;++i){const yi4k_seal_track *t=&r->tracks[i];uint8_t *p=b+112+i*40;put64(p,t->records);put64(p+8,t->first_pts);put64(p+16,t->end_pts);put32(p+24,t->first_sequence);put32(p+28,t->last_sequence);put32(p+32,t->scale);}
    copy(b+192,digest,32);put32(b+248,crc(b,BODY));
}
static void marker(uint8_t *m,const yi4k_seal_request *r,uint32_t body_crc){copy(m,"Y4KSFIN1",8);put64(m+8,r->closure_id);put32(m+16,body_crc);put32(m+20,crc(m,20));}
static int32_t collect(void *context,uint64_t ordinal,const yi4k_spool_sample *s){yi4k_source_coverage *c=context;if(ordinal!=c->records+1)return -1;return yi4k_coverage_add(c,s);}
static int32_t scan(const yi4k_seal_request *r,const yi4k_spool_io *io,uint8_t *scratch,uint32_t capacity,uint64_t bytes,uint8_t *digest){
    yi4k_source_coverage actual;yi4k_spool_scan_result result;int32_t status;
    zero(&actual,sizeof(actual));if(yi4k_coverage_init(&actual,&r->identity))return YI4K_SEAL_BAD_ARGUMENT;
    status=yi4k_spool_scan(io,&r->identity,scratch,capacity,collect,&actual,&result);
    if(status)return status;
    if(result.file_bytes!=bytes||result.committed_bytes!=bytes||result.records!=r->records||result.trailing_bytes||result.corrupt||!coverage_equal(&actual,r))return YI4K_SEAL_MISMATCH;
    sha_final(&actual.transcript,digest);return 0;
}
int32_t yi4k_spool_seal_commit(yi4k_source_coverage *c,const yi4k_seal_request *r,const yi4k_spool_io *spool,const yi4k_spool_io *seal,uint8_t *scratch,uint32_t capacity){
    uint8_t b[BODY],m[MARKER],read_b[BODY],read_m[MARKER],expected[32],actual[32];uint64_t bytes,n=0;int32_t status;
    if(!valid(c,sizeof(*c))||c->magic!=MAGIC||!request_valid(r,&bytes)||!io_arguments(r,spool,seal,scratch,capacity)||
       overlap(c,sizeof(*c),r,sizeof(*r))||overlap(c,sizeof(*c),scratch,capacity)||overlap(c,sizeof(*c),spool,sizeof(*spool))||overlap(c,sizeof(*c),seal,sizeof(*seal)))return YI4K_SEAL_BAD_ARGUMENT;
    if(c->state!=YI4K_SEAL_OPEN)return YI4K_SEAL_BAD_STATE;
    if(!coverage_equal(c,r))return YI4K_SEAL_MISMATCH;
    sha_final(&c->transcript,expected);c->state=YI4K_SEAL_CHECKING;
    status=scan(r,spool,scratch,capacity,bytes,actual);if(status)goto failed;
    status=YI4K_SEAL_MISMATCH;if(!equal(expected,actual,32))goto failed;
    status=YI4K_SEAL_IO_FAILED;if(seal->size(seal->context,&n)!=0)goto failed;
    status=YI4K_SEAL_BAD_STATE;if(n!=0)goto failed;
    encode(b,r,bytes,expected);marker(m,r,get32(b+248));status=YI4K_SEAL_IO_FAILED;
    if(!write_exact(seal,0,b,BODY)||seal->sync(seal->context)!=0||!write_exact(seal,BODY,m,MARKER)||seal->sync(seal->context)!=0||
       !read_exact(seal,0,read_b,BODY)||!read_exact(seal,BODY,read_m,MARKER)||seal->size(seal->context,&n)!=0||n!=BODY+MARKER||
       spool->size(spool->context,&n)!=0||n!=bytes)goto failed;
    status=YI4K_SEAL_MISMATCH;if(!equal(b,read_b,BODY)||!equal(m,read_m,MARKER))goto failed;
    c->state=YI4K_SEAL_COMMITTED;return 0;
failed:c->state=YI4K_SEAL_FROZEN;return status;
}
int32_t yi4k_spool_seal_verify(const yi4k_seal_request *r,const yi4k_spool_io *spool,const yi4k_spool_io *seal,uint8_t *scratch,uint32_t capacity,yi4k_seal_receipt *receipt){
    uint8_t b[BODY],m[MARKER],expected[BODY],expected_m[MARKER],actual[32];uint64_t bytes,n=0;int32_t status;
    if(!valid(receipt,sizeof(*receipt)))return YI4K_SEAL_BAD_ARGUMENT;
    if(!valid(r,sizeof(*r))||!io_arguments(r,spool,seal,scratch,capacity)||overlap(receipt,sizeof(*receipt),r,sizeof(*r))||
       overlap(receipt,sizeof(*receipt),spool,sizeof(*spool))||overlap(receipt,sizeof(*receipt),seal,sizeof(*seal))||overlap(receipt,sizeof(*receipt),scratch,capacity))return YI4K_SEAL_BAD_ARGUMENT;
    zero(receipt,sizeof(*receipt));
    if(!request_valid(r,&bytes))return YI4K_SEAL_BAD_ARGUMENT;
    if(seal->size(seal->context,&n)!=0)return YI4K_SEAL_IO_FAILED;
    if(n!=BODY+MARKER)return YI4K_SEAL_MISMATCH;
    if(!read_exact(seal,0,b,BODY)||!read_exact(seal,BODY,m,MARKER))return YI4K_SEAL_IO_FAILED;
    encode(expected,r,bytes,b+192);marker(expected_m,r,get32(expected+248));
    if(!equal(b,expected,BODY)||!equal(m,expected_m,MARKER))return YI4K_SEAL_MISMATCH;
    status=scan(r,spool,scratch,capacity,bytes,actual);if(status)return status;
    if(!equal(actual,b+192,32))return YI4K_SEAL_MISMATCH;
    if(!read_exact(seal,0,expected,BODY)||!read_exact(seal,BODY,expected_m,MARKER)||seal->size(seal->context,&n)!=0||n!=BODY+MARKER||spool->size(spool->context,&n)!=0||n!=bytes)return YI4K_SEAL_IO_FAILED;
    if(!equal(b,expected,BODY)||!equal(m,expected_m,MARKER))return YI4K_SEAL_MISMATCH;
    receipt->scope=r->scope;receipt->closure_id=r->closure_id;receipt->records=r->records;receipt->spool_bytes=bytes;copy(receipt->transcript_sha256,actual,32);receipt->valid=1;return 0;
}
