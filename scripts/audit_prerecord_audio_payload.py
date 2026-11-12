#!/usr/bin/env python3
"""Offline original ARM audio payload producer -> FIFO -> retirement audit.

Reuses the existing FIFO fixture's explicit mutex, queue-send and log models.
PCM conversion, callback selection/dispatch, metadata and FIFO handling, chunk
allocation and the bounded retirement worker path execute pinned ARM bytes.
AAC codec execution is explicitly modeled only in the separate wrapper case.
"""
from __future__ import annotations

import hashlib
import importlib.util
import json
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("audio_fifo_life", ROOT / "scripts/prerecord-fifo-lifecycle.py")
life = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(life)
OUT = ROOT / "artifacts/device/2026-11-11-prerecord-audio-payload/audit.json"
SRC = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled"
HANDLE, STATE, GRAPH = 0x10000000, 0x10002000, 0x10005000
INPUT, CONTROL, PCM_CFG, EVENT_TABLE = 0x10006000, 0x10007000, 0x10007200, 0x10007400
CALLBACKS, PACKET, BASEQ, META, PAYLOAD = 0x10007500, 0x10007600, 0x10009000, 0x1000B000, 0x10012000
AUDIO = 0xA19C7250
OBSERVER = life.CALLBACK


def sha(data):
    return hashlib.sha256(data).hexdigest()


def chunk_for(fmt):
    return 0x600 if fmt in (0x10, 0x11, 0x12) else 0x800 if fmt in (0x20, 0x40, 0x50) else 0x2000


class AudioMachine(life.Machine):
    def __init__(self, image, fmt=0, chunks=3, spare=0, metadata_entries=8):
        super().__init__(image)
        self.uc.mem_map(0xA19C7000, 0x2000)
        self.trace = []
        self.observed = []
        self.aac_model = None
        self.existing(0, 0, 128)
        chunk = chunk_for(fmt)
        capacity = chunk * chunks + spare
        self.chunk, self.capacity = chunk, capacity
        for off, value, n in [(0x08, AUDIO, 4), (0x80, BASEQ, 4), (0x84, 128 * 32, 4),
            (0x88, 128, 4), (0x90, 0, 8), (0x98, 0, 8), (0xA4, 0xA045CF84, 4),
            (0xB0, 1, 1), (0xB4, 0, 4), (0xB8, PAYLOAD, 4), (0xBC, PAYLOAD + capacity - 1, 4)]:
            self.put(life.BASE_FIFO + off, value, n)
        self.put(life.VIRTUAL + 8, AUDIO)
        self.put(life.VIRTUAL + 0xC0, 0xFF)
        for off, value, n in [(0x08, 1, 1), (0x0C, GRAPH, 4), (0x10, 4, 1),
            (0x4C, fmt, 1), (0x88, PAYLOAD, 4), (0x8C, capacity, 4),
            (0x90, META, 4), (0x94, metadata_entries * 32, 4),
            (0x98, capacity, 4), (0xA8, life.BASE_FIFO, 4),
            (0xB0, 0, 8), (0xB8, 0, 8), (0xC0, 0, 4), (0xC4, 0, 4),
            (0xC8, 0, 4), (0xCC, META, 4), (0xD0, META, 4),
            (0xD4, META + (metadata_entries - 1) * 32, 4)]:
            self.put(AUDIO + off, value, n)
        self.put(GRAPH + 4, HANDLE)
        self.put(GRAPH + 0x60, PACKET)
        self.put(HANDLE + 0x178, EVENT_TABLE)
        self.put(HANDLE + 0x188, STATE)
        self.put(EVENT_TABLE, 2)
        self.put(EVENT_TABLE + 4, CALLBACKS)
        self.put(CALLBACKS, 0xA045E7DC)
        self.put(CALLBACKS + 4, 0)
        for off, value, n in [(0x10, 1024, 4), (0x14, 2, 4), (0x20, 0, 4),
            (0x24, 90000, 4), (0x2C, 48000, 4), (0x30, PCM_CFG, 4),
            (0x34, CONTROL, 4), (0x38, fmt, 1), (0x40, INPUT, 4), (0x44, 0xA045D690, 4)]:
            self.put(STATE + off, value, n)
        self.put(PCM_CFG, 16)
        self.put(PCM_CFG + 4, 0)  # keep high16 of native 32-bit samples, little endian
        self.put(PCM_CFG + 8, 4)
        self.samples = [0x31000000 + i * 0x10101 + 0x1234 for i in range(8)]
        self.uc.mem_write(INPUT, struct.pack("<8I", *self.samples))
        self.uc.mem_write(PAYLOAD, bytes([0xDD]) * capacity)

    def audio_event(self, address):
        return dict(address=hex(address), encoder=hex(self.get(address)),
            opaque_04=hex(self.get(address + 4)), pts=self.get(address + 8, 8),
            eos=self.get(address + 0x10), size=self.get(address + 0x14),
            payload=hex(self.get(address + 0x18)), opaque_1c=hex(self.get(address + 0x1C)))

    def hook(self, uc, address, size, user):
        # Parent constructor installs this override; audio fields exist before
        # the first emulation begins, so the inherited hook remains usable.
        if address == OBSERVER:
            event = self.audio_event(uc.reg_read(UC_ARM_REG_R0))
            event.update(name="second_observer", fifo_write=self.get(life.BASE_FIFO + 0x98, 8),
                locks_held=[hex(k) for k, v in self.locks.items() if v > 0])
            self.observed.append(event)
            self.trace.append(event)
            uc.reg_write(UC_ARM_REG_R0, 0xFFFFFFA5)  # dispatcher ignores callback status
            uc.reg_write(UC_ARM_REG_PC, uc.reg_read(UC_ARM_REG_LR))
            return
        if address == 0xA045E7DC:
            event = self.audio_event(uc.reg_read(UC_ARM_REG_R0))
            event.update(name="stock_audio_callback_entry", fifo_write=self.get(life.BASE_FIFO + 0x98, 8))
            self.trace.append(event)
        if address == 0xA0452254:
            pointer = uc.reg_read(UC_ARM_REG_R1)
            self.trace.append(dict(name="fifo_write_entry", descriptor_hex=bytes(uc.mem_read(pointer, 32)).hex()))
        if address == 0xA045CF84:
            self.trace.append(dict(name="audio_fifo_callback_entry", event=hex(uc.reg_read(UC_ARM_REG_R1))))
        if address == 0xA0255FFC and self.aac_model is not None:
            control = uc.reg_read(UC_ARM_REG_R0)
            assert self.get(control + 0x38) == self.get(STATE + 0x3C)
            assert self.get(control + 0x3C) == INPUT
            self.put(control + 0x30, 0)
            self.put(control + 0x34, self.aac_model)
            self.trace.append(dict(name="aac_codec_explicit_model", output_bits=self.aac_model))
            uc.reg_write(UC_ARM_REG_PC, uc.reg_read(UC_ARM_REG_LR))
            return
        super().hook(uc, address, size, user)

    def producer(self, eos=0, poison=0xBAD055AA):
        self.uc.reg_write(UC_ARM_REG_CPSR, 0x13)
        self.uc.reg_write(UC_ARM_REG_SP, life.arm.STACK)
        self.uc.reg_write(UC_ARM_REG_R4, STATE)
        self.uc.reg_write(UC_ARM_REG_R10, HANDLE)
        self.uc.reg_write(UC_ARM_REG_R8, GRAPH)
        self.put(PACKET + 0x16, eos << 6, 2)
        # UpdateBitsBuf allocates 0x48 bytes; the event starts at SP-0x40.
        # Deliberately poison its two unwritten words before this real caller
        # chain. Earlier callees may use this same stack, so the direct event
        # fixture below is the authoritative untouched-word test.
        self.uc.mem_write(life.arm.STACK - 0x500, struct.pack("<I", poison) * (0x500 // 4))
        life.arm.run(self.uc, 0xA02906E8, 0xA0290714)
        assert self.uc.reg_read(UC_ARM_REG_SP) == life.arm.STACK
        assert not any(self.locks.values())


def messages(m):
    return [e["message_words"] for e in m.events if e["kind"] == "send_message_model"]


def worker(m, words):
    stack = life.arm.STACK - 0x600
    m.uc.reg_write(UC_ARM_REG_CPSR, 0x13)
    m.uc.reg_write(UC_ARM_REG_SP, stack)
    m.uc.reg_write(UC_ARM_REG_R7, life.GLOBAL)
    for i, word in enumerate(words):
        m.put(stack + 0x40 + 4 * i, word)
    life.arm.run(m.uc, 0xA044F0C0, 0xA044F0A8)
    assert not any(m.locks.values())


def main():
    image = life.arm.IMAGE.read_bytes()
    assert sha(image) == life.arm.DIGEST
    cases = []

    # Real callback registration uses the second free slot, not a video-style
    # exclusive registration. It also reports success if both slots are full.
    for label, initial, target, expected in [
        ("add_observer", [0xA045E7DC, 0], OBSERVER, [0xA045E7DC, OBSERVER]),
        ("duplicate", [0xA045E7DC, 0], 0xA045E7DC, [0xA045E7DC, 0]),
        ("full_reports_success", [0xA045E7DC, OBSERVER], OBSERVER + 4, [0xA045E7DC, OBSERVER]),
    ]:
        m = AudioMachine(image)
        for i, v in enumerate(initial):
            m.put(CALLBACKS + i * 4, v)
        status = m.run(0xA02955C0, HANDLE, 0, target)
        actual = [m.get(CALLBACKS + i * 4) for i in range(2)]
        assert status == 0 and actual == expected, (label, status, actual)
        assert not any(m.locks.values())
        cases.append(dict(name="registration_" + label, status=status,
            callbacks_before=list(map(hex, initial)), callbacks_after=list(map(hex, actual))))

    # Whole original PCM generation -> task-local event -> dispatcher -> stock
    # high-level callback -> FIFO. The observer runs AFTER stock WriteEntry.
    m = AudioMachine(image)
    assert m.run(0xA02955C0, HANDLE, 0, OBSERVER) == 0
    m.producer()
    expected = b"".join(struct.pack("<H", v >> 16) for v in m.samples)
    assert m.get(STATE + 0x1C) == 16
    assert bytes(m.uc.mem_read(PAYLOAD, 16)) == expected
    assert m.get(AUDIO + 0xB0, 8) == 0x2000
    assert m.get(AUDIO + 0xE0, 8) == 16  # byte statistics, separate from reserved accounting
    desc = bytes(m.uc.mem_read(BASEQ, 32))
    assert struct.unpack_from("<I", desc, 0x14)[0] == PAYLOAD
    assert struct.unpack_from("<I", desc, 0x18)[0] == 16
    assert desc[0x10:0x12] == b"\x08\x01"
    assert m.get(META + 0x14) == 16 and m.get(META + 0x18) == PAYLOAD
    assert [t["name"] for t in m.trace] == ["stock_audio_callback_entry", "fifo_write_entry", "second_observer"]
    assert m.observed[0]["fifo_write"] == 1
    assert m.observed[0]["locks_held"] == [hex(HANDLE + 0x100)]
    cases.append(dict(name="original_pcm_task_through_fifo_and_late_observer", trace=m.trace,
        payload_hex=expected.hex(), fifo_descriptor_hex=desc.hex(),
        reserved_bytes=m.get(AUDIO + 0xB0, 8), actual_payload_bytes=m.get(AUDIO + 0xE0, 8),
        messages=messages(m), codec_and_callback_and_fifo_original_arm=True))

    # Earliest general observer requires pre-stock ordering, supplied here as a
    # constructed callback table, not an installer or an authorized device patch.
    m = AudioMachine(image)
    m.put(CALLBACKS, OBSERVER)
    m.put(CALLBACKS + 4, 0xA045E7DC)
    m.producer()
    assert m.observed[0]["fifo_write"] == 0
    assert [t["name"] for t in m.trace] == ["second_observer", "stock_audio_callback_entry", "fifo_write_entry"]
    cases.append(dict(name="constructed_early_slot_precedes_stock_write", trace=m.trace,
        installation_tested=False, callback_table_precondition_constructed=True))

    # Distinguish actual event fields from two stale stack words. Full event
    # metadata copy preserves them; they are NOT reliable codec metadata.
    for poison in (0xBAD055AA, 0x51667788):
        m = AudioMachine(image)
        m.put(STATE + 0x3C, PAYLOAD)
        m.put(STATE + 0x1C, 16)
        m.uc.mem_write(life.arm.STACK - 0x48, struct.pack("<I", poison) * (0x48 // 4))
        assert m.run(0xA029016C, HANDLE, 0) == 0
        event = m.trace[0]
        assert event["opaque_04"] == hex(poison) and event["opaque_1c"] == hex(poison)
        assert m.get(META + 4) == poison and m.get(META + 0x1C) == poison
        cases.append(dict(name="uninitialized_event_words_" + hex(poison), event=event,
            metadata_copies_stale_words=True, event_semantic_fields_exclude_offsets=["0x04", "0x1c"]))

    # Pointer allocation and byte retirement use one fixed chunk per ordinary
    # frame; actual encoded length is deliberately unequal (13 bytes).
    for fmt in (0x10, 0x11, 0x12, 0x20, 0x40, 0x50, 0):
        m = AudioMachine(image, fmt=fmt, spare=17)
        addresses = [m.run(0xA045D690, HANDLE) for _ in range(4)]
        chunk = chunk_for(fmt)
        assert addresses == [PAYLOAD, PAYLOAD + chunk, PAYLOAD + chunk * 2, PAYLOAD]
        assert m.get(AUDIO + 0xC0) == 1
        assert m.get(AUDIO + 0xC4) == 0 and m.get(AUDIO + 0xB8, 8) == 0
        # Feed an event using the original high callback, then force one worker
        # retirement message to exercise the actual audio callback and counters.
        event = life.CONFIG
        for off, v, n in [(0, HANDLE, 4), (8, 777, 8), (0x10, 0, 4),
            (0x14, 13, 4), (0x18, PAYLOAD, 4)]:
            m.put(event + off, v, n)
        assert m.run(0xA045E7DC, event) == 0
        assert m.get(AUDIO + 0xB0, 8) == chunk
        before = bytes(m.uc.mem_read(PAYLOAD, m.capacity))
        worker(m, [0x10000000, life.BASE_FIFO, 1])
        assert m.get(AUDIO + 0xB8, 8) == chunk
        assert m.get(AUDIO + 0xC4) == 1
        assert m.get(AUDIO + 0xD0) == META + 32
        assert m.get(META + 8, 8) == 0xFEE1DEAD
        assert m.get(META + 0x18) == PAYLOAD  # unlike video, pointer not cleared
        assert bytes(m.uc.mem_read(PAYLOAD, m.capacity)) == before
        cases.append(dict(name="format_chunk_allocation_and_retirement_" + hex(fmt),
            format=hex(fmt), chunk_bytes=chunk, configured_capacity=m.capacity,
            returned_addresses=list(map(hex, addresses)), trailing_unused_bytes=17,
            actual_payload_length=13, produced_reserved_bytes=m.get(AUDIO + 0xB0, 8),
            retired_reserved_bytes=m.get(AUDIO + 0xB8, 8), retired_index=m.get(AUDIO + 0xC4),
            metadata_pts_marker=hex(m.get(META + 8, 8)), metadata_payload_pointer_retained=True,
            producer_wrap_did_not_check_consumer_credit=True, payload_overwrite_simulated=False))

    # End markers do not increment reserved accounting; both stock terminal
    # descriptors are recovered, including the distinct transient 0xfffffe.
    for encode_state, expected_length in [(2, 0xFFFFFF), (5, 0xFFFFFE)]:
        m = AudioMachine(image, fmt=0x10)
        m.put(AUDIO + 9, encode_state, 1)
        m.put(AUDIO + 0xC8, 123)
        for off, v, n in [(0, HANDLE, 4), (8, 987, 8), (0x10, 1, 4),
            (0x14, 13, 4), (0x18, PAYLOAD, 4)]:
            m.put(life.CONFIG + off, v, n)
        assert m.run(0xA045E7DC, life.CONFIG) == 0
        assert m.get(BASEQ + 0x18) == expected_length
        assert m.get(BASEQ + 0x10, 1) == 0xFF and m.get(BASEQ + 0x14) == 0
        assert m.get(AUDIO + 0xB0, 8) == 0
        worker(m, [0x10000000, life.BASE_FIFO, 1])
        assert m.get(AUDIO + 0xB8, 8) == 0 and m.get(AUDIO + 0xC4) == 0
        assert m.get(META + 8, 8) == 0xFEE1DEAD
        cases.append(dict(name="eos_state_" + str(encode_state), fifo_length=hex(expected_length),
            produced_reserved=0, retired_reserved=0, sequence_after=m.get(AUDIO + 0xC8),
            EOS_payload_not_consumed=True))

    # Read metadata wraps independently of payload byte lengths. A zero-byte
    # ordinary event is removed/marked but does not retire its reserved chunk,
    # so it cannot be treated as a successful ordinary frame by a new adapter.
    m = AudioMachine(image, fmt=0x10, metadata_entries=3)
    for index, (length, eos) in enumerate([(13, 0), (0, 0), (13, 1)]):
        for off, v, n in [(0, HANDLE, 4), (8, 100 + index, 8), (0x10, eos, 4),
            (0x14, length, 4), (0x18, PAYLOAD + index * m.chunk, 4)]:
            m.put(life.CONFIG + off, v, n)
        assert m.run(0xA045E7DC, life.CONFIG) == 0
    assert m.get(AUDIO + 0xCC) == META
    assert m.get(AUDIO + 0xB0, 8) == 2 * m.chunk
    worker(m, [0x10000000, life.BASE_FIFO, 3])
    assert m.get(AUDIO + 0xB8, 8) == m.chunk
    assert m.get(AUDIO + 0xD0) == META and m.get(AUDIO + 0xC4) == 1
    assert all(m.get(META + i * 32 + 8, 8) == 0xFEE1DEAD for i in range(3))
    cases.append(dict(name="metadata_wrap_zero_size_and_eos_retirement",
        metadata_slots=3, write_pointer_after=hex(m.get(AUDIO + 0xCC)),
        read_pointer_after=hex(m.get(AUDIO + 0xD0)), removed_metadata=3,
        ordinary_reserved_bytes=2 * m.chunk, retired_bytes=m.chunk,
        zero_size_ordinary_does_not_retire_chunk=True, eos_does_not_retire_chunk=True))

    # EraseAll notification resets counters and metadata cursors, but neither
    # the producer chunk index nor the retire chunk index is reset here.
    m = AudioMachine(image, fmt=0x10)
    for off, value, n in [(0xB0, 0x123456789, 8), (0xB8, 0x12345, 8),
        (0xC0, 2, 4), (0xC4, 1, 4), (0xCC, META + 64, 4), (0xD0, META + 32, 4)]:
        m.put(AUDIO + off, value, n)
    assert m.run(0xA045CF84, life.BASE_FIFO, 0x4000004, 0) == 0
    assert m.get(AUDIO + 0xB0, 8) == m.get(AUDIO + 0xB8, 8) == 0
    assert m.get(AUDIO + 0xCC) == m.get(AUDIO + 0xD0) == META
    assert m.get(AUDIO + 0xC0) == 2 and m.get(AUDIO + 0xC4) == 1
    assert not any(m.locks.values())
    cases.append(dict(name="erase_notification_preserves_chunk_indices",
        produced_reserved=0, retired_reserved=0, metadata_read=hex(META), metadata_write=hex(META),
        producer_index_after=2, retired_index_after=1, full_audio_lifecycle_reset_proven=False))

    # The AAC wrapper passes CPU destination/source and rounds bits up to bytes.
    # The codec itself is an explicit fixture model, NOT real AAC encoding.
    m = AudioMachine(image, fmt=0x10)
    m.aac_model = 101
    m.producer()
    assert m.get(STATE + 0x1C) == 13
    assert m.get(BASEQ + 0x18) == 13
    assert m.get(CONTROL + 0x38) == PAYLOAD and m.get(CONTROL + 0x3C) == INPUT
    cases.append(dict(name="aac_wrapper_destination_and_length_explicit_codec_model",
        output_bits=101, output_bytes=13, trace=m.trace, real_aac_encoding_tested=False))

    # Deliberate actual PCM reuse: four real encoded frames in a three-chunk
    # constructed ring overwrite frame0 while no retire callback was run.
    m = AudioMachine(image)
    first = None
    for index in range(4):
        samples = [0x11110000 + index * 0x1000000 + j * 0x10000 for j in range(8)]
        m.uc.mem_write(INPUT, struct.pack("<8I", *samples))
        m.producer()
        # Invoke the real fan-out function with the full 32B descriptor. The
        # inherited queue-send model intentionally captures only three words,
        # insufficient to reconstruct an embedded data-ready descriptor.
        m.run(0xA044E8D4, life.BASE_FIFO, BASEQ + index * 32)
        if index == 0:
            first = bytes(m.uc.mem_read(PAYLOAD, 16))
    last = bytes(m.uc.mem_read(PAYLOAD, 16))
    assert first != last
    assert m.get(AUDIO + 0xB8, 8) == 0
    assert m.get(life.VIRTUAL + 0x90, 8) == 0
    assert m.get(life.QUEUE + 0x14) == PAYLOAD
    cases.append(dict(name="original_pcm_overwrites_held_virtual_payload_on_chunk_wrap",
        frames=4, chunks=3, first_bytes=first.hex(), overwritten_bytes=last.hex(),
        virtual_read=m.get(life.VIRTUAL + 0x90, 8), retired_bytes=0,
        original_pcm_cpu_writes=True, hardware_aac_or_adc_tested=False))

    sources = []
    for name, needles in {
        "a02902b4.c": ["puVar13[0xf] = uVar4", "matched_FUN_a029024c(param_1)", "matched_FUN_a029016c"],
        "a029024c.c": ["PTR_matched_FUN_a028fce8_a05abf8c", "iVar1 + 0x38"],
        "a029011c.c": ["iVar1 + 0x38", "iVar1 + 0x3c", "matched_FUN_a0255ffc", "+ 7U >> 3"],
        "a029016c.c": ["matched_FUN_a0295800(param_1,0,local_40)"],
        "a0295800.c": ["(*(code *)*puVar3)(param_3)", "iVar2 != iVar1"],
        "a02955c0.c": ["*piVar6 = param_3", "if (iVar4 == iVar1) goto LAB_a0295688"],
        "a045e7dc.c": ["uVar8 = 0x600", "uVar8 = 0x800", "uVar8 = 0x2000", "local_30 = 0xfffffe", "piVar6[7] = iVar2"],
        "a045f204.c": ["local_74 = &DAT_a045cf84", "local_64 = 1", "iVar3,0,2,&DAT_a19c71ac"],
        "a045d690.c": ["iVar5 = 0x600", "iVar5 = 0x800", "iVar5 = 0x2000", "DAT_a19c7310"],
    }.items():
        path = SRC / name
        lines = path.read_text().splitlines()
        assert all(any(needle in line for line in lines) for needle in needles), name
        sources.append(dict(path=str(path.relative_to(ROOT)), sha256=sha(path.read_bytes()),
            line_hits={n:[i for i,l in enumerate(lines,1) if n in l] for n in needles}))

    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    assertions = []
    for address, mnemonic, operands in [
        (0xA02906F4, "str", "r0, [r4, #0x3c]"),
        (0xA02906FC, "bl", "#0xa029024c"),
        (0xA0290710, "bl", "#0xa029016c"),
        (0xA02901D8, "bl", "#0xa0295800"),
        (0xA029586C, "blx", "r3"),
        (0xA045D184, "strd", "sl, fp, [r4, #0xb8]"),
        (0xA045D190, "strd", "r8, sb, [r6, #8]"),
        (0xA045D754, "mla", "r5, r6, r1, r5"),
    ]:
        ins = next(md.disasm(image[address-life.arm.BASE:address-life.arm.BASE+4], address))
        assert (ins.mnemonic, ins.op_str) == (mnemonic, operands)
        assertions.append(dict(address=hex(address), bytes=ins.bytes.hex(), instruction=mnemonic + " " + operands))
    windows = [(0xA02906E8,0xA0290714), (0xA028FCE8,0xA028FE30),
        (0xA029011C,0xA029024C), (0xA029024C,0xA02902B4),
        (0xA02955C0,0xA02956AC), (0xA0295800,0xA02958A0),
        (0xA045CF84,0xA045D264), (0xA045D690,0xA045D7B8),
        (0xA045E7DC,0xA045EC00), (0xA045F378,0xA045F3E4)]
    result = dict(audit="prerecord_audio_payload", image_sha256=life.arm.DIGEST,
        evidence_type="Original ARM with constructed RAM and explicit OS models; PCM is original CPU codec, AAC library is modeled only in labeled case",
        original_arm_cases=len(cases), cases=cases, source_checks=len(sources), sources=sources,
        assertions=assertions, windows=[dict(start=hex(a), end_exclusive=hex(b),
            sha256=sha(image[a-life.arm.BASE:b-life.arm.BASE])) for a,b in windows],
        dependency=dict(path="scripts/prerecord-fifo-lifecycle.py", sha256=sha((ROOT / "scripts/prerecord-fifo-lifecycle.py").read_bytes())),
        event_layout={"0x00":"encoder handle", "0x04":"UNWRITTEN task-stack word; do not interpret",
            "0x08":"u64 task-local synthetic PTS", "0x10":"u32 EOS, stock accepts 0 or 1",
            "0x14":"u32 actual payload bytes", "0x18":"CPU payload pointer",
            "0x1c":"UNWRITTEN task-stack word; do not interpret"},
        sequence=["task calls registered GetWritePointer; obtains base+write_chunk_index*chunk and increments/wraps index without read-credit comparison",
            "task writes pointer into state+0x3c; codec synchronously writes CPU output, stores actual size state+0x1c",
            "UpdateBitsBuf builds stack event; synchronous dispatcher holds encoder event mutex and invokes registered slots in ascending order",
            "stock callback locks all audio instances, stores32B metadata, advances format-reserved accounting and constructs type8 FrameDesc with actual payload length",
            "stock releases audio instance locks then WriteEntry; second registered observer therefore runs after stock FIFO write",
            "FIFO worker retirement event invokes A045CF84; one metadata record per count advances read index and format-reserved retired bytes only if size!=0 and EOS==0",
            "all removed metadata PTS becomes 0x00000000fee1dead; read metadata pointer wraps; payload pointer and bytes remain untouched"],
        conclusions=dict(audio_copy_candidate="synchronous wrapper before stock A045E7DC, or deliberately ordered callback slot before it",
            audio_stock_callback_ABI="int32 callback(const event*) -- not video three-argument ABI",
            secondary_registration_alone_is_not_earliest=True, registration_success_does_not_prove_added=True,
            event_has_two_unwritten_words=True, chunk_wrap_ignores_consumer_credit=True,
            original_pcm_overwrite_of_held_descriptor_demonstrated_offline=True,
            one_minute_retention_requires_owned_payload=True, real_aac_payload_stability_proven=False,
            camera_prerecord_implemented=False),
        external_models=["inherited mutex take/give: bookkeeping, no actual RTOS scheduling",
            "inherited queue send: message capture, no automatic worker thread",
            "inherited printf/FIFO trace suppressed", "second observer: records entry, returns -91",
            "AAC A0255FFC: one explicitly labeled case sets output bit count; does not encode or generate bytes"],
        limitations=["No camera, microphone/ADC, RTOS scheduler, SD writer or device hook executed.",
            "Three-chunk capacities, codec formats, current settings and callback table are synthetic fixture preconditions.",
            "PCM demonstrates original CPU writes and reuse; AAC wrapper execution does not establish real AAC codec timing, output capacity or cache coherence.",
            "Synchronous callback establishes task control-flow order, not a hardware lease against other cores, DMA or producers.",
            "No shared video/audio capture epoch, stable callback installation/uninstallation or one-minute SD spool is implemented."])
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(dict(output=str(OUT.relative_to(ROOT)), original_arm_cases=len(cases), source_checks=len(sources))))


if __name__ == "__main__":
    main()
