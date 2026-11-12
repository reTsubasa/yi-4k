#include "session.h"
#include "ads.h"
#include "elf.h"
#include "log.h"
#include "platform.h"

#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Has the operator asked us to stop? Only meaningful before the JUMP that
 * starts the flash write; see the note at the end of amba_session_run. */
static int cancelled(const amba_session_cfg_t *cfg)
{
    return cfg->cancel_flag && *cfg->cancel_flag;
}

/* zlib-compatible CRC-32, table-free. Kept incremental so the padding
 * word (see send_blob_to) can be folded into the same checksum as the
 * main payload without an extra buffer copy. `c` should be seeded with
 * 0xFFFFFFFFu on the first call and complemented (~c) after the last. */
static uint32_t crc32_step(uint32_t c, const uint8_t *buf, size_t len)
{
    for (size_t i = 0; i < len; i++) {
        c ^= buf[i];
        for (int j = 0; j < 8; j++)
            c = (c >> 1) ^ (0xEDB88320u & -(c & 1));
    }
    return c;
}

static int send_cmd(const amba_usb_dev_t *dev,
                    const amba_usb_cmd_t *cmd,
                    const amba_usb_params_t *p)
{
    return amba_usb_bulk_send(dev, (const uint8_t *)cmd, sizeof(*cmd), p);
}

static int recv_rsp(const amba_usb_dev_t *dev,
                    amba_usb_rsp_t *rsp,
                    const amba_usb_params_t *p)
{
    if (amba_usb_bulk_recv(dev, (uint8_t *)rsp, sizeof(*rsp), p) != 0) return -1;
    if (rsp->signature != AMBA_TOKEN_STATUS) {
        amba_error("Unexpected response signature 0x%08x", rsp->signature);
        return -1;
    }
    if (rsp->response != USB_RSP_SUCCESS) {
        amba_error("Device returned status %u", rsp->response);
        return -1;
    }
    return 0;
}

int amba_proto_inquiry_chip(const amba_usb_dev_t *dev,
                            uint32_t *chip_id,
                            const amba_usb_params_t *p)
{
    /* USB_CMD_INQUIRY_STATUS with p0=USB_BLD_INQUIRY_CHIP; response's p0
     * carries the chip revision id (little-endian u32). Matches the
     * AMBA_USB_CMD_INQUIRY_CHIP arm in amba_usb_protocol.cpp:440-601. */
    amba_usb_cmd_t cmd = { AMBA_TOKEN_COMMAND, USB_CMD_INQUIRY_STATUS,
                           USB_BLD_INQUIRY_CHIP, 0, 0, 0, 0, 0 };
    if (send_cmd(dev, &cmd, p) != 0) return -1;
    amba_usb_rsp_t rsp;
    if (recv_rsp(dev, &rsp, p) != 0) return -1;
    *chip_id = rsp.p0;
    return 0;
}

/* Write a u32 to `addr`. Mirrors AmbaUsbProtocol::set_u32:
 * RDY_TO_RCV cmd carrying FLAG_COMMAND + AMBA_RTR_MEMORY_WRITE, address
 * in p2 and the value in p3. Used to clear the running amboot's USBDL
 * flag so it doesn't re-enter download mode on a soft-jump-back.
 * Errors are amba_debug-only; the caller decides whether it's fatal. */
static int proto_set_u32(const amba_usb_dev_t *dev,
                         amba_addr_t addr, uint32_t value,
                         const amba_usb_params_t *p)
{
    amba_usb_cmd_t cmd = { AMBA_TOKEN_COMMAND, USB_CMD_RDY_TO_RCV,
                           AMBA_FLAG_COMMAND, AMBA_RTR_MEMORY_WRITE,
                           addr.lo, value, 0, 0 };
    if (send_cmd(dev, &cmd, p) != 0) {
        amba_debug("set_u32 0x%016lx=0x%08x: send failed",
                   (unsigned long)addr.address, value);
        return -1;
    }
    amba_usb_rsp_t rsp;
    if (amba_usb_bulk_recv(dev, (uint8_t *)&rsp, sizeof(rsp), p) != 0 ||
        rsp.signature != AMBA_TOKEN_STATUS ||
        rsp.response  != USB_RSP_SUCCESS) {
        amba_debug("set_u32 0x%016lx=0x%08x: bad rsp",
                   (unsigned long)addr.address, value);
        return -1;
    }
    return 0;
}

/* Issue a bulk get_u32 against `addr`. Mirrors AmbaUsbProtocol::get_u32
 * (AMBA_USB_CMD_GET_U32 state in amba_usb_protocol.cpp). The BLD state
 * machine here is a one-shot request/response:
 *
 *   send  amba_usb_cmd_t { COMMAND_TOKEN, USB_CMD_RDY_TO_RCV,
 *                          p0=FLAG_COMMAND,
 *                          p1=AMBA_RTR_MEMORY_READ,
 *                          p2=addr.lo, p3=addr.hi }
 *   recv  amba_usb_rsp_t { STATUS_TOKEN, USB_RSP_SUCCESS, p0=value, ... }
 *
 * Errors are only debug-logged: the caller decides whether a probe
 * failure is fatal. */
static int proto_get_u32(const amba_usb_dev_t *dev,
                         amba_addr_t addr,
                         uint32_t *out,
                         const amba_usb_params_t *p)
{
    amba_usb_cmd_t cmd = { AMBA_TOKEN_COMMAND, USB_CMD_RDY_TO_RCV,
                           AMBA_FLAG_COMMAND, AMBA_RTR_MEMORY_READ,
                           addr.lo, addr.hi, 0, 0 };
    if (send_cmd(dev, &cmd, p) != 0) {
        amba_debug("get_u32 0x%016lx: send cmd failed",
                   (unsigned long)addr.address);
        return -1;
    }
    amba_usb_rsp_t rsp;
    if (amba_usb_bulk_recv(dev, (uint8_t *)&rsp, sizeof(rsp), p) != 0) {
        amba_debug("get_u32 0x%016lx: recv rsp failed",
                   (unsigned long)addr.address);
        return -1;
    }
    if (rsp.signature != AMBA_TOKEN_STATUS) {
        amba_debug("get_u32 0x%016lx: bad signature 0x%08x",
                   (unsigned long)addr.address, rsp.signature);
        return -1;
    }
    if (rsp.response != USB_RSP_SUCCESS) {
        amba_debug("get_u32 0x%016lx: device response %u",
                   (unsigned long)addr.address, rsp.response);
        return -1;
    }
    *out = rsp.p0;
    return 0;
}

/* Read the amboot version word (major.minor packed as
 * lo=minor, hi=major, upper 16 bits must be 0). Lives at
 * amboot_start + BLD_OFFSET_BLD_VERSION. Mirrors
 * AmbaUsbDevice::usb_bulk_get_bld_version.
 *
 * Two failure modes are surfaced at NOTICE level (visible without -v):
 * a raw protocol failure (bulk send/recv or device rejection) versus a
 * "value looked wrong" rejection where the upper 16 bits are nonzero.
 * They're easy to conflate but need different fixes: the first points
 * at a USB pipe problem, the second at either the wrong address or a
 * board that doesn't expose the version word here at all. */
static int read_bld_version(const amba_usb_dev_t *dev,
                            amba_addr_t amboot_start,
                            uint8_t *major, uint8_t *minor,
                            const amba_usb_params_t *p)
{
    amba_addr_t vaddr;
    vaddr.address = amboot_start.address + BLD_OFFSET_BLD_VERSION;
    uint32_t v = 0;
    if (proto_get_u32(dev, vaddr, &v, p) != 0) {
        amba_notice("BLD version read at 0x%016lx: get_u32 wire failure "
                    "(bulk send/recv error or device returned non-SUCCESS).",
                    (unsigned long)vaddr.address);
        return -1;
    }
    if ((v & 0xFFFF0000u) != 0) {
        amba_notice("BLD version read at 0x%016lx returned 0x%08x; upper "
                    "16 bits nonzero, treating as unreadable.",
                    (unsigned long)vaddr.address, v);
        return -1;
    }
    *major = (uint8_t)((v >> 8) & 0xFF);
    *minor = (uint8_t)(v & 0xFF);
    return 0;
}

/* Decode a raw DRAM-size register value into MiB, matching
 * AmbaMem::set_dram_size_reg_value in amba_usb_device_struct.cpp.
 *
 * Two lookup tables, keyed by whether the chip is UST-type ("new_chip"):
 *
 *   Legacy (bits [7:5] of the low byte, values 0..6):
 *     0=32MB, 1=64MB, 2=128MB, 3=256MB, 4=512MB, 5=1024MB, 6=2048MB
 *   New / UST (bits [5:2] of the reg, values 0..8):
 *     0=256MB, 1=384MB, 2=512MB, 3=768MB, 4=1024MB, 5=1536MB, 6=2048MB,
 *     7=3072MB, 8=4096MB
 *
 * Returns MiB, or 0 on unrecognised bitfield. */
static uint32_t decode_dram_reg_value(uint32_t reg_value, int new_chip)
{
    static const uint32_t new_table[] = {
        256, 384, 512, 768, 1024, 1536, 2048, 3072, 4096
    };
    static const uint32_t legacy_table[] = {
        32, 64, 128, 256, 512, 1024, 2048
    };
    if (new_chip) {
        uint32_t idx = (reg_value >> 2) & 0xF;
        if (idx < sizeof(new_table) / sizeof(new_table[0])) return new_table[idx];
    } else {
        uint32_t idx = ((reg_value & 0xFF) >> 5) & 0x7;
        if (idx < sizeof(legacy_table) / sizeof(legacy_table[0]))
            return legacy_table[idx];
    }
    amba_error("Unrecognised DRAM size register value 0x%08x "
               "(%s decoding). Pass --dram-mb explicitly.",
               reg_value, new_chip ? "UST" : "legacy");
    return 0;
}

/* Probe the device for its DRAM size in MiB, mirroring
 * AmbaUsbDevice::update_board_memory_size. Returns 0 on success and
 * writes the value into *out_mb; returns -1 on failure.
 *
 * Strategy (matches the Qt source path-for-path):
 *   1. Read the BLD version out of amboot (only used to gate the
 *      DRAM_SIZE_QUERY_COMMAND upgrade below).
 *   2. Pick a query address:
 *        - UST devices, or amboot >= 3.10: DRAM_SIZE_QUERY_COMMAND
 *          (magic pseudo-address the bootloader answers in MiB directly)
 *        - Otherwise: the chip's real dram_size_reg (bitfield in a
 *          physical register; needs decoding)
 *   3. get_u32(query_addr). If it returns 0xFFFFFFFF, fall back to
 *      reading amboot_start + BLD_OFFSET_DRAM_REG (the copy amboot
 *      stashes in its own header: always a raw register value).
 *   4. If the query address was DRAM_SIZE_QUERY_COMMAND, the result IS
 *      the size in MiB. Otherwise decode via decode_dram_reg_value. */
static int probe_dram_mb(const amba_usb_dev_t *dev,
                         const amba_chip_t *chip,
                         amba_addr_t amboot_start,
                         const amba_usb_params_t *p,
                         uint32_t *out_mb)
{
    if (dev->mode != AMBA_USB_MODE_AMBOOT &&
        dev->mode != AMBA_USB_MODE_UST) {
        amba_error("Cannot probe DRAM size in this mode "
                   "(only AMBOOT and UST are supported).");
        return -1;
    }

    int is_ust = (strcmp(chip->type, "ust") == 0);

    /* Step 1: BLD version (best-effort; UST paths don't need it). */
    uint8_t bld_major = 0, bld_minor = 0;
    int have_bld_ver = 0;
    if (dev->mode == AMBA_USB_MODE_AMBOOT) {
        if (read_bld_version(dev, amboot_start, &bld_major, &bld_minor, p) == 0) {
            amba_info("Amboot version: %u.%u", bld_major, bld_minor);
            have_bld_ver = 1;
        } else {
            amba_notice("Could not read amboot version; falling back to "
                        "chip-table dram_size_reg (0x%08x).",
                        chip->dram_size_reg.lo);
        }
    }

    /* Step 2: pick a query address. */
    amba_addr_t query = chip->dram_size_reg;
    int used_query_cmd = (query.lo == DRAM_SIZE_QUERY_COMMAND);
    if (dev->mode == AMBA_USB_MODE_AMBOOT && !used_query_cmd &&
        have_bld_ver && bld_major >= 3 && bld_minor >= 10) {
        query.address    = DRAM_SIZE_QUERY_COMMAND;
        used_query_cmd   = 1;
        amba_info("Amboot >= 3.10 supports DRAM_SIZE_QUERY_COMMAND; "
                  "using it instead of the raw register.");
    }
    if (dev->mode == AMBA_USB_MODE_UST) {
        /* UST firmware answers DRAM_SIZE_QUERY_COMMAND in MiB. The chip
         * table sets dram_size_reg to that magic value for UST chips, but
         * be defensive in case a config file was hand-edited. */
        used_query_cmd = 1;
    }

    /* Step 3: issue the query, with the amboot-copy fallback for the
     * "BLD can't read the real register" case. */
    uint32_t value = 0;
    if (proto_get_u32(dev, query, &value, p) != 0) {
        amba_error("Failed to query DRAM size (0x%08x). "
                   "Pass --dram-mb explicitly.", query.lo);
        return -1;
    }
    if (value == 0xFFFFFFFFu && dev->mode == AMBA_USB_MODE_AMBOOT) {
        amba_notice("Primary DRAM query returned 0xFFFFFFFF; falling back "
                    "to amboot's pre-set dram_size_reg copy.");
        amba_addr_t fb;
        fb.address = amboot_start.address + BLD_OFFSET_DRAM_REG;
        if (proto_get_u32(dev, fb, &value, p) != 0) {
            amba_error("Fallback DRAM-size read at 0x%016lx failed. "
                       "Pass --dram-mb explicitly.",
                       (unsigned long)fb.address);
            return -1;
        }
        /* The fallback address is always a raw register value regardless
         * of the primary query type; force the decode path. */
        used_query_cmd = 0;
    }

    /* Step 4: interpret. */
    uint32_t mb = 0;
    if (used_query_cmd) {
        if (value == 0 || value > 0x10000u) {
            amba_error("Device returned implausible DRAM size %u MiB. "
                       "Pass --dram-mb explicitly.", value);
            return -1;
        }
        mb = value;
        amba_notice("DRAM size probed: %u MiB (via DRAM_SIZE_QUERY_COMMAND)",
                    mb);
    } else {
        mb = decode_dram_reg_value(value, is_ust);
        if (mb == 0) return -1;
        amba_notice("DRAM size probed: %u MiB (reg 0x%08x decoded)",
                    mb, value);
    }
    *out_mb = mb;
    return 0;
}

/* Ask amboot to leave the download loop and jump to `address`. Wire
 * format mirrors AmbaUsbProtocol::AMBA_USB_CMD_JUMP_RUN in
 * amba_usb_protocol.cpp:550-557 / 793-820:
 *
 *   cmd { COMMAND_TOKEN, RDY_TO_RCV,
 *         p0 = FLAG_JUMP_EXEC | FLAG_LAST_TRANS | FLAG_FORCE_FINISH,
 *         p1 = addr.lo, p2 = addr.lo }   (p2 mirrors p1 in the Qt source)
 *   rsp { STATUS_TOKEN, SUCCESS, ... }
 *
 * This is the bulk-endpoint jump used in AMBOOT / UST mode; the control-
 * transfer USB_BOOT_CMD_JUMP path is for FORCEUSB DRAM init and does
 * not exit the amboot download loop. Using the wrong one is why the CLI
 * hung with "Jump-to-run control transfer failed" after all four blobs
 * had already transferred with matching CRCs. */
static int proto_jump_run(const amba_usb_dev_t *dev,
                          amba_addr_t address,
                          const amba_usb_params_t *p)
{
    amba_usb_cmd_t cmd = {
        AMBA_TOKEN_COMMAND, USB_CMD_RDY_TO_RCV,
        AMBA_FLAG_JUMP_EXEC | AMBA_FLAG_LAST_TRANS | AMBA_FLAG_FORCE_FINISH,
        address.lo, address.lo, 0, 0, 0
    };
    if (send_cmd(dev, &cmd, p) != 0) {
        amba_error("Failed to send JUMP_RUN cmd for 0x%08x", address.lo);
        return -1;
    }
    amba_usb_rsp_t rsp;
    if (recv_rsp(dev, &rsp, p) != 0) return -1;
    return 0;
}

/* Read the raw dram_size_reg value via a chain of control-transfer reads.
 * Only useful in FORCEUSB mode where the bulk endpoints aren't wired up
 * yet. Mirrors AmbaUsbDevice::usb_ctrl_get_memory (one u32 at a time). */
static int ctrl_get_dram_size_reg(const amba_usb_dev_t *dev,
                                  amba_addr_t reg,
                                  uint32_t *out_value,
                                  const amba_usb_params_t *p)
{
    if (amba_usb_ctrl_read_u32(dev, reg.lo, out_value, p) != 0) {
        amba_error("FORCEUSB: failed to read dram_size_reg 0x%08x",
                   reg.lo);
        return -1;
    }
    return 0;
}

/* Word-by-word ctrl-transfer send of a binary blob, patching a handful
 * of fixed offsets on the way through. Only used in FORCEUSB mode where
 * the bulk pipe isn't up yet. Matches usb_ctrl_send_file in the Qt
 * source (amba_usb_device.cpp:1791-1870).
 *
 * When `patch_amboot` is non-zero:
 *   - offset BLD_OFFSET_BLD_VERSION: read only, remembers we're
 *     writing a real amboot with a valid version word so the USBDL
 *     patch below is safe to apply.
 *   - offset BLD_OFFSET_BOOT_MEDIA: replace zero with the RCT media byte.
 *   - offset BLD_OFFSET_USB_BOOT: force to 1 (enter USBDL after DRAM init)
 *     when we saw a valid BLD version above.
 *   - offset BLD_OFFSET_DRAM_REG: overwrite with the runtime-read
 *     dram_size_reg value so amboot doesn't have to re-read the reg.
 *
 * `media_rct` is the value produced by amba_media_to_rct; only used
 * when patching. `dram_size_reg_value` is the raw register value read
 * back from the chip at boot. */
static int ctrl_send_binary(const amba_usb_dev_t *dev,
                            const uint8_t *bin, size_t len,
                            amba_addr_t target,
                            int patch_amboot,
                            uint32_t media_rct,
                            uint32_t dram_size_reg_value,
                            const amba_usb_params_t *p)
{
    if ((len % sizeof(uint32_t)) != 0) {
        amba_error("Binary length %zu is not a multiple of 4", len);
        return -1;
    }
    amba_info("Start writing to 0x%016lx, data size %zu bytes!",
              (unsigned long)target.address, len);

    int have_bld_version = 0;
    uint64_t written = 0;
    for (size_t off = 0; off < len; off += sizeof(uint32_t)) {
        uint32_t value;
        memcpy(&value, bin + off, sizeof(value));

        if (patch_amboot) {
            if (off == BLD_OFFSET_BLD_VERSION && (value & 0xFFFF0000u) == 0) {
                uint8_t maj = (uint8_t)((value >> 8) & 0xFF);
                uint8_t minr = (uint8_t)(value & 0xFF);
                have_bld_version = 1;
                amba_notice("Amboot Version: %u.%u", maj, minr);
            } else if (off == BLD_OFFSET_BOOT_MEDIA && value == 0) {
                value = media_rct;
                amba_notice("Boot media set in BLD to 0x%08x", value);
            } else if (off == BLD_OFFSET_USB_BOOT && have_bld_version) {
                value = 0x00000001u;
            } else if (off == BLD_OFFSET_DRAM_REG) {
                value = dram_size_reg_value;
            }
        }

        if (amba_usb_ctrl_write_u32(dev, USB_BOOT_CMD_WRITE,
                                    (uint32_t)target.address + (uint32_t)off,
                                    value, p) != 0) {
            amba_error("FORCEUSB ctrl-write at 0x%08x failed",
                       (uint32_t)target.address + (uint32_t)off);
            return -1;
        }
        written += sizeof(uint32_t);
    }
    amba_debug("Wrote %llu bytes via ctrl transfers", (unsigned long long)written);
    return 0;
}

/* Bring a FORCEUSB (raw / pre-DRAM-init) device up to the point where
 * amboot is running and answering bulk protocol commands. Closes the
 * original device handle and re-opens the amboot version of the same
 * board on the way out, updating *dev in-place. On failure the handle
 * is left closed; the caller cleans up. Returns 0 on success, -2 if the
 * operator cancelled (nothing here writes flash, so that is safe to report
 * as a cancel), -1 on any other failure. Loosely mirrors
 * AmbaUsbDramInitSession::start (amba_usb_dram_session.cpp:62-103):
 *
 *   1. Play the .ads DRAM init script (ads_execute). This is what programs
 *      the DRAM controller, including the dram_size_reg read in step 2.
 *   2. Read the raw dram_size_reg via ctrl-transfer (bulk isn't wired
 *      up yet). The value gets baked into the amboot binary at
 *      BLD_OFFSET_DRAM_REG so amboot doesn't have to re-read it.
 *   3. Optionally load ambhal.bin at addr_hal (if the board defines one).
 *   4. Load the BLD ELF, patching boot_media / USBDL / dram_size_reg in
 *      the process, and write it at addr_amboot via ctrl transfers.
 *   5. Write the boardinfo (magic + AUTO + reg-value dram_size) at
 *      addr_boardinfo so amboot boots straight into the firmware
 *      programmer instead of stopping in USBDL waiting for input.
 *   6. Ctrl-transfer USB_BOOT_CMD_JUMP to addr_amboot.
 *   7. Wait for the FORCEUSB node to leave the bus.
 *   8. Wait for a fresh 4255:xxxx node to appear (that's amboot).
 *   9. Verify chip id via INQUIRY_CHIP, update *dev with the new open
 *      handle.
 *
 * `amboot_start` is filled in with the address the caller should treat
 * as amboot_start for the subsequent firmware session. */
static int dram_init_and_reconnect(amba_usb_dev_t *dev,
                                   const amba_session_cfg_t *cfg,
                                   amba_addr_t *amboot_start_out,
                                   uint32_t *dram_mb_out)
{
    /* Step 1: DRAM init script.
     *
     * This has to run before the dram_size_reg read below: on a FORCEUSB
     * device the DRAM controller is still unprogrammed, and the .ads script
     * is what writes that very register (e.g. platform/cv22/chip.conf has
     * DramSizeReg = 0xDFFE0804 and the cv22 .ads scripts contain
     * "write 0xdffe0804,..."). Reading first yields a garbage size that then
     * gets baked into the BLD at BLD_OFFSET_DRAM_REG, into board_info, and
     * into the top-of-DRAM placement of boardinfo/firminfo for both this
     * session and the firmware session that follows. The Qt source does the
     * same order: amba_usb_dram_session.cpp:242 runs usb_init_dram() before
     * update_board_memory_size(AMBA_DEV_MODE_FORCEUSB). */
    if (!cfg->board->ads[0]) {
        amba_error("Board %s has no .ads script; cannot initialise DRAM.",
                   cfg->board->name);
        return -1;
    }
    amba_ads_script_t script;
    if (amba_ads_parse(cfg->board->ads, /*memprog_addr=*/0, &script) != 0) {
        return -1;
    }
    if (amba_ads_execute(dev, &script, cfg->params) != 0) {
        amba_ads_free(&script);
        return -1;
    }
    amba_ads_free(&script);

    /* Step 2: raw dram_size_reg via ctrl, now that the script has set it. */
    uint32_t reg_value = 0;
    if (ctrl_get_dram_size_reg(dev, cfg->chip->dram_size_reg,
                               &reg_value, cfg->params) != 0) {
        return -1;
    }
    int is_ust = (strcmp(cfg->chip->type, "ust") == 0);
    uint32_t dram_mb = decode_dram_reg_value(reg_value, is_ust);
    if (dram_mb == 0) return -1;
    amba_notice("DRAM size initialized to %u MB, RegValue: 0x%08x",
                dram_mb, reg_value);

    /* Compute the memory map from chip defaults. */
    amba_mem_t mem;
    memset(&mem, 0, sizeof(mem));
    amba_mem_set_dram_start(&mem, cfg->chip->dram_start_addr,
                            cfg->chip->dram_size_reg);
    amba_addr_t amboot_start;
    amboot_start.address = mem.dram_start.address + DRAM_OFFSET_AMBOOT;
    amba_mem_set_amboot_start(&mem, amboot_start);
    amba_mem_set_dram_size(&mem, dram_mb);
    mem.addr_width = cfg->chip->reg_bits;

    uint32_t media_rct = amba_media_to_rct(amba_media_from_string(cfg->board->media));

    /* Step 3: ambhal (optional). */
    if (cfg->board->hal[0]) {
        amba_binary_t hal;
        if (amba_elf_extract(cfg->board->hal, &hal) == 0) {
            int rc = ctrl_send_binary(dev, hal.data, hal.size,
                                      mem.addr_hal, /*patch_amboot=*/0,
                                      media_rct, reg_value, cfg->params);
            amba_binary_free(&hal);
            if (rc != 0) return -1;
        } else {
            amba_notice("%s does not exist or is not an ELF! Ignore...",
                        cfg->board->hal);
        }
    }

    /* Step 4: amboot (BLD ELF) with patching. */
    amba_binary_t bld;
    if (amba_elf_extract(cfg->board->bld, &bld) != 0) {
        amba_error("Failed to extract BLD ELF %s", cfg->board->bld);
        return -1;
    }
    if (bld.load_addr && bld.load_addr != mem.addr_amboot.address) {
        amba_mem_set_amboot_start(&mem,
                                  (amba_addr_t){ .address = bld.load_addr });
    }
    int rc = ctrl_send_binary(dev, bld.data, bld.size, mem.addr_amboot,
                              /*patch_amboot=*/1,
                              media_rct, reg_value, cfg->params);
    amba_binary_free(&bld);
    if (rc != 0) return -1;

    /* Step 5: boardinfo at addr_boardinfo (via ctrl writes, u32 at a time). */
    amba_boardinfo_t board_info;
    memset(&board_info, 0, sizeof(board_info));
    board_info.magic      = AMBA_BOARD_MAGIC;
    board_info.init_mode  = AMBA_DEV_INIT_MODE_AUTO;
    board_info.ptb        = 0;
    board_info.dram_size  = reg_value;
    board_info.new_device = 1;
    /* Copy through an aligned scratch buffer; the packed struct's
     * alignment is 1 and -Waddress-of-packed-member trips on a direct
     * u32 cast even though the layout happens to be 4-aligned. */
    _Static_assert(sizeof(board_info) % sizeof(uint32_t) == 0,
                   "boardinfo size must be a multiple of 4");
    uint32_t bi_words[sizeof(board_info) / sizeof(uint32_t)];
    memcpy(bi_words, &board_info, sizeof(board_info));
    for (size_t i = 0; i < sizeof(bi_words) / sizeof(bi_words[0]); i++) {
        if (amba_usb_ctrl_write_u32(dev, USB_BOOT_CMD_WRITE,
                                    (uint32_t)mem.addr_boardinfo.address +
                                        (uint32_t)(i * sizeof(uint32_t)),
                                    bi_words[i], cfg->params) != 0) {
            amba_error("FORCEUSB: failed writing boardinfo word %zu", i);
            return -1;
        }
    }

    /* Step 6: jump to amboot. */
    amba_info("Jumping to amboot at 0x%08x", mem.addr_amboot.lo);
    if (amba_usb_ctrl_write_u32(dev, USB_BOOT_CMD_JUMP,
                                mem.addr_amboot.lo, 0,
                                cfg->params) != 0) {
        amba_error("Failed to send USB_BOOT_CMD_JUMP to amboot");
        return -1;
    }

    /* Step 7: wait for old node to leave. */
    amba_usb_ctx_t *ctx = dev->ctx;
    uint16_t vid = dev->vid;
    char old_node[16];
    snprintf(old_node, sizeof(old_node), "%s", dev->node);
    amba_usb_close(dev);
    amba_info("Waiting for %s to leave the bus after DRAM init...", old_node);
    int wrc = amba_usb_wait_disconnect(ctx, old_node,
                                       cfg->wait_timeout_ms,
                                       cfg->cancel_flag);
    /* -2 is a cancel, and DRAM init writes nothing to flash, so it is safe
     * to report it as one instead of as a DRAM-init failure. */
    if (wrc == -2) {
        amba_warn("Cancelled while waiting for %s to leave the bus.",
                  old_node);
        return -2;
    }
    if (wrc == -3) {
        amba_error("Could not enumerate the USB bus while waiting for "
                   "FORCEUSB device %s to leave it.", old_node);
        return -1;
    }
    if (wrc != 0) {
        amba_error("FORCEUSB device %s did not leave the bus; DRAM init "
                   "probably failed.", old_node);
        return -1;
    }

    /* Step 8: wait for the amboot device to appear. */
    amba_info("Waiting for the amboot device to appear...");
    int find_ms = cfg->wait_timeout_ms > 0 ? cfg->wait_timeout_ms : 30000;
    int frc = amba_usb_find_and_open(ctx, vid, /*pid=*/0, find_ms,
                                    cfg->cancel_flag, dev);
    if (frc == -2) {
        amba_warn("Cancelled while waiting for the amboot device to appear.");
        return -2;
    }
    if (frc != 0) {
        amba_error("Amboot device did not appear on the bus within %d ms",
                   find_ms);
        return -1;
    }
    if (dev->mode != AMBA_USB_MODE_AMBOOT && dev->mode != AMBA_USB_MODE_UST) {
        amba_error("Reopened device on %s reports mode %d (not AMBOOT/UST); "
                   "DRAM init probably failed.", dev->node, dev->mode);
        return -1;
    }

    /* Step 9: verify chip id. */
    uint32_t reported = 0;
    if (amba_proto_inquiry_chip(dev, &reported, cfg->params) != 0) {
        amba_error("INQUIRY_CHIP failed on reopened device %s", dev->node);
        return -1;
    }
    if (reported != cfg->chip->id) {
        amba_error("Reopened chip id 0x%x does not match --chip %s (0x%x)",
                   reported,
                   cfg->chip->pretty_name[0] ?
                       cfg->chip->pretty_name : cfg->chip->name,
                   cfg->chip->id);
        return -1;
    }
    amba_info("DRAM init complete; amboot is running on %s (chip 0x%x).",
              dev->node, reported);

    if (amboot_start_out) *amboot_start_out = mem.addr_amboot;
    if (dram_mb_out) *dram_mb_out = dram_mb;
    return 0;
}

/* High-level "write blob to device address" used for fwprog_cmd, fw_info,
 * board_info and the firmware binary itself. Mirrors the wire protocol
 * used by AmbaUsbProtocol::send_to / AMBA_USB_CMD_SET_MEM in the Qt
 * source. Sequence on the wire:
 *
 *   1. RDY_TO_RCV cmd  (FLAG_ADDRESS + target.lo/hi)
 *   2. rsp             (SUCCESS)
 *   3. RCV_DATA cmd    (p0 = CRC32 of data [+ padding])
 *   4. bulk data       (`len` bytes)
 *   5. bulk padding    (4 bytes, only when `len % max_pkt_out == 0`)
 *   6. rsp             (SUCCESS)
 *
 * Two subtleties the earlier implementation got wrong:
 *
 *   - RCV_DATA is sent BEFORE the payload, and carries the CRC in p0.
 *     Our previous format put flags in p0 and the CRC in p2; the BLD
 *     interpreted the flags word (0x09) as the CRC, so every transfer
 *     effectively lied about its checksum and only worked because the
 *     BLD firmware appears not to reject a mismatched CRC.
 *
 *   - When `len` is an exact multiple of the OUT endpoint's max packet
 *     size (e.g. the 64 KiB fwprog blob at wMaxPacketSize=512), no
 *     short packet is emitted after the last full packet, so the BLD
 *     never sees end-of-data and interprets subsequent commands as more
 *     data. The "Wrong signature: 0x00000000" spam in the amboot
 *     console came from the BLD reading zero-filled fwprog padding as
 *     32-byte command frames. Appending 4 real bytes (preserved by
 *     reading them back from the target first) forces a short packet
 *     without disturbing target memory. */
static int send_blob_to(const amba_usb_dev_t *dev,
                        const amba_mem_t *mem,
                        const uint8_t *data, size_t len,
                        amba_addr_t target,
                        const amba_usb_params_t *p)
{
    uint32_t padding_word = 0;
    size_t   padding_len  = 0;
    if (dev->max_pkt_out && (len % dev->max_pkt_out) == 0) {
        padding_len = sizeof(padding_word);
    }

    /* Refuse to write outside physical DRAM, mirroring the pre-flight in
     * AmbaUsbProtocol::send_to (amba_usb_protocol.cpp:207-222) plus the
     * all-ones sentinel check in AmbaUsbFirmwareSession::usb_bulk_send_to
     * (amba_usb_firmware_session.cpp:324). This matters because one of the
     * targets, fwinfo.fw_addr_cmd, is a 32-bit word lifted verbatim out of
     * the firmware image at FIRM_OFFSET_MEMFWCMD, and a non-ELF file is
     * accepted as a flat binary — so without this, an unrelated file passed
     * to --firmware makes us bulk-write 64 KiB to an arbitrary address.
     *
     * Qt only checks the upper bound (address + size + padding vs
     * dram_start + dram_size); the lower bound below is stricter, and is a
     * no-op for every shipped preset since cv22/cv25/s6lm all declare
     * DramStartAddress = 0. Like the Qt source this only bounds the write to
     * the DRAM window; it cannot tell a legitimate target from one that
     * happens to land on the running amboot. */
    if (!data || len == 0) {
        amba_error("Refusing to send an empty blob to 0x%016lx",
                   (unsigned long)target.address);
        return -1;
    }
    if (target.address == UINT64_MAX) {
        amba_error("Refusing to send %zu bytes to the invalid address "
                   "0x%016lx", len, (unsigned long)target.address);
        return -1;
    }
    if (mem->dram_size_mb == 0) {
        amba_warn("DRAM size unknown; skipping the range check for the "
                  "%zu-byte write to 0x%016lx", len,
                  (unsigned long)target.address);
    } else {
        uint64_t dram_bytes = (uint64_t)mem->dram_size_mb << 20;
        uint64_t limit      = mem->dram_start.address + dram_bytes;
        uint64_t avail      = target.address <= limit
                            ? limit - target.address : 0;
        if (target.address < mem->dram_start.address ||
            (uint64_t)len > avail ||
            (uint64_t)padding_len > avail - (uint64_t)len) {
            amba_error("Refusing to write %zu bytes + %zu padding at "
                       "0x%016lx: outside DRAM 0x%016lx..0x%016lx (%u MiB)",
                       len, padding_len, (unsigned long)target.address,
                       (unsigned long)mem->dram_start.address,
                       (unsigned long)limit, mem->dram_size_mb);
            return -1;
        }
    }

    if (padding_len) {
        amba_addr_t pad_addr;
        pad_addr.address = target.address + len;
        if (proto_get_u32(dev, pad_addr, &padding_word, p) != 0) {
            amba_error("Failed reading padding word at 0x%016lx (needed "
                       "because %zu is a multiple of max_pkt_out=%u).",
                       (unsigned long)pad_addr.address, len,
                       dev->max_pkt_out);
            return -1;
        }
        amba_debug("Padded blob at 0x%016lx with 0x%08x (short-packet "
                   "termination)", (unsigned long)pad_addr.address,
                   padding_word);
    }

    uint32_t crc = crc32_step(0xFFFFFFFFu, data, len);
    if (padding_len) {
        crc = crc32_step(crc, (const uint8_t *)&padding_word, padding_len);
    }
    crc = ~crc;

    amba_usb_cmd_t rdy = { AMBA_TOKEN_COMMAND, USB_CMD_RDY_TO_RCV,
                           AMBA_FLAG_ADDRESS, target.lo, target.hi, 0, 0, 0 };
    if (send_cmd(dev, &rdy, p) != 0) {
        amba_error("Failed to send RDY_TO_RCV for 0x%016lx",
                   (unsigned long)target.address);
        return -1;
    }
    amba_usb_rsp_t rsp;
    if (recv_rsp(dev, &rsp, p) != 0) return -1;

    amba_usb_cmd_t rcv = { AMBA_TOKEN_COMMAND, USB_CMD_RCV_DATA,
                           crc, 0, 0, 0, 0, 0 };
    if (send_cmd(dev, &rcv, p) != 0) {
        amba_error("Failed to send RCV_DATA (crc=0x%08x)", crc);
        return -1;
    }

    if (amba_usb_bulk_send(dev, data, len, p) != 0) {
        amba_error("Bulk payload send to 0x%016lx failed",
                   (unsigned long)target.address);
        return -1;
    }
    if (padding_len &&
        amba_usb_bulk_send(dev, (const uint8_t *)&padding_word,
                           padding_len, p) != 0) {
        amba_error("Padding short-packet to 0x%016lx failed",
                   (unsigned long)(target.address + len));
        return -1;
    }

    if (recv_rsp(dev, &rsp, p) != 0) return -1;
    return 0;
}

int amba_session_run(amba_usb_dev_t *dev, const amba_session_cfg_t *cfg)
{
    /* FORCEUSB devices haven't run DRAM init yet, so their bulk endpoints
     * don't answer anything sensible. Run the ADS DRAM init, load amboot
     * over ctrl transfers, hand control to it, then wait for the device
     * to come back as an AMBOOT node. On return `*dev` refers to the new
     * amboot handle and we fall through to the normal flash flow. */
    uint32_t forceusb_dram_mb = 0;
    if (dev->mode == AMBA_USB_MODE_FORCEUSB) {
        amba_addr_t amboot_after;
        int drc = dram_init_and_reconnect(dev, cfg, &amboot_after,
                                         &forceusb_dram_mb);
        if (drc == -2) return 130;
        if (drc != 0) return 1;
    }
    if (dev->mode != AMBA_USB_MODE_AMBOOT && dev->mode != AMBA_USB_MODE_UST) {
        amba_error("Device on %s reports unknown mode (mfr=\"%s\", prod=\"%s\")",
                   dev->node, dev->mfr, dev->product);
        amba_error("It has to be in amboot or UST mode to be flashed. How to "
                   "get there depends on the model: B4 can be power-cycled "
                   "into amboot, B0/B2/N1 need amboot triggered over the "
                   "debug cable.");
        return 2;
    }

    /* 1. ELF -> binary, then probe fwprog cmd/result + memfwprog. */
    amba_binary_t bin;
    if (amba_elf_extract(cfg->firmware_path, &bin) != 0) {
        amba_error("Firmware: %s", cfg->firmware_path);
        amba_error("%s is an invalid ELF file!", cfg->firmware_path);
        return 1;
    }
    amba_info("Firmware: %s (size %zu, load 0x%016lx)",
              cfg->firmware_path, bin.size, (unsigned long)bin.load_addr);

    amba_fwinfo_t fwinfo;
    uint32_t fw_version = 0, fw_memfwprog_off = 0;
    if (amba_fw_probe(&bin, &fwinfo, &fw_version, &fw_memfwprog_off) != 0) {
        amba_binary_free(&bin);
        return 1;
    }

    /* 2. Derive memory map from chip + firmware-reported memfwprog. */
    amba_mem_t mem;
    memset(&mem, 0, sizeof(mem));
    amba_mem_set_dram_start(&mem, cfg->chip->dram_start_addr,
                            cfg->chip->dram_size_reg);
    amba_addr_t amboot_start;
    amboot_start.address = mem.dram_start.address + DRAM_OFFSET_AMBOOT;
    amba_mem_set_amboot_start(&mem, amboot_start);
    mem.addr_width = cfg->chip->reg_bits;

    uint64_t orig_addr = mem.addr_memfwprog.address;
    uint64_t binary_start = bin.load_addr ? bin.load_addr : 0;
    amba_fw_adjust_memfwprog(fw_version, fw_memfwprog_off, orig_addr, &binary_start);
    if (binary_start) mem.addr_memfwprog.address = binary_start;
    /* Sanity check the resolved memfwprog address the same way the Qt
     * source does (amba_usb_firmware_session.cpp:80-88). If the ELF /
     * chip table combination somehow lands us at or below DRAM start,
     * the write will scribble on the wrong page; refuse to proceed. */
    if (mem.addr_memfwprog.address <= mem.dram_start.address) {
        amba_error("Resolved memfwprog address 0x%016lx is at or below "
                   "DRAM start 0x%016lx; refusing to flash to that "
                   "address (would collide with amboot).",
                   (unsigned long)mem.addr_memfwprog.address,
                   (unsigned long)mem.dram_start.address);
        amba_binary_free(&bin);
        return 1;
    }
    amba_debug("Using 0x%016lx as memfwprog start address",
               (unsigned long)mem.addr_memfwprog.address);

    /* DRAM size: used only to derive addr_boardinfo/addr_firminfo (top of
     * usable DRAM, minus the struct sizes). When the caller passes 0 we
     * probe the device (mirroring AmbaUsbDevice::update_board_memory_size);
     * a non-zero value is honoured as an explicit override. */
    uint32_t dram_mb = cfg->dram_size_mb;
    if (dram_mb == 0 && forceusb_dram_mb != 0) {
        /* We already resolved the DRAM size via ctrl-transfer read during
         * DRAM init; no point re-probing over bulk now that amboot is up. */
        dram_mb = forceusb_dram_mb;
        amba_info("Reusing FORCEUSB-phase DRAM size: %u MiB", dram_mb);
    } else if (dram_mb == 0) {
        if (probe_dram_mb(dev, cfg->chip, amboot_start, cfg->params,
                          &dram_mb) != 0) {
            amba_binary_free(&bin);
            return 1;
        }
    } else {
        amba_info("Using caller-supplied DRAM size: %u MiB (probe skipped)",
                  dram_mb);
    }
    amba_mem_set_dram_size(&mem, dram_mb);

    /* 3. Compose the host-side blobs.
     *
     * fwprog.cmd[6..7] and boardInfo.init_mode encode a contract with
     * memfwprog: "when you're done, hand control back to amboot so the
     * device actually reboots into the freshly-flashed image". Without
     * this, memfwprog writes the image but never triggers a re-enum,
     * wait_disconnect times out and the user sees a "reboot failed"
     * message even though the flash actually landed.
     *
     * The Qt path is buried in two hops so it's easy to miss:
     *
     *   1. AmbaUsbFirmwareSession::start (amba_usb_firmware_session.cpp:98-108)
     *      picks init_mode via get_firm_session_init_mode(); for a fresh
     *      device (dev_init_mode == NORM) it returns STOP, then force-writes
     *          cmd[6] = BLD_START_ADDR_PLACE_HOLDER (0x00B1DADD)
     *          cmd[7] = FIRM_PROG_CMD_VERIFY       (0x00007E57)
     *
     *   2. AmbaUsbDevice::set_command (amba_usb_device.cpp:1037-1049)
     *      spots the placeholder in cmd[6] and rewrites it as
     *          (amboot_start.lo & 0xFFFF0000) | FIRM_PROG_CMD_VERIFY
     *      i.e. amboot's top-16-bit "page" tagged with the 0x7E57 magic
     *      that memfwprog looks for. That's the bit-pattern actually put
     *      on the wire.
     *
     * We apply the composite value unconditionally. AMBA_USB_VERIFY_ALL is
     * defined (amba_usb_device_struct.h:108), so the live branch of
     * get_firm_session_init_mode (amba_usb_device.cpp:916-920) is:
     *
     *   cmd[7] == VERIFY            -> TEST
     *   else dev_init_mode == AUTO  -> STOP
     *   else                        -> NORM
     *
     * and on_verify_checked (amba_usb.cpp:744-758) is what puts the magic in
     * cmd[7] in the first place. That gives three reachable combinations:
     *
     *   verify on                 -> init_mode TEST, cmd[6]/[7] = magic
     *   verify off, dev AUTO      -> init_mode STOP, cmd[6]/[7] = magic
     *                                (forced by the STOP branch above)
     *   verify off, dev not AUTO  -> init_mode NORM, cmd[6]/[7] = 0
     *
     * The last one is the "device never reboots" case, so we never send it.
     * The first two differ *only* in boardInfo.init_mode, which is therefore
     * the one thing --verify selects — see below. cmd[6]/[7] are the same
     * either way, so the verify flag deliberately does not reach
     * amba_compute_fwprog_cmd. */
    static amba_fwprog_cmd_t fwprog; /* 64 KiB, static to avoid stack blow-up */
    memset(&fwprog, 0, sizeof(fwprog));
    uint32_t cmd_tmp[AMBA_FWPROG_MAX_CMD];
    amba_compute_fwprog_cmd(cfg->chip, cfg->board, /*verify=*/0, cmd_tmp);
    cmd_tmp[6] = (mem.addr_amboot.lo & 0xFFFF0000u) | FIRM_PROG_CMD_VERIFY;
    cmd_tmp[7] = FIRM_PROG_CMD_VERIFY;
    memcpy(fwprog.cmd, cmd_tmp, sizeof(cmd_tmp));
    amba_info("Enforcing to run amboot after programming!");
    amba_debug("fwprog cmd[6]=0x%08x cmd[7]=0x%08x "
               "(amboot handoff, amboot_start.lo=0x%08x)",
               cmd_tmp[6], cmd_tmp[7], mem.addr_amboot.lo);

    amba_boardinfo_t board_info;
    memset(&board_info, 0, sizeof(board_info));
    board_info.magic      = AMBA_BOARD_MAGIC;
    /* The only thing --verify changes on the wire: TEST asks memfwprog to
     * validate what it wrote, STOP just hands control back to amboot. Both
     * keep the amboot handoff (cmd[6]/[7] above); sending NORM here, as the
     * CLI once did, skipped it and left the device waiting instead of
     * rebooting. */
    board_info.init_mode  = cfg->verify ? AMBA_DEV_INIT_MODE_TEST
                                        : AMBA_DEV_INIT_MODE_STOP;
    amba_info("Post-program init mode: %s", cfg->verify ? "TeSt (verify)"
                                                        : "StOp");
    board_info.ptb        = 0;
    board_info.dram_size  = 0xffffffff;
    board_info.new_device = 1;

    /* 4. Send blobs in order, matching AmbaUsbFirmwareSession::start.
     *
     * Everything here lands in DRAM, so a cancel between blobs is safe and
     * is honoured: nothing has been written to flash yet. That stops being
     * true at the JUMP below, which is the point of no return. */
    if (cancelled(cfg)) {
        amba_warn("Cancelled before programming started; nothing was written "
                  "to flash.");
        amba_binary_free(&bin);
        return 130;
    }
    amba_info("Sending fwprog command -> 0x%016lx",
              (unsigned long)fwinfo.fw_addr_cmd.address);
    if (send_blob_to(dev, &mem, (const uint8_t *)&fwprog, sizeof(fwprog),
                     fwinfo.fw_addr_cmd, cfg->params) != 0) {
        amba_error("Failed sending firmware program command");
        amba_binary_free(&bin);
        return 1;
    }

    if (cancelled(cfg)) {
        amba_warn("Cancelled before programming started; nothing was written "
                  "to flash.");
        amba_binary_free(&bin);
        return 130;
    }
    amba_info("Sending firmware info -> 0x%016lx",
              (unsigned long)mem.addr_firminfo.address);
    if (send_blob_to(dev, &mem, (const uint8_t *)&fwinfo, sizeof(fwinfo),
                     mem.addr_firminfo, cfg->params) != 0) {
        amba_error("Failed sending firmware information");
        amba_binary_free(&bin);
        return 1;
    }

    /* Mirror AmbaUsbFirmwareSession::send_board_info's pre-flight:
     * re-read the BLD version (best-effort, purely for the log line) and
     * then clear the USBDL flag in the running amboot so it doesn't
     * re-enter download mode when memfwprog hands control back.
     *
     * The Qt source gates the set_u32 on a successful get_u32 of the
     * version word, but that's overly cautious for our purposes: on
     * boards like the CV22 test unit the version address returns
     * junk-with-nonzero-upper-16-bits even though set_u32 into the
     * USBDL slot works fine, and gating on the read leaves the flag
     * set: turning the flash into an infinite USBDL boot loop. */
    {
        uint8_t maj = 0, minr = 0;
        if (read_bld_version(dev, amboot_start, &maj, &minr, cfg->params) == 0) {
            amba_notice("Amboot Version: %u.%u", maj, minr);
        }
        amba_addr_t usbdl_addr;
        usbdl_addr.address = amboot_start.address + BLD_OFFSET_USB_BOOT;
        /* init_mode = STOP -> usbdl = 0 (usbdl = 1 is only for TEST) */
        if (proto_set_u32(dev, usbdl_addr, 0, cfg->params) != 0) {
            amba_warn("Failed to clear amboot USBDL flag at 0x%016lx; "
                      "device may re-enter download mode after reboot.",
                      (unsigned long)usbdl_addr.address);
        } else {
            amba_debug("Cleared amboot USBDL flag at 0x%016lx",
                       (unsigned long)usbdl_addr.address);
        }
    }

    amba_info("Sending board info -> 0x%016lx",
              (unsigned long)mem.addr_boardinfo.address);
    if (send_blob_to(dev, &mem, (const uint8_t *)&board_info,
                     sizeof(board_info),
                     mem.addr_boardinfo, cfg->params) != 0) {
        amba_error("Failed sending board information");
        amba_binary_free(&bin);
        return 1;
    }

    if (cancelled(cfg)) {
        amba_warn("Cancelled before programming started; nothing was written "
                  "to flash.");
        amba_binary_free(&bin);
        return 130;
    }
    amba_info("Sending firmware (%zu bytes) -> 0x%016lx",
              bin.size, (unsigned long)mem.addr_memfwprog.address);
    if (send_blob_to(dev, &mem, bin.data, bin.size,
                     mem.addr_memfwprog, cfg->params) != 0) {
        amba_error("Firmware bulk transfer failed");
        amba_binary_free(&bin);
        return 1;
    }
    amba_binary_free(&bin);

    /* 5. Jump to run. In amboot mode this is a bulk RDY_TO_RCV cmd with
     * the JUMP_EXEC / LAST_TRANS / FORCE_FINISH flags, not the control-
     * transfer USB_BOOT_CMD_JUMP path (that's for FORCEUSB). See
     * proto_jump_run above for the wire format. */
    if (cancelled(cfg)) {
        amba_warn("Cancelled before programming started; nothing was written "
                  "to flash.");
        return 130;
    }
    amba_info("Jumping to 0x%08x", mem.addr_memfwprog.lo);
    if (proto_jump_run(dev, mem.addr_memfwprog, cfg->params) != 0) {
        amba_error("Jump-to-run failed");
        return 1;
    }

    /* 6. Wait for the device to disappear from the bus — that's how the
     * firmware-session detects programming completion.
     *
     * Past this point memfwprog is writing flash, so cancelling is no longer
     * a safe thing to honour — the Qt GUI simply offers no way to abort a
     * running session (it disables every widget, amba_usb.cpp:928) and there
     * is no interruption check anywhere in AmbaUsbFirmwareSession. So the
     * cancel flag is deliberately NOT passed to the wait below: reporting
     * "cancelled" here would tell the operator to power-cycle at the one
     * moment that can brick the device. */
    amba_info("%s programming started — waiting for device to reboot",
              dev->node);
    char node_copy[16];
    snprintf(node_copy, sizeof(node_copy), "%s", dev->node);
    amba_usb_close(dev);

    if (cancelled(cfg)) {
        amba_warn("Cancel requested, but %s is already programming flash — "
                  "ignoring it. Do NOT power-cycle the device until this "
                  "finishes.", node_copy);
    }
    int rc = amba_usb_wait_disconnect(dev->ctx, node_copy,
                                      cfg->wait_timeout_ms,
                                      /*cancel_flag=*/NULL);
    if (rc == 0) {
        amba_info("%s Transfer finished successfully!", node_copy);
        return 0;
    }
    if (rc == -3) {
        amba_error("Could not enumerate the USB bus while waiting for %s to "
                   "reboot; programming may or may not have completed. Check "
                   "the device before power-cycling it.", node_copy);
        return 1;
    }
    amba_timeout("Waiting for %s to reboot timed out after %d ms",
                 node_copy, cfg->wait_timeout_ms);
    return 1;
}
