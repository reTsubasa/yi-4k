#!/usr/bin/env python3
"""Trace original video FIFO reclaim into BitsMgr byte retirement, offline only.

The existing lifecycle fixture models locks/queue sends/logs, but WriteEntry,
RemoveEntry, the bounded FIFO worker branch, the video FIFO callback, BitsMgr
ConsumeBitstream/GetUsedSpace and callback registration execute original ARM.
No camera, real DSP, payload overwrite, cache operation or SD I/O is exercised.
"""
from __future__ import annotations

import hashlib
import importlib.util
import json
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn.arm_const import UC_ARM_REG_R7, UC_ARM_REG_SP

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("fifo_life", ROOT / "scripts/prerecord-fifo-lifecycle.py")
life = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(life)
OUT = ROOT / "artifacts/device/2026-11-11-prerecord-payload-reclaim/audit.json"
SRC = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled"
CTRL, BASEQ, INFO, PAYLOAD = 0xA19C7A08, 0x10009000, 0x1000B000, 0x1000E000


def sha(data):
    return hashlib.sha256(data).hexdigest()


def new_machine(image, threshold=4000, remove_on_write=1, pending=2, payload_bounds=True):
    m = life.Machine(image)
    m.existing(100, 100 + pending, 128)
    m.uc.mem_map(0xA19C7000, 0x2000)
    for off, value, size in [(0x80, BASEQ, 4), (0x84, 4096, 4), (0x88, 128, 4),
        (0x90, 100, 8), (0x98, 100 + pending, 8), (0xb0, remove_on_write, 1),
        (0xb8, PAYLOAD if payload_bounds else 0, 4),
        (0xbc, PAYLOAD + 4095 if payload_bounds else 0, 4),
        (0xb4, threshold, 4), (0xa4, 0xA046E3E0, 4)]:
        m.put(life.BASE_FIFO + off, value, size)
    m.put(0xA19CA388, life.BASE_FIFO)
    m.put(0xA19C9EC0 + 0x44, 0, 1)  # primary stream
    m.put(0xA19C9EC0 + 0x88, 1, 1)  # first BitsMgr bank
    for i in range(pending + 1):
        descriptor = BASEQ + ((100 + i) % 128) * 32
        m.put(descriptor + 0x14, PAYLOAD + (i * 512) % 4096)
        m.put(descriptor + 0x18, 512)
        m.put(descriptor + 0x10, 1, 1)
        if i < pending:
            m.uc.mem_write(life.QUEUE + ((100 + i) % 128) * 32,
                bytes(m.uc.mem_read(descriptor, 32)))
    for off, value, size in [(0x5c, INFO, 4), (0x60, INFO + 3 * 48, 4),
        (0x58, INFO, 4), (0x64, INFO, 4), (0x68, INFO, 4), (0x6c, INFO, 4),
        (0x70, 4, 4), (0x38, 1024, 8), (0x40, 0, 8),
        (0x34, 1, 2), (0x50, 4096, 4), (0x58, INFO, 4)]:
        m.put(CTRL + off, value, size)
    for i in range(4):
        m.put(INFO + i * 48 + 4, 0)
        m.put(INFO + i * 48 + 0x10, 1000 + i, 8)
        m.put(INFO + i * 48 + 0x18, PAYLOAD + i * 512)
        m.put(INFO + i * 48 + 0x24, 512)
    m.put(life.CONFIG + 0x14, PAYLOAD + 1024)
    m.put(life.CONFIG + 0x18, 512)
    m.put(life.CONFIG + 0x10, 1, 1)
    m.uc.mem_write(PAYLOAD, bytes([0x5a]) * 4096)
    return m


def run_worker_message(m, words):
    # The real task loops forever. Supply one received message and the known
    # task-local preconditions, run dispatch through its return-to-receive edge.
    task_sp = life.arm.STACK - 0x100
    m.uc.reg_write(UC_ARM_REG_SP, task_sp)
    m.uc.reg_write(UC_ARM_REG_R7, life.GLOBAL)
    for i, value in enumerate(words):
        m.put(task_sp + 0x40 + i * 4, value)
    life.arm.run(m.uc, 0xA044F0C0, 0xA044F0A8)


def messages(m):
    return [event["message_words"] for event in m.events if event["kind"] == "send_message_model"]


def snapshot(m):
    return dict(base_read=m.get(life.BASE_FIFO + 0x90, 8),
        base_write=m.get(life.BASE_FIFO + 0x98, 8),
        virtual_read=m.get(life.VIRTUAL + 0x90, 8),
        held_virtual_payload=hex(m.get(life.QUEUE + (100 % 128) * 32 + 0x14)),
        bits_retired_bytes=m.get(CTRL + 0x40, 8),
        bits_head=hex(m.get(CTRL + 0x58)),
        first_metadata_payload=hex(m.get(INFO + 0x18)))


def main():
    image = life.arm.IMAGE.read_bytes()
    assert sha(image) == life.arm.DIGEST
    assert int.from_bytes(image[0xA0460E54-life.arm.BASE:0xA0460E58-life.arm.BASE], "little") == CTRL
    cases = []

    # Holding a virtual head does not pin video producer reclaim at that head.
    for threshold, expected_read in [(3000, 100), (4000, 101)]:
        m = new_machine(image, threshold=threshold)
        initial_payload = bytes(m.uc.mem_read(PAYLOAD, 4096))
        assert m.run(0xA0452254, life.BASE_FIFO, life.CONFIG) == 0
        queued = messages(m)
        assert queued[0] == [0x10000000, life.BASE_FIFO, expected_read - 100]
        assert queued[1][:2] == [0x4000002, life.BASE_FIFO]
        assert m.get(life.BASE_FIFO + 0x90, 8) == expected_read
        assert m.get(life.VIRTUAL + 0x90, 8) == 100
        assert m.get(life.QUEUE + (100 % 128) * 32 + 0x14) == PAYLOAD
        after_producer = snapshot(m)
        assert m.get(CTRL + 0x40, 8) == 0  # queue send alone is not retirement
        run_worker_message(m, queued[0])
        assert m.get(CTRL + 0x40, 8) == (expected_read - 100) * 512
        assert m.get(life.VIRTUAL + 0x90, 8) == 100
        assert m.get(life.QUEUE + (100 % 128) * 32 + 0x14) == PAYLOAD
        assert bytes(m.uc.mem_read(PAYLOAD, 4096)) == initial_payload
        assert not any(m.locks.values())
        cases.append(dict(name="producer_threshold_" + str(threshold), threshold=threshold,
            ring_bytes=4096, after_producer=after_producer, after_worker=snapshot(m),
            messages=queued, held_virtual_cursor_did_not_prevent_retirement=expected_read > 100,
            payload_overwrite_simulated=False, payload_bytes_preserved_in_fixture=True))

    # Descriptor reserve removal precedes payload-distance/minimum-cursor loop.
    for pending, removed in [(63, 0), (64, 1), (65, 2)]:
        m = new_machine(image, threshold=0, pending=pending, payload_bounds=False)
        assert m.run(0xA0452254, life.BASE_FIFO, life.CONFIG) == 0
        assert m.get(life.BASE_FIFO + 0x90, 8) == 100 + removed
        assert m.get(life.VIRTUAL + 0x90, 8) == 100
        assert messages(m)[0] == [0x10000000, life.BASE_FIFO, removed]
        cases.append(dict(name="descriptor_reserve_pending_" + str(pending),
            capacity=128, pending_before=pending, removed=removed,
            payload_bounds_disabled_to_isolate_descriptor_branch=True,
            state=snapshot(m), messages=messages(m)))

    for enabled in (0, 1):
        m = new_machine(image, remove_on_write=enabled)
        assert m.run(0xA0451C94, life.VIRTUAL, 1) == 0
        assert m.get(life.VIRTUAL + 0x90, 8) == 101
        assert m.get(CTRL + 0x40, 8) == 0
        if enabled:
            assert not messages(m)
        else:
            assert messages(m) == [[0x4000000, life.VIRTUAL, 1]]
        cases.append(dict(name="virtual_remove_base_b0_" + str(enabled),
            state=snapshot(m), messages=messages(m), immediate_bits_retirement=False))

    # BitsMgr retires only a contiguous marked prefix, with 64-byte rounding.
    m = new_machine(image)
    for i, (stream, length) in enumerate([(1, 65), (0, 128), (0, 0xffffff), (2, 64)]):
        m.put(INFO + i * 48 + 4, stream)
        m.put(INFO + i * 48 + 0x24, length)
    for stream, expected_bytes, expected_head in [(0, 0, INFO), (1, 256, INFO + 96), (0, 256, INFO + 144)]:
        before = snapshot(m)
        assert m.run(0xA0460C98, stream, 1, 1) == 0
        assert m.get(CTRL + 0x40, 8) == expected_bytes
        assert m.get(CTRL + 0x58) == expected_head
        cases.append(dict(name="bits_retire_prefix_" + str(len(cases)),
            stream=stream, count=1, before=before, after=snapshot(m),
            arithmetic="align_up_64(65)+align_up_64(128)=256; EOS 0xffffff adds zero"))

    # Registration is one callback per stream; it is not a subscriber API.
    for occupied in (False, True):
        m = new_machine(image)
        slot = 0xA19C7A00 + 0x108
        m.put(slot, 0xA046CA94 if occupied else 0)
        status = m.run(0xA04611CC, 0, 1, life.CALLBACK)
        assert status == (-1 if occupied else 0)
        assert m.get(slot) == (0xA046CA94 if occupied else life.CALLBACK)
        cases.append(dict(name="register_occupied_" + str(occupied).lower(),
            status=status, callback_after=hex(m.get(slot)), subscriber_fanout=False))

    # An occupied counter reports accounting, not DMA/payload lease status.
    m = new_machine(image)
    assert m.run(0xA04612BC, 0, 1, life.OUTPUT, life.OUTPUT + 4) == 0
    before = [m.get(life.OUTPUT), m.get(life.OUTPUT + 4)]
    assert before == [1024, 0]
    assert m.run(0xA0460C98, 0, 1, 1) == 0
    assert m.run(0xA04612BC, 0, 1, life.OUTPUT, life.OUTPUT + 4) == 0
    after = [m.get(life.OUTPUT), m.get(life.OUTPUT + 4)]
    assert after == [512, 0]
    cases.append(dict(name="used_space_tracks_produced_minus_retired", before=before, after=after))

    sources = []
    needles = {
        "a046fecc.c": ["local_5c = 1", "local_74 = 0x2800", "local_6c = matched_FUN_a046e3e0"],
        "a0452254.c": ["local_a4 = (0x41 - *(uint *)(iVar9 + 0x88)) + local_a4", "local_50 = 0x10000000", "local_50 = 0x4000002"],
        "a0451c94.c": ["if ((iVar6 == 0) || (*(char *)(iVar6 + 0xb0) != '\\x01'))"],
        "a046e3e0.c": ["if (param_2 == 0x4000000)", "matched_FUN_a0460c98"],
        "a0460c98.c": ["0xfee1dead", "*(undefined4 *)(uVar4 + 0x18) = 0", "*(int *)(uVar4 + 0x24) + 0x3fU & 0xffffffc0"],
        "a0460754.c": ["matched_analyst_dcache_invalidate", "(*(code *)(&DAT_a19c7a00)[iVar7])(0,0x1f,param_1)"],
        "a04611cc.c": ["if ((&DAT_a19c7a00)[param_1 + 0x42] == 0)", "(&DAT_a19c7a00)[param_1 + 0x42] = param_3"],
        "a04612bc.c": ["*param_3 = iVar3 - iVar4"],
    }
    for name, required in needles.items():
        path = SRC / name
        lines = path.read_text().splitlines()
        assert all(any(needle in line for line in lines) for needle in required), name
        sources.append(dict(path=str(path.relative_to(ROOT)),sha256=sha(path.read_bytes()),
            line_hits={needle:[i for i,line in enumerate(lines,1) if needle in line] for needle in required}))

    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    assertions = []
    for address, mnemonic, operands in [(0xA044F16C,"blx","r3"),
        (0xA044F3DC,"strd","r6, r7, [r5, #0x90]"),
        (0xA044F718,"blx","r3"),(0xA0460D2C,"strdeq","r6, r7, [r3, #0x10]"),
        (0xA0460DB4,"strd","r0, r1, [r4, #0x40]"),
        (0xA0460DB8,"str","lr, [r3, #0x18]")]:
        ins = next(md.disasm(image[address-life.arm.BASE:address-life.arm.BASE+4], address))
        assert (ins.mnemonic, ins.op_str) == (mnemonic, operands)
        assertions.append(dict(address=hex(address),bytes=ins.bytes.hex(),instruction=mnemonic+" "+operands))
    windows = [(0xA0452254,0xA0452B64),(0xA044F0C0,0xA044F438),
        (0xA044F5E8,0xA044F628),(0xA044F6E4,0xA044F748),
        (0xA046E3E0,0xA046E4B0),(0xA0460C98,0xA0460E54)]
    result = dict(audit="prerecord_payload_reclaim",image_sha256=life.arm.DIGEST,
        evidence_type="Original ARM executed with constructed RAM; bounded worker dispatch plus explicit existing external models",
        original_arm_cases=len(cases), cases=cases, source_checks=len(sources),sources=sources,
        assertions=assertions,
        windows=[dict(start=hex(lo),end_exclusive=hex(hi),sha256=sha(image[lo-life.arm.BASE:hi-life.arm.BASE])) for lo,hi in windows],
        dependency=dict(path="scripts/prerecord-fifo-lifecycle.py",sha256=sha((ROOT / "scripts/prerecord-fifo-lifecycle.py").read_bytes())),
        sequence=["BitsMgr Obtain updates produced byte count, conditionally invalidates cache, records event, unlocks, calls single callback event 0x1f",
            "Video FrameDesc callback calls WriteEntry; enabled RemoveOnWrite can advance base read while virtual read remains held",
            "WriteEntry queues 0x10000000 retirement count before 0x4000002 data-ready message",
            "FIFO worker retirement message calls base callback event 0x4000000 under base write mutex",
            "VideoEnc_BitstreamFifoHandler calls BitsMgr_ConsumeBitstream(stream,bank,count)",
            "BitsMgr marks stream entries 0xfee1dead; retires only contiguous prefix; increments retired bytes by aligned64 length excluding EOS; clears metadata payload pointer"],
        candidate_backend_interface=dict(status="offline_design_only_not_bound_or_device_ready",
            hook="single BitsMgr stream callback wrapper, before chaining existing video FrameDesc callback",
            method="copy_ready_video_event(event, cpu_ring_bounds, owned_nonblocking_sink)",
            preconditions=["safe callback installation before producer start with original callback retained", "known CPU ring bounds and stock cache invalidation decision", "preallocated bounded owner storage", "measured hardware copy deadline and DMA/cache stability"],
            operation_order=["copy transient event metadata", "exclude EOS", "validate address/length and wrap", "copy payload into owned storage", "publish owned frame", "chain original callback exactly once on every path"],
            constraints=["do not block encoder callback on SD/network I/O", "do not advance base cursor, call BitsMgr Consume or free encoder addresses", "overflow records a gap/fails pre-record explicitly while stock path continues", "one-minute retention belongs to owned spool storage after immediate copy"],
            blockers=["stock Register cannot add a second observer when slot is already occupied", "no hardware proof that callback entry grants stable payload lifetime for whole copy", "payload ring size and worst-case transfer budget unmeasured", "audio equivalent copy/retire path and A/V epoch still unproven"]),
        conclusions=dict(held_virtual_descriptor_is_not_payload_lease=True,
            video_remove_on_write_bypasses_virtual_remove_messages=True,
            real_fifo_worker_to_bitsmgr_retirement_chain_executed_offline=True,
            one_minute_descriptor_only_history_rejected=True,
            owned_payload_copy_before_retirement_required=True,
            actual_dsp_overwrite_or_copy_deadline_proven=False,camera_pre_record_implemented=False),
        limitations=["All initial FIFO/metadata/global states and queue messages are synthetic; actual camera configuration and scheduler are not observed.",
            "The bounded task starts after queue receive and stops before next receive; lock, message, diagnostic and allocation functions are explicit fixture models.",
            "Retired byte accounting and metadata invalidation do not prove when hardware overwrites payload; the fixture intentionally preserves payload bytes.",
            "Real BitsMgr Obtain/cache invalidation and DSP hardware are statically traced, not executed here.",
            "No Android/roadmap changes, camera connections, device writes, hidden setters or firmware execution."],
        safety=dict(camera_connected=False,device_written=False,hardware_executed=False))
    OUT.parent.mkdir(parents=True,exist_ok=True)
    OUT.write_text(json.dumps(result,indent=2,ensure_ascii=False)+"\n")
    print(json.dumps(dict(output=str(OUT.relative_to(ROOT)),original_arm_cases=len(cases),source_checks=len(sources),instruction_assertions=len(assertions),status="passed")))


if __name__ == "__main__":
    main()
