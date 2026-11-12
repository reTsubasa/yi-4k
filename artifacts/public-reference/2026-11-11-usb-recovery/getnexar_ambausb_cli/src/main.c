/*
 * ambausb-cli — single-shot Ambarella USB firmware flasher.
 *
 * Replaces the Qt5 GUI in ambausb-5.0.7. One-device, one-firmware, one-shot:
 *
 *   ambausb-cli --chip <name> --config <index> \
 *               --firmware <elf> [--verify] [--wait-timeout 90]
 *
 *   ambausb-cli --chip CV25 --list-configs
 *
 * Camera presets (see camera.h) fill in --chip/--config for a known model:
 *
 *   ambausb-cli -n1 --firmware <elf>
 *
 * Exit codes:
 *   0   success
 *   1   programming failed (USB error, bad ELF, timeout, ...)
 *   2   device in wrong mode (FORCEUSB / unknown) — get it into amboot first
 *       (B4: power-cycle; B0/B2/N1: trigger amboot over the debug cable)
 *   3   device found but not openable (permission denied — see udev hint)
 *   64  invalid arguments
 *   130 cancelled by SIGINT/SIGTERM
 */
#include "camera.h"
#include "log.h"
#include "platform.h"
#include "resource.h"
#include "session.h"
#include "usb.h"

#include <errno.h>
#include <getopt.h>
#include <limits.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/stat.h>
#include <unistd.h>

static volatile sig_atomic_t g_cancel = 0;

static void on_signal(int sig)
{
    /* async-signal-safe: just flip the flag; main loops poll it. */
    (void)sig;
    g_cancel = 1;
}

static void install_handlers(void)
{
    struct sigaction sa = {0};
    sa.sa_handler = on_signal;
    sigemptyset(&sa.sa_mask);
    sigaction(SIGINT,  &sa, NULL);
    sigaction(SIGTERM, &sa, NULL);
    sigaction(SIGHUP,  &sa, NULL);
}

/* Shared by --list-cameras and print_help. */
static void print_camera_list(FILE *out)
{
    int n = amba_camera_count();
    if (n == 0) {
        fprintf(out, "  (none)\n");
        return;
    }
    int flag_w = 0, chip_w = 0;
    for (int i = 0; i < n; i++) {
        const amba_camera_t *cam = amba_camera_at(i);
        int fl = (int)strlen(cam->flag);
        int cl = (int)strlen(cam->chip);
        if (fl > flag_w) flag_w = fl;
        if (cl > chip_w) chip_w = cl;
    }
    for (int i = 0; i < n; i++) {
        const amba_camera_t *cam = amba_camera_at(i);
        fprintf(out, "  -%-*s  chip=%-*s  config=%s\n",
                flag_w, cam->flag, chip_w, cam->chip, cam->config);
    }
}

/* Parse a "seconds" option. The value is later multiplied by 1000 to get
 * milliseconds, so it has to stay below INT_MAX/1000 or the multiplication
 * overflows into a negative number — which every wait loop reads as "wait
 * forever", turning a too-large timeout into a hang. Qt validates the
 * equivalent settings with QVariant::toUInt(&ok) and falls back to the
 * default (amba_usb_setting.cpp:731-751); we fail loudly instead.
 * `allow_forever` permits the documented -1 for --find-timeout. */
#define AMBA_MAX_TIMEOUT_S (INT_MAX / 1000)
static int parse_timeout_s(const char *arg, const char *flag,
                           int allow_forever, int *out)
{
    char *endp = NULL;
    errno = 0;
    long v = strtol(arg, &endp, 10);
    if (endp == arg || !endp || *endp != '\0' || errno == ERANGE) {
        amba_error("%s expects a whole number of seconds, got \"%s\"",
                   flag, arg);
        return -1;
    }
    if (allow_forever && v == -1) { *out = -1; return 0; }
    if (v < 0) {
        amba_error("%s cannot be negative (got %ld)%s", flag, v,
                   allow_forever ? "; pass -1 to wait forever" : "");
        return -1;
    }
    if (v > AMBA_MAX_TIMEOUT_S) {
        amba_error("%s is capped at %d seconds (got %ld)", flag,
                   AMBA_MAX_TIMEOUT_S, v);
        return -1;
    }
    *out = (int)v;
    return 0;
}

/* `out` is stdout when help was explicitly asked for and stderr when it is
 * printed alongside a usage error. */
static void print_help(FILE *out, const char *prog)
{
    fprintf(out,
"Usage: %s [options]\n"
"\n"
"  --chip <name>         Chip name (e.g. CV25). Required for flash.\n"
"  --list-chips          Print known chips and exit.\n"
"  --list-configs        Print board configs for --chip and exit. Each board\n"
"                        is shown with the index --config wants.\n"
"  --config <spec>       Board config to use: either the index or the name\n"
"                        shown by --list-configs.\n"
"  --list-cameras        Print the camera presets listed below and exit.\n"
"  --firmware <path>     Firmware ELF (or flat binary). Required for flash.\n"
"  --dram-mb <mib>       Override the DRAM size (MiB). By default the CLI\n"
"                        probes the running bootloader (amboot / UST) the\n"
"                        same way the GUI does; only pass this when the\n"
"                        device answers with junk or you need to force a\n"
"                        specific value. Controls placement of boardinfo/\n"
"                        firminfo at top-of-DRAM.\n"
"  --verify              Ask the firmware programmer to validate what it\n"
"                        wrote (boardinfo init_mode TeSt instead of StOp).\n"
"  --wait-timeout <sec>  How long to wait for the device to disconnect\n"
"                        after JUMP (default 90).\n"
"  --find-timeout <sec>  How long to wait for the USB device to appear\n"
"                        before flashing (default 0 = device must be present).\n"
"                        Pass -1 to wait forever.\n"
"  --no-color            Disable ANSI colour in the log.\n"
"  -v, --verbose         Raise log level (repeatable: notice/info/debug).\n"
"  -q, --quiet           Lower log level (errors only).\n"
"  -h, --help            This help.\n"
"\n"
"Examples:\n"
"  %s --chip CV25 --list-configs\n"
"  %s --chip CV25 --config 0 --firmware ./fw.elf --verify\n"
"  %s --chip CV25 --config 0 --firmware ./fw.elf --dram-mb 512\n"
"  %s -n1 --firmware ./fw.elf --verify\n"
"\n"
"Camera presets — each one sets --chip and --config for you. An explicit\n"
"--chip/--config still overwrite it:\n",
            prog, prog, prog, prog, prog);
    print_camera_list(out);
}

static void print_chip_list(const amba_chip_list_t *chips)
{
    printf("Known chips:\n");
    for (int i = 0; i < chips->chip_count; i++) {
        const amba_chip_t *c = &chips->chips[i];
        printf("  %-12s  (id=0x%x, VID:PID=%04x:%04x, dram=0x%lx)\n",
               c->pretty_name[0] ? c->pretty_name : c->name,
               c->id, c->vid, c->pid,
               (unsigned long)c->dram_start_addr.address);
    }
}

static void print_board_list(const amba_chip_t *chip,
                             const amba_board_list_t *boards)
{
    printf("Board configs for %s:\n",
           chip->pretty_name[0] ? chip->pretty_name : chip->name);
    if (boards->board_count == 0) {
        printf("  (none — no .board files embedded for %s)\n", chip->name);
        return;
    }
    int idx_w = 3;
    int name_w = 0;
    for (int i = 0; i < boards->board_count; i++) {
        int l = (int)strlen(boards->boards[i].name);
        if (l > name_w) name_w = l;
    }
    for (int i = 0; i < boards->board_count; i++) {
        const amba_board_t *b = &boards->boards[i];
        const char *kind = b->ust[0] ? "UST" : "ADS";
        printf("  [%*d] %-*s  media=%-7s  %s\n",
               idx_w, i, name_w, b->name, b->media, kind);
    }
}

int main(int argc, char **argv)
{
    enum {
        OPT_CHIP = 1000,
        OPT_LIST_CHIPS,
        OPT_LIST_CONFIGS,
        OPT_LIST_CAMERAS,
        OPT_CONFIG,
        OPT_FIRMWARE,
        OPT_VERIFY,
        OPT_WAIT_TIMEOUT,
        OPT_FIND_TIMEOUT,
        OPT_NO_COLOR,
        OPT_DRAM_MB,
        /* Camera presets get one code each: OPT_CAMERA_FIRST + table index. */
        OPT_CAMERA_FIRST = 2000,
    };
    static const struct option base_opts[] = {
        { "chip",          required_argument, 0, OPT_CHIP         },
        { "list-chips",    no_argument,       0, OPT_LIST_CHIPS   },
        { "list-configs",  no_argument,       0, OPT_LIST_CONFIGS },
        { "list-cameras",  no_argument,       0, OPT_LIST_CAMERAS },
        { "config",        required_argument, 0, OPT_CONFIG       },
        { "firmware",      required_argument, 0, OPT_FIRMWARE     },
        { "dram-mb",       required_argument, 0, OPT_DRAM_MB      },
        { "verify",        no_argument,       0, OPT_VERIFY       },
        { "wait-timeout",  required_argument, 0, OPT_WAIT_TIMEOUT },
        { "find-timeout",  required_argument, 0, OPT_FIND_TIMEOUT },
        { "no-color",      no_argument,       0, OPT_NO_COLOR     },
        { "verbose",       no_argument,       0, 'v'              },
        { "quiet",         no_argument,       0, 'q'              },
        { "help",          no_argument,       0, 'h'              },
    };

    /* Camera presets are registered as long options so that getopt handles
     * "--" and option arguments for us; getopt_long_only below then accepts
     * the single-dash spelling the presets are documented with (-n1). Both
     * the flag and the display name are registered so -n1 and -N1 work
     * (long-option matching is case-sensitive). */
    struct option opts[sizeof(base_opts) / sizeof(base_opts[0])
                       + 2 * AMBA_CAMERA_MAX + 1];
    size_t n_opts = sizeof(base_opts) / sizeof(base_opts[0]);
    memcpy(opts, base_opts, sizeof(base_opts));
    for (int i = 0; i < amba_camera_count(); i++) {
        const amba_camera_t *cam = amba_camera_at(i);
        struct option o = { cam->flag, no_argument, 0, OPT_CAMERA_FIRST + i };
        opts[n_opts++] = o;
        if (strcmp(cam->flag, cam->name) != 0) {
            o.name = cam->name;
            opts[n_opts++] = o;
        }
    }
    memset(&opts[n_opts], 0, sizeof(opts[n_opts]));

    const char *chip_name    = NULL;
    const char *firmware     = NULL;
    const char *config_spec  = NULL;
    const amba_camera_t *camera = NULL;
    int list_chips = 0, list_configs = 0, list_cameras = 0;
    int verify = 0;
    int wait_timeout_s = 90;
    int find_timeout_s = 0;
    uint32_t dram_mb = 0;
    int verbosity = AMBA_LOG_LEVEL_INFO;

    int c;
    while ((c = getopt_long_only(argc, argv, "vqh", opts, NULL)) != -1) {
        switch (c) {
            case OPT_CHIP:         chip_name = optarg;    break;
            case OPT_LIST_CHIPS:   list_chips = 1;        break;
            case OPT_LIST_CONFIGS: list_configs = 1;      break;
            case OPT_LIST_CAMERAS: list_cameras = 1;      break;
            case OPT_CONFIG:       config_spec = optarg;  break;
            case OPT_FIRMWARE:     firmware = optarg;     break;
            case OPT_VERIFY:       verify = 1;            break;
            case OPT_WAIT_TIMEOUT:
                if (parse_timeout_s(optarg, "--wait-timeout",
                                    /*allow_forever=*/0,
                                    &wait_timeout_s) != 0) return 64;
                break;
            case OPT_FIND_TIMEOUT:
                if (parse_timeout_s(optarg, "--find-timeout",
                                    /*allow_forever=*/1,
                                    &find_timeout_s) != 0) return 64;
                break;
            case OPT_DRAM_MB: {
                char *endp = NULL;
                long v = strtol(optarg, &endp, 10);
                if (!endp || *endp != '\0' || v <= 0 || v > 0x10000) {
                    amba_error("--dram-mb expects a positive integer "
                               "(MiB), got \"%s\"", optarg);
                    return 64;
                }
                dram_mb = (uint32_t)v;
            } break;
            case OPT_NO_COLOR:     amba_log_set_color(0); break;
            case 'v': if (verbosity < AMBA_LOG_LEVEL_DEBUG) verbosity++; break;
            case 'q': verbosity = AMBA_LOG_LEVEL_ERROR; break;
            case 'h': print_help(stdout, argv[0]); return 0;
            default:
                if (c >= OPT_CAMERA_FIRST &&
                    c < OPT_CAMERA_FIRST + amba_camera_count()) {
                    camera = amba_camera_at(c - OPT_CAMERA_FIRST);
                    break;
                }
                print_help(stderr, argv[0]);
                return 64;
        }
    }
    amba_log_set_level((amba_log_level_t)verbosity);

    if (list_cameras) {
        printf("Camera presets:\n");
        print_camera_list(stdout);
        return 0;
    }

    /* Apply the preset, but never silently ignore an explicit flag. */
    if (camera) {
        int chip_overridden = 0;
        if (chip_name && strcasecmp(chip_name, camera->chip) != 0) {
            amba_warn("--chip %s overrides the -%s preset chip %s",
                      chip_name, camera->flag, camera->chip);
            chip_overridden = 1;
        }
        if (config_spec && strcasecmp(config_spec, camera->config) != 0) {
            amba_warn("--config %s overrides the -%s preset config %s",
                      config_spec, camera->flag, camera->config);
        }
        if (!chip_name)   chip_name   = camera->chip;
        /* The preset's config belongs to the preset's chip, so keeping it
         * after --chip switched chips guarantees a "not a valid config for
         * <chip>" failure. Drop it and let --config (or the error listing the
         * valid ones) take over. */
        if (chip_overridden && !config_spec) {
            amba_warn("dropping the -%s preset config %s: it belongs to %s, "
                      "not %s. Pass --config, or run --chip %s --list-configs.",
                      camera->flag, camera->config, camera->chip,
                      chip_name, chip_name);
        } else if (!config_spec) {
            config_spec = camera->config;
        }
        if (config_spec) {
            amba_notice("autoset: chip %s, config %s for %s",
                        chip_name, config_spec, camera->name);
        } else {
            amba_notice("autoset: chip %s for %s", chip_name, camera->name);
        }
    }

    install_handlers();

    char *platform_dir = resource_extract_platform();
    if (!platform_dir) return 1;
    amba_chip_list_t chips;
    if (amba_chip_list_load(platform_dir, &chips) != 0) { free(platform_dir); return 64; }
    free(platform_dir);

    if (list_chips) {
        print_chip_list(&chips);
        amba_chip_list_free(&chips);
        return 0;
    }

    if (!chip_name) {
        amba_error("--chip is required (use --list-chips to see options, or "
                   "a camera preset like -n1 — see --list-cameras)");
        amba_chip_list_free(&chips);
        return 64;
    }
    const amba_chip_t *chip = amba_chip_find(&chips, chip_name);
    if (!chip) {
        amba_error("Unknown chip \"%s\"", chip_name);
        amba_chip_list_free(&chips);
        return 64;
    }

    amba_board_list_t boards;
    amba_board_list_load(chip, &boards);

    if (list_configs) {
        print_board_list(chip, &boards);
        amba_board_list_free(&boards);
        amba_chip_list_free(&chips);
        return 0;
    }

    if (!firmware) {
        amba_error("--firmware is required");
        amba_board_list_free(&boards);
        amba_chip_list_free(&chips);
        return 64;
    }
    /* Check the path here, not at the first fopen deep inside the session:
     * that happens after the USB open and the mode check, so a typo used to
     * be reported as "No Ambarella device found". */
    struct stat fw_st;
    if (stat(firmware, &fw_st) != 0) {
        amba_error("--firmware \"%s\": %s", firmware, strerror(errno));
        amba_board_list_free(&boards);
        amba_chip_list_free(&chips);
        return 64;
    }
    if (!S_ISREG(fw_st.st_mode)) {
        amba_error("--firmware \"%s\" is not a regular file", firmware);
        amba_board_list_free(&boards);
        amba_chip_list_free(&chips);
        return 64;
    }
    if (access(firmware, R_OK) != 0) {
        amba_error("--firmware \"%s\": %s", firmware, strerror(errno));
        amba_board_list_free(&boards);
        amba_chip_list_free(&chips);
        return 64;
    }
    if (!config_spec) {
        amba_error("--config is required. Run with --list-configs to see the "
                   "options.");
        amba_board_list_free(&boards);
        amba_chip_list_free(&chips);
        return 64;
    }
    int config_index = amba_board_find(&boards, config_spec);
    if (config_index < 0) {
        amba_error("--config \"%s\" is not a board name or a valid index "
                   "(0..%d) for %s. Run with --list-configs to see the "
                   "options.",
                   config_spec, boards.board_count - 1,
                   chip->pretty_name[0] ? chip->pretty_name : chip->name);
        amba_board_list_free(&boards);
        amba_chip_list_free(&chips);
        return 64;
    }
    const amba_board_t *board = &boards.boards[config_index];
    amba_info("Selected chip:  %s", chip->pretty_name[0] ? chip->pretty_name : chip->name);
    amba_info("Selected board: %s (media=%s)", board->name, board->media);
    amba_info("BLD: %s", board->bld);

    amba_usb_ctx_t *ctx = NULL;
    if (amba_usb_init(&ctx) != 0) {
        amba_board_list_free(&boards);
        amba_chip_list_free(&chips);
        return 1;
    }

    amba_usb_params_t p;
    amba_usb_params_default(&p);

    amba_usb_dev_t dev;
    int ftm = find_timeout_s < 0 ? -1 : find_timeout_s * 1000;
    /* Match the GUI: filter by VID only. Chips running amboot/UST often
     * present a placeholder PID (e.g. 0x0001) instead of the one recorded
     * in chip.conf; identity is verified below via INQUIRY_CHIP. */
    amba_info("Looking for USB device with VID %04x ...", chip->vid);
    int rc = amba_usb_find_and_open(ctx, chip->vid, /*pid=*/0,
                                    ftm, &g_cancel, &dev);
    if (rc == -2) {
        amba_warn("Cancelled while waiting for device");
        amba_usb_exit(ctx);
        amba_board_list_free(&boards);
        amba_chip_list_free(&chips);
        return 130;
    }
    if (rc == -4) {
        amba_error("Found an Ambarella device with VID %04x but could not "
                   "open it: permission denied.", chip->vid);
        amba_error("Run as root, or install a udev rule, e.g.:");
        amba_error("  echo 'SUBSYSTEM==\"usb\", ATTR{idVendor}==\"%04x\", "
                   "MODE=\"0660\", TAG+=\"uaccess\"' \\", chip->vid);
        amba_error("    | sudo tee /etc/udev/rules.d/70-ambausb.rules");
        amba_error("  sudo udevadm control --reload && sudo udevadm trigger");
        amba_usb_exit(ctx);
        amba_board_list_free(&boards);
        amba_chip_list_free(&chips);
        return 3;
    }
    if (rc != 0) {
        amba_error("No Ambarella device with VID %04x found", chip->vid);
        amba_usb_exit(ctx);
        amba_board_list_free(&boards);
        amba_chip_list_free(&chips);
        return 1;
    }
    amba_info("Opened %s (VID:PID %04x:%04x)", dev.node, dev.vid, dev.pid);
    if (dev.pid != chip->pid) {
        amba_info("Note: presented PID %04x differs from chip-table PID "
                  "%04x; verifying chip identity via INQUIRY_CHIP.",
                  dev.pid, chip->pid);
    }

    /* Ask the running bootloader for its chip revision id. AMBOOT and UST
     * both answer; FORCEUSB does not (and the session refuses that mode
     * anyway). If inquiry fails we surface it as a mismatch rather than a
     * hard USB error because the more useful diagnostic is "wrong --chip". */
    if (dev.mode == AMBA_USB_MODE_AMBOOT || dev.mode == AMBA_USB_MODE_UST) {
        uint32_t reported_chip = 0;
        if (amba_proto_inquiry_chip(&dev, &reported_chip, &p) != 0) {
            amba_error("INQUIRY_CHIP failed: cannot confirm this device "
                       "is a %s. Check the USB cable and try again.",
                       chip->pretty_name[0] ? chip->pretty_name : chip->name);
            amba_usb_close(&dev);
            amba_usb_exit(ctx);
            amba_board_list_free(&boards);
            amba_chip_list_free(&chips);
            return 1;
        }
        if (reported_chip != chip->id) {
            amba_error("Chip mismatch: device reports id %u (0x%x) but "
                       "--chip %s expects %u (0x%x). Pass the correct "
                       "--chip, or run --list-chips to see options.",
                       reported_chip, reported_chip,
                       chip->pretty_name[0] ? chip->pretty_name : chip->name,
                       chip->id, chip->id);
            amba_usb_close(&dev);
            amba_usb_exit(ctx);
            amba_board_list_free(&boards);
            amba_chip_list_free(&chips);
            return 1;
        }
        amba_info("Device chip id 0x%x matches %s", reported_chip,
                  chip->pretty_name[0] ? chip->pretty_name : chip->name);
    }

    amba_session_cfg_t cfg = {
        .chip            = chip,
        .board           = board,
        .firmware_path   = firmware,
        .verify          = verify,
        .wait_timeout_ms = wait_timeout_s * 1000,
        .dram_size_mb    = dram_mb,
        .params          = &p,
        .cancel_flag     = &g_cancel,
    };
    int exit_code = amba_session_run(&dev, &cfg);

    amba_usb_close(&dev);
    amba_usb_exit(ctx);
    amba_board_list_free(&boards);
    amba_chip_list_free(&chips);
    return exit_code;
}
