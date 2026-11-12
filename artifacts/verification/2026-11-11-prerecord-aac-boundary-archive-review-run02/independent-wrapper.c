
#include "yi4k_1107_aac_boundary.h"
#include <string.h>
static yi4k_1107_aac_boundary c;
static unsigned char bytes[YI4K_CODEC_AUDIO_MAX];
static yi4k_1107_codec_config config;
int fresh(uint32_t scale,uint64_t split,uint32_t split_scale) {
 memset(&c,0,sizeof(c));memset(bytes,0xa5,sizeof(bytes));memset(&config,0,sizeof(config));
 config.sample_rate=scale;config.samples_per_aac=1024;config.channels=2;
 memset(config.identity,1,32);memset(config.config_digest,2,32);
 yi4k_1107_aac_time time={split,split_scale};
 return yi4k_1107_aac_boundary_init(&c,bytes,sizeof(bytes),&config,1,1,0,time);
}
int offer(const unsigned char *data,uint32_t size,uint32_t sequence,uint64_t pts) {
 yi4k_1107_aac_input in;memset(&in,0,sizeof(in));
 in.packet.payload=data;in.packet.source_kind=YI4K_EARLY_SOURCE_AUDIO;
 in.packet.descriptor.sequence=sequence;in.packet.descriptor.corrected_pts=pts;
 in.packet.descriptor.type=8;in.packet.descriptor.flags=1;
 in.packet.descriptor.payload_size=size;in.packet.descriptor.cpu_payload_address=0x20000000;
 memcpy(in.identity,config.identity,32);memcpy(in.config_digest,config.config_digest,32);
 in.epoch_id=1;in.dts=pts;in.pts=pts;in.duration=1024;in.scale=config.sample_rate;
 return yi4k_1107_aac_boundary_offer(&c,&in);
}
int advance(uint64_t segment,uint64_t epoch,uint64_t split,uint32_t scale) {
 yi4k_1107_aac_time t={split,scale};
 return yi4k_1107_aac_boundary_advance(&c,segment,epoch,t);
}
int receipt(uint64_t ticket,uint32_t outcome){return yi4k_1107_aac_boundary_receipt(&c,ticket,outcome);}
uint64_t field(uint32_t key) {
 switch(key){case 0:return c.state;case 1:return c.ticket;case 2:return c.segment_id;
 case 3:return c.source_epoch;case 4:return c.held.pts;case 5:return c.held.dts;
 case 6:return c.held.packet.descriptor.sequence;case 7:return c.held.packet.descriptor.payload_size;
 case 8:return c.previous_end;default:return 0;}
}
uint32_t read_bytes(unsigned char *out){memcpy(out,bytes,c.held.packet.descriptor.payload_size);return c.held.packet.descriptor.payload_size;}
void snapshot(unsigned char *out){memcpy(out,&c,sizeof(c));memcpy(out+sizeof(c),bytes,sizeof(bytes));}
uint32_t snapshot_size(void){return sizeof(c)+sizeof(bytes);}
