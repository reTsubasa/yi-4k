#include "ini.h"

#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char *trim(char *s)
{
    while (*s && isspace((unsigned char)*s)) s++;
    if (!*s) return s;
    char *end = s + strlen(s) - 1;
    while (end > s && isspace((unsigned char)*end)) *end-- = '\0';
    return s;
}

int ini_parse_file(const char *path, ini_cb_t cb, void *user)
{
    FILE *f = fopen(path, "r");
    if (!f) return -errno;

    char line[1024];
    char section[128] = "";
    int rc = 0;

    while (fgets(line, sizeof(line), f)) {
        char *p = trim(line);
        if (*p == '\0' || *p == ';' || *p == '#') continue;

        if (*p == '[') {
            char *end = strchr(p, ']');
            if (!end) continue;
            *end = '\0';
            char *name = trim(p + 1);
            snprintf(section, sizeof(section), "%s", name);
            continue;
        }

        char *eq = strchr(p, '=');
        if (!eq) continue;
        *eq = '\0';
        char *key = trim(p);
        char *value = trim(eq + 1);
        if (cb(section, key, value, user)) { rc = 1; break; }
    }

    fclose(f);
    return rc;
}

struct lookup_ctx {
    const char *section;
    const char *key;
    char *out;
};

static int lookup_cb(const char *section, const char *key,
                     const char *value, void *user)
{
    struct lookup_ctx *c = (struct lookup_ctx *)user;
    if (strcmp(section, c->section) == 0 && strcmp(key, c->key) == 0) {
        c->out = strdup(value);
        return 1;
    }
    return 0;
}

char *ini_get(const char *path, const char *section, const char *key)
{
    struct lookup_ctx ctx = { section, key, NULL };
    ini_parse_file(path, lookup_cb, &ctx);
    return ctx.out;
}
