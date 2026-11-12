#include "resource.h"
#include "log.h"

#include <errno.h>
#include <fcntl.h>
#include <ftw.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

/* Symbols from embedded.S — pointer to the start/end of the linked-in tar */
extern const uint8_t ambusb_platform_tar[];
extern const uint8_t ambusb_platform_tar_end[];

/* ustar header layout. Only the fields we actually consult are named.
 * The Makefile passes --format=ustar to keep us inside the 100-char path
 * limit and avoid GNU @LongLink extensions. */
struct ustar_header {
    char name[100];
    char mode[8];
    char uid[8];
    char gid[8];
    char size[12];
    char mtime[12];
    char chksum[8];
    char typeflag;
    char linkname[100];
    char magic[6];     /* "ustar" + NUL */
    char version[2];   /* "00"          */
    char uname[32];
    char gname[32];
    char devmajor[8];
    char devminor[8];
    char prefix[155];
    char pad[12];
};
_Static_assert(sizeof(struct ustar_header) == 512, "ustar header must be 512 bytes");

static size_t parse_octal(const char *s, size_t n)
{
    size_t v = 0;
    for (size_t i = 0; i < n && s[i] >= '0' && s[i] <= '7'; i++) {
        v = v * 8 + (size_t)(s[i] - '0');
    }
    return v;
}

/* Create `path` and any missing parents. */
static int mkdirs(const char *path)
{
    char tmp[1024];
    snprintf(tmp, sizeof(tmp), "%s", path);
    for (char *p = tmp + 1; *p; p++) {
        if (*p == '/') {
            *p = '\0';
            if (mkdir(tmp, 0700) != 0 && errno != EEXIST) return -1;
            *p = '/';
        }
    }
    if (mkdir(tmp, 0700) != 0 && errno != EEXIST) return -1;
    return 0;
}

static int write_file(const char *path, const uint8_t *data, size_t len)
{
    /* Make sure the parent directory exists. */
    char dir[1024];
    snprintf(dir, sizeof(dir), "%s", path);
    char *slash = strrchr(dir, '/');
    if (slash) { *slash = '\0'; if (mkdirs(dir) != 0) return -1; }

    int fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0600);
    if (fd < 0) return -1;
    size_t off = 0;
    while (off < len) {
        ssize_t n = write(fd, data + off, len - off);
        if (n <= 0) { close(fd); return -1; }
        off += (size_t)n;
    }
    close(fd);
    return 0;
}

/* Path-traversal guard. Reject:
 *   - absolute paths (leading '/')
 *   - any component equal to ".." (covers "../", "a/../b", "..\0", etc.)
 * The tar is embedded from the build tree, so this is defense-in-depth
 * rather than untrusted-input filtering, but the test is cheap. */
static int is_unsafe_member(const char *prefix, const char *name)
{
    if (prefix[0] == '/' || name[0] == '/') return 1;
    for (int phase = 0; phase < 2; phase++) {
        const char *s = phase == 0 ? prefix : name;
        if (!s[0]) continue;
        const char *seg = s;
        for (const char *p = s; ; p++) {
            if (*p == '/' || *p == '\0') {
                size_t len = (size_t)(p - seg);
                if (len == 2 && seg[0] == '.' && seg[1] == '.') return 1;
                if (*p == '\0') break;
                seg = p + 1;
            }
        }
    }
    return 0;
}

static int extract_tar(const uint8_t *tar, size_t tar_size, const char *dest)
{
    const uint8_t *p = tar;
    const uint8_t *end = tar + tar_size;
    int files = 0;

    while (p + 512 <= end) {
        const struct ustar_header *h = (const struct ustar_header *)p;

        /* End-of-archive marker: two zero blocks. A single zero header is
         * enough for us to stop scanning. */
        if (h->name[0] == '\0') break;

        /* Sanity-check the magic. Block isn't ustar → skip and try next. */
        if (memcmp(h->magic, "ustar", 5) != 0) {
            p += 512;
            continue;
        }

        /* Copy name/prefix into local NUL-terminated buffers — fields in
         * the header are NOT guaranteed NUL-terminated when they fill the
         * full 100/155 bytes. */
        char nbuf[101], pbuf[156];
        memcpy(nbuf, h->name, 100);   nbuf[100] = '\0';
        memcpy(pbuf, h->prefix, 155); pbuf[155] = '\0';

        if (is_unsafe_member(pbuf, nbuf)) {
            amba_error("Refusing unsafe tar entry: prefix=%s name=%s",
                       pbuf, nbuf);
            return -1;
        }

        size_t size = parse_octal(h->size, sizeof(h->size));
        size_t blocks = (size + 511) / 512;

        /* Compose the destination path. prefix/ comes first when set. */
        char full[1100];
        if (pbuf[0]) {
            snprintf(full, sizeof(full), "%s/%s/%s", dest, pbuf, nbuf);
        } else {
            snprintf(full, sizeof(full), "%s/%s", dest, nbuf);
        }

        if (h->typeflag == '5') {
            /* Directory */
            if (mkdirs(full) != 0) {
                amba_error("mkdir %s: %s", full, strerror(errno));
                return -1;
            }
        } else if (h->typeflag == '0' || h->typeflag == '\0') {
            /* Regular file */
            if (p + 512 + size > end) {
                amba_error("Embedded tar truncated at %s", full);
                return -1;
            }
            if (write_file(full, p + 512, size) != 0) {
                amba_error("write %s: %s", full, strerror(errno));
                return -1;
            }
            files++;
        }
        /* Skip other types (symlinks, devices, ...) — we don't ship them. */

        p += 512 + blocks * 512;
    }

    amba_debug("Extracted %d files from embedded tar", files);
    return 0;
}

/* Best-effort recursive remove using nftw — avoids a fork+exec of /bin/sh
 * and the quoting-injection risk of system("rm -rf '<path>'"). FTW_PHYS
 * means we don't traverse symlinks (the tarball ships none, but the
 * mkdtemp directory could be raced). */
static int remove_cb(const char *p, const struct stat *sb,
                     int typeflag, struct FTW *ftwbuf)
{
    (void)sb; (void)typeflag; (void)ftwbuf;
    if (remove(p) != 0) {
        amba_debug("remove(%s): %s", p, strerror(errno));
    }
    return 0;
}

static int remove_tree(const char *path)
{
    return nftw(path, remove_cb, 32, FTW_DEPTH | FTW_PHYS);
}

static char *g_extracted_dir = NULL;

static void on_exit_cleanup(void)
{
    if (g_extracted_dir) {
        remove_tree(g_extracted_dir);
        free(g_extracted_dir);
        g_extracted_dir = NULL;
    }
}

char *resource_extract_platform(void)
{
    if (g_extracted_dir) return strdup(g_extracted_dir);

    const uint8_t *tar = ambusb_platform_tar;
    size_t tar_size = (size_t)(ambusb_platform_tar_end - ambusb_platform_tar);
    if (tar_size < 512) {
        amba_error("Embedded platform tar is missing or empty (%zu bytes). "
                   "Did the build link build/platform.tar?", tar_size);
        return NULL;
    }

    char tmpl[] = "/tmp/ambausb-cli.XXXXXX";
    if (!mkdtemp(tmpl)) {
        amba_error("mkdtemp: %s", strerror(errno));
        return NULL;
    }

    /* Register cleanup BEFORE extraction so a failure/cancel partway through
     * still triggers it. atexit is only fired on normal exit() — signals
     * that go through main.c's handler return via main() and so are fine. */
    g_extracted_dir = strdup(tmpl);
    atexit(on_exit_cleanup);

    if (extract_tar(tar, tar_size, tmpl) != 0) {
        /* on_exit_cleanup will still run; nothing else to do here. */
        return NULL;
    }

    /* The tar's top-level entry is "platform/", so the directory the rest
     * of the CLI wants is <tmpl>/platform. */
    char *out = malloc(strlen(tmpl) + sizeof("/platform"));
    if (!out) return NULL;
    sprintf(out, "%s/platform", tmpl);
    return out;
}
