/*
 * ambausb_proto.h
 *
 * Wire-protocol constants and POD structs for the Ambarella USB firmware
 * download flow. Qt-free copies of the relevant declarations from:
 *   ambausb-5.0.7/src/app/amba_usb_command.h
 *   ambausb-5.0.7/src/app/amba_usb_device_struct.h
 *
 * Only the constants/structs needed for a CLI single-device flash are
 * included; PTB, partition, wizard, and notice config types are omitted.
 */
#ifndef AMBUSB_CLI_PROTO_H
#define AMBUSB_CLI_PROTO_H

#include <stdint.h>
#include <string.h>

#ifdef __cplusplus
extern "C" {
#endif

#define AMBA_FOURCC(a,b,c,d) ((uint32_t)((a) | ((b) << 8) | ((c) << 16) | ((d) << 24)))

/* USB vendor ID used by Ambarella devices */
#define AMBA_USB_VENDOR_ID            0x4255

/* Magic numbers embedded in board/firmware/result blobs */
#define AMBA_BOARD_MAGIC              AMBA_FOURCC('A','m','b','A')
#define AMBA_FIRM_INFO_MAGIC          AMBA_FOURCC('A','m','B','a')
#define AMBA_FWPROG_RESULT_MAGIC      0xb0329ac3u

/* DRAM offsets used to derive memfwprog/amboot/hal addresses from
 * the per-chip dram_start. See AmbaMem::set_dram_start. */
#define DRAM_OFFSET_AMBOOT            0x00000000u
#define DRAM_OFFSET_HAL               0x000A0000u
#define DRAM_OFFSET_MEMFWPROG         0x00100000u
#define DRAM_OFFSET_KERNEL            0x00100000u

/* Offsets inside the firmware blob */
#define FIRM_OFFSET_VERSION           0x0000003Cu
#define FIRM_OFFSET_MEMFWRESULT       0x00000040u
#define FIRM_OFFSET_MEMFWCMD          0x00000050u
#define FIRM_OFFSET_MEMFWPROG         0x00000060u

/* Offsets inside the BLD blob */
#define BLD_OFFSET_BLD_VERSION        0x00000038u
#define BLD_OFFSET_BOOT_MEDIA         0x0000003Cu
#define BLD_OFFSET_USB_BOOT           0x00000040u
#define BLD_OFFSET_DRAM_REG           0x00000048u
#define BLD_OFFSET_BOARD_ID           0x0000004Cu

/* Firmware program command sentinel values */
#define FIRM_PROG_CMD_VERIFY          0x00007E57u
#define BLD_START_ADDR_PLACE_HOLDER   0x00B1DADDu
#define DRAM_SIZE_QUERY_COMMAND       0x444D535Au

/* USB command tokens */
#define AMBA_TOKEN_COMMAND            0x55434D44u
#define AMBA_TOKEN_STATUS             0x55525350u

/* BLD command set — outer command word (amba_usb_cmd_t.command) */
enum {
    USB_CMD_RDY_TO_RCV     = 0,
    USB_CMD_RCV_DATA       = 1,
    USB_CMD_RDY_TO_SND     = 2,
    USB_CMD_SND_DATA       = 3,
    USB_CMD_INQUIRY_STATUS = 4,
};

/* Sub-command for USB_CMD_RDY_TO_RCV, passed in amba_usb_cmd_t.p1 alongside
 * AMBA_FLAG_COMMAND in p0. Matches AmbaUsbBldCmdRcvParam in the Qt source. */
enum {
    AMBA_RTR_MEMORY_READ    = 1,   /* get_u32(addr)  — reply.p0 = value      */
    AMBA_RTR_MEMORY_WRITE   = 2,   /* set_u32(addr, value)                   */
    AMBA_RTR_UST_REG_WRITE  = 9,   /* UST 64-bit reg write                   */
    AMBA_RTR_UST_REG_READ   = 10,  /* UST 64-bit reg read — reply.p0 = value */
};

/* Response status codes */
enum {
    USB_RSP_SUCCESS = 0,
    USB_RSP_FAILED  = 1,
    USB_RSP_IN_BLD  = 2,
};

/* Inquiry types */
enum {
    USB_BLD_INQUIRY_CHIP = 0x00000001,
    USB_BLD_INQUIRY_ADDR = 0x00000002,
    USB_BLD_INQUIRY_REG  = 0x00000003,
};

/* Device init/mode classifiers (matches AmbaDevModeType / AmbaDevInitType /
 * AmbaDevInitMode in the Qt source). */
enum {
    AMBA_DEV_MODE_RAW       = AMBA_FOURCC('R','a','W',' '),
    AMBA_DEV_MODE_FORCEUSB  = AMBA_FOURCC('H','a','R','d'),
    AMBA_DEV_MODE_AMBOOT    = AMBA_FOURCC('A','m','B','t'),
    AMBA_DEV_MODE_UST       = AMBA_FOURCC('U','s','T',' '),
};
enum {
    AMBA_DEV_INIT_FIND_NONE = AMBA_FOURCC('N','o','N','e'),
    AMBA_DEV_INIT_DRAM_ONLY = AMBA_FOURCC('D','r','A','m'),
    AMBA_DEV_INIT_FIRM_ONLY = AMBA_FOURCC('F','i','R','m'),
    AMBA_DEV_INIT_DRAM_FIRM = AMBA_FOURCC('D','f','D','f'),
    AMBA_DEV_INIT_ABOT_FIRM = AMBA_FOURCC('A','m','F','m'),
};
enum {
    AMBA_DEV_INIT_MODE_AUTO = AMBA_FOURCC('A','u','T','o'),
    AMBA_DEV_INIT_MODE_STOP = AMBA_FOURCC('S','t','O','p'),
    AMBA_DEV_INIT_MODE_NORM = AMBA_FOURCC('N','o','R','m'),
    AMBA_DEV_INIT_MODE_TEST = AMBA_FOURCC('T','e','S','t'),
};

/* Media type bitmask used in the BLD media field */
enum {
    AMBA_DEV_MEDIA_NAND    = 0x01,
    AMBA_DEV_MEDIA_EMMC    = 0x02,
    AMBA_DEV_MEDIA_SPINOR  = 0x04,
    AMBA_DEV_MEDIA_SPINAND = 0x08,
    AMBA_DEV_MEDIA_HIF     = 0x10,
};

/* fwprog command array size and reserved data area, exactly as in the
 * Qt struct AmbaFwProgCmd. */
#define AMBA_FWPROG_MAX_CMD            8
#define AMBA_MEMFWPROG_HOOKCMD_SIZE    0x00010000u

/* Every struct below this comment travels over USB. They are packed and
 * accompanied by _Static_assert on the expected wire size so the host
 * memory layout can never silently disagree with what the bootloader
 * reads. amba_fwinfo_t reserves an explicit 4-byte padding word to match
 * the natural (LP64) sizeof of the Qt AmbaUsbFwInfo the target's memfwprog
 * was compiled against: 24 bytes, not 20. */
#define AMBA_PACKED __attribute__((packed))

/* 64-bit address (little-endian) — matches AmbaAddress union */
typedef union AMBA_PACKED {
    struct AMBA_PACKED {
        uint32_t lo;
        uint32_t hi;
    };
    uint64_t address;
} amba_addr_t;
_Static_assert(sizeof(amba_addr_t) == 8, "amba_addr_t wire size");

/* Firmware-program-command blob written to addr_fwprogcmd before flash.
 * The Qt source defines AmbaFwProgCmd as a 64KB blob; layout must match. */
typedef struct AMBA_PACKED {
    uint32_t cmd[AMBA_FWPROG_MAX_CMD];
    uint32_t error;
    uint32_t result_data;
    uint32_t result_str_len;
    uint32_t result_str_addr;
    uint8_t  data[AMBA_MEMFWPROG_HOOKCMD_SIZE - 12 * sizeof(uint32_t)];
} amba_fwprog_cmd_t;
_Static_assert(sizeof(amba_fwprog_cmd_t) == AMBA_MEMFWPROG_HOOKCMD_SIZE,
               "amba_fwprog_cmd_t must be exactly the 64 KiB hookcmd slot");

/* Firmware info written to addr_firminfo before sending the binary.
 *
 * The 4-byte `_pad` word is not cosmetic. The Qt AmbaUsbFwInfo struct is
 * declared without __attribute__((packed)), so on any LP64 target the C++
 * compiler inserts 4 bytes of padding after the enum-based `magic` to
 * satisfy the 8-byte alignment of AmbaAddress (which is a union containing
 * a uint64_t). That makes sizeof(AmbaUsbFwInfo) == 24, not 20.
 *
 * memfwprog is compiled against the same header, so it reads a 24-byte
 * fwinfo at (addr_boardinfo - 24). Sending a packed 20-byte blob puts
 * fw_addr_cmd at the wrong offset in the target's view, and additionally
 * misaligns addr_firminfo by 4 bytes so memfwprog's read simply misses.
 *
 * Keep the struct packed so serialization stays wire-exact, but reserve
 * the padding word explicitly. */
typedef struct AMBA_PACKED {
    uint32_t    magic;          /* AMBA_FIRM_INFO_MAGIC */
    uint32_t    _pad;           /* mirrors LP64 natural alignment */
    amba_addr_t fw_addr_cmd;    /* fwprog cmd address read from firmware */
    amba_addr_t fw_addr_result; /* fwprog result address read from firmware */
} amba_fwinfo_t;
_Static_assert(sizeof(amba_fwinfo_t) == 24, "amba_fwinfo_t wire size");

/* Board info — written to addr_boardinfo before sending the binary.
 * Members beyond `new_device` are deliberately omitted: the CLI does not
 * support PTB editing, so ptb is always NULL and dram_size carries either
 * the raw register value (legacy) or the byte count (CV5+). */
typedef struct AMBA_PACKED {
    uint32_t magic;        /* AMBA_BOARD_MAGIC */
    uint32_t init_mode;    /* AMBA_DEV_INIT_MODE_* */
    uint64_t ptb;          /* always 0 in CLI build (no PTB editing) */
    uint32_t dram_size;
    uint32_t new_device;
} amba_boardinfo_t;
_Static_assert(sizeof(amba_boardinfo_t) == 24, "amba_boardinfo_t wire size");

/* Result blob read back from the firmware after programming.
 *
 * The Qt source declares `flag[PART_NUM]` where PART_NUM aliases PART_RAW
 * = 0xf = 15 (not 16, PART_NUM is the sentinel *value* PART_RAW, not
 * PART_RAW+1). memfwprog writes 15 u32 entries plus the two-word header
 * for a total of 68 bytes, so allocating 16 slots here would misalign
 * any struct placed immediately after this in memory. */
typedef struct AMBA_PACKED {
    uint32_t magic;
    uint32_t bad_blk_info;
    uint32_t flag[15];     /* PART_NUM == PART_RAW == 0xf */
} amba_fwprog_result_t;
_Static_assert(sizeof(amba_fwprog_result_t) == 68, "amba_fwprog_result_t wire size");

/* The amba_usb_cmd / amba_usb_rsp / amba_boot_cmd structs used by the BLD
 * handshake and the ctrl-write protocol. Defined here so wire constants
 * (FLAG_*, USB_BOOT_CMD_*) live alongside their payloads. */
typedef struct AMBA_PACKED {
    uint32_t signature;
    uint32_t command;
    uint32_t p0, p1, p2, p3, p4, p5;
} amba_usb_cmd_t;
_Static_assert(sizeof(amba_usb_cmd_t) == 32, "amba_usb_cmd_t wire size");

typedef struct AMBA_PACKED {
    uint32_t signature;
    uint32_t response;
    uint32_t p0, p1;
} amba_usb_rsp_t;
_Static_assert(sizeof(amba_usb_rsp_t) == 16, "amba_usb_rsp_t wire size");

typedef struct AMBA_PACKED {
    uint32_t command;
    uint32_t address;
    uint32_t value;
} amba_boot_cmd_t;
_Static_assert(sizeof(amba_boot_cmd_t) == 12, "amba_boot_cmd_t wire size");

/* Parameter0 flags for amba_usb_cmd_t commands */
#define AMBA_FLAG_LAST_TRANS     0x01
#define AMBA_FLAG_ADDRESS        0x02
#define AMBA_FLAG_JUMP_EXEC      0x04
#define AMBA_FLAG_COMMAND        0x08
#define AMBA_FLAG_FORCE_FINISH   0x10

/* Boot commands carried by amba_boot_cmd_t */
#define USB_BOOT_CMD_WRITE       0x30000000u
#define USB_BOOT_CMD_JUMP        0x00010000u

/* Memory map derived from the chip table + DRAM probe.
 * Mirrors the relevant subset of AmbaMem. */
typedef struct {
    amba_addr_t dram_start;
    amba_addr_t dram_size_reg;
    amba_addr_t addr_amboot;
    amba_addr_t addr_amboot_usbdl;
    amba_addr_t addr_amboot_version;
    amba_addr_t addr_amboot_boot_media;
    amba_addr_t addr_hal;
    amba_addr_t addr_memfwprog;
    amba_addr_t addr_kernel;
    amba_addr_t addr_boardinfo;
    amba_addr_t addr_firminfo;
    uint32_t    addr_width;          /* 32 or 64 */
    uint32_t    dram_size_mb;
    uint32_t    dram_size_reg_value;
} amba_mem_t;

/* Apply the per-chip dram_start to fill addr_hal/memfwprog/kernel. */
static inline void amba_mem_set_dram_start(amba_mem_t *m,
                                           amba_addr_t start,
                                           amba_addr_t size_reg)
{
    m->dram_start              = start;
    m->dram_size_reg           = size_reg;
    m->dram_size_mb            = 0;
    m->addr_hal.address        = start.address + DRAM_OFFSET_HAL;
    m->addr_memfwprog.address  = start.address + DRAM_OFFSET_MEMFWPROG;
    m->addr_kernel.address     = start.address + DRAM_OFFSET_KERNEL;
}

static inline void amba_mem_set_amboot_start(amba_mem_t *m, amba_addr_t amboot)
{
    m->addr_amboot                    = amboot;
    m->addr_amboot_version.address    = amboot.address + BLD_OFFSET_BLD_VERSION;
    m->addr_amboot_boot_media.address = amboot.address + BLD_OFFSET_BOOT_MEDIA;
    m->addr_amboot_usbdl.address      = amboot.address + BLD_OFFSET_USB_BOOT;
}

/* boardinfo/firminfo live at the top of usable DRAM. The Qt source derives
 * them after the device reports its size. See AmbaMem::set_dram_size. */
static inline void amba_mem_set_dram_size(amba_mem_t *m, uint32_t size_mb)
{
    /* A5s/A7l/S2 cap (dram_start == 0xC0000000): clamp usable to 256 MB */
    if (m->dram_start.lo == 0xC0000000u && (size_mb << 20) > 0x10000000u) {
        m->dram_size_mb = 0x10000000u >> 20;
    } else {
        m->dram_size_mb = size_mb;
    }
    m->addr_boardinfo.address = m->dram_start.address +
                                ((uint64_t)m->dram_size_mb << 20) -
                                sizeof(amba_boardinfo_t);
    m->addr_firminfo.address  = m->addr_boardinfo.address -
                                sizeof(amba_fwinfo_t);
}

#ifdef __cplusplus
}
#endif
#endif /* AMBUSB_CLI_PROTO_H */
