#include "platform.h"
#include "ini.h"
#include "log.h"

#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/stat.h>

static int has_suffix(const char *s, const char *suf)
{
    size_t a = strlen(s), b = strlen(suf);
    return a >= b && strcmp(s + a - b, suf) == 0;
}

/* Replace characters that the shell treats specially (parens, slashes,
 * spaces) with '_' so the names from chip.conf can be passed to --chip
 * without quoting. Trailing underscores left over from that substitution
 * (e.g. "S2(A9)" -> "S2_A9_" -> "S2_A9") are then stripped so the names
 * read cleanly. Operates in-place on a NUL-terminated string. */
static void sanitize_chip_name(char *s)
{
    for (char *p = s; *p; p++) {
        switch (*p) {
            case '(': case ')':
            case '/': case '\\':
            case ' ': case '\t':
                *p = '_';
                break;
            default:
                break;
        }
    }
    size_t n = strlen(s);
    while (n > 0 && s[n - 1] == '_') s[--n] = '\0';
}

static int path_exists(const char *p)
{
    struct stat st;
    return stat(p, &st) == 0;
}

struct chip_ctx {
    amba_chip_t *chip;
};

static int chip_cb(const char *section, const char *key,
                   const char *value, void *user)
{
    if (strcmp(section, "ChipInfo") != 0) return 0;
    amba_chip_t *c = ((struct chip_ctx *)user)->chip;

    if (strcmp(key, "Name") == 0) {
        snprintf(c->name, sizeof(c->name), "%s", value);
        sanitize_chip_name(c->name);
    } else if (strcmp(key, "PrettyName") == 0) {
        snprintf(c->pretty_name, sizeof(c->pretty_name), "%s", value);
        sanitize_chip_name(c->pretty_name);
    } else if (strcmp(key, "Type") == 0) {
        snprintf(c->type, sizeof(c->type), "%s", value);
    } else if (strcmp(key, "Id") == 0) {
        c->id = (uint32_t)strtoul(value, NULL, 0);
    } else if (strcmp(key, "Product") == 0) {
        /* "vid/pid[/...]" — hex */
        unsigned int vid = 0, pid = 0;
        if (sscanf(value, "%x/%x", &vid, &pid) == 2) {
            c->vid = (uint16_t)vid;
            c->pid = (uint16_t)pid;
        }
    } else if (strcmp(key, "DramStartAddress") == 0) {
        c->dram_start_addr.address = strtoull(value, NULL, 16);
    } else if (strcmp(key, "DramSizeReg") == 0) {
        c->dram_size_reg.address = strtoull(value, NULL, 16);
    } else if (strcmp(key, "PtbVersion") == 0) {
        c->ptb_version = (uint32_t)strtoul(value, NULL, 0);
    } else if (strcmp(key, "RegBits") == 0) {
        uint32_t bits = (uint32_t)strtoul(value, NULL, 0);
        c->reg_bits = (bits == 32 || bits == 64) ? bits : 32;
    } else if (strcmp(key, "BootAds") == 0) {
        snprintf(c->boot_ads, sizeof(c->boot_ads), "%s/ads/%s",
                 c->chip_dir, value);
    }
    return 0;
}

static int cmp_str(const void *a, const void *b)
{
    return strcmp(*(const char *const *)a, *(const char *const *)b);
}

static int list_subdirs(const char *root, char ***out_names, int *out_count)
{
    DIR *d = opendir(root);
    if (!d) return -errno;

    char **names = NULL;
    int n = 0, cap = 0;
    struct dirent *e;
    while ((e = readdir(d)) != NULL) {
        if (e->d_name[0] == '.') continue;
        char full[1024];
        snprintf(full, sizeof(full), "%s/%s", root, e->d_name);
        struct stat st;
        if (stat(full, &st) != 0 || !S_ISDIR(st.st_mode)) continue;
        if (n == cap) {
            int new_cap = cap ? cap * 2 : 16;
            char **tmp = realloc(names, (size_t)new_cap * sizeof(*names));
            if (!tmp) {
                amba_error("realloc failed listing %s", root);
                for (int i = 0; i < n; i++) free(names[i]);
                free(names);
                closedir(d);
                return -ENOMEM;
            }
            names = tmp;
            cap = new_cap;
        }
        /* A NULL here would reach strcmp() via qsort below and snprintf("%s")
         * at every call site. */
        char *copy = strdup(e->d_name);
        if (!copy) {
            amba_error("Out of memory listing %s", root);
            for (int i = 0; i < n; i++) free(names[i]);
            free(names);
            closedir(d);
            return -ENOMEM;
        }
        names[n++] = copy;
    }
    closedir(d);
    if (n > 0) qsort(names, (size_t)n, sizeof(*names), cmp_str);
    *out_names = names;
    *out_count = n;
    return 0;
}

int amba_chip_list_load(const char *root, amba_chip_list_t *out)
{
    out->chips = NULL;
    out->chip_count = 0;

    char **dirs = NULL;
    int n = 0;
    int rc = list_subdirs(root, &dirs, &n);
    if (rc < 0) {
        amba_error("Cannot open platform directory %s: %s",
                   root, strerror(-rc));
        return rc;
    }

    amba_chip_t *chips = n > 0 ? calloc((size_t)n, sizeof(*chips)) : NULL;
    if (n > 0 && !chips) {
        amba_error("Out of memory allocating %d chip entries", n);
        for (int i = 0; i < n; i++) free(dirs[i]);
        free(dirs);
        return -ENOMEM;
    }
    int kept = 0;
    for (int i = 0; i < n; i++) {
        char conf[1024];
        snprintf(conf, sizeof(conf), "%s/%s/chip.conf", root, dirs[i]);
        if (!path_exists(conf)) { free(dirs[i]); continue; }

        amba_chip_t *c = &chips[kept];
        c->reg_bits = 32;
        snprintf(c->chip_dir, sizeof(c->chip_dir), "%s/%s", root, dirs[i]);

        struct chip_ctx ctx = { c };
        if (ini_parse_file(conf, chip_cb, &ctx) < 0) {
            amba_warn("Failed to parse %s", conf);
            free(dirs[i]);
            continue;
        }
        if (c->name[0] == '\0') {
            amba_warn("chip.conf %s has no Name, skipping", conf);
            free(dirs[i]);
            continue;
        }
        kept++;
        free(dirs[i]);
    }
    free(dirs);

    out->chips = chips;
    out->chip_count = kept;
    return 0;
}

void amba_chip_list_free(amba_chip_list_t *list)
{
    free(list->chips);
    list->chips = NULL;
    list->chip_count = 0;
}

const amba_chip_t *amba_chip_find(const amba_chip_list_t *list, const char *name)
{
    for (int i = 0; i < list->chip_count; i++) {
        if (strcasecmp(list->chips[i].name, name) == 0 ||
            strcasecmp(list->chips[i].pretty_name, name) == 0) {
            return &list->chips[i];
        }
    }
    return NULL;
}

struct board_ctx {
    amba_board_t *board;
    const amba_chip_t *chip;
};

static int board_cb(const char *section, const char *key,
                    const char *value, void *user)
{
    if (strcmp(section, "BoardInfo") != 0) return 0;
    struct board_ctx *bc = (struct board_ctx *)user;
    amba_board_t *b = bc->board;

    if (strcmp(key, "name") == 0) {
        snprintf(b->name, sizeof(b->name), "%s", value);
    } else if (strcmp(key, "ads") == 0) {
        snprintf(b->ads, sizeof(b->ads), "%s/ads/%s", bc->chip->chip_dir, value);
    } else if (strcmp(key, "ust") == 0) {
        snprintf(b->ust, sizeof(b->ust), "%s/ust/%s", bc->chip->chip_dir, value);
    } else if (strcmp(key, "bld") == 0) {
        snprintf(b->bld, sizeof(b->bld), "%s/bld/%s", bc->chip->chip_dir, value);
        snprintf(b->hal, sizeof(b->hal), "%s/bld/ambhal.bin", bc->chip->chip_dir);
    } else if (strcmp(key, "media") == 0) {
        snprintf(b->media, sizeof(b->media), "%s", value);
    }
    return 0;
}

int amba_board_list_load(const amba_chip_t *chip, amba_board_list_t *out)
{
    out->boards = NULL;
    out->board_count = 0;

    char boards_dir[1024];
    snprintf(boards_dir, sizeof(boards_dir), "%s/boards", chip->chip_dir);

    DIR *d = opendir(boards_dir);
    if (!d) {
        amba_warn("No boards/ directory at %s", boards_dir);
        return 0;
    }

    char **files = NULL;
    int n = 0, cap = 0;
    struct dirent *e;
    while ((e = readdir(d)) != NULL) {
        if (!has_suffix(e->d_name, ".board")) continue;
        if (n == cap) {
            int new_cap = cap ? cap * 2 : 16;
            char **tmp = realloc(files, (size_t)new_cap * sizeof(*files));
            if (!tmp) {
                amba_error("realloc failed listing %s", boards_dir);
                for (int i = 0; i < n; i++) free(files[i]);
                free(files);
                closedir(d);
                return -ENOMEM;
            }
            files = tmp;
            cap = new_cap;
        }
        char *copy = strdup(e->d_name);
        if (!copy) {
            amba_error("Out of memory listing %s", boards_dir);
            for (int i = 0; i < n; i++) free(files[i]);
            free(files);
            closedir(d);
            return -ENOMEM;
        }
        files[n++] = copy;
    }
    closedir(d);
    if (n > 0) qsort(files, (size_t)n, sizeof(*files), cmp_str);

    /* calloc(0, …) is implementation-defined; guard it. */
    amba_board_t *boards = n > 0 ? calloc((size_t)n, sizeof(*boards)) : NULL;
    if (n > 0 && !boards) {
        amba_error("Out of memory allocating %d board entries", n);
        for (int i = 0; i < n; i++) free(files[i]);
        free(files);
        return -ENOMEM;
    }
    int kept = 0;
    for (int i = 0; i < n; i++) {
        char full[1024];
        snprintf(full, sizeof(full), "%s/%s", boards_dir, files[i]);
        amba_board_t *b = &boards[kept];
        snprintf(b->media, sizeof(b->media), "nand");
        snprintf(b->boot_ads, sizeof(b->boot_ads), "%s", chip->boot_ads);

        struct board_ctx bc = { b, chip };
        if (ini_parse_file(full, board_cb, &bc) >= 0 && b->name[0]) {
            kept++;
        }
        free(files[i]);
    }
    free(files);

    out->boards = boards;
    out->board_count = kept;
    return 0;
}

void amba_board_list_free(amba_board_list_t *list)
{
    free(list->boards);
    list->boards = NULL;
    list->board_count = 0;
}

/* Board names appear as "RTOS.CV25.LPDDR4.NAND.840MHz" in the .board files
 * but as "RTOS_CV25_LPDDR4_NAND_840MHz" in the file names they came from, and
 * the two spellings are used interchangeably in the wild. Fold every
 * separator onto '_' and lower-case the rest so either one matches. */
static int fold_sep(unsigned char c)
{
    if (c == '.' || c == '-' || c == '_') return '_';
    return tolower(c);
}

static int board_name_cmp(const char *a, const char *b)
{
    for (;; a++, b++) {
        int ca = fold_sep((unsigned char)*a);
        int cb = fold_sep((unsigned char)*b);
        if (ca != cb) return ca - cb;
        if (*a == '\0') return 0;
    }
}

int amba_board_find(const amba_board_list_t *list, const char *spec)
{
    if (!spec || !*spec) return -1;

    /* All digits: treat as the --list-configs index. */
    const char *p = spec;
    while (*p >= '0' && *p <= '9') p++;
    if (*p == '\0') {
        char *endp = NULL;
        long v = strtol(spec, &endp, 10);
        if (endp && *endp == '\0' && v >= 0 && v < list->board_count) {
            return (int)v;
        }
        return -1;
    }

    for (int i = 0; i < list->board_count; i++) {
        if (board_name_cmp(list->boards[i].name, spec) == 0) return i;
    }
    return -1;
}

uint32_t amba_media_from_string(const char *s)
{
    if (!s || !*s) return AMBA_DEV_MEDIA_NAND;
    if (strcasecmp(s, "emmc")    == 0) return AMBA_DEV_MEDIA_EMMC;
    if (strcasecmp(s, "spinor")  == 0) return AMBA_DEV_MEDIA_SPINOR;
    if (strcasecmp(s, "spinand") == 0) return AMBA_DEV_MEDIA_SPINAND;
    if (strcasecmp(s, "hif")     == 0) return AMBA_DEV_MEDIA_HIF;
    return AMBA_DEV_MEDIA_NAND;
}

uint32_t amba_media_to_rct(uint32_t media_mask)
{
    /* Values match media_type_to_rct_type() in amba_usb_device.cpp:52-65.
     * NAND=1, EMMC=4, SPINOR=8, SPINAND=8, HIF=0x10. NAND is the fallback. */
    switch (media_mask) {
        case AMBA_DEV_MEDIA_NAND:    return 0x00000001;
        case AMBA_DEV_MEDIA_EMMC:    return 0x00000004;
        case AMBA_DEV_MEDIA_SPINOR:  return 0x00000008;
        case AMBA_DEV_MEDIA_SPINAND: return 0x00000008;
        case AMBA_DEV_MEDIA_HIF:     return 0x00000010;
        default:                     return 0x00000001;
    }
}

void amba_compute_fwprog_cmd(const amba_chip_t *chip,
                             const amba_board_t *board,
                             int verify,
                             uint32_t cmd[AMBA_FWPROG_MAX_CMD])
{
    (void)chip;
    (void)board;
    /* The GUI exposes eight free-form hex slots. The two with semantic
     * meaning are [6] = BLD start placeholder and [7] = verify magic;
     * the rest default to zero (matching empty lineEdits in the .ui). */
    memset(cmd, 0, sizeof(uint32_t) * AMBA_FWPROG_MAX_CMD);
    if (verify) {
        cmd[6] = BLD_START_ADDR_PLACE_HOLDER;
        cmd[7] = FIRM_PROG_CMD_VERIFY;
    }
}
