/*
 * log.h
 *
 * Drop-in replacement for amba_usb_log macros. Output format matches
 * the GUI's QTextEdit log:
 *
 *   YYYY-MM-DD-HH:mm:ss.zzz: <file>[<line>]: <message>
 *
 * Levels: ERROR (red), WARN (yellow), NOTICE (magenta), INFO (green),
 * DEBUG (blue). Colors are emitted via ANSI escapes when stdout is a TTY.
 */
#ifndef AMBUSB_CLI_LOG_H
#define AMBUSB_CLI_LOG_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    AMBA_LOG_LEVEL_ERROR  = 0,
    AMBA_LOG_LEVEL_WARN   = 1,
    AMBA_LOG_LEVEL_NOTICE = 2,
    AMBA_LOG_LEVEL_INFO   = 3,
    AMBA_LOG_LEVEL_DEBUG  = 4,
} amba_log_level_t;

/* Set the minimum level that should be printed. Default is INFO. */
void amba_log_set_level(amba_log_level_t level);

/* Disable colour output explicitly (auto-detected from isatty otherwise). */
void amba_log_set_color(int enabled);

/* Worker called by the macros below. */
void amba_log_emit(amba_log_level_t level,
                   const char *file,
                   uint32_t line,
                   const char *fmt, ...)
    __attribute__((format(printf, 4, 5)));

void amba_sleep_ms(uint32_t ms);

#define amba_error(...)  amba_log_emit(AMBA_LOG_LEVEL_ERROR,  __FILE__, __LINE__, __VA_ARGS__)
#define amba_warn(...)   amba_log_emit(AMBA_LOG_LEVEL_WARN,   __FILE__, __LINE__, __VA_ARGS__)
#define amba_notice(...) amba_log_emit(AMBA_LOG_LEVEL_NOTICE, __FILE__, __LINE__, __VA_ARGS__)
#define amba_info(...)   amba_log_emit(AMBA_LOG_LEVEL_INFO,   __FILE__, __LINE__, __VA_ARGS__)
#define amba_debug(...)  amba_log_emit(AMBA_LOG_LEVEL_DEBUG,  __FILE__, __LINE__, __VA_ARGS__)
#define amba_timeout(...) amba_log_emit(AMBA_LOG_LEVEL_ERROR, __FILE__, __LINE__, __VA_ARGS__)

#ifdef __cplusplus
}
#endif
#endif /* AMBUSB_CLI_LOG_H */
