/*
 * resource.h — runtime access to the embedded platform/ tarball.
 *
 * The platform tree is shipped baked into the binary (see embedded.S +
 * Makefile build/platform.tar rule). At startup we extract it into a
 * private temp directory; the path is returned for the rest of the CLI to
 * use as if --platform had been passed. Cleanup happens via atexit().
 */
#ifndef AMBUSB_CLI_RESOURCE_H
#define AMBUSB_CLI_RESOURCE_H

#ifdef __cplusplus
extern "C" {
#endif

/* Extract the embedded platform tree to a fresh /tmp/ambausb-cli.XXXXXX
 * directory. Returns a malloc'd path string, or NULL on error. The
 * directory will be removed via atexit() at process exit. */
char *resource_extract_platform(void);

#ifdef __cplusplus
}
#endif
#endif
