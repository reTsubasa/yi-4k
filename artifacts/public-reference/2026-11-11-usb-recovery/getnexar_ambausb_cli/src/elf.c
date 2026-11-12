#include "elf.h"
#include "log.h"

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#define EI_NIDENT 16
#define EI_CLASS  4
#define ELFCLASS32 1
#define ELFCLASS64 2
#define EM_ARM     40
#define EM_AARCH64 183
#define PT_LOAD     1
#define SHF_ALLOC   2

typedef struct {
    uint8_t  e_ident[EI_NIDENT];
    uint16_t e_type;
    uint16_t e_machine;
    uint32_t e_version;
    uint32_t e_entry;
    uint32_t e_phoff;
    uint32_t e_shoff;
    uint32_t e_flags;
    uint16_t e_ehsize;
    uint16_t e_phentsize;
    uint16_t e_phnum;
    uint16_t e_shentsize;
    uint16_t e_shnum;
    uint16_t e_shstrndx;
} Elf32_Ehdr;

typedef struct {
    uint8_t  e_ident[EI_NIDENT];
    uint16_t e_type;
    uint16_t e_machine;
    uint32_t e_version;
    uint64_t e_entry;
    uint64_t e_phoff;
    uint64_t e_shoff;
    uint32_t e_flags;
    uint16_t e_ehsize;
    uint16_t e_phentsize;
    uint16_t e_phnum;
    uint16_t e_shentsize;
    uint16_t e_shnum;
    uint16_t e_shstrndx;
} Elf64_Ehdr;

typedef struct { uint32_t p_type, p_offset, p_vaddr, p_paddr, p_filesz, p_memsz, p_flags, p_align; } Elf32_Phdr;
typedef struct { uint32_t p_type, p_flags; uint64_t p_offset, p_vaddr, p_paddr, p_filesz, p_memsz, p_align; } Elf64_Phdr;
typedef struct { uint32_t sh_name, sh_type, sh_flags, sh_addr, sh_offset, sh_size, sh_link, sh_info, sh_addralign, sh_entsize; } Elf32_Shdr;
typedef struct { uint32_t sh_name, sh_type; uint64_t sh_flags, sh_addr, sh_offset, sh_size; uint32_t sh_link, sh_info; uint64_t sh_addralign, sh_entsize; } Elf64_Shdr;

static int read_file(const char *path, uint8_t **buf_out, size_t *size_out)
{
    FILE *f = fopen(path, "rb");
    if (!f) { amba_error("Cannot open %s: %s", path, strerror(errno)); return -1; }
    struct stat st;
    if (fstat(fileno(f), &st) != 0) { fclose(f); return -1; }
    /* st_size is only meaningful for regular files; a directory, fifo or
     * /proc-style file would otherwise be accepted as a 0-byte "flat
     * binary" and sail through to the device. */
    if (!S_ISREG(st.st_mode)) {
        amba_error("%s is not a regular file", path);
        fclose(f);
        return -1;
    }
    if (st.st_size <= 0) {
        amba_error("%s is empty", path);
        fclose(f);
        return -1;
    }
    size_t sz = (size_t)st.st_size;
    uint8_t *buf = malloc(sz);
    if (!buf) { fclose(f); amba_error("Out of memory reading %s", path); return -1; }
    if (fread(buf, 1, sz, f) != sz) {
        amba_error("Short read on %s", path); free(buf); fclose(f); return -1;
    }
    fclose(f);
    *buf_out = buf;
    *size_out = sz;
    return 0;
}

/* Bounds-check a table of `count` entries of `entsize` bytes at file offset
 * `off`. Every input is attacker-controlled, so the arithmetic is done in a
 * way that cannot wrap: a plain `off + count * entsize > elf_size` is
 * bypassable with e.g. off = 2^64-56, count = 1, entsize = 56. */
static int table_in_bounds(uint64_t off, uint64_t count, uint64_t entsize,
                           size_t elf_size)
{
    if (off > (uint64_t)elf_size) return 0;
    if (entsize != 0 && count > UINT64_MAX / entsize) return 0;
    return count * entsize <= (uint64_t)elf_size - off;
}

/* Concatenate PT_LOAD segments. For the last segment, p_memsz is truncated
 * to p_filesz (matches the Qt extractor). load_addr is taken from the first
 * allocated section in segment 0.
 *
 * `elf` is user-supplied via --firmware, so every offset and size read out
 * of it is treated as hostile: table bounds, entry sizes, the p_filesz /
 * p_memsz relation and the output-size accumulation are all checked before
 * they reach a memcpy. */
static int extract_segments_generic(const uint8_t *elf, size_t elf_size,
                                    int is_64,
                                    uint64_t *load_addr,
                                    uint8_t **out_data, size_t *out_size)
{
    uint16_t phnum, phentsize, shnum, shentsize;
    uint64_t phoff, shoff;
    if (is_64) {
        const Elf64_Ehdr *h = (const Elf64_Ehdr *)elf;
        phoff = h->e_phoff; shoff = h->e_shoff;
        phnum = h->e_phnum; phentsize = h->e_phentsize;
        shnum = h->e_shnum; shentsize = h->e_shentsize;
    } else {
        const Elf32_Ehdr *h = (const Elf32_Ehdr *)elf;
        phoff = h->e_phoff; shoff = h->e_shoff;
        phnum = h->e_phnum; phentsize = h->e_phentsize;
        shnum = h->e_shnum; shentsize = h->e_shentsize;
    }
    /* An entry has to be at least as big as the header we read out of it,
     * otherwise the bounds check below passes while the last entry still
     * reads past the end of the file. */
    const size_t ph_size = is_64 ? sizeof(Elf64_Phdr) : sizeof(Elf32_Phdr);
    const size_t sh_size_hdr = is_64 ? sizeof(Elf64_Shdr) : sizeof(Elf32_Shdr);
    if (phnum != 0 && phentsize < ph_size) {
        amba_error("ELF e_phentsize %u is smaller than a program header (%zu)",
                   phentsize, ph_size);
        return -1;
    }
    if (shnum != 0 && shentsize < sh_size_hdr) {
        amba_error("ELF e_shentsize %u is smaller than a section header (%zu)",
                   shentsize, sh_size_hdr);
        return -1;
    }
    if (!table_in_bounds(phoff, phnum, phentsize, elf_size) ||
        !table_in_bounds(shoff, shnum, shentsize, elf_size)) {
        amba_error("ELF header/section tables out of bounds");
        return -1;
    }

    /* Pass 1: figure total output size = sum of (writeSize) per PT_LOAD */
    size_t total = 0;
    int load_count = 0;
    for (uint16_t i = 0; i < phnum; i++) {
        const uint8_t *ph = elf + phoff + (size_t)i * phentsize;
        Elf64_Phdr p64; Elf32_Phdr p32;
        uint64_t filesz, memsz;
        if (is_64) {
            memcpy(&p64, ph, sizeof(p64));
            if (p64.p_type != PT_LOAD) continue;
            filesz = p64.p_filesz; memsz = p64.p_memsz;
        } else {
            memcpy(&p32, ph, sizeof(p32));
            if (p32.p_type != PT_LOAD) continue;
            filesz = p32.p_filesz; memsz = p32.p_memsz;
        }
        /* The output buffer is sized from p_memsz but filled from p_filesz,
         * so p_filesz > p_memsz overflows it. ELF requires filesz <= memsz
         * for PT_LOAD; anything else is malformed. */
        if (filesz > memsz) {
            amba_error("PT_LOAD segment %d has p_filesz (%llu) larger than "
                       "p_memsz (%llu)", load_count,
                       (unsigned long long)filesz, (unsigned long long)memsz);
            return -1;
        }
        if (memsz > SIZE_MAX - 4 - total) {
            amba_error("ELF PT_LOAD segments exceed the addressable output "
                       "size");
            return -1;
        }
        load_count++;
        total += (size_t)memsz;
    }
    if (load_count == 0) {
        amba_error("ELF contains no PT_LOAD segments");
        return -1;
    }

    uint8_t *out = calloc(1, total + 4);
    if (!out) { amba_error("Out of memory"); return -1; }
    size_t written = 0;
    int got_addr = 0;
    int seg_index = -1;
    int last_load_index = load_count - 1;

    for (uint16_t i = 0; i < phnum; i++) {
        const uint8_t *ph = elf + phoff + (size_t)i * phentsize;
        Elf64_Phdr p64; Elf32_Phdr p32;
        uint64_t offset, vaddr, filesz, memsz;
        if (is_64) {
            memcpy(&p64, ph, sizeof(p64));
            if (p64.p_type != PT_LOAD) continue;
            offset = p64.p_offset; vaddr = p64.p_vaddr;
            filesz = p64.p_filesz; memsz = p64.p_memsz;
        } else {
            memcpy(&p32, ph, sizeof(p32));
            if (p32.p_type != PT_LOAD) continue;
            offset = p32.p_offset; vaddr = p32.p_vaddr;
            filesz = p32.p_filesz; memsz = p32.p_memsz;
        }
        seg_index++;
        int is_last = (seg_index == last_load_index);

        uint64_t read_size  = filesz;
        uint64_t write_size = memsz;
        if (is_last && read_size < write_size) write_size = read_size;

        /* Walk section table to find the first allocated section of seg 0 */
        if (!got_addr && seg_index == 0) {
            for (uint16_t j = 0; j < shnum; j++) {
                const uint8_t *sh = elf + shoff + (size_t)j * shentsize;
                Elf64_Shdr s64; Elf32_Shdr s32;
                uint64_t sh_size, sh_flags, sh_addr, sh_off;
                if (is_64) {
                    memcpy(&s64, sh, sizeof(s64));
                    sh_size = s64.sh_size;  sh_flags = s64.sh_flags;
                    sh_addr = s64.sh_addr;  sh_off   = s64.sh_offset;
                } else {
                    memcpy(&s32, sh, sizeof(s32));
                    sh_size = s32.sh_size;  sh_flags = s32.sh_flags;
                    sh_addr = s32.sh_addr;  sh_off   = s32.sh_offset;
                }
                if (sh_size == 0) continue;
                /* Written as subtractions so a huge sh_size/sh_addr cannot
                 * wrap the comparison into "inside the segment". */
                int in_segment = (sh_flags & SHF_ALLOC)
                    ? (sh_addr >= vaddr && sh_size <= memsz &&
                       sh_addr - vaddr <= memsz - sh_size)
                    : (sh_off >= offset && sh_size <= filesz &&
                       sh_off - offset <= filesz - sh_size);
                if (!in_segment) continue;
                *load_addr = sh_addr;
                got_addr = 1;
                /* The Qt extractor moves `offset` forward to the first section
                 * and trims read/write_size by the gap from the segment
                 * start. Both sizes are unsigned, so a gap larger than the
                 * segment would underflow them into huge values. */
                if (sh_off > offset) {
                    uint64_t gap = sh_off - offset;
                    if (gap > read_size || gap > write_size) {
                        amba_warn("First allocated section of segment 0 starts "
                                  "past the segment's file image; not trimming");
                    } else {
                        read_size  -= gap;
                        write_size -= gap;
                        offset = sh_off;
                    }
                }
                amba_notice("Binary start address read from file is 0x%016lx",
                            (unsigned long)*load_addr);
                break;
            }
        }

        if (offset > (uint64_t)elf_size ||
            read_size > (uint64_t)elf_size - offset) {
            amba_error("PT_LOAD segment %d out of bounds", seg_index);
            free(out);
            return -1;
        }
        /* Clamp to what is left of the output buffer. filesz <= memsz was
         * enforced in pass 1 and total is the sum of every memsz, so neither
         * clamp fires on a well-formed ELF; they are the last line of
         * defence for one that isn't. */
        if (write_size > total - written) write_size = total - written;
        if (read_size  > write_size)      read_size  = write_size;
        memcpy(out + written, elf + offset, (size_t)read_size);
        /* memsz > filesz → bss-style zero padding via calloc */
        written += write_size;
    }

    /* 4-byte tail padding to match the Qt extractor's write_binary_file. */
    size_t padded = (written + 3) & ~(size_t)3;
    *out_size = padded;
    *out_data = out;
    if (!got_addr) {
        amba_warn("ELF first segment has no allocated section; "
                  "load_addr left at caller default");
    }
    return 0;
}

int amba_elf_extract(const char *path, amba_binary_t *out)
{
    memset(out, 0, sizeof(*out));
    uint8_t *elf = NULL;
    size_t   elf_size = 0;
    if (read_file(path, &elf, &elf_size) != 0) return -1;

    if (elf_size < EI_NIDENT || memcmp(elf, "\x7f""ELF", 4) != 0) {
        /* Not an ELF — treat as already-flat binary, no load_addr override */
        out->data = elf;
        out->size = elf_size;
        out->load_addr = 0;
        amba_notice("%s does not begin with ELF magic; "
                    "treating as flat binary", path);
        return 0;
    }

    int is_64;
    if (elf[EI_CLASS] == ELFCLASS32) {
        if (elf_size < sizeof(Elf32_Ehdr)) {
            amba_error("Truncated ELF32 header");
            free(elf);
            return -1;
        }
        const Elf32_Ehdr *h = (const Elf32_Ehdr *)elf;
        if (h->e_machine != EM_ARM) {
            amba_error("%s is not ARM ELF (e_machine = %u)", path, h->e_machine);
            free(elf);
            return -1;
        }
        is_64 = 0;
    } else if (elf[EI_CLASS] == ELFCLASS64) {
        if (elf_size < sizeof(Elf64_Ehdr)) {
            amba_error("Truncated ELF64 header");
            free(elf);
            return -1;
        }
        const Elf64_Ehdr *h = (const Elf64_Ehdr *)elf;
        if (h->e_machine != EM_AARCH64) {
            amba_error("%s is not AArch64 ELF (e_machine = %u)", path, h->e_machine);
            free(elf);
            return -1;
        }
        is_64 = 1;
    } else {
        amba_error("%s has invalid ELF class %u", path, elf[EI_CLASS]);
        free(elf);
        return -1;
    }

    out->is_64bit = is_64;
    int rc = extract_segments_generic(elf, elf_size, is_64,
                                      &out->load_addr,
                                      &out->data, &out->size);
    free(elf);
    return rc;
}

void amba_binary_free(amba_binary_t *bin)
{
    free(bin->data);
    memset(bin, 0, sizeof(*bin));
}

int amba_fw_probe(const amba_binary_t *bin,
                  amba_fwinfo_t *firm_info,
                  uint32_t *fw_version,
                  uint32_t *fw_memfwprog_off)
{
    /* Furthest field is FIRM_OFFSET_MEMFWPROG; need 4 bytes of payload past
     * it. The original bound check only protected up to MEMFWCMD, which
     * left a 1-4 byte OOB read window for short binaries. */
    const size_t need = FIRM_OFFSET_MEMFWPROG + sizeof(uint32_t);
    if (bin->size < need) {
        amba_error("Firmware binary too small (%zu < %zu) to contain "
                   "fwprog header", bin->size, need);
        return -1;
    }
    memset(firm_info, 0, sizeof(*firm_info));
    firm_info->magic = AMBA_FIRM_INFO_MAGIC;

    uint32_t ver;
    memcpy(&ver, bin->data + FIRM_OFFSET_VERSION, sizeof(ver));
    /* Qt accepts only versions with the high 16 bits clear */
    *fw_version = (ver & 0xffff0000u) ? 0 : ver;

    uint32_t v;
    memcpy(&v, bin->data + FIRM_OFFSET_MEMFWRESULT, sizeof(v));
    firm_info->fw_addr_result.lo = v;
    memcpy(&v, bin->data + FIRM_OFFSET_MEMFWCMD, sizeof(v));
    firm_info->fw_addr_cmd.lo = v;
    memcpy(fw_memfwprog_off, bin->data + FIRM_OFFSET_MEMFWPROG,
           sizeof(*fw_memfwprog_off));

    amba_debug("fw_version = 0x%08x", *fw_version);
    amba_debug("memfwresult addr = 0x%016lx",
               (unsigned long)firm_info->fw_addr_result.address);
    amba_debug("memfwcmd    addr = 0x%016lx",
               (unsigned long)firm_info->fw_addr_cmd.address);
    amba_debug("memfwprog offset = 0x%08x", *fw_memfwprog_off);
    return 0;
}

void amba_fw_adjust_memfwprog(uint32_t fw_version,
                              uint32_t fw_memfwprog_off,
                              uint64_t orig_addr,
                              uint64_t *binary_start_addr)
{
    if (fw_version == 0) return;
    uint8_t major = (fw_version >> 8) & 0xff;
    uint8_t minor = fw_version & 0xff;
    amba_notice("Firmware memfwprog version is %u.%u", major, minor);
    if (major < 3) return;

    /* binary_start_addr starts from the ELF-derived value. If the ELF didn't
     * carry one (zero), we treat it as "from chip default" (= orig_addr). */
    int is_from_elf = (*binary_start_addr != 0);

    if (minor >= 7) {
        if (is_from_elf) {
            if ((uint64_t)fw_memfwprog_off != *binary_start_addr) {
                amba_notice("Memfwprog address in firmware (0x%08x) differs "
                            "from ELF; using ELF address",
                            fw_memfwprog_off);
            }
        } else {
            uint32_t off = (uint32_t)(*binary_start_addr & 0x0FFFFFFFu);
            if (off != 0x00100000u && off != 0x00400000u && off != 0x01400000u) {
                amba_notice("Use user defined memfwprog address 0x%08lx",
                            (unsigned long)orig_addr);
                *binary_start_addr = orig_addr;
            } else {
                amba_notice("Memfwprog address in firmware is 0x%08x",
                            fw_memfwprog_off);
                *binary_start_addr = fw_memfwprog_off;
            }
        }
    } else if (minor >= 4) {
        uint32_t off = (uint32_t)(*binary_start_addr & 0x0FFFFFFFu);
        if (off != 0x00100000u && off != 0x00400000u) {
            if (is_from_elf) {
                amba_notice("Memfwprog address in ELF is 0x%016lx; "
                            "firmware version suggests 0x00400000, using ELF",
                            (unsigned long)*binary_start_addr);
            } else {
                amba_notice("Use user defined memfwprog address 0x%08lx",
                            (unsigned long)orig_addr);
                *binary_start_addr = orig_addr;
            }
        } else if (!is_from_elf) {
            amba_notice("Firmware memfwprog address offset reset to 0x00400000");
            *binary_start_addr = (orig_addr & 0xFFFFFFFFFF0FFFFFULL) | 0x00400000ULL;
        }
    } else if (!is_from_elf && *binary_start_addr != 0x00100000ULL) {
        amba_notice("Use user defined memfwprog address 0x%08lx",
                    (unsigned long)orig_addr);
        *binary_start_addr = orig_addr;
    }
}
