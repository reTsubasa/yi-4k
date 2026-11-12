
#include "yi4k_1107_owned_mux.h"
#include "yi4k_1107_audio_early_copy.h"
#include "yi4k_1107_codec_epoch.h"
typedef struct setup {
 uint8_t *source; uint32_t source_base,ring_size;
 uint8_t *arena; uint32_t arena_base,slot_capacity;
 uint8_t *output; uint32_t output_base,output_capacity,kind;
 const yi4k_1107_codec_config *config;
} setup;
static setup parameters;
static yi4k_1107_early_copy queue;
static yi4k_1107_owned_slot slots[2];
static yi4k_1107_owned_mux mux;
static yi4k_1107_codec_epoch epoch;
static yi4k_1107_audio_ingress audio;
yi4k_1107_frame_desc pipeline_writer_descriptor;
uint32_t pipeline_report[16];
static void zero(void *p,uint32_t n){volatile uint8_t*b=p;while(n--)*b++=0;}
static void update(void){
 pipeline_report[2]=atomic_load(&queue.head);pipeline_report[3]=atomic_load(&queue.tail);
 pipeline_report[4]=mux.held!=0;pipeline_report[5]=mux.poisoned;
 pipeline_report[8]=mux.packet.ring_base;pipeline_report[9]=mux.packet.ring_end;
 pipeline_report[10]=parameters.output_base;pipeline_report[11]=parameters.output_base+parameters.output_capacity;
 pipeline_report[12]=queue.accepted;pipeline_report[13]=queue.dropped;pipeline_report[14]=queue.failed;
}
static int32_t original_video(void*context,uint32_t handle,uint32_t code,const void*arg){
 uint32_t i;(void)context;(void)handle;(void)code;(void)arg;
 pipeline_report[1]++;
 for(i=0;i<parameters.ring_size;i++)parameters.source[i]=0xee;
 return -19;
}
static int32_t original_audio(void*c,const void*a){return original_video(c,0,0,a);}
int32_t pipeline_begin(const setup *p){
 yi4k_1107_ring_view ring;yi4k_1107_owned_arena arena;int32_t s;uint32_t i;
 parameters=*p;zero(&queue,sizeof(queue));zero(slots,sizeof(slots));zero(&mux,sizeof(mux));
 zero(&epoch,sizeof(epoch));zero(&audio,sizeof(audio));zero(pipeline_report,sizeof(pipeline_report));
 zero(&pipeline_writer_descriptor,sizeof(pipeline_writer_descriptor));
 ring=(yi4k_1107_ring_view){p->source,p->source_base,p->ring_size};
 arena=(yi4k_1107_owned_arena){p->arena,p->arena_base,2*p->slot_capacity};
 for(i=0;i<2;i++){slots[i].payload=p->arena+i*p->slot_capacity;slots[i].capacity=p->slot_capacity;}
 s=yi4k_1107_early_init(&queue,&ring,slots,2);if(s)return -101;
 s=yi4k_1107_owned_mux_init(&mux,&queue,&arena,p->kind);if(s)return -102;
 s=yi4k_1107_codec_init(&epoch,p->config);if(s)return s;
 audio.owned=&queue;update();return 0;
}
int32_t pipeline_offer(uint32_t n,uint32_t offset,uint32_t type){
 yi4k_1107_early_result r;
 if(parameters.kind==1){
  yi4k_1107_video_event e;yi4k_1107_early_chain chain={0,original_video};zero(&e,sizeof(e));
  e.sequence=123;e.corrected_pts=0x123456789ULL;e.cpu_payload_address=parameters.source_base+offset;
  e.type=type;e.payload_size=n;
  r=yi4k_1107_early_on_event(&chain,&queue,0,YI4K_EARLY_VIDEO_EVENT,&e);
 }else{
  yi4k_1107_audio_event e;yi4k_1107_audio_chain chain={0,original_audio};zero(&e,sizeof(e));
  e.encoder_handle=0x123;e.synthetic_pts=0x123456789ULL;
  e.cpu_payload_address=parameters.source_base+offset;e.payload_size=n;
  r=yi4k_1107_audio_on_event(&chain,&audio,&e);
 }
 pipeline_report[0]=r.capture_status;pipeline_report[15]=(uint32_t)r.original_status;
 update();return r.capture_status;
}
int32_t pipeline_adapt(const uint8_t identity[32],uint32_t new_segment,uint32_t capacity){
 int32_t s;uint32_t n=0;yi4k_1107_mux_status ready=yi4k_1107_owned_mux_prepare(&mux);
 if(ready!=YI4K_MUX_READY){update();return -200-(int32_t)ready;}
 if(parameters.kind==1)s=yi4k_1107_codec_video(&epoch,identity,new_segment,0,
    mux.packet.payload,mux.packet.descriptor.payload_size,parameters.output,capacity,&n);
 else s=yi4k_1107_codec_audio(&epoch,identity,0,mux.packet.payload,
    mux.packet.descriptor.payload_size,parameters.output,capacity,&n);
 pipeline_report[6]=(uint32_t)s;pipeline_report[7]=n;
 if(s){yi4k_1107_owned_mux_finish(&mux,s,0);update();return s;}
 pipeline_writer_descriptor=mux.packet.descriptor;
 pipeline_writer_descriptor.cpu_payload_address=parameters.output_base;
 pipeline_writer_descriptor.payload_size=n;update();return 0;
}
int32_t pipeline_finish(int32_t writer_status,uint32_t complete){
 yi4k_1107_mux_status s=yi4k_1107_owned_mux_finish(&mux,writer_status,complete);update();return s;
}
int32_t pipeline_rebind(const yi4k_1107_codec_config *p){return yi4k_1107_codec_init(&epoch,p);}
int32_t pipeline_prepare(void){yi4k_1107_mux_status s=yi4k_1107_owned_mux_prepare(&mux);update();return s;}
