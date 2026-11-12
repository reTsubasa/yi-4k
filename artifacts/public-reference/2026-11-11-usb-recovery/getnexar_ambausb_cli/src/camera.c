#include "camera.h"

#include <stddef.h>
#include <strings.h>

/* ------------------------------------------------------------------------
 * Camera presets — add new cameras here, one row each.
 *
 *      flag    name    chip      config
 * ------------------------------------------------------------------------ */
static const amba_camera_t g_cameras[] = {
    {  "b0",   "B0",   "S6Lm",   "S6Lm.DDR4.EMMC.792MHz"         },
    {  "n1",   "N1",   "CV25",   "RTOS.CV25.LPDDR4.NAND.840MHz"  },
    {  "b2",   "B2",   "CV25",   "RTOS.CV25.LPDDR4.NAND.840MHz"  },
    {  "b4",   "B4",   "CV22",   "LINUX.CV22.LPDDR4.NAND"        },
};

#define CAMERA_COUNT ((int)(sizeof(g_cameras) / sizeof(g_cameras[0])))

_Static_assert(CAMERA_COUNT <= AMBA_CAMERA_MAX,
               "too many camera presets: bump AMBA_CAMERA_MAX in camera.h");

int amba_camera_count(void)
{
    return CAMERA_COUNT;
}

const amba_camera_t *amba_camera_at(int index)
{
    if (index < 0 || index >= CAMERA_COUNT) return NULL;
    return &g_cameras[index];
}

const amba_camera_t *amba_camera_find(const char *name)
{
    if (!name) return NULL;
    while (*name == '-') name++;
    if (!*name) return NULL;

    for (int i = 0; i < CAMERA_COUNT; i++) {
        if (strcasecmp(g_cameras[i].flag, name) == 0 ||
            strcasecmp(g_cameras[i].name, name) == 0) {
            return &g_cameras[i];
        }
    }
    return NULL;
}
