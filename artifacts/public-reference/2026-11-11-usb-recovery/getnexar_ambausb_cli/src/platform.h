/*
 * platform.h — discovers chips and board configs from the platform/ tree.
 *
 * Expected on-disk layout (same as ambausb-5.0.7/platform/):
 *
 *   <root>/<chip>/chip.conf            INI [ChipInfo] Name, Id, Product, ...
 *   <root>/<chip>/boards/<name>.board  INI [BoardInfo] name, ads, bld, media
 *   <root>/<chip>/ads/<name>.ads       DRAM init script (ADS chips)
 *   <root>/<chip>/bld/<name>.elf       BLD ELF (per-board)
 *   <root>/<chip>/ust/<name>.ust       UST blob (UST chips)
 *
 * The CLI loads all chips, but only enumerates boards for the chip the user
 * selected via --chip. --list-configs and the help text show boards by
 * index; the user references one with --config <index>.
 */
#ifndef AMBUSB_CLI_PLATFORM_H
#define AMBUSB_CLI_PLATFORM_H

#include <stdint.h>
#include "ambausb_proto.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    char        name[64];        /* internal name from chip.conf            */
    char        pretty_name[64]; /* display name                            */
    char        type[16];        /* "ads" or "ust"                          */
    uint32_t    id;              /* chip id                                 */
    uint16_t    vid;             /* USB vendor id (parsed from Product)     */
    uint16_t    pid;             /* USB product id (parsed from Product)    */
    uint32_t    ptb_version;
    uint32_t    reg_bits;        /* 32 or 64                                */
    amba_addr_t dram_start_addr;
    amba_addr_t dram_size_reg;
    char        chip_dir[512];   /* absolute path to <root>/<chip-dir>      */
    char        boot_ads[512];   /* optional, empty if not set              */
} amba_chip_t;

typedef struct {
    char name[128];
    char ads[512];   /* absolute path to .ads file, empty if UST            */
    char ust[512];   /* absolute path to .ust file, empty if ADS            */
    char bld[512];   /* absolute path to BLD ELF                            */
    char hal[512];   /* absolute path to ambhal.bin (sibling of bld)        */
    char media[16];  /* "nand" | "emmc" | "spinor" | "spinand"              */
    char boot_ads[512];
} amba_board_t;

typedef struct {
    amba_chip_t *chips;
    int          chip_count;
} amba_chip_list_t;

typedef struct {
    amba_board_t *boards;
    int           board_count;
} amba_board_list_t;

/* Scan each <root>/<chip>/chip.conf and populate `out`. Caller must free
 * with amba_chip_list_free. Returns 0 on success. */
int amba_chip_list_load(const char *root, amba_chip_list_t *out);
void amba_chip_list_free(amba_chip_list_t *list);

/* Find a chip by name or pretty_name (case-insensitive). NULL if not found. */
const amba_chip_t *amba_chip_find(const amba_chip_list_t *list, const char *name);

/* Load all boards for `chip` from <chip_dir>/boards (each *.board file).
 * Boards are sorted alphabetically by filename, giving each a stable index
 * that the --config flag can reference. */
int amba_board_list_load(const amba_chip_t *chip, amba_board_list_t *out);
void amba_board_list_free(amba_board_list_t *list);

/* Resolve a --config spec to an index into `list`. The spec is either the
 * decimal index printed by --list-configs, or a board name. Names match
 * case-insensitively and treat '.', '_' and '-' as equivalent, so both
 * "RTOS.CV25.LPDDR4.NAND.840MHz" and the file-name spelling
 * "RTOS_CV25_LPDDR4_NAND_840MHz" resolve to the same board. Returns -1 if
 * the spec names nothing or the index is out of range. */
int amba_board_find(const amba_board_list_t *list, const char *spec);

/* Convert a media string to an AMBA_DEV_MEDIA_* mask. Returns NAND on
 * anything unrecognised (matching the Qt default). */
uint32_t amba_media_from_string(const char *s);

/* Convert an AMBA_DEV_MEDIA_* mask into the RCT boot-media byte that the
 * running amboot expects at BLD_OFFSET_BOOT_MEDIA. Mirrors
 * media_type_to_rct_type() in the Qt source. */
uint32_t amba_media_to_rct(uint32_t media_mask);

/* Translate a chip+board into the 8-word fwprog command array.
 * Mirrors AmbaUSB::get_firmware_program_cmd in the Qt source. */
void amba_compute_fwprog_cmd(const amba_chip_t *chip,
                             const amba_board_t *board,
                             int verify,
                             uint32_t cmd[AMBA_FWPROG_MAX_CMD]);

#ifdef __cplusplus
}
#endif
#endif
