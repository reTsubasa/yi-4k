
#include "yi4k_spool_seal.h"
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <string.h>
typedef struct file {int fd,is_seal;} file;
static file p={-1,0},s={-1,1};
static yi4k_packet_spool spool;
static yi4k_source_coverage source;
static yi4k_seal_request request;
static unsigned char scratch[1048576];
static int cut=0,phase=0,active=0;
static void tick(file *f){if(active&&f->is_seal&&++phase==cut)_exit(73);}
static int32_t size_fn(void *context,uint64_t *n){file *f=context;struct stat st;int r=fstat(f->fd,&st);if(!r)*n=(uint64_t)st.st_size;tick(f);return r;}
static int32_t read_fn(void *context,uint64_t at,uint8_t *b,uint32_t n,uint32_t *got){file *f=context;ssize_t r=pread(f->fd,b,n,(off_t)at);*got=r<0?0:(uint32_t)r;tick(f);return r<0?-1:0;}
static int32_t write_fn(void *context,uint64_t at,const uint8_t *b,uint32_t n,uint32_t *got){file *f=context;ssize_t r=pwrite(f->fd,b,n,(off_t)at);*got=r<0?0:(uint32_t)r;tick(f);return r<0?-1:0;}
static int32_t sync_fn(void *context){file *f=context;int r=fsync(f->fd);tick(f);return r;}
static yi4k_spool_io pio={&p,size_fn,write_fn,read_fn,sync_fn},sio={&s,size_fn,write_fn,read_fn,sync_fn};
void configure(uint64_t session,uint64_t segment,uint64_t epoch,const uint8_t *digest,uint64_t closure,uint32_t scope,uint64_t count,uint64_t bytes){
 memset(&request,0,sizeof(request));request.identity.session=session;request.identity.segment=segment;request.identity.epoch=epoch;
 memcpy(request.identity.config_digest,digest,32);request.closure_id=closure;request.scope=scope;request.records=count;request.payload_bytes=bytes;
}
void track(uint32_t index,uint64_t count,uint64_t first,uint64_t end,uint32_t first_seq,uint32_t last_seq,uint32_t scale){
 yi4k_seal_track *t=&request.tracks[index];t->records=count;t->first_pts=first;t->end_pts=end;t->first_sequence=first_seq;t->last_sequence=last_seq;t->scale=scale;
}
static int open_new(file *f,const char *path){
 char parent[4096],*slash;int dir;
 if(strlen(path)>=sizeof(parent))return -91;strcpy(parent,path);slash=strrchr(parent,'/');if(!slash)return -92;*slash=0;
 f->fd=open(path,O_RDWR|O_CREAT|O_EXCL,0600);if(f->fd<0)return -90;
 dir=open(parent,O_RDONLY);if(dir<0)return -93;if(fsync(dir)){close(dir);return -94;}close(dir);return 0;
}
int create(const char *a,const char *b){int r;active=0;phase=0;memset(&spool,0,sizeof(spool));memset(&source,0,sizeof(source));
 if((r=open_new(&p,a))||(r=open_new(&s,b)))return r;
 if((r=yi4k_spool_init(&spool,&pio,&request.identity,scratch,sizeof(scratch))))return r;
 return yi4k_coverage_init(&source,&request.identity);
}
int add(uint32_t kind,uint32_t seq,uint64_t pts,uint32_t scale,uint32_t duration,uint32_t type,const uint8_t *data,uint32_t n){
 yi4k_spool_sample v;int r;memset(&v,0,sizeof(v));v.packet.source_kind=kind;v.packet.payload=data;
 v.packet.descriptor.sequence=seq;v.packet.descriptor.corrected_pts=pts;v.packet.descriptor.type=(uint8_t)type;v.packet.descriptor.flags=1;v.packet.descriptor.payload_size=n;
 v.dts=v.pts=pts;v.scale=scale;v.duration=duration;
 if((r=yi4k_coverage_add(&source,&v)))return r;
 return yi4k_spool_append(&spool,&v);
}
int finish(int crash){int r;cut=crash;phase=0;active=1;r=yi4k_spool_seal_commit(&source,&request,&pio,&sio,scratch,sizeof(scratch));active=0;return r;}
int close_files(void){int a=0,b=0;active=0;if(p.fd>=0)a=close(p.fd);if(s.fd>=0)b=close(s.fd);p.fd=s.fd=-1;return a?a:b;}
int verify(const char *a,const char *b,uint64_t *words,uint8_t *digest){
 yi4k_seal_receipt receipt;int r;active=0;p.fd=open(a,O_RDONLY);s.fd=open(b,O_RDONLY);
 if(p.fd<0||s.fd<0){close_files();return -90;}
 memset(&receipt,0,sizeof(receipt));r=yi4k_spool_seal_verify(&request,&pio,&sio,scratch,sizeof(scratch),&receipt);
 words[0]=receipt.valid;words[1]=receipt.scope;words[2]=receipt.closure_id;words[3]=receipt.records;words[4]=receipt.spool_bytes;
 memcpy(digest,receipt.transcript_sha256,32);close_files();return r;
}

typedef int32_t (*emit_sample)(uint64_t,uint32_t,uint32_t,uint64_t,uint32_t,uint32_t,uint32_t,const uint8_t *,uint32_t);
static emit_sample emit_callback;
static int32_t emit(void *context,uint64_t ordinal,const yi4k_spool_sample *v){
 (void)context;return emit_callback(ordinal,v->packet.source_kind,v->packet.descriptor.sequence,
 v->pts,v->scale,v->duration,v->packet.descriptor.type,v->packet.payload,v->packet.descriptor.payload_size);
}
int scan_values(const char *path,emit_sample callback,uint64_t *words){
 yi4k_spool_scan_result result;int r;active=0;p.fd=open(path,O_RDONLY);if(p.fd<0)return -90;
 emit_callback=callback;memset(&result,0,sizeof(result));
 r=yi4k_spool_scan(&pio,&request.identity,scratch,sizeof(scratch),emit,0,&result);
 words[0]=result.records;words[1]=result.committed_bytes;words[2]=result.file_bytes;
 words[3]=result.trailing_bytes;words[4]=result.corrupt;close_files();return r;
}
