
#include "yi4k_packet_spool.h"
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <string.h>
static yi4k_packet_spool controller;
static unsigned char scratch[1048576];
static yi4k_spool_identity identity;
static int descriptor=-1;
static int32_t size_fn(void *c,uint64_t *n){struct stat s;(void)c;if(fstat(descriptor,&s))return -1;*n=(uint64_t)s.st_size;return 0;}
static int32_t write_fn(void *c,uint64_t at,const uint8_t *p,uint32_t n,uint32_t *got){ssize_t r;(void)c;r=pwrite(descriptor,p,n,(off_t)at);*got=r<0?0:(uint32_t)r;return r<0?-1:0;}
static int32_t read_fn(void *c,uint64_t at,uint8_t *p,uint32_t n,uint32_t *got){ssize_t r;(void)c;r=pread(descriptor,p,n,(off_t)at);*got=r<0?0:(uint32_t)r;return r<0?-1:0;}
static int32_t sync_fn(void *c){(void)c;return fsync(descriptor);}
static yi4k_spool_io io={0,size_fn,write_fn,read_fn,sync_fn};
static void set_id(uint64_t segment,const unsigned char *digest){memset(&identity,0,sizeof(identity));identity.session=1107;identity.segment=segment;identity.epoch=1;memcpy(identity.config_digest,digest,32);}
int create_file(const char *path,uint64_t segment,const unsigned char *digest){
 char parent[4096],*slash;int parent_fd;
 if(strlen(path)>=sizeof(parent))return -91;
 strcpy(parent,path);slash=strrchr(parent,'/');if(!slash)return -92;*slash=0;
 descriptor=open(path,O_RDWR|O_CREAT|O_EXCL,0600);if(descriptor<0)return -90;
 parent_fd=open(parent,O_RDONLY);if(parent_fd<0)return -93;
 if(fsync(parent_fd)){close(parent_fd);return -94;}close(parent_fd);
 memset(&controller,0,sizeof(controller));set_id(segment,digest);
 return yi4k_spool_init(&controller,&io,&identity,scratch,sizeof(scratch));
}
int close_file(void){int r=close(descriptor);descriptor=-1;return r;}
int append_record(uint32_t kind,uint32_t sequence,uint64_t pts,uint32_t scale,uint32_t duration,uint32_t type,uint32_t address,const unsigned char *p,uint32_t n){
 yi4k_spool_sample s;memset(&s,0,sizeof(s));s.packet.payload=p;s.packet.source_kind=kind;
 s.packet.descriptor.sequence=sequence;s.packet.descriptor.corrected_pts=pts;
 s.packet.descriptor.type=(uint8_t)type;s.packet.descriptor.flags=1;
 s.packet.descriptor.cpu_payload_address=address;s.packet.descriptor.payload_size=n;
 s.dts=s.pts=pts;s.scale=scale;s.duration=duration;return yi4k_spool_append(&controller,&s);
}
typedef int32_t (*emit_fn)(uint64_t,uint32_t,uint32_t,uint64_t,uint64_t,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t,const uint8_t *,uint32_t);
static emit_fn emit;
static int32_t collect(void *c,uint64_t ordinal,const yi4k_spool_sample *s){
 const yi4k_1107_frame_desc *d=&s->packet.descriptor;(void)c;
 return emit(ordinal,s->packet.source_kind,d->sequence,s->dts,s->pts,s->scale,s->duration,d->type,d->flags,d->cpu_payload_address,s->packet.payload,d->payload_size);
}
int scan_file(const char *path,uint64_t segment,const unsigned char *digest,emit_fn callback,uint64_t *words){
 yi4k_spool_scan_result r;int status;set_id(segment,digest);emit=callback;
 descriptor=open(path,O_RDONLY);if(descriptor<0)return -90;
 status=yi4k_spool_scan(&io,&identity,scratch,sizeof(scratch),collect,0,&r);
 words[0]=r.file_bytes;words[1]=r.committed_bytes;words[2]=r.records;words[3]=r.trailing_bytes;words[4]=r.corrupt;
 close_file();return status;
}
