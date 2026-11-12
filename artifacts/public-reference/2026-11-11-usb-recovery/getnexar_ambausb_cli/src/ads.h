/*
 * ads.h — Ambarella DRAM init script parser and executor.
 *
 * A .ads file is a plain-text list of USB control-transfer directives
 * that the running (pre-DRAM) chip needs before its DRAM controller
 * comes alive. Grammar (case-insensitive, one directive per line):
 *
 *   write <addr>, <value>          # 32-bit register write
 *   read  <addr>                   # 32-bit register read (result discarded)
 *   poll  <addr>, <mask>, <value>  # spin until (read(addr) & mask) == value
 *   usleep <us>                    # sleep microseconds
 *   sleep  <s>                     # sleep seconds
 *   # ... or ; ... or / ...        # comment
 *
 * Numbers can be decimal or 0x-prefixed hex. Whitespace, commas and
 * equals signs are all valid separators. Blank lines are skipped.
 *
 * The special token $MEMPROG_ADDR is substituted with the memfwprog
 * address when parsing an ads_jump_run script; the plain DRAM init path
 * doesn't use it.
 *
 * Runtime side: each directive maps to one or more calls into
 * amba_usb_ctrl_write_u32 / amba_usb_ctrl_read_u32 (usb.c). No bulk
 * transfers are used — the target's bulk endpoints are only wired up
 * after the .ads has finished and amboot is running. */
#ifndef AMBUSB_CLI_ADS_H
#define AMBUSB_CLI_ADS_H

#include <stddef.h>
#include <stdint.h>
#include "usb.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    ADS_CMD_WRITE  = 0,
    ADS_CMD_READ   = 1,
    ADS_CMD_POLL   = 2,
    ADS_CMD_USLEEP = 3,
    ADS_CMD_SLEEP  = 4,
} amba_ads_op_t;

typedef struct {
    amba_ads_op_t op;
    uint32_t      addr;   /* write/read/poll target */
    uint32_t      data;   /* write value, poll expected, or sleep count */
    uint32_t      mask;   /* poll bitmask (unused for other ops) */
    uint32_t      line;   /* 1-based source line, for error messages */
} amba_ads_cmd_t;

typedef struct {
    amba_ads_cmd_t *cmds;
    size_t          count;
    size_t          capacity;
} amba_ads_script_t;

/* Parse `path` into `out`. `memprog_addr` substitutes for $MEMPROG_ADDR
 * (pass 0 for the plain DRAM init case, which never references it).
 * Returns 0 on success. Caller frees with amba_ads_free. */
int amba_ads_parse(const char *path, uint32_t memprog_addr,
                   amba_ads_script_t *out);
void amba_ads_free(amba_ads_script_t *s);

/* Execute the parsed script on `dev` (which must be an open FORCEUSB
 * device). Returns 0 on success, -1 on any error. On failure the log
 * points at the offending source line. */
int amba_ads_execute(const amba_usb_dev_t *dev,
                     const amba_ads_script_t *s,
                     const amba_usb_params_t *params);

#ifdef __cplusplus
}
#endif
#endif
