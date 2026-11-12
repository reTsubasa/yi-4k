#ifndef YI4K_1107_EIS_STAGE_TRACE_H
#define YI4K_1107_EIS_STAGE_TRACE_H
#include <stdint.h>

/* Offline receipt reducer, NOT an installed RTOS observer. Caller serializes
 * access and supplies stable snapshots from the SAME invocation. No firmware
 * pointers are dereferenced, no code is patched and no bank is published.
 * Digest fields are evidence identifiers, not authenticity or hardware/cache
 * completion proofs. This version supports the mandatory-Get zero branch.
 */
#define YI4K_EIS_TRACE_SLOTS 4u
#define YI4K_EIS_TRACE_COPIED_CLEANED 15u
enum yi4k_eis_stage { YI4K_EIS_CALC=1, YI4K_EIS_SET=2,
    YI4K_EIS_GET=3, YI4K_EIS_CANDIDATE=4 };
enum yi4k_eis_verdict { YI4K_EIS_INCOMPLETE=0, YI4K_EIS_PREPARED=1,
    YI4K_EIS_CALC_FAILED=2, YI4K_EIS_SET_FAILED=3,
    YI4K_EIS_GET_FAILED=4, YI4K_EIS_STALE=5,
    YI4K_EIS_ORDER_ERROR=6, YI4K_EIS_INVALID_TOKEN=7,
    YI4K_EIS_BAD_ARGUMENT=8 };
struct yi4k_eis_table_identity { uint32_t bank, x, y, digest_x, digest_y; };
struct yi4k_eis_stage_receipt {
    uint32_t token, context, stage;
    int32_t status; /* Calc/Set/Get return; Candidate MUST use zero. */
    /* Provenance token carried with the table snapshot, not inferred from
     * its bank address (the same bank may be reused next invocation). */
    uint32_t table_token;
    struct yi4k_eis_table_identity table;
    /* Set: bit0/1 X/Y copied, bit2/3 X/Y clean calls observed.
     * Candidate: ready byte as observed, deliberately NOT a success condition. */
    uint32_t observations;
};
struct yi4k_eis_stage_slot {
    uint32_t token, context, stage, finished, verdict;
    struct yi4k_eis_table_identity generated, prepared;
};
struct yi4k_eis_stage_trace {
    uint32_t next_token;
    struct yi4k_eis_stage_slot slots[YI4K_EIS_TRACE_SLOTS];
};
_Static_assert(sizeof(struct yi4k_eis_table_identity)==20, "table receipt ABI");
_Static_assert(sizeof(struct yi4k_eis_stage_receipt)==44, "stage receipt ABI");
_Static_assert(sizeof(struct yi4k_eis_stage_trace)==244, "stage trace ABI");
void yi4k_eis_stage_trace_init(struct yi4k_eis_stage_trace *);
/* Nonzero token; zero on full/invalid/exhausted. Tokens never wrap or reuse
 * within a trace lifetime. Reinitialize only after all producers are quiescent;
 * a new lifetime must be associated with a new capture epoch by the exporter. */
uint32_t yi4k_eis_stage_trace_begin(struct yi4k_eis_stage_trace *, uint32_t context);
uint32_t yi4k_eis_stage_trace_apply(struct yi4k_eis_stage_trace *,
    const struct yi4k_eis_stage_receipt *);
/* Seals the slot, including incomplete/error evidence; only then reusable.
 * PREPARED means checked receipts agree, not DSP latch, encoded-frame identity,
 * native execution safety or permission to replace EIS. */
uint32_t yi4k_eis_stage_trace_finish(struct yi4k_eis_stage_trace *, uint32_t token);
#endif
