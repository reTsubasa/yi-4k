/*
 * session.h — orchestrates the firmware-download sequence.
 *
 * This module is the single-threaded equivalent of AmbaUsbFirmwareSession
 * plus AmbaUsbDramInitSession in the Qt source.
 *
 * If the device is opened in FORCEUSB (raw) mode, the session first
 * plays the board's .ads DRAM init script and loads amboot over ctrl
 * transfers, then waits for the device to re-enumerate as an amboot
 * node and continues with the normal flash flow below. See
 * dram_init_and_reconnect in session.c.
 *
 * Normal (amboot) flow:
 *   1. Validate + ELF-unpack firmware (probe fwprog cmd/result + memfwprog).
 *   2. Compose AmbaFwInfo / AmbaBoardInfo / AmbaFwProgCmd in host memory.
 *   3. Bulk-send fwprog_cmd  -> addr_fwprogcmd (= memfwprog start)
 *   4. Bulk-send fw_info     -> addr_firminfo  (top-of-DRAM)
 *   5. Bulk-send board_info  -> addr_boardinfo (just below fw_info)
 *   6. Bulk-send firmware    -> addr_memfwprog
 *   7. Bulk JUMP_RUN         -> addr_memfwprog
 *   8. Wait for the device to disconnect (= success).
 */
#ifndef AMBUSB_CLI_SESSION_H
#define AMBUSB_CLI_SESSION_H

#include <stdint.h>
#include "ambausb_proto.h"
#include "platform.h"
#include "usb.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    const amba_chip_t       *chip;
    const amba_board_t      *board;
    const char              *firmware_path;
    int                      verify;
    int                      wait_timeout_ms;     /* default 90000 */
    /* DRAM size in MiB. Used to derive addr_boardinfo / addr_firminfo
     * (top-of-DRAM - sizeof(struct)). Must match the device's actual DRAM
     * or the bootloader writes board metadata to the wrong page.
     *
     * Pass 0 to have the session probe the device (mirroring the Qt
     * AmbaUsbDevice::update_board_memory_size flow): read the BLD version
     * out of amboot, then either issue a DRAM_SIZE_QUERY_COMMAND (BLD >=
     * 3.10, UST) or read the raw dram_size_reg and decode the bitfield.
     * A non-zero value here is treated as an explicit override and skips
     * the probe entirely: useful when the device answers with garbage,
     * or when scripting against a known board. */
    uint32_t                 dram_size_mb;
    const amba_usb_params_t *params;
    const volatile int      *cancel_flag;
} amba_session_cfg_t;

/* Run the full sequence on `dev`. Returns 0 on success, non-zero on
 * failure. The session does not close `dev` — caller still owns it. */
int amba_session_run(amba_usb_dev_t *dev, const amba_session_cfg_t *cfg);

/* Ask the running bootloader for its chip revision ID via
 * USB_CMD_INQUIRY_STATUS + USB_BLD_INQUIRY_CHIP. Mirrors
 * AmbaUsbProtocol::query_chip; the returned value matches the `Id`
 * field in the chip.conf files (e.g. 22000 for CV22).
 *
 * Only valid in AMBOOT / UST modes: FORCEUSB devices do not yet answer
 * inquiries. Returns 0 on success and writes into *chip_id. */
int amba_proto_inquiry_chip(const amba_usb_dev_t *dev,
                            uint32_t *chip_id,
                            const amba_usb_params_t *params);

#ifdef __cplusplus
}
#endif
#endif
