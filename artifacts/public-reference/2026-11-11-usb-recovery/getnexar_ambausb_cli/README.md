# AMBAUSB CLI addition

Inspired by the work done for Helix via Autobox, I've created a more complete CLI tool.

# Build

```sh
./bootstrap.sh          # installs deps (gcc, make, tar, pkg-config, libusb-1.0) then builds
```

or, if you already have the dependencies:

```sh
make                    # -> out/ambausb-cli
```

# How to use

With a camera flag — chip and config are set for you:

```sh
# see which cameras are known
ambausb-cli --list-cameras

# flash a B4 (CV22 / LINUX.CV22.LPDDR4.NAND)
ambausb-cli -b4 --firmware ./ambarella/out/cv22_nexarbeam/images/bst_bld_pba_kernel_lnx_release.elf


# same, with post-write verify, and wait up to 60s for the device to show up
ambausb-cli -b4 --firmware /ambarella/out/cv22_nexarbeam/images/bst_bld_pba_kernel_lnx_release.elf  --verify --find-timeout 60
```

`-b4` prints what it picked, so you always see the effective selection:

```
autoset: chip CV22, config LINUX.CV22.LPDDR4.NAND for B4
```

Without a camera flag — pick the chip and config by hand:

```sh
# what chips are embedded?
ambausb-cli --list-chips

# what board configs does that chip have?
ambausb-cli --chip CV22 --list-configs
#   [  0] LINUX.CV22.LPDDR4.EMMC   media=emmc     ADS
#   [  1] LINUX.CV22.LPDDR4.NAND   media=nand     ADS
#   [  2] LINUX.CV22.LPDDR4.STACK  media=spinor   ADS

# flash it, by index or by name
ambausb-cli --chip CV22 --config 1 --firmware ./fw.elf
ambausb-cli --chip CV22 --config LINUX.CV22.LPDDR4.NAND --firmware ./fw.elf
```

An explicit `--chip`/`--config` beats the camera flag, so you can borrow a preset and
override one half of it:

```sh
ambausb-cli -b4 --config 0 --firmware ./fw.elf   # B4's chip, EMMC config instead
```

Overriding the chip half drops the preset's config too, since that config belongs to the
preset's chip — so pass a `--config` as well:

```sh
ambausb-cli -b4 --chip CV25 --config 0 --firmware ./fw.elf
```

Useful extras: `-v` (repeat for more log), `-q`, `--no-color`, `--dram-mb <mib>` to force
the DRAM size when the device reports junk. `--help` lists everything.

Exit codes: `0` ok, `1` flash failed, `2` device in the wrong mode, `3` device found but
not openable (permission denied), `64` bad arguments, `130` cancelled.

Exit `2` means the device isn't in amboot/UST mode. B4 can be power-cycled into amboot;
B0/B2/N1 need amboot triggered over the debug cable.

If — and only if — you hit exit `3` with `permission denied`, your user lacks access to the
raw USB device. Nothing to do otherwise. Either run it with `sudo`, or grant your user
access once with a udev rule (the tool prints this same snippet when it happens):

```sh
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="4255", MODE="0660", TAG+="uaccess"' \
  | sudo tee /etc/udev/rules.d/70-ambausb.rules
sudo udevadm control --reload && sudo udevadm trigger
```

# Features

- C code that compiles on Linux/macOS (given the dependencies are found)
- No Qt5 logic to be found — building this needs no Qt5 libs, unlike the Autobox solution
- Standalone binary — all needed platform resources are embedded in the CLI itself, making
  it portable
- Flags for devices — instead of manually setting the chip id and config id, just use
  `-b2` or `-b4` to get the correct config (configurable via `src/camera.c`)

# Tested

- Tested on B0/B2/B4

Note: Aoni cameras B0/B2/N1 are able to flash, but they can only flash partition A. To
affect partition B you'll need to copy the nexar.bin and restart.

# Full arguments
```
Usage: ambausb-cli [options]

  --chip <name>         Chip name (e.g. CV25). Required for flash.
  --list-chips          Print known chips and exit.
  --list-configs        Print board configs for --chip and exit. Each board
                        is shown with the index --config wants.
  --config <spec>       Board config to use: either the index or the name
                        shown by --list-configs.
  --list-cameras        Print the camera presets listed below and exit.
  --firmware <path>     Firmware ELF (or flat binary). Required for flash.
  --dram-mb <mib>       Override the DRAM size (MiB). By default the CLI
                        probes the running bootloader (amboot / UST) the
                        same way the GUI does; only pass this when the
                        device answers with junk or you need to force a
                        specific value. Controls placement of boardinfo/
                        firminfo at top-of-DRAM.
  --verify              Ask the firmware programmer to validate what it
                        wrote (boardinfo init_mode TeSt instead of StOp).
  --wait-timeout <sec>  How long to wait for the device to disconnect
                        after JUMP (default 90).
  --find-timeout <sec>  How long to wait for the USB device to appear
                        before flashing (default 0 = device must be present).
                        Pass -1 to wait forever.
  --no-color            Disable ANSI colour in the log.
  -v, --verbose         Raise log level (repeatable: notice/info/debug).
  -q, --quiet           Lower log level (errors only).
  -h, --help            This help.

Examples:
  ambausb-cli --chip CV25 --list-configs
  ambausb-cli --chip CV25 --config 0 --firmware ./fw.elf --verify
  ambausb-cli --chip CV25 --config 0 --firmware ./fw.elf --dram-mb 512
  ambausb-cli -n1 --firmware ./fw.elf --verify

Camera presets — each one sets --chip and --config for you. An explicit
--chip/--config still overwrite it:
  -b0  chip=S6Lm  config=S6Lm.DDR4.EMMC.792MHz
  -n1  chip=CV25  config=RTOS.CV25.LPDDR4.NAND.840MHz
  -b2  chip=CV25  config=RTOS.CV25.LPDDR4.NAND.840MHz
  -b4  chip=CV22  config=LINUX.CV22.LPDDR4.NAND
  ```

# Ready to use examples

### B4
```sh
ambausb-cli -b4 --firmware ./ambarella/out/cv22_nexarbeam/images/bst_bld_pba_kernel_lnx_release.elf
```

### B2
```sh
ambausb-cli -b2 --firmware ./rtos/cortex_a/output.64/out/fwprog/bst_bld_pba_atf_sys_sec_rom_lnx_rfs.elf
```

### B0
```sh
ambausb-cli -b0 --firmware ./rtos_82001/cortex_a/output.64/out/fwprog/bst_bld_pba_atf_sys_sec_rom_lnx_rfs.elf
```

### N1
```sh
ambausb-cli -n1 --firmware ./rtos/cortex_a/output.64/out/fwprog/bst_bld_pba_atf_sys_sec_rom_lnx_rfs.elf
```

# Credits

- ambausb source code
- work on Autobox for the idea
- LLMs for the intelligent copy/transform/paste work
