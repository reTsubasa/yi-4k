#include "log.h"

#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

static amba_log_level_t g_min_level = AMBA_LOG_LEVEL_INFO;
static int g_color = -1; /* -1 = auto-detect on first use */

void amba_log_set_level(amba_log_level_t level) { g_min_level = level; }
void amba_log_set_color(int enabled)            { g_color = enabled ? 1 : 0; }

static const char *level_color(amba_log_level_t l)
{
    switch (l) {
        case AMBA_LOG_LEVEL_ERROR:  return "\033[1;31m"; /* bold red     */
        case AMBA_LOG_LEVEL_WARN:   return "\033[1;33m"; /* bold yellow  */
        case AMBA_LOG_LEVEL_NOTICE: return "\033[1;35m"; /* bold magenta */
        case AMBA_LOG_LEVEL_INFO:   return "\033[1;32m"; /* bold green   */
        case AMBA_LOG_LEVEL_DEBUG:  return "\033[0;34m"; /* blue         */
    }
    return "";
}

static const char *basename_only(const char *path)
{
    const char *slash = strrchr(path, '/');
    return slash ? slash + 1 : path;
}

void amba_log_emit(amba_log_level_t level,
                   const char *file,
                   uint32_t line,
                   const char *fmt, ...)
{
    if (level > g_min_level) return;
    if (g_color < 0) g_color = isatty(fileno(stderr)) ? 1 : 0;

    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    struct tm tm;
    localtime_r(&ts.tv_sec, &tm);

    char prefix[80];
    snprintf(prefix, sizeof(prefix),
             "%04d-%02d-%02d-%02d:%02d:%02d.%03ld: %s[%4u]: ",
             tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
             tm.tm_hour, tm.tm_min, tm.tm_sec, ts.tv_nsec / 1000000L,
             basename_only(file), line);

    /* All diagnostics go to stderr, including notice/info: stdout is
     * reserved for the --list-* payload so it stays parseable. */
    FILE *out = stderr;

    if (g_color) fputs(level_color(level), out);
    fputs(prefix, out);

    va_list ap;
    va_start(ap, fmt);
    vfprintf(out, fmt, ap);
    va_end(ap);

    if (g_color) fputs("\033[0m", out);
    fputc('\n', out);
    fflush(out);
}

void amba_sleep_ms(uint32_t ms)
{
    struct timespec t = { ms / 1000, (long)(ms % 1000) * 1000000L };
    nanosleep(&t, NULL);
}
