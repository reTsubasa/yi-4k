#include "yi4k_1107_eis_stage_trace.h"

static struct yi4k_eis_stage_slot *find(struct yi4k_eis_stage_trace *t, uint32_t token)
{
    uint32_t i;
    if (!t || !token) return 0;
    for (i=0;i<YI4K_EIS_TRACE_SLOTS;++i)
        if (t->slots[i].token==token && !t->slots[i].finished) return &t->slots[i];
    return 0;
}
static void identity(struct yi4k_eis_table_identity *a,
    const struct yi4k_eis_table_identity *b)
{
    a->bank=b->bank; a->x=b->x; a->y=b->y;
    a->digest_x=b->digest_x; a->digest_y=b->digest_y;
}
static uint32_t equal(const struct yi4k_eis_table_identity *a,
    const struct yi4k_eis_table_identity *b)
{
    return a->bank==b->bank && a->x==b->x && a->y==b->y &&
        a->digest_x==b->digest_x && a->digest_y==b->digest_y;
}
static void zero_table(struct yi4k_eis_table_identity *a)
{
    a->bank=0; a->x=0; a->y=0; a->digest_x=0; a->digest_y=0;
}
void yi4k_eis_stage_trace_init(struct yi4k_eis_stage_trace *t)
{
    uint32_t i;
    if (!t) return;
    t->next_token=1;
    for (i=0;i<YI4K_EIS_TRACE_SLOTS;++i) {
        t->slots[i].token=0; t->slots[i].finished=1;
        t->slots[i].stage=0; t->slots[i].context=0;
        t->slots[i].verdict=YI4K_EIS_INCOMPLETE;
        zero_table(&t->slots[i].generated);
        zero_table(&t->slots[i].prepared);
    }
}
uint32_t yi4k_eis_stage_trace_begin(struct yi4k_eis_stage_trace *t, uint32_t context)
{
    uint32_t i;
    if (!t || !context || !t->next_token) return 0;
    for (i=0;i<YI4K_EIS_TRACE_SLOTS;++i) if (t->slots[i].finished) {
        struct yi4k_eis_stage_slot *s=&t->slots[i];
        s->token=t->next_token++;
        s->context=context; s->stage=0; s->finished=0;
        s->verdict=YI4K_EIS_INCOMPLETE;
        zero_table(&s->generated); zero_table(&s->prepared);
        return s->token;
    }
    return 0;
}
uint32_t yi4k_eis_stage_trace_apply(struct yi4k_eis_stage_trace *t,
    const struct yi4k_eis_stage_receipt *r)
{
    struct yi4k_eis_stage_slot *s;
    if (!t || !r) return YI4K_EIS_BAD_ARGUMENT;
    s=find(t,r->token);
    if (!s) return YI4K_EIS_INVALID_TOKEN;
    if (s->verdict==YI4K_EIS_PREPARED) s->verdict=YI4K_EIS_ORDER_ERROR;
    if (s->verdict!=YI4K_EIS_INCOMPLETE) return s->verdict;
    if (r->context!=s->context || r->stage!=s->stage+1 ||
        r->stage>YI4K_EIS_CANDIDATE) {
        s->verdict=YI4K_EIS_ORDER_ERROR; return s->verdict;
    }
    s->stage=r->stage;
    /* Candidate is a snapshot, not a function return. Nonzero status cannot
     * be silently accepted as a successful candidate receipt. */
    if (r->stage==YI4K_EIS_CANDIDATE && r->status) {
        s->verdict=YI4K_EIS_ORDER_ERROR; return s->verdict;
    }
    if (r->table_token!=r->token && !r->status) {
        s->verdict=YI4K_EIS_STALE; return s->verdict;
    }
    switch (r->stage) {
    case YI4K_EIS_CALC:
        if (r->status) s->verdict=YI4K_EIS_CALC_FAILED;
        else identity(&s->generated,&r->table);
        break;
    case YI4K_EIS_SET:
        if (r->status) s->verdict=YI4K_EIS_SET_FAILED;
        else if (r->observations!=YI4K_EIS_TRACE_COPIED_CLEANED ||
            !r->table.bank || !r->table.x || !r->table.y ||
            r->table.x==r->table.y ||
            r->table.digest_x!=s->generated.digest_x ||
            r->table.digest_y!=s->generated.digest_y)
            s->verdict=YI4K_EIS_STALE;
        else identity(&s->prepared,&r->table);
        break;
    case YI4K_EIS_GET:
        if (r->status) s->verdict=YI4K_EIS_GET_FAILED;
        else if (!equal(&s->prepared,&r->table)) s->verdict=YI4K_EIS_STALE;
        break;
    case YI4K_EIS_CANDIDATE:
        if (!equal(&s->prepared,&r->table)) s->verdict=YI4K_EIS_STALE;
        else s->verdict=YI4K_EIS_PREPARED;
        break;
    default: s->verdict=YI4K_EIS_ORDER_ERROR; break;
    }
    return s->verdict;
}
uint32_t yi4k_eis_stage_trace_finish(struct yi4k_eis_stage_trace *t, uint32_t token)
{
    struct yi4k_eis_stage_slot *s=find(t,token);
    if (!s) return YI4K_EIS_INVALID_TOKEN;
    s->finished=1;
    return s->verdict;
}
