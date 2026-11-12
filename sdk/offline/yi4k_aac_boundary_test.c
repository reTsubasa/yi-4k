/* Synthetic raw bytes and caller attestations only, no codec/mux/device execution. */
#include "yi4k_1107_aac_boundary.h"
static yi4k_1107_aac_boundary c;
static yi4k_1107_codec_config config;
static yi4k_1107_aac_input in;
static uint8_t bytes[64],source[65],downstream[64];
uint32_t yi4k_aac_boundary_report[12];
static void zero(void *p,size_t n){uint8_t *b=p;while(n--)*b++=0;}
static void cp(void *p,const void *q,size_t n){uint8_t *a=p;const uint8_t *b=q;while(n--)*a++=*b++;}
static int eq(const void *p,const void *q,size_t n){const uint8_t *a=p,*b=q;while(n--)if(*a++!=*b++)return 0;return 1;}
static yi4k_1107_aac_time time_at(uint64_t n,uint32_t scale){yi4k_1107_aac_time t;t.ticks=n;t.scale=scale;return t;}
static int init(uint64_t origin,yi4k_1107_aac_time split){return yi4k_1107_aac_boundary_init(&c,bytes,sizeof(bytes),&config,11,1,origin,split);}
static int offer(void){return yi4k_1107_aac_boundary_offer(&c,&in);}
static int receipt(uint32_t outcome){return yi4k_1107_aac_boundary_receipt(&c,c.ticket,outcome);}
static void packet(uint32_t seq,uint64_t pts){
 uint32_t i;zero(&in,sizeof(in));for(i=0;i<32;i++){in.identity[i]=config.identity[i];in.config_digest[i]=config.config_digest[i];}
 in.epoch_id=11;in.dts=in.pts=pts;in.duration=1024;in.scale=48000;
 in.packet.source_kind=YI4K_EARLY_SOURCE_AUDIO;in.packet.payload=source;
 in.packet.descriptor.sequence=seq;in.packet.descriptor.corrected_pts=pts;
 in.packet.descriptor.type=8;in.packet.descriptor.flags=1;in.packet.descriptor.payload_size=64;
 in.packet.descriptor.cpu_payload_address=0xabcdef00;
}
static void defaults(void){
 uint32_t i;zero(&c,sizeof(c));zero(&config,sizeof(config));zero(yi4k_aac_boundary_report,sizeof(yi4k_aac_boundary_report));
 for(i=0;i<32;i++){config.identity[i]=(uint8_t)(i+1);config.config_digest[i]=(uint8_t)(i+65);}
 config.sample_rate=48000;config.samples_per_aac=1024;
 for(i=0;i<64;i++){bytes[i]=0xcc;source[i]=(uint8_t)(i+17);downstream[i]=0;}
 packet(0,0);
}
#define CHECK(x) do{if(!(x))return __LINE__;}while(0)
static void report(void){
 yi4k_aac_boundary_report[0]=c.state;yi4k_aac_boundary_report[1]=(uint32_t)c.ticket;
 yi4k_aac_boundary_report[2]=(uint32_t)c.segment_id;yi4k_aac_boundary_report[3]=(uint32_t)c.source_epoch;
 yi4k_aac_boundary_report[4]=(uint32_t)c.previous_end;yi4k_aac_boundary_report[5]=(uint32_t)(c.previous_end>>32);
 yi4k_aac_boundary_report[6]=c.previous_sequence;yi4k_aac_boundary_report[7]=(uint32_t)c.held.pts;
 yi4k_aac_boundary_report[8]=(uint32_t)(c.held.pts>>32);yi4k_aac_boundary_report[9]=bytes[0];
 yi4k_aac_boundary_report[10]=c.held.packet.descriptor.cpu_payload_address;
 yi4k_aac_boundary_report[11]=c.have_previous;
}
int32_t yi4k_aac_boundary_test(uint32_t which){
 uint32_t i,first=0,next=0;int32_t status;yi4k_1107_aac_boundary before;yi4k_1107_aac_input snapshot;
 defaults();
 if(which==0){CHECK(init(0,time_at(1024,48000))==0);CHECK(offer()==YI4K_AAC_READY);}
 else if(which==1){CHECK(init(0,time_at(1023,48000))==0);CHECK(offer()==YI4K_AAC_NEXT);CHECK(receipt(1)==YI4K_AAC_BAD_STATE);}
 else if(which==2){CHECK(init(0,time_at(1800*1001,30000))==0);packet(2815,UINT64_C(2815)*1024);cp(&snapshot,&in,sizeof(in));
  CHECK(offer()==YI4K_AAC_NEXT);source[0]^=0xff;CHECK(bytes[0]==17);CHECK(c.held.pts==snapshot.pts&&c.held.dts==snapshot.dts);
  CHECK(yi4k_1107_aac_boundary_advance(&c,2,c.held.pts,time_at(1920*1001,30000))==YI4K_AAC_READY);
  CHECK(c.source_epoch==UINT64_C(2815)*1024);CHECK(eq(&c.held.packet.descriptor,&snapshot.packet.descriptor,sizeof(snapshot.packet.descriptor)));
  CHECK(receipt(0)==YI4K_AAC_READY);CHECK(c.ticket==1&&bytes[0]==17);CHECK(receipt(1)==0);CHECK(receipt(1)==YI4K_AAC_BAD_STATE);
 }
 else if(which==3){CHECK(init(0,time_at(1,1))==0);CHECK(offer()==1);cp(&before,&c,sizeof(c));source[0]^=3;CHECK(offer()==YI4K_AAC_BUSY);CHECK(eq(&before,&c,sizeof(c)));CHECK(bytes[0]==17);}
 else if(which==4){CHECK(init(0,time_at(1,1))==0);CHECK(offer()==1);cp(&before,&c,sizeof(c));CHECK(receipt(0)==1);CHECK(eq(&before,&c,sizeof(c)));CHECK(receipt(1)==0);CHECK(c.state==0);}
 else if(which==5){CHECK(init(0,time_at(1,1))==0);CHECK(offer()==1);CHECK(receipt(2)==YI4K_AAC_BAD_STATE);CHECK(c.state==YI4K_AAC_FROZEN);CHECK(receipt(1)==YI4K_AAC_BAD_STATE);CHECK(bytes[0]==17);}
 else if(which==6){CHECK(init(0,time_at(1,1))==0);CHECK(offer()==1);CHECK(yi4k_1107_aac_boundary_receipt(&c,0,1)==YI4K_AAC_BAD_STATE);CHECK(c.state==1);}
 else if(which>=7&&which<=15){CHECK(init(0,time_at(1,1))==0);CHECK(offer()==1);CHECK(receipt(1)==0);packet(1,1024);
  if(which==7)in.packet.descriptor.sequence=0;
  if(which==8)in.packet.descriptor.sequence=2;
  if(which==9)in.dts=in.pts=in.packet.descriptor.corrected_pts=1025;
  if(which==10)in.dts=1023;
  if(which==11)in.identity[0]^=1;
  if(which==12)in.config_digest[0]^=1;
  if(which==13)in.epoch_id=12;
  if(which==14)in.scale=44100;
  if(which==15)in.duration=960;
  CHECK(offer()==YI4K_AAC_DISCONTINUITY);CHECK(c.state==YI4K_AAC_FROZEN);CHECK(bytes[0]==17);
 }
 else if(which==16){CHECK(init(0,time_at(UINT64_MAX,1))==0);packet(0,UINT64_MAX-1023);CHECK(offer()==YI4K_AAC_LIMIT);CHECK(c.state==0&&c.ticket==0&&bytes[0]==0xcc);}
 else if(which==17){CHECK(init(UINT64_MAX-1024,time_at(UINT64_MAX,48000))==0);packet(0,UINT64_MAX-1024);CHECK(offer()==1);CHECK(c.previous_end==UINT64_MAX);}
 else if(which==18){CHECK(init(0,time_at(UINT64_MAX,UINT32_MAX))==0);packet(0,UINT64_MAX-1024);CHECK(offer()==2);}
 else if(which==19){CHECK(init(0,time_at(1,1))==0);in.packet.descriptor.payload_size=65;CHECK(offer()==YI4K_AAC_LIMIT);CHECK(bytes[0]==0xcc&&c.ticket==0);in.packet.descriptor.payload_size=64;CHECK(offer()==1);}
 else if(which==20){CHECK(init(0,time_at(1,1))==0);c.ticket=UINT64_MAX;CHECK(offer()==YI4K_AAC_LIMIT);CHECK(bytes[0]==0xcc);}
 else if(which==21){CHECK(init(0,time_at(1,1))==0);packet(UINT32_MAX,0);CHECK(offer()==1);CHECK(receipt(1)==0);packet(0,1024);CHECK(offer()==YI4K_AAC_DISCONTINUITY);}
 else if(which==22){CHECK(init(0,time_at(1023,48000))==0);CHECK(offer()==2);cp(&before,&c,sizeof(c));
  CHECK(yi4k_1107_aac_boundary_advance(&c,1,0,time_at(2048,48000))==-1);CHECK(eq(&before,&c,sizeof(c)));
  CHECK(yi4k_1107_aac_boundary_advance(&c,2,1,time_at(2048,48000))==-1);CHECK(eq(&before,&c,sizeof(c)));
  CHECK(yi4k_1107_aac_boundary_advance(&c,2,0,time_at(1023,48000))==-1);CHECK(eq(&before,&c,sizeof(c)));
  CHECK(yi4k_1107_aac_boundary_advance(&c,2,0,time_at(1023,47999))==-1);CHECK(eq(&before,&c,sizeof(c)));
  CHECK(yi4k_1107_aac_boundary_advance(&c,2,0,time_at(2048,48000))==1);CHECK(c.ticket==1);
 }
 else if(which==23){CHECK(init(1024,time_at(1,1))==0);packet(0,0);CHECK(offer()==YI4K_AAC_DISCONTINUITY);}
 else if(which==24){CHECK(init(0,time_at(1,1))==0);in.packet.payload=bytes;CHECK(offer()==-1);CHECK(c.state==0&&bytes[0]==0xcc);}
 else if(which==25){CHECK(init(0,time_at(1,1))==0);in.packet.is_end=1;CHECK(offer()==-1);CHECK(c.state==0);}
 else if(which==26){CHECK(init(0,time_at(1,1))==0);in.packet.source_kind=YI4K_EARLY_SOURCE_VIDEO;CHECK(offer()==-1);}
 else if(which==27){CHECK(init(0,time_at(1,1))==0);in.packet.descriptor.corrected_pts=1;CHECK(offer()==YI4K_AAC_DISCONTINUITY);}
 else if(which==28){config.identity[0]=0;for(i=1;i<32;i++)config.identity[i]=0;CHECK(init(0,time_at(1,1))==-1);CHECK(c.magic==0);}
 else if(which==29){CHECK(init(0,time_at(0,1))==-1);CHECK(c.magic==0);CHECK(init(0,time_at(1,0))==-1);CHECK(c.magic==0);}
 else if(which==30){CHECK(init(0,time_at(1,1))==0);cp(&before,&c,sizeof(c));CHECK(init(0,time_at(2,1))==-2);CHECK(eq(&before,&c,sizeof(c)));}
 else if(which==31){CHECK(init(0,time_at(1800*1001,30000))==0);
  for(i=0;i<3003;i++){
   packet(i,(uint64_t)i*1024);status=offer();
   if(status==2){CHECK(i==2815);CHECK(c.held.pts==UINT64_C(2882560));CHECK(c.previous_end==UINT64_C(2883584));
    CHECK(yi4k_1107_aac_boundary_advance(&c,2,c.held.pts,time_at(1920*1001,30000))==1);}
   else CHECK(status==1);
   if(c.segment_id==1)first++;else next++;
   for(uint32_t j=0;j<64;j++)downstream[j]=c.bytes[j];
   CHECK(receipt(0)==1);CHECK(eq(downstream,c.bytes,64));CHECK(receipt(1)==0);
   CHECK(yi4k_1107_aac_boundary_receipt(&c,c.ticket,1)==YI4K_AAC_BAD_STATE);
  }
  CHECK(first==2815&&next==188&&c.ticket==3003);yi4k_aac_boundary_report[0]=first;yi4k_aac_boundary_report[1]=next;
  yi4k_aac_boundary_report[2]=(uint32_t)c.source_epoch;return 0;
 }
 else return -99;
 report();return 0;
}
/* Python independently supplies random exact rational split cases. */
int32_t yi4k_aac_boundary_classify(uint32_t lo,uint32_t hi,uint32_t audio_scale,
 uint32_t split_lo,uint32_t split_hi,uint32_t split_scale){
 uint64_t end=(uint64_t)lo|((uint64_t)hi<<32),split=(uint64_t)split_lo|((uint64_t)split_hi<<32);
 defaults();config.sample_rate=audio_scale;
 if(end<1024)return -99;
 if(init(0,time_at(split,split_scale)))return -98;
 packet(0,end-1024);in.scale=audio_scale;return offer();
}
