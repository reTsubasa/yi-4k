#ifndef YI4K_11052_INTERNAL_H
#define YI4K_11052_INTERNAL_H
/*
 * STATIC ANALYSIS ONLY. This is an analyst's ABI notebook, not a tested SDK.
 * Do not call these addresses from Linux or from another firmware build.
 * Community release v1.10.52; RTOS retains a 1.10.9 build string.
 * RTOS SHA256:
 * c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
 *
 * Address/ABI evidence: artifacts/rtos-reverse/core/{interfaces.json,findings.md}
 * A32 code unless explicitly Thumb. Runtime execution, privilege, object life,
 * stack alignment, global initialization, and reentrancy remain untested.
 */
#include <stdint.h>

#define YI4K_RTOS_SHA256 "c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141"
#define YI4K_RTOS_ANALYSIS_BASE UINT32_C(0xA0100000)

/* Handler register convention observed in shell dispatcher and consumers.
 * Callback is printf-like; its exact return type is not proven (callers ignore it).
 * t dispatcher shifts argv by one, so handler argv[0] is its subcommand name.
 */
typedef int (*yi4k_shell_print_candidate_t)(const char *format, ...);
typedef int (*yi4k_shell_handler_candidate_t)(int argc, char **argv,
                                            yi4k_shell_print_candidate_t print);
typedef int (*yi4k_t_register_candidate_t)(const char *name,
                                          yi4k_shell_handler_candidate_t handler);
#define YI4K_ADDR_T_REGISTER UINT32_C(0xA029E098)
#define YI4K_ADDR_T_DISPATCH UINT32_C(0xA029E1A4)

/* Internal file object is opaque; it is not the toolchain's libc FILE.
 * YI callers use four 32-bit registers for fread/fwrite, unlike some older DJI
 * annotated signatures with uint64_t parameters. Do not transplant those types.
 */
struct yi4k_internal_file;
typedef struct yi4k_internal_file *(*yi4k_fopen_candidate_t)(const char *, const char *);
typedef int (*yi4k_fclose_candidate_t)(struct yi4k_internal_file *);
typedef uint32_t (*yi4k_fread_candidate_t)(void *, uint32_t, uint32_t,
                                         struct yi4k_internal_file *);
typedef uint32_t (*yi4k_fwrite_candidate_t)(const void *, uint32_t, uint32_t,
                                          struct yi4k_internal_file *);
#define YI4K_ADDR_FS_FOPEN  UINT32_C(0xA032E0C8)
#define YI4K_ADDR_FS_FCLOSE UINT32_C(0xA032E0D0)
#define YI4K_ADDR_FS_FREAD  UINT32_C(0xA032E0D4)
#define YI4K_ADDR_FS_FWRITE UINT32_C(0xA032E0D8)

/* Task/ThreadX types remain deliberately opaque. 0xD8 control-block bytes is
 * observed in this build, but this does not establish required alignment,
 * ownership, SMP extensions, stack guards, or life-cycle cleanup rules.
 */
#define YI4K_OBSERVED_THREAD_CONTROL_BYTES UINT32_C(0xD8)
typedef void (*yi4k_task_entry_candidate_t)(uint32_t arg);
typedef uint32_t (*yi4k_task_create_candidate_t)(void *task, const char *name,
    uint32_t priority, yi4k_task_entry_candidate_t entry, uint32_t entry_arg,
    void *stack_base, uint32_t stack_bytes, uint32_t auto_start);
typedef uint32_t (*yi4k_task_sleep_candidate_t)(uint32_t raw_ticks);
typedef uint32_t (*yi4k_task_control_candidate_t)(void *task);
typedef void *(*yi4k_task_identify_candidate_t)(void);
#define YI4K_ADDR_TASK_CREATE    UINT32_C(0xA03BC2BC)
#define YI4K_ADDR_TASK_DELETE    UINT32_C(0xA03BC30C)
#define YI4K_ADDR_TASK_TERMINATE UINT32_C(0xA03BC310)
#define YI4K_ADDR_TASK_RESUME    UINT32_C(0xA03BC314)
#define YI4K_ADDR_TASK_SUSPEND   UINT32_C(0xA03BC31C)
#define YI4K_ADDR_TASK_SLEEP     UINT32_C(0xA03BC320)
#define YI4K_ADDR_TASK_IDENTIFY  UINT32_C(0xA03BC384)

/* Byte-pool APIs require a valid, initialized firmware pool. They do not mean
 * arbitrary RAM is available. Pool object size/lifetime has not been recovered.
 */
typedef uint32_t (*yi4k_pool_alloc_candidate_t)(void *pool, void **output,
                                               uint32_t bytes, uint32_t timeout);
typedef uint32_t (*yi4k_pool_free_candidate_t)(void *original_allocation);
typedef uint32_t (*yi4k_aligned_alloc_candidate_t)(void *pool, void **aligned_output,
    void **original_output, uint32_t bytes, uint32_t alignment);
#define YI4K_ADDR_POOL_ALLOC    UINT32_C(0xA03BC6DC)
#define YI4K_ADDR_POOL_FREE     UINT32_C(0xA03BC714)
#define YI4K_ADDR_ALIGNED_ALLOC UINT32_C(0xA029A7D8)

/* D-cache maintenance only, identified by log labels AND CP15 instructions.
 * No claim that these alone make a newly loaded code buffer executable/coherent.
 */
typedef void (*yi4k_dcache_candidate_t)(void *address, uint32_t bytes);
#define YI4K_OBSERVED_DCACHE_LINE_BYTES UINT32_C(32)
#define YI4K_ADDR_DCACHE_CLEAN      UINT32_C(0xA0498728)
#define YI4K_ADDR_DCACHE_INVALIDATE UINT32_C(0xA049878C)
#define YI4K_ADDR_DCACHE_FLUSH      UINT32_C(0xA04987F0)

/* Bit 0 must be set when using these Thumb addresses as function pointers. */
typedef int (*yi4k_strcmp_candidate_t)(const char *, const char *);
typedef uint32_t (*yi4k_strlen_candidate_t)(const char *);
typedef uint32_t (*yi4k_strtoul_candidate_t)(const char *, char **, int);
#define YI4K_ADDR_THUMB_STRCMP  UINT32_C(0xA04F9745)
#define YI4K_ADDR_THUMB_STRLEN  UINT32_C(0xA04F99F1)
#define YI4K_ADDR_THUMB_STRTOUL UINT32_C(0xA04FB329)

#endif
