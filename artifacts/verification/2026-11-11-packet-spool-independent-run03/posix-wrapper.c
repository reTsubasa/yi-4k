
#include "yi4k_packet_spool.h"
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
static yi4k_packet_spool controller;
static unsigned char scratch[1048576];
static yi4k_spool_identity identity;
static int descriptor=-1, crash_phase=0, phase=0;
static unsigned long long recovered=0;
static int32_t size_fn(void *c,uint64_t *n) { struct stat s;(void)c;if(fstat(descriptor,&s))return -1;*n=(uint64_t)s.st_size;return 0; }
static void crash(void) { if(++phase==crash_phase)_exit(73); }
static int32_t write_fn(void *c,uint64_t at,const uint8_t *p,uint32_t n,uint32_t *got) {
 ssize_t r;(void)c;r=pwrite(descriptor,p,n,(off_t)at);*got=r<0?0:(uint32_t)r;crash();return r<0?-1:0;
}
static int32_t read_fn(void *c,uint64_t at,uint8_t *p,uint32_t n,uint32_t *got) {
 ssize_t r;(void)c;r=pread(descriptor,p,n,(off_t)at);*got=r<0?0:(uint32_t)r;crash();return r<0?-1:0;
}
static int32_t sync_fn(void *c){int r;(void)c;r=fsync(descriptor);crash();return r;}
static yi4k_spool_io backend={0,size_fn,write_fn,read_fn,sync_fn};
static void id(void){memset(&identity,0,sizeof(identity));identity.session=1;identity.segment=2;identity.epoch=3;memset(identity.config_digest,0x44,32);}
int create_file(const char *path,int cut){
 char parent[4096],*slash;int parent_fd;
 memset(&controller,0,sizeof(controller));id();phase=0;crash_phase=cut;
 descriptor=open(path,O_RDWR|O_CREAT|O_EXCL,0600);if(descriptor<0)return -90;
 if(strlen(path)>=sizeof(parent))return -91;
 strcpy(parent,path);slash=strrchr(parent,'/');if(!slash)return -92;
 *slash=0;parent_fd=open(parent,O_RDONLY);if(parent_fd<0)return -93;
 if(fsync(parent_fd)){close(parent_fd);return -94;}close(parent_fd);
 return yi4k_spool_init(&controller,&backend,&identity,scratch,sizeof(scratch));
}
int close_file(void){int r=close(descriptor);descriptor=-1;return r;}
int append_audio(const unsigned char *p,uint32_t n,uint32_t sequence,uint64_t pts){
 yi4k_spool_sample s;memset(&s,0,sizeof(s));s.packet.payload=p;s.packet.source_kind=YI4K_EARLY_SOURCE_AUDIO;
 s.packet.descriptor.type=8;s.packet.descriptor.flags=1;s.packet.descriptor.sequence=sequence;
 s.packet.descriptor.corrected_pts=pts;s.packet.descriptor.payload_size=n;s.packet.descriptor.cpu_payload_address=0x22000000;
 s.dts=s.pts=pts;s.scale=48000;s.duration=1024;return yi4k_spool_append(&controller,&s);
}
static int32_t collect(void *c,uint64_t ordinal,const yi4k_spool_sample *s){
 (void)c;if(ordinal!=recovered+1||s->packet.descriptor.sequence!=recovered||s->pts!=recovered*1024)return -1;
 ++recovered;return 0;
}
int scan_file(const char *path,uint64_t *words){
 yi4k_spool_scan_result r;int status;id();phase=0;crash_phase=0;recovered=0;
 descriptor=open(path,O_RDONLY);if(descriptor<0)return -90;
 status=yi4k_spool_scan(&backend,&identity,scratch,sizeof(scratch),collect,0,&r);
 words[0]=r.file_bytes;words[1]=r.committed_bytes;words[2]=r.records;words[3]=r.trailing_bytes;words[4]=r.corrupt;words[5]=recovered;
 close_file();return status;
}
