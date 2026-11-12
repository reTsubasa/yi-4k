#include "../yi4k_packet_spool.h"

static yi4k_packet_spool writer;
static uint8_t disk[8192],scratch[128],payload[64],observed[128];
static uint64_t length;
static uint32_t calls,fail_at,short_at,corrupt_at,reentry,bad,consumed;
static uint32_t size_calls,change_size_at,reject_consume,interleaved;
uint32_t yi4k_packet_spool_report[12];
static void clear(void *p,size_t n) { uint8_t *b=p; while(n--) *b++=0; }
static void copy(uint8_t *d,const uint8_t *s,uint32_t n) { while(n--) *d++=*s++; }
static int eq(const uint8_t *a,const uint8_t *b,uint32_t n) { while(n--)if(*a++!=*b++)return 0;return 1; }
static int32_t size_io(void *ctx,uint64_t *out) { (void)ctx;*out=length;if(++size_calls==change_size_at)++*out;return 0; }
static int32_t write_io(void *ctx,uint64_t at,const uint8_t *p,uint32_t n,uint32_t *got) {
    uint32_t step=++calls; (void)ctx;*got=0;
    if(step==fail_at) return -1;
    if(step==short_at && n) --n;
    if(at>sizeof(disk) || n>sizeof(disk)-at)return -1;
    copy(disk+(size_t)at,p,n);*got=n;if(at+n>length)length=at+n;
    return 0;
}
static int32_t read_io(void *ctx,uint64_t at,uint8_t *p,uint32_t n,uint32_t *got) {
    uint32_t step=++calls; (void)ctx;*got=0;
    if(step==fail_at) return -1;
    if(at>length || n>length-at)return -1;
    if(step==short_at && n)--n;
    copy(p,disk+(size_t)at,n);*got=n;
    if(step==corrupt_at && n)p[0]^=1;
    return 0;
}
static int32_t sync_io(void *ctx) {
    uint32_t step=++calls; (void)ctx;
    if(reentry && writer.state!=YI4K_SPOOL_BUSY)bad=1;
    return step==fail_at ? -1 : 0;
}
static int32_t consume(void *ctx,uint64_t ordinal,const yi4k_spool_sample *s) {
    (void)ctx;
    if(reject_consume)return -1;
    if(interleaved) { ++consumed;return 0; }
    if(ordinal!=consumed+1 || s->packet.descriptor.sequence!=consumed ||
       s->pts!=(uint64_t)consumed*1024 || s->packet.payload==payload ||
       !eq(s->packet.payload,payload,64))bad=1;
    copy(observed,s->packet.payload,64);++consumed;return 0;
}
static yi4k_spool_io io={0,size_io,write_io,read_io,sync_io};
static yi4k_spool_identity identity;
static yi4k_spool_sample sample;
static void reset(void) {
    uint32_t i;
    clear(&writer,sizeof(writer));clear(disk,sizeof(disk));clear(&sample,sizeof(sample));
    clear(&identity,sizeof(identity));clear(yi4k_packet_spool_report,sizeof(yi4k_packet_spool_report));
    identity.session=1;identity.segment=2;identity.epoch=3;identity.config_digest[0]=4;
    length=0;calls=fail_at=short_at=corrupt_at=reentry=bad=consumed=0;
    size_calls=change_size_at=reject_consume=interleaved=0;
    for(i=0;i<64;++i)payload[i]=(uint8_t)(17+i);
    sample.packet.payload=payload;sample.packet.source_kind=YI4K_EARLY_SOURCE_AUDIO;
    sample.packet.descriptor.type=8;sample.packet.descriptor.flags=1;
    sample.packet.descriptor.payload_size=64;sample.packet.descriptor.cpu_payload_address=0x22222222;
    sample.scale=48000;sample.duration=1024;
}
#define CHECK(x) do{if(!(x))return __LINE__;}while(0)
int32_t yi4k_packet_spool_test(uint32_t which) {
    yi4k_spool_scan_result scan;int32_t result;uint32_t i;
    reset();CHECK(which<31);
    if(which==21) { length=1;CHECK(yi4k_spool_init(&writer,&io,&identity,scratch,sizeof(scratch))==-2);CHECK(writer.magic==0);return 0; }
    CHECK(yi4k_spool_init(&writer,&io,&identity,scratch,sizeof(scratch))==0);
    if(which==24) {
        sample.packet.source_kind=99;
        CHECK(yi4k_spool_append(&writer,&sample)==YI4K_SPOOL_BAD_ARGUMENT);
        CHECK(length==0&&writer.state==1&&writer.next_ordinal==1);return 0;
    }
    if(which>=1 && which<=8)fail_at=which;
    if(which>=9 && which<=14) { const uint32_t steps[6]={1,2,4,6,7,8};short_at=steps[which-9]; }
    if(which==15)corrupt_at=7;
    if(which==16)reentry=1;
    result=yi4k_spool_append(&writer,&sample);
    if(which>=1 && which<=15) {
        CHECK(result<0&&writer.state==YI4K_SPOOL_FROZEN&&writer.offset==0&&writer.next_ordinal==1);
        CHECK(yi4k_spool_append(&writer,&sample)==YI4K_SPOOL_BAD_STATE);
        CHECK(payload[0]==17);
        fail_at=short_at=corrupt_at=0;
        result=yi4k_spool_scan(&io,&identity,scratch,sizeof(scratch),consume,0,&scan);
        if(which==1)CHECK(result==0&&scan.records==0);
        else if(which==2||which==3||which==4||which==9||which==10||which==11)
            CHECK(result==YI4K_SPOOL_INCOMPLETE&&scan.records==0);
        else CHECK(result==0&&scan.records==1);
    } else {
        CHECK(result==0&&writer.offset==248&&writer.next_ordinal==2&&writer.state==1);
        if(which==17) {
            CHECK(yi4k_spool_append(&writer,&sample)==YI4K_SPOOL_MISMATCH);
            CHECK(length==248&&writer.next_ordinal==2);
        }
        if(which==18)disk[160]^=1;
        if(which==19)--length;
        if(which==20)identity.epoch=4;
        if(which==22) {
            for(i=1;i<3;++i) {
                sample.packet.descriptor.sequence=i;
                sample.pts=sample.dts=sample.packet.descriptor.corrected_pts=(uint64_t)i*1024;
                CHECK(yi4k_spool_append(&writer,&sample)==0);
            }
            length-=12;
        }
        if(which==23) {
            sample.pts=sample.dts=sample.packet.descriptor.corrected_pts=UINT64_MAX-1023;
            CHECK(yi4k_spool_append(&writer,&sample)==YI4K_SPOOL_LIMIT);
            CHECK(length==248&&writer.next_ordinal==2);
        }
        if(which==25) {
            interleaved=1;
            sample.packet.source_kind=YI4K_EARLY_SOURCE_VIDEO;sample.packet.descriptor.type=1;
            sample.duration=1001;sample.scale=30000;
            CHECK(yi4k_spool_append(&writer,&sample)==0);
            sample.packet.descriptor.sequence=1;sample.pts=sample.dts=sample.packet.descriptor.corrected_pts=1001;
            sample.packet.descriptor.type=2;
            CHECK(yi4k_spool_append(&writer,&sample)==0);
            sample.packet.source_kind=YI4K_EARLY_SOURCE_AUDIO;sample.packet.descriptor.type=8;
            sample.pts=sample.dts=sample.packet.descriptor.corrected_pts=1024;sample.duration=1024;sample.scale=48000;
            CHECK(yi4k_spool_append(&writer,&sample)==0);
            sample.packet.descriptor.sequence=2;sample.pts=sample.dts=sample.packet.descriptor.corrected_pts=2049;
            CHECK(yi4k_spool_append(&writer,&sample)==YI4K_SPOOL_MISMATCH);
        }
        if(which==26)reject_consume=1;
        if(which==27)change_size_at=size_calls+2;
        if(which==28) {
            sample.packet.source_kind=YI4K_EARLY_SOURCE_VIDEO;sample.packet.descriptor.type=8;
            CHECK(yi4k_spool_append(&writer,&sample)==YI4K_SPOOL_BAD_ARGUMENT);
        }
        if(which==29) {
            sample.packet.descriptor.sequence=1;sample.pts=sample.dts=sample.packet.descriptor.corrected_pts=1024;
            CHECK(yi4k_spool_append(&writer,&sample)==0);length=248;
        }
        if(which==30)length=0;
        result=yi4k_spool_scan(&io,&identity,scratch,sizeof(scratch),consume,0,&scan);
        if(which==18||which==20)CHECK(result==YI4K_SPOOL_MISMATCH&&scan.records==0&&scan.corrupt);
        else if(which==19)CHECK(result==YI4K_SPOOL_INCOMPLETE&&scan.records==0);
        else if(which==22)CHECK(result==YI4K_SPOOL_INCOMPLETE&&scan.records==2&&scan.committed_bytes==496);
        else if(which==25)CHECK(result==0&&scan.records==4&&scan.committed_bytes==992);
        else if(which==26)CHECK(result==YI4K_SPOOL_BAD_STATE&&scan.records==0);
        else if(which==27)CHECK(result==YI4K_SPOOL_IO_FAILED&&scan.records==1);
        else if(which==30)CHECK(result==0&&scan.records==0&&scan.committed_bytes==0);
        else CHECK(result==0&&scan.records==1&&scan.committed_bytes==248);
    }
    CHECK(!bad);
    yi4k_packet_spool_report[0]=(uint32_t)result;
    yi4k_packet_spool_report[1]=(uint32_t)length;
    yi4k_packet_spool_report[2]=writer.state;
    yi4k_packet_spool_report[3]=(uint32_t)writer.offset;
    yi4k_packet_spool_report[4]=(uint32_t)writer.next_ordinal;
    yi4k_packet_spool_report[5]=(uint32_t)scan.records;
    yi4k_packet_spool_report[6]=(uint32_t)scan.committed_bytes;
    yi4k_packet_spool_report[7]=scan.trailing_bytes;
    yi4k_packet_spool_report[8]=scan.corrupt;
    yi4k_packet_spool_report[9]=consumed;
    yi4k_packet_spool_report[10]=calls;
    yi4k_packet_spool_report[11]=payload[0];
    return 0;
}
