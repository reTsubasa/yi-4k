#include "yi4k_1107_aac_boundary.h"
#define MAGIC UINT32_C(0x41414342)
static int valid(const void *p,size_t n){return p && n<=UINTPTR_MAX-(uintptr_t)p;}
static int overlap(const void *p,size_t n,const void *q,size_t m){return (uintptr_t)p<(uintptr_t)q+m&&(uintptr_t)q<(uintptr_t)p+n;}
static void copy(void *d,const void *s,size_t n){uint8_t *a=d;const uint8_t *b=s;while(n--)*a++=*b++;}
static int equal(const uint8_t *a,const uint8_t *b,size_t n){while(n--)if(*a++!=*b++)return 0;return 1;}
static int nonzero(const uint8_t *p){uint32_t i,v=0;for(i=0;i<32;i++)v|=p[i];return v!=0;}
/* Exact 96-bit product, no compiler division helper or overflowing cross product. */
static void mul(uint64_t a,uint32_t b,uint64_t *lo,uint32_t *hi){
    uint64_t x=(uint64_t)(uint32_t)a*b,y=(a>>32)*b;
    *lo=x+(y<<32);*hi=(uint32_t)(y>>32)+(*lo<x);
}
static int compare(yi4k_1107_aac_time a,yi4k_1107_aac_time b){
    uint64_t x,y;uint32_t h,k;mul(a.ticks,b.scale,&x,&h);mul(b.ticks,a.scale,&y,&k);
    return h<k?-1:h>k?1:x<y?-1:x>y?1:0;
}
static int aliases(const yi4k_1107_aac_boundary *c,const void *p,size_t n){
    return overlap(c,sizeof(*c),p,n)||overlap(c->bytes,c->capacity,p,n);
}
int32_t yi4k_1107_aac_boundary_init(yi4k_1107_aac_boundary *c,uint8_t *bytes,
 uint32_t cap,const yi4k_1107_codec_config *config,uint64_t epoch,uint64_t segment,
 uint64_t origin,yi4k_1107_aac_time split){
    yi4k_1107_aac_time start;
    if(!valid(c,sizeof(*c))||!valid(config,sizeof(*config))||!valid(bytes,cap)||
       (uintptr_t)c%_Alignof(yi4k_1107_aac_boundary)||
       (uintptr_t)config%_Alignof(yi4k_1107_codec_config)||!cap||cap>YI4K_CODEC_AUDIO_MAX||
       overlap(c,sizeof(*c),bytes,cap)||overlap(c,sizeof(*c),config,sizeof(*config))||
       overlap(bytes,cap,config,sizeof(*config))||!epoch||!segment||!split.scale||
       !config->sample_rate||config->samples_per_aac!=1024||
       !nonzero(config->identity)||!nonzero(config->config_digest))return YI4K_AAC_BAD_ARGUMENT;
    if(c->magic)return YI4K_AAC_BAD_STATE;
    start.ticks=origin;start.scale=config->sample_rate;
    if(compare(start,split)>=0)return YI4K_AAC_BAD_ARGUMENT;
    c->magic=MAGIC;c->state=YI4K_AAC_EMPTY;c->bytes=bytes;c->capacity=cap;
    copy(c->identity,config->identity,32);copy(c->config_digest,config->config_digest,32);
    c->scale=config->sample_rate;c->duration=config->samples_per_aac;c->epoch_id=epoch;
    c->segment_id=segment;c->source_epoch=origin;c->split=split;
    c->have_previous=0;c->previous_sequence=0;c->previous_end=0;c->ticket=0;
    return YI4K_AAC_OK;
}
int32_t yi4k_1107_aac_boundary_offer(yi4k_1107_aac_boundary *c,const yi4k_1107_aac_input *in){
    const yi4k_1107_frame_desc *d;yi4k_1107_aac_time end;
    if(!c||c->magic!=MAGIC||!valid(in,sizeof(*in))||
       (uintptr_t)in%_Alignof(yi4k_1107_aac_input))return YI4K_AAC_BAD_ARGUMENT;
    if(c->state==YI4K_AAC_FROZEN)return YI4K_AAC_BAD_STATE;
    if(c->state!=YI4K_AAC_EMPTY)return YI4K_AAC_BUSY;
    d=&in->packet.descriptor;
    if(aliases(c,in,sizeof(*in))||in->packet.is_end||in->packet.source_kind!=YI4K_EARLY_SOURCE_AUDIO||
       d->type!=8||d->flags!=1||!d->payload_size||
       !valid(in->packet.payload,d->payload_size)||aliases(c,in->packet.payload,d->payload_size)||
       overlap(in,sizeof(*in),in->packet.payload,d->payload_size))return YI4K_AAC_BAD_ARGUMENT;
    if(d->payload_size>c->capacity||in->pts>UINT64_MAX-in->duration||c->ticket==UINT64_MAX)
        return YI4K_AAC_LIMIT;
    if(in->epoch_id!=c->epoch_id||!equal(in->identity,c->identity,32)||
       !equal(in->config_digest,c->config_digest,32)||in->scale!=c->scale||
       in->duration!=c->duration||in->dts!=in->pts||d->corrected_pts!=in->pts||
       in->pts<c->source_epoch||(c->have_previous&&
       (c->previous_sequence==UINT32_MAX||d->sequence!=c->previous_sequence+1||in->dts!=c->previous_end))){
        c->state=YI4K_AAC_FROZEN;return YI4K_AAC_DISCONTINUITY;
    }
    copy(c->bytes,in->packet.payload,d->payload_size);copy(&c->held,in,sizeof(*in));
    c->held.packet.payload=c->bytes; /* Source descriptor address remains provenance, never dereferenced. */
    c->previous_sequence=d->sequence;c->previous_end=in->pts+in->duration;c->have_previous=1;++c->ticket;
    end.ticks=c->previous_end;end.scale=c->scale;
    c->state=compare(end,c->split)<=0?YI4K_AAC_READY:YI4K_AAC_NEXT;
    return (int32_t)c->state;
}
int32_t yi4k_1107_aac_boundary_advance(yi4k_1107_aac_boundary *c,uint64_t segment,
 uint64_t origin,yi4k_1107_aac_time split){
    yi4k_1107_aac_time end;
    if(!c||c->magic!=MAGIC||!split.scale)return YI4K_AAC_BAD_ARGUMENT;
    if(c->state!=YI4K_AAC_NEXT)return YI4K_AAC_BAD_STATE;
    end.ticks=c->previous_end;end.scale=c->scale;
    if(segment<=c->segment_id||origin<c->source_epoch||origin>c->held.pts||
       compare(split,c->split)<=0||compare(end,split)>0)return YI4K_AAC_BAD_ARGUMENT;
    c->segment_id=segment;c->source_epoch=origin;c->split=split;c->state=YI4K_AAC_READY;
    return YI4K_AAC_READY;
}
int32_t yi4k_1107_aac_boundary_receipt(yi4k_1107_aac_boundary *c,uint64_t ticket,uint32_t outcome){
    if(!c||c->magic!=MAGIC||outcome>YI4K_AAC_AMBIGUOUS)return YI4K_AAC_BAD_ARGUMENT;
    if(c->state!=YI4K_AAC_READY||ticket!=c->ticket)return YI4K_AAC_BAD_STATE;
    if(outcome==YI4K_AAC_AMBIGUOUS){c->state=YI4K_AAC_FROZEN;return YI4K_AAC_BAD_STATE;}
    if(outcome==YI4K_AAC_RETRY_UNTOUCHED)return YI4K_AAC_READY;
    c->state=YI4K_AAC_EMPTY;return YI4K_AAC_OK;
}
