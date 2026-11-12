#!/usr/bin/env python3
"""Owned descriptor handoff: host/compiled C, plus pinned original ARM writers.

Only synthetic host RAM, archived samples, modeled stream/index/OS services.
No camera access. Compiled C is never described as original firmware code.
"""
from __future__ import annotations

import argparse
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
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_MEM_READ
from unicorn.arm_const import *
import audit_prerecord_owned_mux_writer as stock

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "artifacts/device/2026-11-11-prerecord-owned-mux-adapter/validation.json"
SOURCES = [ROOT / p for p in ["sdk/yi4k_1107_owned_mux.c", "sdk/yi4k_1107_early_copy.c",
    "sdk/yi4k_1107_audio_early_copy.c", "sdk/yi4k_1107_payload_copy.c",
    "sdk/offline/yi4k_owned_mux_test.c"]]
HEADERS = [ROOT / p for p in ["sdk/yi4k_1107_owned_mux.h", "sdk/yi4k_1107_early_copy.h",
    "sdk/yi4k_1107_audio_early_copy.h", "sdk/yi4k_1107_audio_event.h",
    "sdk/yi4k_1107_payload_copy.h", "sdk/yi4k_1107_video_descriptor.h"]]
CASES = ["video_callback_copy_relocate_source_reuse", "audio_callback_copy_relocate_source_reuse",
    "wrapping_source_is_contiguous_owned", "last_slot_exact_arena_end_and_queue_wrap",
    "held_packet_retains_backpressure_and_bytes", "success_releases_once_and_advances",
    "writer_error_holds_and_poisons", "success_without_payload_completion_holds_and_poisons",
    "invalid_completion_receipt_holds_and_poisons", "empty_finish_does_not_poison",
    "video_raw_eos_normalized_without_payload", "audio_owned_eos_without_payload",
    "wrong_stream_kind_fails_closed", "corrupt_owned_length_rejected", "copied_length_mismatch_rejected",
    "wrong_track_type_rejected", "invalid_flags_rejected", "false_terminal_rejected",
    "arena_one_byte_short_rejected_atomic_init", "cpu_end_overflow_rejected",
    "source_cpu_alias_rejected", "overlapping_slot_allocations_rejected",
    "external_release_violation_stops_finish", "null_control_arguments",
    "corrupt_video_eos_type_rejected", "corrupt_video_eos_flags_rejected",
    "corrupt_video_eos_copy_spans_rejected"]


def sha(b):
    return hashlib.sha256(b).hexdigest()


def load_sections(m, elf):
    m.mem_map(0x10030000, 0x20000)
    for section in elf.iter_sections():
        if section["sh_flags"] & 2 and section["sh_size"]:
            assert 0x10030000 <= section["sh_addr"] < section["sh_addr"]+section["sh_size"] <= 0x10050000
            m.mem_write(section["sh_addr"], section.data() if section["sh_type"] != "SHT_NOBITS" else bytes(section["sh_size"]))


class BridgeMachine(stock.WriterMachine):
    def hook(self, uc, address, size, user):
        # Compiled C uses no substituted services. Avoid decoding every C loop
        # iteration's registers in the original firmware service dispatcher.
        if 0x10030000 <= address < 0x10050000:
            return
        super().hook(uc,address,size,user)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output",type=Path,default=OUT,
        help="Validation JSON path (default: retained owned-mux adapter artifact)")
    args=parser.parse_args()
    clang = shutil.which("clang")
    linkers = sorted(Path("/Users/hyc/Library/Android/sdk/ndk").glob("*/toolchains/llvm/prebuilt/*/bin/ld.lld"))
    linker = shutil.which("ld.lld") or (str(linkers[-1]) if linkers else None)
    assert clang and linker
    common = ["-std=c11", "-O2", "-Wall", "-Wextra", "-Werror", "-fno-builtin"]
    flags = ["--target=armv7-none-eabi", "-mcpu=cortex-a9", "-marm", "-mfloat-abi=soft", "-mfpu=none",
        "-ffreestanding", "-fno-stack-protector", "-fno-pic", "-fno-unwind-tables", "-fno-asynchronous-unwind-tables", *common]
    commands, rows, integrations = [], [], []

    def command(args):
        result = subprocess.run(args, capture_output=True, text=True)
        if result.returncode:
            raise RuntimeError(result.stderr)
        commands.append(args)

    with tempfile.TemporaryDirectory(prefix="yi4k-owned-mux-") as temp:
        directory = Path(temp)
        library_path = directory / "mux.dylib"
        command([clang, "-shared", "-fPIC", *common, *map(str, SOURCES), "-o", str(library_path)])
        objects = []
        for source in SOURCES:
            obj = directory / (source.name + ".o")
            objects.append(str(obj))
            command([clang, *flags, "-c", str(source), "-o", str(obj)])
        script = directory / "mux.ld"
        script.write_text((ROOT / "sdk/offline/yi4k_payload_copy_emulation.ld").read_text().replace(
            "ENTRY(yi4k_1107_copy_payload)", "ENTRY(yi4k_owned_mux_test)"))
        target = directory / "mux.elf"
        command([linker, "-T", str(script), *objects, "-o", str(target)])
        blob = target.read_bytes()
        elf = ELFFile(io.BytesIO(blob))
        symbols = list(elf.get_section_by_name(".symtab").iter_symbols())
        assert not any(s.name and s["st_shndx"] == "SHN_UNDEF" for s in symbols)
        assert not any(s["sh_type"] in ("SHT_REL", "SHT_RELA") and s["sh_size"] for s in elf.iter_sections())
        functions = {s.name:dict(address=s["st_value"],bytes=s["st_size"]) for s in symbols if s["st_info"]["type"] == "STT_FUNC"}
        globals_ = {s.name:s["st_value"] for s in symbols if s["st_info"]["type"] == "STT_OBJECT"}
        library = ct.CDLL(str(library_path))
        test = library.yi4k_owned_mux_test
        test.argtypes, test.restype = [ct.c_uint32], ct.c_int
        host_report = (ct.c_uint32 * 16).in_dll(library, "yi4k_owned_mux_test_report")
        for index, name in enumerate(CASES):
            status = test(index)
            assert status == 0, (name,"host",status)
            host_words = list(host_report)
            m = Uc(UC_ARCH_ARM, UC_MODE_ARM)
            load_sections(m, elf)
            m.mem_map(0x23000000, 0x10000)
            m.reg_write(UC_ARM_REG_CPSR,0x13)
            saved = {r:0x41230000+i*0x1234 for i,r in enumerate((UC_ARM_REG_R4,UC_ARM_REG_R5,
                UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11))}
            for r,v in saved.items(): m.reg_write(r,v)
            m.reg_write(UC_ARM_REG_R0,index)
            m.reg_write(UC_ARM_REG_SP,0x23008000)
            m.reg_write(UC_ARM_REG_LR,0x1004FF00)
            m.emu_start(functions["yi4k_owned_mux_test"]["address"],0x1004FF00,count=2000000)
            assert m.reg_read(UC_ARM_REG_PC)==0x1004FF00 and m.reg_read(UC_ARM_REG_R0)==0, (name,"compiled ARM",m.reg_read(UC_ARM_REG_R0))
            assert m.reg_read(UC_ARM_REG_SP)==0x23008000
            assert all(m.reg_read(r)==value for r,value in saved.items())
            arm_words=list(struct.unpack("<16I",m.mem_read(globals_["yi4k_owned_mux_test_report"],64)))
            assert arm_words==host_words,(name,arm_words,host_words)
            rows.append(dict(name=name,host_status=status,compiled_arm_status=0,report=arm_words,
                host_and_arm_match=True,callee_saved_and_sp_preserved=True))

        image=stock.life.arm.IMAGE.read_bytes()
        assert sha(image)==stock.life.arm.DIGEST
        video,nals,audio,sample_source=stock.load_archived_samples()
        for is_video,data in [(True,video),(False,audio)]:
            for failure in ("none","source_wrap","short_write","post_payload_index","commit"):
                m=BridgeMachine(image)
                load_sections(m.uc,elf)
                track=m.movie(video=True,audio=not is_video)+(0 if is_video else 0x90)
                offset=stock.CAPACITY-7 if failure=="source_wrap" else 32
                first=min(len(data),stock.CAPACITY-offset)
                m.uc.mem_write(stock.ORIGINAL+offset,data[:first])
                m.uc.mem_write(stock.ORIGINAL,data[first:])
                # Execute the newly COMPILED C: bounded source copy, owned SPSC
                # publication, private descriptor relocation and packet prepare.
                prepared=m.call(functions["yi4k_owned_mux_bridge_seed"]["address"],1 if is_video else 2,len(data),offset)
                assert prepared==1
                report=globals_["yi4k_mux_bridge_result"]
                desc_ptr,base,end,source_ptr,head,tail,*_=struct.unpack("<8I",m.uc.mem_read(report,32))
                desc=bytes(m.uc.mem_read(desc_ptr,32))
                pointer,length=struct.unpack_from("<II",desc,0x14)
                assert pointer==stock.OWNED+128 and length==len(data)
                assert source_ptr==stock.ORIGINAL+offset and head==0 and tail==1
                assert bytes(m.uc.mem_read(pointer,length))==data
                m.uc.mem_write(stock.ORIGINAL,b"\xEE"*stock.CAPACITY)
                # Synthetic stock virtual FIFO, now populated exclusively from
                # the C adapter output, not hand-constructed descriptor fields.
                m.put(stock.life.VIRTUAL+0x90,0,8)
                m.put(stock.life.VIRTUAL+0x98,1,8)
                m.uc.mem_write(stock.life.QUEUE,desc)
                m.put(track+0x34,base)
                m.put(track+0x38,end)
                assert (base,end)==(stock.OWNED,stock.OWNED+stock.CAPACITY)
                reads=dict(owned=0,source=0)
                def on_read(uc,access,address,size,value,user):
                    if pointer <= address < pointer+length: reads["owned"]+=1
                    if stock.ORIGINAL <= address < stock.ORIGINAL+stock.CAPACITY: reads["source"]+=1
                hook=m.uc.hook_add(UC_HOOK_MEM_READ,on_read)
                if failure=="short_write": m.short_write_at=1 if is_video else 0
                if failure=="post_payload_index": m.index_failure_kind=2 if is_video else 8
                if failure=="commit": m.commit_failure=-12
                if is_video:
                    status=m.call(0xA042D0F8,stock.MOVIE,track,stock.PARAMS,stock.INDEX,stock.STREAM,60000,0xFFFFFFFF,0xFFFFFFFF)
                else:
                    status=m.call(0xA043173C,stock.MOVIE,track,stock.INDEX,stock.STREAM,0,60000,0xFFFFFFFF,0xFFFFFFFF)
                m.uc.hook_del(hook)
                # Raw AAC helper passes the owned pointer to the stream method;
                # it need not CPU-load the payload itself. The explicit stream
                # model reads it via the emulator API, outside CPU read hooks.
                stream_owned_bytes=sum(w["returned_bytes"] for w in m.writes
                    if pointer <= int(w["source_address"],16) < pointer+length)
                assert stream_owned_bytes>0 and reads["source"]==0
                if is_video: assert reads["owned"]>0
                success=failure in ("none","source_wrap")
                assert (status==0)==success
                expected=(struct.pack(">I",len(nals[-1]))+nals[-1]) if is_video else audio
                assert bytes(m.output)==(expected[:-1] if failure=="short_write" else expected)
                stock_cursor=m.get(stock.life.VIRTUAL+0x90,8)
                assert stock_cursor==(1 if success or failure=="commit" else 0)
                # Capture-stream model copied bytes synchronously and retains no
                # pointer. That is the EXPLICIT use_complete receipt; no claim
                # that a real SD/DMA implementation has the same contract.
                finished=m.call(functions["yi4k_owned_mux_bridge_complete"]["address"],status&0xFFFFFFFF,1)
                assert finished==(7 if success else 3)
                _,_,_,_,owned_head,_,poisoned,_=struct.unpack("<8I",m.uc.mem_read(report,32))
                assert owned_head==(1 if success else 0) and poisoned==int(not success)
                if not success:
                    # Even after stock removed its descriptor on Commit error,
                    # the source owned slot cannot be released or retried here.
                    assert m.call(functions["yi4k_1107_owned_mux_prepare"]["address"],globals_["yi4k_mux_bridge_consumer"])==3
                integrations.append(dict(name=("video" if is_video else "audio")+"_"+failure,
                    compiled_c_prepare_status=prepared,source_ring_overwritten_before_writer=True,
                    source_descriptor_address=hex(source_ptr),relocated_address=hex(pointer),
                    track_bounds=[hex(base),hex(end)],original_writer_status=status,
                    stock_virtual_read_cursor_after=stock_cursor,compiled_c_finish_status=finished,
                    early_queue_head_after=owned_head,poisoned=bool(poisoned),
                    output_bytes=len(m.output),output_sha256=sha(m.output),
                    writer_owned_memory_reads=reads["owned"],writer_original_source_memory_reads=reads["source"],
                    modeled_stream_bytes_copied_from_owned_address=stream_owned_bytes,
                    original_writer_trace=m.trace,index_models=m.index_events))

        result=dict(evidence_type="New C relocation/lifetime adapter on host and compiled ARM, connected to pinned original ARM consumers with explicit stream/index/OS models",
            host_cases=len(rows),compiled_arm_cases=len(rows),original_arm_integration_cases=len(integrations),
            results=rows,original_arm_integrations=integrations,
            image_sha256=stock.life.arm.DIGEST,sample_source=sample_source,
            build=dict(commands=commands,clang_version=subprocess.check_output([clang,"--version"],text=True).splitlines()[0],
                linker_version=subprocess.check_output([linker,"--version"],text=True).strip(),
                arm_elf_sha256=sha(blob),undefined_symbols=0,linked_relocations=0,functions=functions,
                source_sha256={str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in SOURCES},
                header_sha256={str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in HEADERS}),
            original_arm_harness_sha256=sha((ROOT/"scripts/audit_prerecord_owned_mux_writer.py").read_bytes()),
            validation_script_sha256=sha(Path(__file__).read_bytes()),
            limitations=["No device access, firmware installation, hook registration or RTOS scheduling.",
                "Only metadata/owned mapping and fail-stop handoff; codec configuration, epoch, sync selection and PTS rebasing remain external.",
                "Original stock virtual FIFO is synthetic RAM; stream/index/OS services remain explicit models.",
                "Archived finalized MP4 samples are not raw encoder FIFO or SPS/PPS repetition evidence.",
                "No complete MP4 file/index open/close, recovery, SD/DMA ownership proof, audio/video epoch or one-minute spool.",
                "Use-complete receipts are caller attestations; C cannot prove a real writer stopped retaining the pointer."],
            device_access=False,camera_prerecord_implemented=False)
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,indent=2)+"\n")
    print(json.dumps(dict(output=str(args.output),host_cases=len(rows),compiled_arm_cases=len(rows),original_arm_integration_cases=len(integrations))))


if __name__=="__main__":
    main()
