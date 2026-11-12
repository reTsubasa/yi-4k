/*
 * camera.h — camera-model shorthands for --chip / --config.
 *
 * Each preset binds a camera model to the (chip, board config) pair its
 * hardware needs, so
 *
 *   ambausb-cli -n1 --firmware fw.elf
 *
 * is shorthand for
 *
 *   ambausb-cli --chip CV25 --config RTOS.CV25.LPDDR4.NAND.840MHz \
 *               --firmware fw.elf
 *
 * To add a camera, append one row to g_cameras[] in camera.c. Nothing else
 * in the CLI has to change — the flag, --list-cameras and the help text are
 * all derived from the table:
 *
 *   {  "n1",  "N1",  "CV25",  "RTOS.CV25.LPDDR4.NAND.840MHz"  },
 *       |      |       |        `- config: [BoardInfo] name from a
 *       |      |       |           platform/<chip>/boards/ .board file
 *       |      |       |           ('.', '_' and '-' are interchangeable),
 *       |      |       |           or a plain --config index
 *       |      |       `- chip: [ChipInfo] Name or PrettyName from a
 *       |      |          platform/<chip>/chip.conf (see --list-chips)
 *       |      `- name: shown in messages and --list-cameras
 *       `- flag: accepted as -n1, -N1, --n1 and --N1
 */
#ifndef AMBUSB_CLI_CAMERA_H
#define AMBUSB_CLI_CAMERA_H

#ifdef __cplusplus
extern "C" {
#endif

/* Upper bound on g_cameras[] — main.c sizes its getopt table from this.
 * camera.c static-asserts that the table still fits; bump it if it grows. */
#define AMBA_CAMERA_MAX 32

typedef struct {
    const char *flag;   /* lower-case CLI flag, without the leading dash */
    const char *name;   /* display name, e.g. "N1"                       */
    const char *chip;   /* value handed to --chip                        */
    const char *config; /* value handed to --config                      */
} amba_camera_t;

/* Number of presets in the table. */
int amba_camera_count(void);

/* Preset at `index` (0 .. amba_camera_count()-1). NULL if out of range. */
const amba_camera_t *amba_camera_at(int index);

/* Find a preset by flag or display name (case-insensitive, leading dashes
 * ignored). NULL if not found. */
const amba_camera_t *amba_camera_find(const char *name);

#ifdef __cplusplus
}
#endif
#endif /* AMBUSB_CLI_CAMERA_H */
