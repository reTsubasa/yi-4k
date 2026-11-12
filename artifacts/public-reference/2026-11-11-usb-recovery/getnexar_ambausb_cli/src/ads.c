#include "ads.h"
#include "log.h"

#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAX_LINE 256

static int append_cmd(amba_ads_script_t *s, amba_ads_cmd_t c)
{
    if (s->count == s->capacity) {
        size_t new_cap = s->capacity ? s->capacity * 2 : 256;
        amba_ads_cmd_t *n = realloc(s->cmds, new_cap * sizeof(*n));
        if (!n) return -1;
        s->cmds = n;
        s->capacity = new_cap;
    }
    s->cmds[s->count++] = c;
    return 0;
}

/* Parse an unsigned hex or decimal number. `$MEMPROG_ADDR` substitutes
 * the caller-supplied memprog value. Returns 0 on success. */
static int parse_num(const char *s, uint32_t memprog_addr, uint32_t *out)
{
    if (!*s) return -1;
    if (strcasecmp(s, "$MEMPROG_ADDR") == 0) {
        *out = memprog_addr;
        return 0;
    }
    char *end = NULL;
    unsigned long v;
    if (s[0] == '0' && (s[1] == 'x' || s[1] == 'X')) {
        v = strtoul(s + 2, &end, 16);
    } else if (strchr(s, 'a') || strchr(s, 'b') || strchr(s, 'c') ||
               strchr(s, 'd') || strchr(s, 'e') || strchr(s, 'f') ||
               strchr(s, 'A') || strchr(s, 'B') || strchr(s, 'C') ||
               strchr(s, 'D') || strchr(s, 'E') || strchr(s, 'F')) {
        /* Bare hex (no 0x prefix): the reference parser accepts this too. */
        v = strtoul(s, &end, 16);
    } else {
        v = strtoul(s, &end, 0);
    }
    if (!end || *end != '\0') return -1;
    *out = (uint32_t)v;
    return 0;
}

/* Skip leading whitespace and return a pointer to the first non-space
 * character. Sets *is_comment for lines that start with #, ; or /. */
static const char *skip_ws(const char *p, int *is_comment)
{
    while (*p == ' ' || *p == '\t') p++;
    *is_comment = (*p == '#' || *p == ';' || *p == '/' ||
                   *p == '\n' || *p == '\r' || *p == '\0');
    return p;
}

int amba_ads_parse(const char *path, uint32_t memprog_addr,
                   amba_ads_script_t *out)
{
    memset(out, 0, sizeof(*out));
    FILE *f = fopen(path, "r");
    if (!f) {
        amba_error("Cannot open ADS file %s: %s", path, strerror(errno));
        return -1;
    }
    char line[MAX_LINE];
    uint32_t line_no = 0;
    while (fgets(line, sizeof(line), f)) {
        line_no++;
        int is_comment = 0;
        const char *p = skip_ws(line, &is_comment);
        if (is_comment) continue;

        /* Grab the opcode token. */
        char tok[32];
        size_t tlen = 0;
        while (p[tlen] && p[tlen] != ' ' && p[tlen] != '\t' && p[tlen] != ',' &&
               p[tlen] != '=' && p[tlen] != '\n' && p[tlen] != '\r') tlen++;
        if (tlen == 0 || tlen >= sizeof(tok)) {
            amba_error("ADS %s line %u: bad opcode", path, line_no);
            goto fail;
        }
        memcpy(tok, p, tlen);
        tok[tlen] = '\0';
        p += tlen;

        amba_ads_cmd_t c = { .line = line_no };
        char a[64] = {0}, b[64] = {0}, d[64] = {0};

        if (strcasecmp(tok, "write") == 0) {
            if (sscanf(p, " %63[^,= \t\r\n]%*[,= \t]%63[^ \t\r\n]",
                       a, b) != 2) {
                amba_error("ADS %s line %u: write needs addr,value",
                           path, line_no);
                goto fail;
            }
            c.op = ADS_CMD_WRITE;
            if (parse_num(a, memprog_addr, &c.addr) != 0 ||
                parse_num(b, memprog_addr, &c.data) != 0) {
                amba_error("ADS %s line %u: bad number in write", path, line_no);
                goto fail;
            }
        } else if (strcasecmp(tok, "read") == 0) {
            if (sscanf(p, " %63[^ \t\r\n]", a) != 1) {
                amba_error("ADS %s line %u: read needs addr", path, line_no);
                goto fail;
            }
            c.op = ADS_CMD_READ;
            if (parse_num(a, memprog_addr, &c.addr) != 0) {
                amba_error("ADS %s line %u: bad addr in read", path, line_no);
                goto fail;
            }
        } else if (strcasecmp(tok, "poll") == 0) {
            if (sscanf(p, " %63[^,= \t\r\n]%*[,= \t]%63[^,= \t\r\n]%*[,= \t]"
                          "%63[^ \t\r\n]", a, b, d) != 3) {
                amba_error("ADS %s line %u: poll needs addr,mask,value",
                           path, line_no);
                goto fail;
            }
            c.op = ADS_CMD_POLL;
            if (parse_num(a, memprog_addr, &c.addr) != 0 ||
                parse_num(b, memprog_addr, &c.mask) != 0 ||
                parse_num(d, memprog_addr, &c.data) != 0) {
                amba_error("ADS %s line %u: bad number in poll", path, line_no);
                goto fail;
            }
        } else if (strcasecmp(tok, "usleep") == 0) {
            if (sscanf(p, " %63[^ \t\r\n]", a) != 1) {
                amba_error("ADS %s line %u: usleep needs microseconds",
                           path, line_no);
                goto fail;
            }
            c.op = ADS_CMD_USLEEP;
            if (parse_num(a, memprog_addr, &c.data) != 0) {
                amba_error("ADS %s line %u: bad usleep arg", path, line_no);
                goto fail;
            }
        } else if (strcasecmp(tok, "sleep") == 0) {
            if (sscanf(p, " %63[^ \t\r\n]", a) != 1) {
                amba_error("ADS %s line %u: sleep needs seconds",
                           path, line_no);
                goto fail;
            }
            c.op = ADS_CMD_SLEEP;
            if (parse_num(a, memprog_addr, &c.data) != 0) {
                amba_error("ADS %s line %u: bad sleep arg", path, line_no);
                goto fail;
            }
        } else {
            amba_error("ADS %s line %u: unknown opcode '%s'",
                       path, line_no, tok);
            goto fail;
        }

        if (append_cmd(out, c) != 0) {
            amba_error("ADS %s: out of memory", path);
            goto fail;
        }
    }
    fclose(f);
    if (out->count == 0) {
        amba_error("ADS %s parsed to zero commands", path);
        amba_ads_free(out);
        return -1;
    }
    amba_info("ADS %s: parsed %zu commands", path, out->count);
    return 0;

fail:
    fclose(f);
    amba_ads_free(out);
    return -1;
}

void amba_ads_free(amba_ads_script_t *s)
{
    if (!s) return;
    free(s->cmds);
    memset(s, 0, sizeof(*s));
}

/* Bounded busy-wait for a poll directive. Mirrors the reference
 * usb_busy_timeout in libdraminit_ads: up to 0xfffff iterations of
 * ctrl-read, then give up. That gives plenty of headroom for the
 * DRAM controller's "ready" bits to flip. */
#define ADS_POLL_MAX_ITER 0xfffffu

static int poll_addr(const amba_usb_dev_t *dev, uint32_t addr,
                     uint32_t mask, uint32_t expected,
                     const amba_usb_params_t *p)
{
    for (uint32_t i = 0; i < ADS_POLL_MAX_ITER; i++) {
        uint32_t v = 0;
        if (amba_usb_ctrl_read_u32(dev, addr, &v, p) != 0) return -1;
        if ((v & mask) == expected) return 0;
    }
    amba_error("ADS poll timed out at 0x%08x (mask 0x%08x expect 0x%08x)",
               addr, mask, expected);
    return -1;
}

static void ads_usleep(uint32_t us)
{
    struct timespec ts = { us / 1000000u, (long)(us % 1000000u) * 1000L };
    nanosleep(&ts, NULL);
}

int amba_ads_execute(const amba_usb_dev_t *dev,
                     const amba_ads_script_t *s,
                     const amba_usb_params_t *p)
{
    for (size_t i = 0; i < s->count; i++) {
        const amba_ads_cmd_t *c = &s->cmds[i];
        switch (c->op) {
            case ADS_CMD_WRITE:
                if (amba_usb_ctrl_write_u32(dev, USB_BOOT_CMD_WRITE,
                                            c->addr, c->data, p) != 0) {
                    amba_error("ADS line %u: write 0x%08x=0x%08x failed",
                               c->line, c->addr, c->data);
                    return -1;
                }
                break;
            case ADS_CMD_READ: {
                uint32_t v = 0;
                if (amba_usb_ctrl_read_u32(dev, c->addr, &v, p) != 0) {
                    amba_error("ADS line %u: read 0x%08x failed",
                               c->line, c->addr);
                    return -1;
                }
                amba_debug("ADS read 0x%08x -> 0x%08x", c->addr, v);
                break;
            }
            case ADS_CMD_POLL:
                if (poll_addr(dev, c->addr, c->mask, c->data, p) != 0) {
                    amba_error("ADS line %u: poll failed", c->line);
                    return -1;
                }
                break;
            case ADS_CMD_USLEEP:
                ads_usleep(c->data);
                break;
            case ADS_CMD_SLEEP:
                ads_usleep(c->data * 1000000u);
                break;
        }
    }
    return 0;
}
