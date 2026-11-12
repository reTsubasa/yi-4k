#include "usb.h"
#include "log.h"

#include <errno.h>
#include <libusb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct amba_usb_ctx {
    libusb_context *lctx;
};

void amba_usb_params_default(amba_usb_params_t *p)
{
    p->bulk_send_block = 2 * 1024 * 1024;
    p->bulk_recv_block = 1 * 1024 * 1024;
    p->timeout_ms      = 1000;
    p->retry_count     = 5;
}

int amba_usb_init(amba_usb_ctx_t **out)
{
    amba_usb_ctx_t *c = calloc(1, sizeof(*c));
    if (!c) return -ENOMEM;
    int err = libusb_init(&c->lctx);
    if (err != LIBUSB_SUCCESS) {
        amba_error("libusb_init failed: %s", libusb_strerror(err));
        free(c);
        return -1;
    }
    *out = c;
    return 0;
}

void amba_usb_exit(amba_usb_ctx_t *c)
{
    if (!c) return;
    libusb_exit(c->lctx);
    free(c);
}

/* Read an ASCII-style USB string descriptor (LANGID 0x0409). The Ambarella
 * device returns a UTF-16-LE descriptor; we lower 8 bits of each code unit. */
static int read_string_desc(libusb_device_handle *h, int idx, char *out, size_t out_len)
{
    out[0] = '\0';
    if (idx == 0) return 0;
    uint8_t buf[64];
    int r = libusb_get_string_descriptor(h, (uint8_t)idx, 0x0409, buf, sizeof(buf));
    if (r < 2) return -1;
    int dlen = buf[0];
    if (dlen > r) dlen = r;
    int j = 0;
    for (int i = 2; i + 1 < dlen && j + 1 < (int)out_len; i += 2) {
        out[j++] = (char)buf[i];
    }
    out[j] = '\0';
    return 0;
}

static amba_usb_mode_t classify(const char *mfr, const char *prod)
{
    if (strcmp(mfr, "Amba") == 0) return AMBA_USB_MODE_FORCEUSB;
    if (strcmp(mfr, "AMBA") == 0 && strcmp(prod, "Ambarella USB generic class") == 0)
        return AMBA_USB_MODE_AMBOOT;
    if (strcmp(mfr, "Ambarella") == 0 && strcmp(prod, "Ambarella USB generic class") == 0)
        return AMBA_USB_MODE_UST;
    return AMBA_USB_MODE_UNKNOWN;
}

static void log_speed(libusb_device *d, uint8_t max_power_units)
{
    int s = libusb_get_device_speed(d);
    const char *name = "UNKNOWN";
    int power_factor = 0;
    switch (s) {
        case LIBUSB_SPEED_LOW:   name = "LOW";   break;
        case LIBUSB_SPEED_FULL:  name = "FULL";  break;
        case LIBUSB_SPEED_HIGH:  name = "HIGH";  power_factor = 2; break;
        case LIBUSB_SPEED_SUPER: name = "SUPER"; power_factor = 8; break;
#ifdef LIBUSB_SPEED_SUPER_PLUS
        case LIBUSB_SPEED_SUPER_PLUS: name = "SUPER PLUS"; break;
#endif
        default: break;
    }
    amba_info("Speed: %s", name);
    if (power_factor)
        amba_info("MaxPower: %dmA", max_power_units * power_factor);
}

static int open_one(amba_usb_ctx_t *ctx, libusb_device *d, amba_usb_dev_t *dev)
{
    struct libusb_device_descriptor desc;
    if (libusb_get_device_descriptor(d, &desc) != 0) return -1;
    dev->ctx = ctx;
    dev->vid = desc.idVendor;
    dev->pid = desc.idProduct;
    snprintf(dev->node, sizeof(dev->node), "%03d-%03d",
             libusb_get_bus_number(d), libusb_get_device_address(d));

    libusb_device_handle *h = NULL;
    int rc = libusb_open(d, &h);
    if (rc != LIBUSB_SUCCESS) {
        amba_error("Cannot open device %s: %s", dev->node, libusb_strerror(rc));
        /* Report "found it but can't touch it" separately from "not there":
         * the caller's fallback message is about the device being absent,
         * which is the opposite of what happened. */
        return rc == LIBUSB_ERROR_ACCESS ? -4 : -1;
    }

    read_string_desc(h, desc.iManufacturer, dev->mfr,     sizeof(dev->mfr));
    read_string_desc(h, desc.iProduct,      dev->product, sizeof(dev->product));
    read_string_desc(h, desc.iSerialNumber, dev->serial,  sizeof(dev->serial));
    dev->mode = classify(dev->mfr, dev->product);

    amba_notice("Manufacturer: %s", dev->mfr);
    amba_notice("Product:      %s", dev->product);
    if (dev->serial[0]) amba_notice("Serial:       %s", dev->serial);
    switch (dev->mode) {
        case AMBA_USB_MODE_FORCEUSB: amba_info("USB Mode");    break;
        case AMBA_USB_MODE_AMBOOT:   amba_info("Amboot Mode"); break;
        case AMBA_USB_MODE_UST:      amba_info("UST Mode");    break;
        default:                     amba_info("Unknown Device"); break;
    }

    struct libusb_config_descriptor *cfg = NULL;
    if (libusb_get_active_config_descriptor(d, &cfg) != 0 ||
        !cfg || cfg->bNumInterfaces < 1) {
        amba_error("Failed to get active config descriptor");
        if (cfg) libusb_free_config_descriptor(cfg);
        libusb_close(h);
        return -1;
    }
    const struct libusb_interface_descriptor *idesc = &cfg->interface[0].altsetting[0];
    dev->interface_num = idesc->bInterfaceNumber;
    dev->ep_in = dev->ep_out = 0xFF;
    for (int i = 0; i < idesc->bNumEndpoints; i++) {
        const struct libusb_endpoint_descriptor *ep = &idesc->endpoint[i];
        /* Only bulk endpoints participate in the flash protocol; interrupt
         * or isochronous endpoints on the same interface would silently
         * misclassify if we didn't filter here. */
        if ((ep->bmAttributes & LIBUSB_TRANSFER_TYPE_MASK)
            != LIBUSB_TRANSFER_TYPE_BULK) {
            amba_debug("Skipping non-bulk endpoint 0x%02x (attr=0x%02x)",
                       ep->bEndpointAddress, ep->bmAttributes);
            continue;
        }
        if ((ep->bEndpointAddress & 0x80) == 0) {
            dev->ep_out = ep->bEndpointAddress;
            int m = libusb_get_max_packet_size(d, ep->bEndpointAddress);
            dev->max_pkt_out = (uint16_t)(m > 0 ? m : 64);
            amba_debug("Output endpoint 0x%02x, max pkt %u",
                       dev->ep_out, dev->max_pkt_out);
        } else {
            dev->ep_in = ep->bEndpointAddress;
            int m = libusb_get_max_packet_size(d, ep->bEndpointAddress);
            dev->max_pkt_in = (uint16_t)(m > 0 ? m : 64);
            amba_debug("Input  endpoint 0x%02x, max pkt %u",
                       dev->ep_in, dev->max_pkt_in);
        }
    }
    log_speed(d, cfg->MaxPower);
    libusb_free_config_descriptor(cfg);

    if (dev->ep_in == 0xFF || dev->ep_out == 0xFF) {
        amba_error("Device %s missing bulk IN/OUT endpoints", dev->node);
        libusb_close(h);
        return -1;
    }

    if (libusb_kernel_driver_active(h, dev->interface_num) == 1) {
        libusb_detach_kernel_driver(h, dev->interface_num);
    }
    rc = libusb_claim_interface(h, dev->interface_num);
    if (rc != LIBUSB_SUCCESS) {
        amba_error("Failed to claim interface %u on %s: %s",
                   dev->interface_num, dev->node, libusb_strerror(rc));
        libusb_close(h);
        return -1;
    }
    dev->handle = h;
    return 0;
}

int amba_usb_find_and_open(amba_usb_ctx_t *ctx,
                           uint16_t vid, uint16_t pid,
                           int timeout_ms,
                           const volatile int *cancel_flag,
                           amba_usb_dev_t *dev)
{
    memset(dev, 0, sizeof(*dev));
    const int poll_ms = 200;
    int elapsed = 0;

    for (;;) {
        if (cancel_flag && *cancel_flag) return -2;

        libusb_device **list = NULL;
        ssize_t n = libusb_get_device_list(ctx->lctx, &list);
        if (n < 0) {
            /* Degrade into a retry rather than reporting "not found": the
             * caller can't tell the two apart and the next poll may work. */
            amba_warn("libusb_get_device_list: %s (retrying)",
                      libusb_strerror((int)n));
            n = 0;
        }
        for (ssize_t i = 0; i < n; i++) {
            struct libusb_device_descriptor desc;
            if (libusb_get_device_descriptor(list[i], &desc) != 0) continue;
            if (desc.idVendor != vid) continue;
            /* pid == 0 -> match any product under this vendor (see usb.h) */
            if (pid != 0 && desc.idProduct != pid) continue;
            int rc = open_one(ctx, list[i], dev);
            libusb_free_device_list(list, 1);
            return rc;
        }
        if (list) libusb_free_device_list(list, 1);

        if (timeout_ms == 0) return -1;
        if (timeout_ms > 0 && elapsed >= timeout_ms) return -1;
        amba_sleep_ms((uint32_t)poll_ms);
        elapsed += poll_ms;
    }
}

void amba_usb_close(amba_usb_dev_t *dev)
{
    if (!dev || !dev->handle) return;
    libusb_release_interface(dev->handle, dev->interface_num);
    libusb_close(dev->handle);
    dev->handle = NULL;
}

int amba_usb_wait_disconnect(amba_usb_ctx_t *ctx,
                             const char *node,
                             int timeout_ms,
                             const volatile int *cancel_flag)
{
    const int poll_ms = 250;
    int elapsed = 0;
    while (timeout_ms < 0 || elapsed < timeout_ms) {
        if (cancel_flag && *cancel_flag) return -2;
        libusb_device **list = NULL;
        ssize_t n = libusb_get_device_list(ctx->lctx, &list);
        /* A negative return is an enumeration failure, not an empty bus.
         * Falling through would leave still_present == 0 and report the
         * device as disconnected — i.e. "programming succeeded" — while the
         * device may well still be there mid-flash. Qt never hits this
         * because it detects removal via libusb hotplug callbacks
         * (amba_usb_device_monitor.cpp:147) rather than by polling. */
        if (n < 0) {
            if (list) libusb_free_device_list(list, 1);
            amba_error("libusb_get_device_list: %s",
                       libusb_strerror((int)n));
            return -3;
        }
        int still_present = 0;
        for (ssize_t i = 0; i < n; i++) {
            char tmp[16];
            snprintf(tmp, sizeof(tmp), "%03d-%03d",
                     libusb_get_bus_number(list[i]),
                     libusb_get_device_address(list[i]));
            if (strcmp(tmp, node) == 0) { still_present = 1; break; }
        }
        if (list) libusb_free_device_list(list, 1);
        if (!still_present) return 0;
        amba_sleep_ms((uint32_t)poll_ms);
        elapsed += poll_ms;
    }
    return -1;
}

int amba_usb_bulk_send(const amba_usb_dev_t *dev,
                       const uint8_t *data, size_t len,
                       const amba_usb_params_t *p)
{
    if (!dev->handle || !data || !len) return -EINVAL;
    size_t sent = 0;
    uint32_t fail_count = 0;
    while (sent < len && fail_count < p->retry_count) {
        size_t chunk = len - sent;
        if (chunk > p->bulk_send_block) chunk = p->bulk_send_block;
        int got = 0;
        int r = libusb_bulk_transfer(dev->handle, dev->ep_out,
                                     (uint8_t *)(uintptr_t)(data + sent),
                                     (int)chunk, &got, p->timeout_ms);
        if (r == LIBUSB_SUCCESS) {
            /* A zero-length packet is a "successful" transfer that moves
             * nothing. Resetting fail_count here — which is what Qt's
             * bulk_transfer_data does (amba_usb_device.cpp:1577-1585) —
             * makes the retry counter the only loop bound and then clears
             * it every iteration, so the loop never terminates. Count it
             * as a failed attempt instead: fail_count is only reset when
             * the transfer actually advanced. */
            if (got > 0) {
                sent += (size_t)got;
                fail_count = 0;
            } else {
                amba_notice("libusb_bulk_transfer: zero-length packet on "
                            "endpoint 0x%02x, %zu bytes left",
                            dev->ep_out, len - sent);
                fail_count++;
            }
        } else if (r == LIBUSB_ERROR_TIMEOUT) {
            amba_notice("libusb_bulk_transfer: timeout, %d bytes transferred "
                        "through endpoint 0x%02x, %zu bytes left",
                        got, dev->ep_out, chunk - (size_t)got);
            if (got > 0) { sent += (size_t)got; fail_count = 0; continue; }
            libusb_clear_halt(dev->handle, dev->ep_out);
            fail_count++;
        } else {
            amba_error("libusb_bulk_transfer: %s on endpoint 0x%02x",
                       libusb_strerror(r), dev->ep_out);
            libusb_clear_halt(dev->handle, dev->ep_out);
            return -1;
        }
    }
    if (sent != len) {
        amba_error("libusb_bulk_transfer failed after %u retries (%u ms each)",
                   p->retry_count, p->timeout_ms);
        return -1;
    }
    return 0;
}

int amba_usb_bulk_recv(const amba_usb_dev_t *dev,
                       uint8_t *data, size_t len,
                       const amba_usb_params_t *p)
{
    if (!dev->handle || !data || !len) return -EINVAL;
    size_t got_total = 0;
    uint32_t fail_count = 0;
    while (got_total < len && fail_count < p->retry_count) {
        size_t chunk = len - got_total;
        if (chunk > p->bulk_recv_block) chunk = p->bulk_recv_block;
        int got = 0;
        int r = libusb_bulk_transfer(dev->handle, dev->ep_in,
                                     data + got_total,
                                     (int)chunk, &got, p->timeout_ms);
        if (r == LIBUSB_SUCCESS) {
            /* See amba_usb_bulk_send: a ZLP makes no progress, so it must
             * not reset the only counter that bounds this loop. */
            if (got > 0) {
                got_total += (size_t)got;
                fail_count = 0;
            } else {
                amba_notice("libusb_bulk_transfer (in): zero-length packet "
                            "on endpoint 0x%02x, %zu bytes left",
                            dev->ep_in, len - got_total);
                fail_count++;
            }
        } else if (r == LIBUSB_ERROR_TIMEOUT) {
            if (got > 0) { got_total += (size_t)got; fail_count = 0; continue; }
            libusb_clear_halt(dev->handle, dev->ep_in);
            fail_count++;
        } else {
            amba_error("libusb_bulk_transfer (in): %s", libusb_strerror(r));
            libusb_clear_halt(dev->handle, dev->ep_in);
            return -1;
        }
    }
    return got_total == len ? 0 : -1;
}

/* Vendor-class control transfer carrying a 12-byte amba_boot_cmd_t
 * (defined in ambausb_proto.h). Direction is determined by the OUT
 * endpoint's address (matches the Qt source's libusb_endpoint_direction
 * cast). */
static int ctrl_send(const amba_usb_dev_t *dev,
                     uint8_t direction,        /* 0x80 for IN, 0x00 for OUT */
                     uint16_t wValue, uint16_t wIndex,
                     uint8_t *buf, uint16_t len,
                     const amba_usb_params_t *p)
{
    uint8_t bmRequestType = direction | LIBUSB_REQUEST_TYPE_VENDOR;
    /* The Qt code passes LIBUSB_REQUEST_GET_STATUS (=0) as bRequest. */
    uint8_t bRequest = LIBUSB_REQUEST_GET_STATUS;
    uint32_t fail = 0;
    int trans = 0;
    while (trans < len && fail < p->retry_count) {
        int r = libusb_control_transfer(dev->handle, bmRequestType, bRequest,
                                        wValue, wIndex,
                                        buf + trans, (uint16_t)(len - trans),
                                        p->timeout_ms);
        /* r == 0 is a successful transfer of nothing; see the ZLP note in
         * amba_usb_bulk_send. Only a non-empty transfer clears `fail`. */
        if (r > 0) { trans += r; fail = 0; }
        else if (r == 0) { fail++; }
        else if (r == LIBUSB_ERROR_TIMEOUT) {
            libusb_clear_halt(dev->handle, direction ? dev->ep_in : dev->ep_out);
            fail++;
        } else {
            amba_error("libusb_control_transfer: %s", libusb_strerror(r));
            return -1;
        }
    }
    return trans == len ? 0 : -1;
}

int amba_usb_ctrl_write_u32(const amba_usb_dev_t *dev,
                            uint32_t command, uint32_t addr, uint32_t value,
                            const amba_usb_params_t *p)
{
    amba_boot_cmd_t c = { command, addr, value };
    return ctrl_send(dev, /*OUT*/ 0x00, 0, 0,
                     (uint8_t *)&c, sizeof(c), p);
}

int amba_usb_ctrl_read_u32(const amba_usb_dev_t *dev,
                           uint32_t addr, uint32_t *out,
                           const amba_usb_params_t *p)
{
    return ctrl_send(dev, /*IN*/ 0x80,
                     (uint16_t)((addr >> 16) & 0xFFFF),
                     (uint16_t)(addr & 0xFFFF),
                     (uint8_t *)out, sizeof(*out), p);
}
