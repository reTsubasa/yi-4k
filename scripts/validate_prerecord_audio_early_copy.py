#!/usr/bin/env python3
"""Run the audio early-copy C and shared queue on host and compiled ARM."""
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
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE, UC_HOOK_MEM_READ
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "artifacts/device/2026-11-11-prerecord-audio-early-copy/validation.json"
SOURCES = [ROOT / p for p in ["sdk/yi4k_1107_audio_early_copy.c",
    "sdk/yi4k_1107_early_copy.c", "sdk/yi4k_1107_payload_copy.c",
    "sdk/offline/yi4k_audio_early_copy_test.c"]]
CASES = ["copy_before_original_mutation_and_sanitized_metadata", "two_span_copy",
    "full_queue_preserves_head_and_records_ordinal_gap", "eos_ignores_invalid_source_bytes",
    "invalid_eos", "null_event", "misaligned_event", "zero_encoder_handle",
    "address_before_ring", "zero_payload", "payload_larger_than_ring", "owned_slot_too_small",
    "null_ingress_still_chains", "null_queue_still_chains", "synchronous_reentry_each_chains_once",
    "observation_ordinal_wrap", "eos_full_explicit_drop", "owned_bytes_survive_source_reuse",
    "invalid_chain_cannot_forward", "ordinary_normalized_sentinel_rejected",
    "ordinary_raw_sentinel_rejected", "next_frame_recovers_after_copy_failure"]


def sha(b):
    return hashlib.sha256(b).hexdigest()


def main():
    clang = shutil.which("clang")
    linkers = sorted(Path("/Users/hyc/Library/Android/sdk/ndk").glob("*/toolchains/llvm/prebuilt/*/bin/ld.lld"))
    linker = shutil.which("ld.lld") or (str(linkers[-1]) if linkers else None)
    assert clang and linker
    common = ["-std=c11", "-O2", "-Wall", "-Wextra", "-Werror", "-fno-builtin"]
    flags = ["--target=armv7-none-eabi", "-mcpu=cortex-a9", "-marm", "-mfloat-abi=soft", "-mfpu=none",
        "-ffreestanding", "-fno-stack-protector", "-fno-pic", "-fno-unwind-tables", "-fno-asynchronous-unwind-tables", *common]
    commands, rows = [], []

    def command(args):
        result = subprocess.run(args, capture_output=True, text=True)
        if result.returncode:
            raise RuntimeError(result.stderr)
        commands.append(args)

    with tempfile.TemporaryDirectory(prefix="yi4k-audio-copy-") as temp:
        directory = Path(temp)
        library_path = directory / "audio.dylib"
        command([clang, "-shared", "-fPIC", *common, *map(str, SOURCES), "-o", str(library_path)])
        objects = []
        for source in SOURCES:
            obj = directory / (source.name + ".o")
            objects.append(str(obj))
            command([clang, *flags, "-c", str(source), "-o", str(obj)])
        script = directory / "audio.ld"
        script.write_text((ROOT / "sdk/offline/yi4k_payload_copy_emulation.ld").read_text().replace(
            "ENTRY(yi4k_1107_copy_payload)", "ENTRY(yi4k_audio_early_copy_test)"))
        target = directory / "audio.elf"
        command([linker, "-T", str(script), *objects, "-o", str(target)])
        blob = target.read_bytes()
        elf = ELFFile(io.BytesIO(blob))
        symbols = list(elf.get_section_by_name(".symtab").iter_symbols())
        assert not any(s.name and s["st_shndx"] == "SHN_UNDEF" for s in symbols)
        assert not any(s["sh_type"] in ("SHT_REL", "SHT_RELA") and s["sh_size"] for s in elf.iter_sections())
        functions = {s.name:dict(address=s["st_value"], bytes=s["st_size"]) for s in symbols if s["st_info"]["type"] == "STT_FUNC"}
        report_addr = next(s["st_value"] for s in symbols if s.name == "yi4k_audio_test_report")
        library = ct.CDLL(str(library_path))
        test = library.yi4k_audio_early_copy_test
        test.argtypes, test.restype = [ct.c_uint32], ct.c_int
        host_report = (ct.c_uint32 * 16).in_dll(library, "yi4k_audio_test_report")
        for index, name in enumerate(CASES):
            status = test(index)
            assert status == 0, (name, "host", status)
            host_words = list(host_report)
            m = Uc(UC_ARCH_ARM, UC_MODE_ARM)
            m.mem_map(0x10030000, 0x20000)
            m.mem_map(0x23000000, 0x10000)
            for section in elf.iter_sections():
                if section["sh_flags"] & 2 and section["sh_size"]:
                    m.mem_write(section["sh_addr"], section.data() if section["sh_type"] != "SHT_NOBITS" else bytes(section["sh_size"]))
            m.reg_write(UC_ARM_REG_CPSR, 0x13)
            saved = {r:0x41230000+i*0x1234 for i,r in enumerate((UC_ARM_REG_R4,UC_ARM_REG_R5,
                UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11))}
            for r,v in saved.items():
                m.reg_write(r,v)
            event_addresses, stale_reads, defined_reads = set(), [], []
            entry = functions["yi4k_1107_audio_on_event"]["address"]
            ranges = [(f["address"], f["address"]+f["bytes"]) for n,f in functions.items()
                if n in ("yi4k_1107_audio_on_event", "capture_audio")]

            def on_code(uc, address, size, user):
                if address == entry:
                    # AAPCS returns the result struct through hidden r0; the
                    # actual event pointer is therefore the fourth arg, r3.
                    pointer = uc.reg_read(UC_ARM_REG_R3)
                    if pointer and pointer % 8 == 0:
                        event_addresses.add(pointer)

            def on_read(uc, access, address, size, value, user):
                pc = uc.reg_read(UC_ARM_REG_PC)
                if any(lo <= pc < hi for lo,hi in ranges):
                    for pointer in event_addresses:
                        if address < pointer+0x20 and pointer < address+size:
                            defined_reads.append(dict(pc=hex(pc), address=hex(address), size=size))
                        for off in (4, 0x1C):
                            if address < pointer+off+4 and pointer+off < address+size:
                                stale_reads.append(dict(pc=hex(pc),address=hex(address),size=size))

            m.hook_add(UC_HOOK_CODE, on_code)
            m.hook_add(UC_HOOK_MEM_READ, on_read)
            m.reg_write(UC_ARM_REG_R0,index)
            m.reg_write(UC_ARM_REG_SP,0x23008000)
            m.reg_write(UC_ARM_REG_LR,0x1004FF00)
            m.emu_start(functions["yi4k_audio_early_copy_test"]["address"],0x1004FF00,count=2000000)
            assert m.reg_read(UC_ARM_REG_PC) == 0x1004FF00 and m.reg_read(UC_ARM_REG_R0) == 0, (name,"ARM",m.reg_read(UC_ARM_REG_R0))
            assert m.reg_read(UC_ARM_REG_SP) == 0x23008000
            assert all(m.reg_read(r) == value for r,value in saved.items())
            arm_words = list(struct.unpack("<16I",m.mem_read(report_addr,64)))
            assert arm_words == host_words, (name,arm_words,host_words)
            assert not stale_reads, (name,stale_reads)
            if index not in (5, 6, 12, 13, 18):
                assert defined_reads, (name, "event-read instrumentation did not observe the adapter")
            rows.append(dict(name=name,host_status=status,compiled_arm_status=0,report=arm_words,
                host_and_arm_match=True,callee_saved_and_sp_preserved=True,
                compiled_adapter_event_read_count=len(defined_reads),
                unwritten_event_word_reads_in_compiled_adapter=0))
        result = dict(evidence_type="Real audio normalization and exactly-once one-argument chain, reusing common SPSC owned queue and payload-copy; host and compiled ARM",
            cases=len(rows),host_executions=len(rows),arm_executions=len(rows),results=rows,
            report_fields=["capture_status","original_status_u32","original_calls","accepted","ended","dropped",
                "failed","last_copy_status","next_observation_sequence","head","tail","nested_status","reserved0","reserved1","reserved2","reserved3"],
            build=dict(commands=commands,clang_version=subprocess.check_output([clang,"--version"],text=True).splitlines()[0],
                linker_version=subprocess.check_output([linker,"--version"],text=True).strip(),
                arm_elf_sha256=sha(blob),undefined_symbols=0,linked_relocations=0,functions=functions,
                source_sha256={str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in SOURCES},
                header_sha256={str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in [ROOT / n for n in (
                    "sdk/yi4k_1107_audio_event.h","sdk/yi4k_1107_audio_early_copy.h","sdk/yi4k_1107_early_copy.h",
                    "sdk/yi4k_1107_payload_copy.h","sdk/yi4k_1107_video_descriptor.h")]}),
            limitations=["No device binding, hook installer, callback slot reordering, RTOS task or SD writer.",
                "Source mapping, metadata and payload are stable/coherent fixture preconditions; no hardware lease is proved.",
                "Sequence is an owned observation ordinal, not stock audio FIFO sequence or a shared A/V epoch.",
                "EOS is an owned normalized terminal, not the state-dependent stock 0xfffffe marker.",
                "One serialized callback producer per queue; audio and video require separate queues.",
                "The queue is bounded staging, not a one-minute spool; full/EOS drops must invalidate continuity upstream."],
            device_access=False,camera_prerecord_implemented=False)
    OUT.parent.mkdir(parents=True,exist_ok=True)
    OUT.write_text(json.dumps(result,indent=2)+"\n")
    print(json.dumps(dict(output=str(OUT.relative_to(ROOT)),host_cases=len(rows),compiled_arm_cases=len(rows))))


if __name__ == "__main__":
    main()
