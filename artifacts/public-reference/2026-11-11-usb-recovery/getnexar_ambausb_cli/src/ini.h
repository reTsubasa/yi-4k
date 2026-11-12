/*
 * ini.h — minimal INI parser used to read the chip.conf and *.board files
 * shipped under platform/<chip>/. Same format QSettings(IniFormat) writes:
 *
 *   [Section]
 *   Key = Value
 *   ; comment
 *
 * Values are trimmed of surrounding whitespace. Keys are matched
 * case-sensitively (matching how the Qt loader reads them).
 */
#ifndef AMBUSB_CLI_INI_H
#define AMBUSB_CLI_INI_H

#ifdef __cplusplus
extern "C" {
#endif

/* Callback fired once per key=value pair. Section may be "" before the first
 * [Section] header. Returning non-zero stops parsing. */
typedef int (*ini_cb_t)(const char *section,
                       const char *key,
                       const char *value,
                       void *user);

/* Parse the file at path, returning 0 on success or a negative errno on
 * I/O error. Malformed lines are skipped (not fatal). */
int ini_parse_file(const char *path, ini_cb_t cb, void *user);

/* Convenience: collect "Section/Key" → value into a struct via callback.
 * Returns the value (newly malloc'd, caller frees) or NULL if not found. */
char *ini_get(const char *path, const char *section, const char *key);

#ifdef __cplusplus
}
#endif
#endif
