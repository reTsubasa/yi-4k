/*
 * usb.h — libusb wrappers used by the CLI flash flow.
 *
 * Only the pieces the firmware-download session calls into:
 *   - open by VID/PID (the chip table tells us which)
 *   - read string descriptors to determine FORCEUSB/AMBOOT/UST mode
 *   - claim interface, locate bulk-IN / bulk-OUT endpoints
 *   - bulk send/recv with chunked retry (matches AmbaUsbDevice::bulk_transfer_data)
 *   - control transfer for amba_boot_cmd JUMP / WRITE / READ
 *
 * Higher-level "send blob to address" — i.e. the BLD command/response
 * handshake (RDY_TO_RCV → bulk → RCV_DATA ack) — lives in session.c so the
 * USB layer stays a thin libusb shim.
 */
#ifndef AMBUSB_CLI_USB_H
#define AMBUSB_CLI_USB_H

#include <stdint.h>
#include <stddef.h>

#include "ambausb_proto.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Detected USB mode, derived from manufacturer + product string descriptors.
 * See amba_usb_device.cpp:194-214 for the mapping. */
typedef enum {
    AMBA_USB_MODE_UNKNOWN  = 0,
    AMBA_USB_MODE_FORCEUSB = 1, /* manufacturer = "Amba", DRAM not yet up    */
    AMBA_USB_MODE_AMBOOT   = 2, /* "AMBA" + "Ambarella USB generic class"    */
    AMBA_USB_MODE_UST      = 3, /* "Ambarella" + "Ambarella USB generic ..." */
} amba_usb_mode_t;

typedef struct amba_usb_ctx amba_usb_ctx_t;

typedef struct {
    amba_usb_ctx_t *ctx;
    void           *handle;          /* libusb_device_handle*               */
    uint16_t        vid;
    uint16_t        pid;
    uint8_t         interface_num;
    uint8_t         ep_in;
    uint8_t         ep_out;
    uint16_t        max_pkt_in;
    uint16_t        max_pkt_out;
    amba_usb_mode_t mode;
    char            mfr[64];
    char            product[64];
    char            serial[64];
    char            node[16];        /* "bbb-ddd"                           */
} amba_usb_dev_t;

/* Tunable retry policy mirroring AmbaUsbTransParameter. */
typedef struct {
    uint32_t bulk_send_block;   /* default 2 MiB */
    uint32_t bulk_recv_block;   /* default 1 MiB */
    uint32_t timeout_ms;        /* default 1000  */
    uint32_t retry_count;       /* default 5     */
} amba_usb_params_t;

void amba_usb_params_default(amba_usb_params_t *p);

/* Lifecycle */
int  amba_usb_init(amba_usb_ctx_t **ctx);
void amba_usb_exit(amba_usb_ctx_t *ctx);

/* Block until a device with the given VID/PID appears, or `timeout_ms`
 * elapses (0 = no wait, only return the device if it's already plugged).
 * Negative timeout = wait forever.
 *
 * `pid == 0` is treated as a wildcard, matching any product ID under the
 * given vendor. This mirrors the GUI's hotplug filter (VID-only plus
 * string classification), and is necessary because chips running amboot
 * or UST often present a placeholder PID (e.g. 0x0001) rather than the
 * chip-specific PID recorded in chip.conf. Callers that care about a
 * specific chip should verify via amba_proto_inquiry_chip after opening.
 *
 * Returns 0 on success; on success `dev` is populated and the interface
 * has been opened+claimed (but not configured otherwise). Returns -2 if
 * cancelled, -4 if a matching device was found but could not be opened for
 * lack of permission, -1 for not-found or any other failure.
 * Set `cancel_flag` to a pointer to a sig_atomic_t the signal handler
 * sets to 1; the poll loop checks it between attempts. */
int amba_usb_find_and_open(amba_usb_ctx_t *ctx,
                           uint16_t vid,
                           uint16_t pid,
                           int timeout_ms,
                           const volatile int *cancel_flag,
                           amba_usb_dev_t *dev);

void amba_usb_close(amba_usb_dev_t *dev);

/* Wait until the given dev_node disappears from the bus, or timeout.
 * The firmware-download flow uses this as "verify success". Returns 0 on
 * disconnect, -1 on timeout, -2 on cancel, -3 if the bus could not be
 * enumerated (which must NOT be read as a disconnect). */
int amba_usb_wait_disconnect(amba_usb_ctx_t *ctx,
                             const char *node,
                             int timeout_ms,
                             const volatile int *cancel_flag);

/* Bulk transfer with the same retry/clear-halt pattern as the Qt code. */
int amba_usb_bulk_send(const amba_usb_dev_t *dev,
                       const uint8_t *data, size_t len,
                       const amba_usb_params_t *p);
int amba_usb_bulk_recv(const amba_usb_dev_t *dev,
                       uint8_t *data, size_t len,
                       const amba_usb_params_t *p);

/* Control transfers used in FORCEUSB mode (sending raw words into DRAM). */
int amba_usb_ctrl_write_u32(const amba_usb_dev_t *dev,
                            uint32_t cmd, uint32_t addr, uint32_t value,
                            const amba_usb_params_t *p);
int amba_usb_ctrl_read_u32(const amba_usb_dev_t *dev,
                           uint32_t addr, uint32_t *out,
                           const amba_usb_params_t *p);

#ifdef __cplusplus
}
#endif
#endif
