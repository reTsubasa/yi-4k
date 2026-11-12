#include "../yi4k_spool_seal.h"
typedef struct storage {uint8_t data[16384];uint64_t size;uint32_t calls,size_calls,fail_at,short_at,corrupt_at,change_size_at;} storage;
static storage packets,seals;
static uint8_t scratch[256],payload[256];
static yi4k_packet_spool writer;
static yi4k_source_coverage source;
static yi4k_spool_identity identity;
static yi4k_seal_request request;
uint32_t yi4k_spool_seal_report[24];
static void clear(void *p,size_t n){uint8_t *b=p;while(n--)*b++=0;}
static void copy(void *d,const void *s,size_t n){uint8_t *a=d;const uint8_t *b=s;while(n--)*a++=*b++;}
static int32_t size_io(void *ctx,uint64_t *n){storage *f=ctx;++f->calls;++f->size_calls;if(f->calls==f->fail_at)return -1;*n=f->size+(f->size_calls==f->change_size_at);return 0;}
static int32_t write_io(void *ctx,uint64_t at,const uint8_t *p,uint32_t n,uint32_t *got){storage *f=ctx;++f->calls;*got=0;if(f->calls==f->fail_at)return -1;if(f->calls==f->short_at&&n)--n;if(at>sizeof(f->data)||n>sizeof(f->data)-at)return -1;copy(f->data+(size_t)at,p,n);*got=n;if(at+n>f->size)f->size=at+n;return 0;}
static int32_t read_io(void *ctx,uint64_t at,uint8_t *p,uint32_t n,uint32_t *got){storage *f=ctx;++f->calls;*got=0;if(f->calls==f->fail_at)return -1;if(at>f->size||n>f->size-at)return -1;if(f->calls==f->short_at&&n)--n;copy(p,f->data+(size_t)at,n);*got=n;if(f->calls==f->corrupt_at&&n)p[0]^=1;return 0;}
static int32_t sync_io(void *ctx){storage *f=ctx;++f->calls;return f->calls==f->fail_at?-1:0;}
static yi4k_spool_io spool_io={&packets,size_io,write_io,read_io,sync_io};
static yi4k_spool_io seal_io={&seals,size_io,write_io,read_io,sync_io};
static yi4k_spool_sample sample;
static uint32_t sample_bytes;
static uint64_t base_pts;
static void prepare(uint32_t sequence,uint32_t kind){
    uint32_t i;clear(&sample,sizeof(sample));for(i=0;i<sample_bytes;++i)payload[i]=(uint8_t)(17+i+sequence*7);
    sample.packet.payload=payload;sample.packet.source_kind=kind;sample.packet.descriptor.sequence=sequence;
    sample.packet.descriptor.type=kind==1?(sequence==10?1:3):8;sample.packet.descriptor.flags=1;
    sample.packet.descriptor.payload_size=sample_bytes;sample.packet.descriptor.cpu_payload_address=0x22000000;
    sample.scale=kind==1?30000:48000;sample.duration=kind==1?1001:1024;
    sample.pts=sample.dts=sample.packet.descriptor.corrected_pts=base_pts+(kind==1?(uint64_t)(sequence-10)*1001:(uint64_t)sequence*1024);
}
static int add(uint32_t sequence,uint32_t kind,uint32_t mutation){
    int status;prepare(sequence,kind);status=yi4k_coverage_add(&source,&sample);if(status)return status;
    if(mutation==1)payload[0]^=1;
    if(mutation==2)sample.packet.descriptor.reserved_04=1;
    status=yi4k_spool_append(&writer,&sample);clear(payload,sizeof(payload));return status;
}
/* Test fixture source-stop ledger, deliberately separate from disk scanner.
 * Real stop/quiescence/held-packet evidence remains an external prerequisite. */
static void expected(uint32_t audio,uint32_t video){
    clear(&request,sizeof(request));copy(&request.identity,&identity,sizeof(identity));request.closure_id=7;
    request.scope=video?YI4K_SEAL_AV_SEGMENT:YI4K_SEAL_SNAPSHOT_SET;request.records=audio+video;request.payload_bytes=(uint64_t)(audio+video)*sample_bytes;
    if(audio){request.tracks[1].records=audio;request.tracks[1].first_pts=base_pts;request.tracks[1].end_pts=base_pts+(uint64_t)audio*1024;request.tracks[1].last_sequence=audio-1;request.tracks[1].scale=48000;}
    if(video){request.tracks[0].records=video;request.tracks[0].first_pts=base_pts;request.tracks[0].end_pts=base_pts+(uint64_t)video*1001;request.tracks[0].first_sequence=10;request.tracks[0].last_sequence=10+video-1;request.tracks[0].scale=30000;}
}
static void reset(void){
    clear(&packets,sizeof(packets));clear(&seals,sizeof(seals));clear(&writer,sizeof(writer));clear(&source,sizeof(source));clear(&identity,sizeof(identity));clear(yi4k_spool_seal_report,sizeof(yi4k_spool_seal_report));
    identity.session=1;identity.segment=2;identity.epoch=3;identity.config_digest[0]=4;sample_bytes=48;base_pts=0;
}
#define CHECK(x) do{if(!(x))return __LINE__;}while(0)
int32_t yi4k_spool_seal_test(uint32_t which){
    yi4k_seal_receipt receipt;int32_t result,status;uint32_t i,complete;
    reset();CHECK(which<48);clear(&receipt,sizeof(receipt));
    if(which==42)sample_bytes=47;if(which==43)sample_bytes=48;if(which==46)base_pts=UINT64_C(0x100000000);
    CHECK(yi4k_spool_init(&writer,&spool_io,&identity,scratch,sizeof(scratch))==0);
    CHECK(yi4k_coverage_init(&source,&identity)==0);
    if(which==44){prepare(0,2);sample.packet.descriptor.payload_size=0;CHECK(yi4k_coverage_add(&source,&sample)==YI4K_SEAL_BAD_ARGUMENT);CHECK(source.records==0);return 0;}
    if(which==45){prepare(UINT32_MAX,2);CHECK(yi4k_coverage_add(&source,&sample)==0);prepare(0,2);CHECK(yi4k_coverage_add(&source,&sample)==YI4K_SEAL_MISMATCH);return 0;}
    for(i=0;i<(which==42||which==43?1u:3u);++i){
        if(which==19&&i==2){prepare(i,2);CHECK(yi4k_coverage_add(&source,&sample)==0);}
        else CHECK(add(i,2,which==20&&i==1?1:which==21&&i==1?2:0)==0);
        if(which==35||which==47)if(i<2)CHECK(add(10+i,1,0)==0);
    }
    expected(which==42||which==43?1:3,which==35||which==47?2:0);
    if(which==15){request.tracks[1].first_pts=1;result=yi4k_spool_seal_commit(&source,&request,&spool_io,&seal_io,scratch,sizeof(scratch));CHECK(result==YI4K_SEAL_MISMATCH&&source.state==YI4K_SEAL_OPEN&&seals.calls==0);return 0;}
    if(which==16||which==36){request.scope=YI4K_SEAL_AV_SEGMENT;CHECK(yi4k_spool_seal_commit(&source,&request,&spool_io,&seal_io,scratch,sizeof(scratch))==YI4K_SEAL_BAD_ARGUMENT);CHECK(source.state==YI4K_SEAL_OPEN&&seals.calls==0);return 0;}
    if(which==24){prepare(2,2);CHECK(yi4k_coverage_add(&source,&sample)==YI4K_SEAL_MISMATCH);CHECK(source.records==3&&source.state==YI4K_SEAL_OPEN);}
    if(which==32){source.transcript.bytes=UINT64_MAX>>3;prepare(3,2);CHECK(yi4k_coverage_add(&source,&sample)==YI4K_SEAL_LIMIT);CHECK(source.records==3);return 0;}
    if(which==38){yi4k_source_coverage empty;clear(&empty,sizeof(empty));CHECK(yi4k_coverage_init(&empty,&identity)==0);CHECK(yi4k_spool_seal_commit(&empty,&request,&spool_io,&seal_io,scratch,sizeof(scratch))==YI4K_SEAL_MISMATCH);CHECK(seals.calls==0);return 0;}
    if(which==17)packets.size-=184+sample_bytes;
    if(which==18)--packets.size;
    if(which==34)seals.size=1;
    if(which>=1&&which<=8)seals.fail_at=which;
    if(which>=9&&which<=12){const uint32_t steps[4]={2,4,6,7};seals.short_at=steps[which-9];}
    if(which==13||which==14)seals.corrupt_at=which==13?6:7;
    result=yi4k_spool_seal_commit(&source,&request,&spool_io,&seal_io,scratch,sizeof(scratch));
    if((which>=1&&which<=14)||(which>=17&&which<=21)||which==34){
        CHECK(result!=0&&source.state==YI4K_SEAL_FROZEN);prepare(3,2);CHECK(yi4k_coverage_add(&source,&sample)==YI4K_SEAL_BAD_STATE);
    }else{CHECK(result==0&&source.state==YI4K_SEAL_COMMITTED);CHECK(yi4k_spool_seal_commit(&source,&request,&spool_io,&seal_io,scratch,sizeof(scratch))==YI4K_SEAL_BAD_STATE);}
    seals.fail_at=seals.short_at=seals.corrupt_at=0;seals.calls=seals.size_calls=0;packets.calls=packets.size_calls=0;
    if(which==22)++request.closure_id;if(which==23)++request.identity.epoch;
    if(which==25)CHECK(add(3,2,0)==YI4K_SEAL_BAD_STATE); /* source gate blocks append */
    if(which==25){prepare(3,2);CHECK(yi4k_spool_append(&writer,&sample)==0);} /* deliberate caller violation */
    if(which==26){--request.tracks[1].records;--request.tracks[1].last_sequence;request.tracks[1].end_pts-=1024;--request.records;request.payload_bytes-=sample_bytes;}
    if(which==27)seals.data[0]^=1;if(which==28)seals.data[279]^=1;
    if(which==29)seals.corrupt_at=4;if(which==30)seals.change_size_at=2;if(which==31)packets.change_size_at=3;
    if(which==33)seals.size=0;if(which==39)seals.size=256;if(which==40)request.tracks[1].end_pts+=1;
    if(which==47)request.scope=YI4K_SEAL_SNAPSHOT_SET;
    status=yi4k_spool_seal_verify(&request,&spool_io,&seal_io,scratch,sizeof(scratch),&receipt);
    complete=(which==0||which==5||which==6||which==7||which==8||which==11||which==12||which==13||which==14||which==24||which==35||which==37||which==41||which==42||which==43||which==46);
    CHECK(complete?(status==0&&receipt.valid==1):(status!=0&&receipt.valid==0));
    if(which==37){request.reserved=1;CHECK(yi4k_spool_seal_verify(&request,&spool_io,&seal_io,scratch,sizeof(scratch),&receipt)==YI4K_SEAL_BAD_ARGUMENT);CHECK(receipt.valid==0);}
    yi4k_spool_seal_report[0]=(uint32_t)result;yi4k_spool_seal_report[1]=(uint32_t)status;yi4k_spool_seal_report[2]=source.state;
    yi4k_spool_seal_report[3]=(uint32_t)packets.size;yi4k_spool_seal_report[4]=(uint32_t)seals.size;yi4k_spool_seal_report[5]=(uint32_t)source.records;yi4k_spool_seal_report[6]=receipt.valid;
    if(seals.size>=224){yi4k_spool_seal_report[7]=1;copy(&yi4k_spool_seal_report[8],seals.data+192,32);}
    return 0;
}
