#!/usr/bin/env python3
"""Build real early-copy/payload-copy C, run host/ARM cases and host SPSC stress."""
import ctypes as ct
import hashlib
import io
import json
import shutil
import struct
import subprocess
import tempfile
from pathlib import Path

from elftools.elf.elffile import ELFFile
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "artifacts/device/2026-11-11-prerecord-early-copy/validation.json"
SOURCES = [ROOT / name for name in (
    "sdk/yi4k_1107_early_copy.c", "sdk/yi4k_1107_payload_copy.c",
    "sdk/offline/yi4k_early_copy_test.c")]
THREADS = ROOT / "sdk/offline/yi4k_early_copy_threads.c"
CASES = ["owned_copy_precedes_original_mutation", "two_span_ring_copy",
    "full_queue_preserves_borrowed_owned_head", "queue_index_wrap_and_reuse",
    "normalized_eos_no_payload_read", "raw_eos_no_payload_read", "eos_full_is_explicit_drop",
    "unknown_event_passthrough", "null_event_forwarded_once", "misaligned_event_forwarded_once",
    "payload_address_before_ring", "zero_length", "length_larger_than_ring", "slot_too_small",
    "type_exceeds_byte", "invalid_stream", "synchronous_reentry_each_invocation_chains_once",
    "null_adapter_still_forwards", "failed_copy_then_next_frame", "invalid_chain_cannot_forward",
    "init_rejects_aliases_and_one_slot", "owned_bytes_survive_source_reuse"]


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    clang = shutil.which("clang")
    assert clang
    linkers = sorted(Path("/Users/hyc/Library/Android/sdk/ndk").glob("*/toolchains/llvm/prebuilt/*/bin/ld.lld"))
    linker = shutil.which("ld.lld") or (str(linkers[-1]) if linkers else None)
    assert linker
    common = ["-std=c11", "-O2", "-Wall", "-Wextra", "-Werror", "-fno-builtin"]
    arm_flags = ["--target=armv7-none-eabi", "-mcpu=cortex-a9", "-marm", "-mfloat-abi=soft",
        "-mfpu=none", "-ffreestanding", "-fno-stack-protector", "-fno-pic", "-fno-unwind-tables",
        "-fno-asynchronous-unwind-tables", *common]
    commands = []

    def command(args):
        result = subprocess.run(args, capture_output=True, text=True)
        if result.returncode:
            raise RuntimeError(result.stderr)
        commands.append(args)

    with tempfile.TemporaryDirectory(prefix="yi4k-early-copy-") as temporary:
        directory = Path(temporary)
        library_path = directory / "early.dylib"
        command([clang, "-shared", "-fPIC", "-pthread", *common,
            *map(str, SOURCES), str(THREADS), "-o", str(library_path)])
        objects = []
        for source in SOURCES:
            obj = directory / (source.name + ".o")
            objects.append(str(obj))
            command([clang, *arm_flags, "-c", str(source), "-o", str(obj)])
        script = directory / "early.ld"
        script.write_text((ROOT / "sdk/offline/yi4k_payload_copy_emulation.ld").read_text().replace(
            "ENTRY(yi4k_1107_copy_payload)", "ENTRY(yi4k_early_copy_test)"))
        target = directory / "early.elf"
        command([linker, "-T", str(script), *objects, "-o", str(target)])
        blob = target.read_bytes()
        elf = ELFFile(io.BytesIO(blob))
        symbols = list(elf.get_section_by_name(".symtab").iter_symbols())
        assert not any(s.name and s["st_shndx"] == "SHN_UNDEF" for s in symbols)
        assert not any(s["sh_type"] in ("SHT_REL", "SHT_RELA") and s["sh_size"] for s in elf.iter_sections())
        functions = {s.name: dict(address=s["st_value"], bytes=s["st_size"])
            for s in symbols if s["st_info"]["type"] == "STT_FUNC"}
        report_address = next(s["st_value"] for s in symbols if s.name == "yi4k_early_test_report")
        library = ct.CDLL(str(library_path))
        function = library.yi4k_early_copy_test
        function.argtypes = [ct.c_uint32]
        function.restype = ct.c_int
        host_report = (ct.c_uint32 * 16).in_dll(library, "yi4k_early_test_report")
        rows = []
        for index, name in enumerate(CASES):
            host_status = function(index)
            assert host_status == 0, (name, "host", host_status)
            host_words = list(host_report)
            m = Uc(UC_ARCH_ARM, UC_MODE_ARM)
            m.mem_map(0x10030000, 0x20000)
            m.mem_map(0x23000000, 0x10000)
            for section in elf.iter_sections():
                if section["sh_flags"] & 2 and section["sh_size"]:
                    m.mem_write(section["sh_addr"], section.data() if section["sh_type"] != "SHT_NOBITS" else bytes(section["sh_size"]))
            m.reg_write(UC_ARM_REG_CPSR, 0x13)
            saved = {r:0x51230000 + i * 0x1234 for i,r in enumerate((UC_ARM_REG_R4,
                UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11))}
            for register,value in saved.items():
                m.reg_write(register,value)
            m.reg_write(UC_ARM_REG_R0,index)
            m.reg_write(UC_ARM_REG_SP,0x23008000)
            m.reg_write(UC_ARM_REG_LR,0x1004ff00)
            m.emu_start(functions["yi4k_early_copy_test"]["address"],0x1004ff00,count=2000000)
            status = m.reg_read(UC_ARM_REG_R0)
            assert m.reg_read(UC_ARM_REG_PC) == 0x1004ff00 and status == 0, (name,"ARM",status)
            assert m.reg_read(UC_ARM_REG_SP) == 0x23008000
            assert all(m.reg_read(r) == value for r,value in saved.items())
            arm_words = list(struct.unpack("<16I",m.mem_read(report_address,64)))
            assert arm_words == host_words, (name,arm_words,host_words)
            rows.append(dict(name=name, host_status=host_status, compiled_arm_status=status,
                report=arm_words, host_and_arm_match=True, callee_saved_and_sp_preserved=True))

        stress = library.yi4k_early_thread_stress
        stress.argtypes = [ct.c_uint32]
        stress.restype = ct.c_int
        assert stress(20000) == 0
        stress_words = list((ct.c_uint32 * 6).in_dll(library,"yi4k_early_thread_report"))
        data = dict(evidence_type="Real pure-C early callback adapter reusing existing payload-copy C; host and compiled ARM execution, plus host-only pthread SPSC stress",
            case_count=len(rows), host_execution_count=len(rows), arm_execution_count=len(rows), cases=rows,
            report_fields=["capture_status","original_status_u32","original_calls","accepted","ended",
                "dropped","failed","last_copy_status","head","tail","ingress_busy","nested_status","reserved0","reserved1","reserved2","reserved3"],
            threaded_host_stress=dict(target_owned_frames=20000, original_calls=stress_words[0],
                accepted=stress_words[1], dropped_full=stress_words[2], consumed=stress_words[3],
                integrity_errors=stress_words[4], callback_attempts=stress_words[5],
                each_callback_chained_once=True, ordered_gaps_allowed=True,
                scheduling_waits_confined_to_test_fixture=True),
            build=dict(commands=commands, clang_version=subprocess.check_output([clang,"--version"],text=True).splitlines()[0],
                linker_version=subprocess.check_output([linker,"--version"],text=True).strip(),
                arm_elf_sha256=sha(blob),host_library_sha256=sha(library_path.read_bytes()),
                undefined_symbols=0,linked_relocations=0,functions=functions,
                source_sha256={str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in [*SOURCES,THREADS]},
                header_sha256={str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in [
                    ROOT/"sdk/yi4k_1107_early_copy.h",ROOT/"sdk/yi4k_1107_audio_event.h",
                    ROOT/"sdk/yi4k_1107_payload_copy.h",ROOT/"sdk/yi4k_1107_video_descriptor.h"]}),
            limitations=["Source ring and event payload stability/cache coherence are fixture preconditions, not a proven hardware lease.",
                "No callback installer, registration replacement, firmware address binding, loader, SD writer or camera access exists in this adapter.",
                "Only one serialized callback producer and one consumer are supported; ingress_busy detects synchronous recursion, not concurrent producers.",
                "Exactly-once original forwarding requires a valid immutable non-null chain; invalid chain cannot forward.",
                "Host pthread stress checks C SPSC publication/ownership, not RTOS scheduling, DSP overwrite, DMA/cache or on-device copy deadline.",
                "Owned frames are a bounded staging seam, not a one-minute spool, mux implementation or working prerecord feature."],
            device_access=False, camera_prerecord_implemented=False)
    OUT.parent.mkdir(parents=True,exist_ok=True)
    OUT.write_text(json.dumps(data,indent=2)+"\n")
    print(json.dumps(dict(output=str(OUT.relative_to(ROOT)),cases=len(rows),host_executions=len(rows),arm_executions=len(rows),threaded_owned_frames=20000)))


if __name__ == "__main__":
    main()
