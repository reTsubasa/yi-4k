/*
 * elf.h — minimal ARM/AArch64 ELF -> flat binary extractor.
 *
 * The Ambarella firmware ELF is loaded into DRAM as a single contiguous
 * blob — same pages would be present if the chip just ran `objcopy -O binary`.
 * Mirrors the validation logic in ambausb-5.0.7/src/app/amba_elf.cpp.
 *
 * The extractor:
 *  - validates the magic (\x7fELF)
 *  - rejects anything that's not ELFCLASS32+EM_ARM or ELFCLASS64+EM_AARCH64
 *  - concatenates all PT_LOAD segments, zero-padding bss to p_memsz
 *  - returns load_addr from the first allocated section in segment 0
 *
 * After extraction the firmware blob is also probed for the fwprog
 * version/cmd/result addresses at the Ambarella-specific offsets so that
 * the session can adjust memfwprog placement.
 */
#ifndef AMBUSB_CLI_ELF_H
#define AMBUSB_CLI_ELF_H

#include <stdint.h>
#include <stddef.h>

#include "ambausb_proto.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    uint8_t  *data;       /* malloc'd flat binary, caller frees */
    size_t    size;
    uint64_t  load_addr;  /* address read from the first allocated section */
    int       is_64bit;
} amba_binary_t;

/* Try to load `path` as an ELF and extract the flat binary.
 * If `path` is not an ELF (no \x7fELF magic), it's treated as an already-flat
 * firmware binary and returned verbatim (load_addr left untouched). This
 * matches AmbaElf::get_plain_binary's LOAD_INVALID branch.
 *
 * Returns 0 on success. On failure, out->data is NULL and an error is logged. */
int amba_elf_extract(const char *path, amba_binary_t *out);

/* Free a binary returned by amba_elf_extract. */
void amba_binary_free(amba_binary_t *bin);

/* Probe the firmware blob for the version + fwprog cmd/result addresses.
 * `firmInfo` is populated on success. `fw_memfwprog_off` receives the
 * memfwprog offset stored at FIRM_OFFSET_MEMFWPROG. Returns 0 on success. */
int amba_fw_probe(const amba_binary_t *bin,
                  amba_fwinfo_t *firm_info,
                  uint32_t *fw_version,
                  uint32_t *fw_memfwprog_off);

/* Adjust memfwprog start address based on the firmware version,
 * mirroring AmbaElf::get_plain_binary's major/minor logic. */
void amba_fw_adjust_memfwprog(uint32_t fw_version,
                              uint32_t fw_memfwprog_off,
                              uint64_t orig_addr,
                              uint64_t *binary_start_addr);

#ifdef __cplusplus
}
#endif
#endif
