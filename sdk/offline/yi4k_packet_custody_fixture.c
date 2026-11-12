/* Offline integration fixture: not a firmware wrapper or recovery service. */
#include "yi4k_1107_packet_custody.h"
#define CAP 2048
#define SLOTS 16
uint8_t custody_fixture_input[CAP];
uint8_t custody_fixture_retained[SLOTS * CAP];
uint32_t custody_fixture_report[12];
static uint8_t source[CAP], early_bytes[2 * CAP];
static yi4k_1107_owned_slot early_slots[2];
static yi4k_1107_custody_slot retained_slots[SLOTS];
static yi4k_1107_early_copy early;
static yi4k_1107_owned_mux mux;
static yi4k_1107_packet_custody custody;
static uint32_t kind;
static void zero(void *p, size_t n) { volatile uint8_t *b=p; while(n--) *b++=0; }
static void report(void) {
    custody_fixture_report[0]=custody.count; custody_fixture_report[1]=custody.checked;
    custody_fixture_report[2]=custody.state; custody_fixture_report[3]=mux.held!=0;
    custody_fixture_report[4]=mux.poisoned; custody_fixture_report[5]=atomic_load(&early.head);
    custody_fixture_report[6]=atomic_load(&early.tail); custody_fixture_report[7]=early.accepted;
    custody_fixture_report[8]=early.dropped; custody_fixture_report[9]=source[0];
    custody_fixture_report[10]=early_bytes[0]; custody_fixture_report[11]=early_bytes[CAP];
}
int32_t custody_fixture_init(uint32_t source_kind, uint32_t count, uint32_t capacity) {
    yi4k_1107_ring_view ring; yi4k_1107_owned_arena arena; uint32_t i;
    if(count==0 || count>SLOTS || capacity==0 || capacity>CAP) return -101;
    zero(&early,sizeof(early)); zero(&mux,sizeof(mux)); zero(&custody,sizeof(custody));
    zero(early_slots,sizeof(early_slots)); zero(retained_slots,sizeof(retained_slots));
    zero(custody_fixture_report,sizeof(custody_fixture_report));
    for(i=0;i<sizeof(custody_fixture_retained);i++)custody_fixture_retained[i]=0xcc;
    kind=source_kind;
    ring.bytes=source;ring.cpu_base=0x30000000;ring.size=CAP;
    arena.bytes=early_bytes;arena.cpu_base=0x31000000;arena.size=sizeof(early_bytes);
    for(i=0;i<2;i++){early_slots[i].payload=early_bytes+i*CAP;early_slots[i].capacity=CAP;}
    for(i=0;i<count;i++){retained_slots[i].payload=custody_fixture_retained+i*CAP;retained_slots[i].capacity=capacity;}
    if(yi4k_1107_early_init(&early,&ring,early_slots,2))return -102;
    if(yi4k_1107_owned_mux_init(&mux,&early,&arena,kind))return -103;
    if(yi4k_1107_custody_init(&custody,retained_slots,count,kind))return -104;
    i=yi4k_1107_custody_begin(&custody,1);report();return (int32_t)i;
}
static void descriptor(yi4k_1107_frame_desc *d,uint32_t seq,uint32_t lo,uint32_t hi,uint32_t n) {
    zero(d,sizeof(*d));d->sequence=seq;d->corrected_pts=((uint64_t)hi<<32)|lo;
    d->type=kind==2?8:1;d->flags=1;d->payload_size=n;d->cpu_payload_address=0x30000000;
}
int32_t custody_fixture_offer(uint32_t seq,uint32_t lo,uint32_t hi,uint32_t n) {
    yi4k_1107_frame_desc d;yi4k_1107_video_event v;yi4k_1107_audio_event a;
    uint32_t i;int32_t result;
    if(n>CAP)return -105;
    for(i=0;i<n;i++)source[i]=custody_fixture_input[i];
    descriptor(&d,seq,lo,hi,n);zero(&v,sizeof(v));zero(&a,sizeof(a));
    result=yi4k_1107_early_offer_frame(&early,&d,kind,kind==2?(const void*)&a:(const void*)&v);
    for(i=0;i<CAP;i++)source[i]=0xee;
    if(result!=YI4K_EARLY_COPIED){report();return 100+result;}
    result=yi4k_1107_owned_mux_prepare(&mux);
    if(result!=YI4K_MUX_READY){report();return 200+result;}
    result=yi4k_1107_custody_store(&custody,&mux.packet);
    /* Storage copy, not writer completion: custody now owns the original bytes.
     * Fixture has no writer/DMA readers, so early lease can be released here.
     * A target integration must separately keep any actual writer lease. */
    if(result==0 && yi4k_1107_owned_mux_finish(&mux,0,1)!=YI4K_MUX_RELEASED)return -106;
    report();return result;
}
int32_t custody_fixture_closed(int32_t status) {
    int32_t result=yi4k_1107_custody_closed(&custody,status);report();return result;
}
int32_t custody_fixture_check(uint32_t seq,uint32_t lo,uint32_t hi,uint32_t n,uint32_t id,uint32_t alias) {
    yi4k_1107_frame_desc d;int32_t result;descriptor(&d,seq,lo,hi,n);
    result=yi4k_1107_custody_check(&custody,id,&d,alias?custody_fixture_retained:custody_fixture_input);
    report();return result;
}
int32_t custody_fixture_commit(uint32_t id,uint32_t complete) {
    int32_t result=yi4k_1107_custody_commit(&custody,id,complete);report();return result;
}
int32_t custody_fixture_begin(uint32_t id) {
    int32_t result=yi4k_1107_custody_begin(&custody,id);report();return result;
}
