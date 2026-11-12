
#include "yi4k_1107_aac_boundary.h"
#include "yi4k_1107_packet_custody.h"
#include <string.h>
#define CAP 1048576
static yi4k_1107_aac_boundary owner;
static unsigned char lookahead[32768];
static yi4k_1107_codec_config config;
static yi4k_1107_packet_custody custody[4];
static yi4k_1107_custody_slot slots[4][16];
static unsigned char video[2][16][CAP],audio[2][16][2048];
static uint32_t track_index(uint32_t segment,uint32_t track){return (segment-1)*2+track;}
int fresh(uint32_t audio_slots){
 memset(&owner,0,sizeof(owner));memset(&config,0,sizeof(config));
 config.sample_rate=48000;config.samples_per_aac=1024;config.channels=2;
 memset(config.identity,1,32);memset(config.config_digest,2,32);
 yi4k_1107_aac_time split={8008,30000};
 int r=yi4k_1107_aac_boundary_init(&owner,lookahead,sizeof(lookahead),&config,1,1,0,split);
 if(r)return r;
 for(uint32_t seg=1;seg<=2;seg++)for(uint32_t track=0;track<2;track++){
  uint32_t ix=track_index(seg,track);memset(&custody[ix],0,sizeof(custody[ix]));
  memset(slots[ix],0,sizeof(slots[ix]));
  for(uint32_t i=0;i<16;i++){slots[ix][i].payload=track?audio[seg-1][i]:video[seg-1][i];slots[ix][i].capacity=track?2048:CAP;}
  r=yi4k_1107_custody_init(&custody[ix],slots[ix],track?audio_slots:16,track?2:1);if(r)return r;
  r=yi4k_1107_custody_begin(&custody[ix],seg);if(r)return r;
 }
 return 0;
}
int offer(const unsigned char *data,uint32_t size,uint32_t seq,uint64_t pts){
 yi4k_1107_aac_input in;memset(&in,0,sizeof(in));
 in.packet.payload=data;in.packet.source_kind=2;in.packet.descriptor.sequence=seq;
 in.packet.descriptor.corrected_pts=pts;in.packet.descriptor.type=8;in.packet.descriptor.flags=1;
 in.packet.descriptor.payload_size=size;in.packet.descriptor.cpu_payload_address=0x20100000;
 memcpy(in.identity,config.identity,32);memcpy(in.config_digest,config.config_digest,32);
 in.epoch_id=1;in.dts=in.pts=pts;in.scale=48000;in.duration=1024;
 return yi4k_1107_aac_boundary_offer(&owner,&in);
}
int advance(void){yi4k_1107_aac_time split={16016,30000};return yi4k_1107_aac_boundary_advance(&owner,2,owner.held.pts,split);}
int store_audio(void){
 if(owner.state!=YI4K_AAC_READY)return -98;
 return yi4k_1107_custody_store(&custody[track_index((uint32_t)owner.segment_id,1)],&owner.held.packet);
}
int owner_receipt(uint32_t outcome){return yi4k_1107_aac_boundary_receipt(&owner,owner.ticket,outcome);}
uint32_t owner_read(unsigned char *out){memcpy(out,lookahead,owner.held.packet.descriptor.payload_size);return owner.held.packet.descriptor.payload_size;}
uint64_t owner_field(uint32_t field){switch(field){case 0:return owner.state;case 1:return owner.ticket;case 2:return owner.held.pts;case 3:return owner.held.packet.descriptor.sequence;case 4:return owner.segment_id;case 5:return owner.source_epoch;default:return 0;}}
int store_video(uint32_t seg,const unsigned char *data,uint32_t size,uint32_t seq,uint64_t pts,uint32_t type){
 yi4k_1107_mux_packet p;memset(&p,0,sizeof(p));p.payload=data;p.source_kind=1;
 p.descriptor.sequence=seq;p.descriptor.corrected_pts=pts;p.descriptor.type=(uint8_t)type;
 p.descriptor.flags=1;p.descriptor.payload_size=size;
 return yi4k_1107_custody_store(&custody[track_index(seg,0)],&p);
}
int closed(uint32_t seg,uint32_t track,int32_t status){return yi4k_1107_custody_closed(&custody[track_index(seg,track)],status);}
int check(uint32_t seg,uint32_t track,uint32_t seq,uint64_t pts,uint32_t type,const unsigned char *data,uint32_t size){
 yi4k_1107_frame_desc d;memset(&d,0,sizeof(d));d.sequence=seq;d.corrected_pts=pts;d.type=(uint8_t)type;d.flags=1;d.payload_size=size;
 return yi4k_1107_custody_check(&custody[track_index(seg,track)],seg,&d,data);
}
int commit(uint32_t seg,uint32_t track){return yi4k_1107_custody_commit(&custody[track_index(seg,track)],seg,1);}
uint32_t custody_field(uint32_t seg,uint32_t track,uint32_t field){
 yi4k_1107_packet_custody *c=&custody[track_index(seg,track)];
 return field==0?c->state:field==1?c->count:c->checked;
}
uint32_t retained(uint32_t seg,uint32_t track,uint32_t slot,unsigned char *out){
 yi4k_1107_custody_slot *s=&slots[track_index(seg,track)][slot];memcpy(out,s->payload,s->descriptor.payload_size);return s->descriptor.payload_size;
}
