#!/usr/bin/env python3
"""Offline, byte-backed 1.10.7 encoder/FIFO/mux audit; no camera access."""
import argparse
import hashlib
import json
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = 0xA0100000
EXPECTED_SHA = "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "artifacts/device/2026-11-10-prerecord/output-contract.json")
    args = parser.parse_args()
    src = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis"
    image = src / "rtos-window.bin"
    blob = image.read_bytes()
    digest = hashlib.sha256(blob).hexdigest()
    if digest != EXPECTED_SHA:
        raise SystemExit("Unexpected RTOS image SHA-256")
    from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
    cs = Cs(CS_ARCH_ARM, CS_MODE_ARM)

    def word(address):
        return struct.unpack_from("<I", blob, address - BASE)[0]

    # Split around the video callback's embedded jump table: those words are data.
    windows = {
        "video_event_dispatch": (0xA046CA94, 0xA046CAB0),
        "video_output_descriptor": (0xA046CAE4, 0xA046CB8C),
        "video_callback_registration": (0xA0470B70, 0xA0470D2C),
        "video_callback_store": (0xA04611CC, 0xA0461240),
        "audio_output_descriptor": (0xA045E7DC, 0xA045ECD0),
        "native_mp4_virtual_fifos": (0xA01F6340, 0xA01F65A0),
        "uvcd_virtual_creator": (0xA0233570, 0xA02335C8),
        "uvcd_virtual_consumer": (0xA0233434, 0xA0233508),
        "uvcd_virtual_stop": (0xA02335D0, 0xA02335F8),
        "fifo_default_config": (0xA04509B0, 0xA04509DC),
        "fifo_create": (0xA04509DC, 0xA04514DC),
        "fifo_write": (0xA0452254, 0xA0452B64),
        "fifo_sync_to_consumers": (0xA044E8D4, 0xA044F05C),
        "fifo_peek": (0xA0451960, 0xA0451B88),
        "fifo_remove": (0xA0451C94, 0xA045202C),
        "iso_video_consumer": (0xA042D0F8, 0xA042D6C4),
        "iso_video_write": (0xA042CE28, 0xA042D0F8),
        "iso_audio_consumer": (0xA043173C, 0xA0431AF8),
        "pts_converter": (0xA03E5B5C, 0xA03E5D10),
        "mux_close_lifecycle": (0xA01F6088, 0xA01F6300),
        "event_mux_close_lifecycle": (0xA01F8F08, 0xA01F90B0),
        "record_button_state": (0xA012C2C8, 0xA012C34C),
        "record_button_stop": (0xA012C3E4, 0xA012C458),
        "h264_command_setup": (0xA02B7454, 0xA02B7914),
        "h264_setup_caller": (0xA02D21C0, 0xA02D2200),
    }
    instructions = {}
    evidence = {}
    for name, (start, end) in windows.items():
        raw = blob[start - BASE:end - BASE]
        ins = list(cs.disasm(raw, start))
        instructions[name] = ins
        # Keep the checked raw window hash, but emit a compact call-site view so
        # the JSON remains reviewable; the full bytes are in the fixed image.
        keep = set(range(min(8, len(ins)))) | set(range(max(0, len(ins) - 8), len(ins)))
        key_targets = {"#0xa0452254", "#0xa0451960", "#0xa0451c94", "#0xa04514e4",
                       "#0xa042ce28", "#0xa03efe74", "#0xa03e627c",
                       "#0xa04509dc", "#0xa02b7454"}
        for n, item in enumerate(ins):
            if item.mnemonic in ("bl", "blx") and item.op_str in key_targets:
                keep.update(range(max(0, n - 8), min(len(ins), n + 9)))
        shown = [ins[n] for n in sorted(keep)]
        evidence[name] = {
            "start": hex(start), "end_exclusive": hex(end),
            "window_sha256": hashlib.sha256(raw).hexdigest(),
            "assembly_compact": [{"address": hex(i.address), "bytes": i.bytes.hex(),
                          "mnemonic": i.mnemonic, "operands": i.op_str} for i in shown],
        }

    def has(name, mnemonic, operands):
        return any(i.mnemonic == mnemonic and i.op_str == operands for i in instructions[name])

    def calls(name, target):
        return [hex(i.address) for i in instructions[name]
                if i.mnemonic == "bl" and i.op_str == f"#{target:#x}"]

    table = [word(0xA046CAB0 + 4 * i) for i in range(13)]
    checks = {
        "video_event_1f_goes_to_descriptor": table[0x1F - 0x16] == 0xA046CAE4,
        "video_output_calls_fifo_write": calls("video_output_descriptor", 0xA0452254) == ["0xa046cb7c"],
        "video_pts_is_64_bit_event_offset_10": has("video_output_descriptor", "ldrd", "r6, r7, [r2, #0x10]"),
        "video_pts_written_at_descriptor_offset_8": has("video_output_descriptor", "strd", "r6, r7, [sp, #0x18]"),
        "video_address_from_event_offset_18": has("video_output_descriptor", "ldr", "r2, [r4, #0x18]"),
        "video_size_from_event_offset_24": has("video_output_descriptor", "ldr", "r1, [r2, #0x24]"),
        "video_type_from_event_offset_1c": has("video_output_descriptor", "ldr", "r2, [r4, #0x1c]"),
        "audio_output_calls_fifo_write": calls("audio_output_descriptor", 0xA0452254) == ["0xa045eaac"],
        "mp4_start_creates_four_virtual_fifos": len(calls("native_mp4_virtual_fifos", 0xA04509DC)) == 4,
        "mp4_virtual_fifo_capacity_8192": sum(i.mnemonic == "mov" and i.op_str == "r2, #0x2000" for i in instructions["native_mp4_virtual_fifos"]) == 4,
        "mp4_virtual_fifo_flag_one": sum(i.mnemonic == "mov" and i.op_str == "ip, #1" for i in instructions["native_mp4_virtual_fifos"]) == 4,
        "uvcd_creator_calls_fifo_create": calls("uvcd_virtual_creator", 0xA04509DC) == ["0xa02335c4"],
        "uvcd_creator_stream_id_is_video_primary": has("uvcd_virtual_creator", "movw", "r4, #0x82d8") and has("uvcd_virtual_creator", "movt", "r4, #0xa13c"),
        "uvcd_creator_capacity_8192": has("uvcd_virtual_creator", "mov", "r2, #0x2000"),
        "uvcd_creator_virtual_flag_one": has("uvcd_virtual_creator", "mov", "ip, #1"),
        "uvcd_creator_callback_is_a0233434": has("uvcd_virtual_creator", "movw", "r3, #0x3434") and has("uvcd_virtual_creator", "movt", "r3, #0xa023") and has("uvcd_virtual_creator", "str", "r3, [sp, #0xc]"),
        "uvcd_consumer_peeks_index_zero": calls("uvcd_virtual_consumer", 0xA0451960) == ["0xa0233470"],
        "uvcd_consumer_removes_one_entry": calls("uvcd_virtual_consumer", 0xA0451C94) == ["0xa023348c"],
        "uvcd_consumer_accepts_fifo_data_event": has("uvcd_virtual_consumer", "cmp", "r1, #0x4000002"),
        "uvcd_consumer_ignores_fifo_empty_event": has("uvcd_virtual_consumer", "cmp", "r1, #0x4000001"),
        "uvcd_stop_deletes_virtual_handle": calls("uvcd_virtual_stop", 0xA04514E4) == ["0xa02335e8"],
        "fifo_sync_notifies_data_event": has("fifo_sync_to_consumers", "mov", "r5, #0x4000002") and has("fifo_sync_to_consumers", "blx", "r3"),
        "fifo_sync_notifies_empty_event": has("fifo_sync_to_consumers", "mov", "r4, #0x4000001") and has("fifo_sync_to_consumers", "blx", "r3"),
        "fifo_default_capacity_128_before_overrides": has("fifo_default_config", "str", "r2, [r4, #4]") and has("fifo_default_config", "str", "r3, [r4, #8]"),
        "video_consumer_peeks": bool(calls("iso_video_consumer", 0xA0451960)),
        "video_consumer_removes": bool(calls("iso_video_consumer", 0xA0451C94)),
        "video_consumer_calls_write_helper": bool(calls("iso_video_consumer", 0xA042CE28)),
        "video_helper_writes_h264_stream": bool(calls("iso_video_write", 0xA03EFE74)),
        "video_helper_converts_descriptor_pts": bool(calls("iso_video_write", 0xA03E5B5C)),
        "audio_consumer_peeks": bool(calls("iso_audio_consumer", 0xA0451960)),
        "audio_consumer_writes_stream": bool(calls("iso_audio_consumer", 0xA03E627C)),
        "audio_consumer_removes": bool(calls("iso_audio_consumer", 0xA0451C94)),
        "record_table_first_callback": word(0xA069CBD8) == 0xA012C220,
        "button_idle_operation_12": has("record_button_state", "mov", "r0, #0x12"),
        "button_recording_operation_13": has("record_button_stop", "mov", "r0, #0x13"),
        "h264_setup_direct_call": calls("h264_setup_caller", 0xA02B7454) == ["0xa02d21e0"],
        "mux_close_waits_before_delete": calls("mux_close_lifecycle", 0xA043FEC0) and calls("mux_close_lifecycle", 0xA043F82C) and calls("mux_close_lifecycle", 0xA043FEC0)[0] < calls("mux_close_lifecycle", 0xA043F82C)[0],
        "mux_close_stops_pipe_before_fifo_delete": calls("mux_close_lifecycle", 0xA03E40C8) and calls("mux_close_lifecycle", 0xA04514E4) and calls("mux_close_lifecycle", 0xA03E40C8)[0] < calls("mux_close_lifecycle", 0xA04514E4)[0],
        "event_close_waits_unregisters_then_deletes": calls("event_mux_close_lifecycle", 0xA01F8EBC) and calls("event_mux_close_lifecycle", 0xA043FEC0) and calls("event_mux_close_lifecycle", 0xA04514E4) and calls("event_mux_close_lifecycle", 0xA043FEC0)[0] < calls("event_mux_close_lifecycle", 0xA01F8EBC)[0] < calls("event_mux_close_lifecycle", 0xA04514E4)[0],
    }
    files = ["a04509b0.c", "a04509dc.c", "a0451960.c", "a0451c94.c", "a0452254.c", "a044e8d4.c",
             "a0233508.c", "a0232e90.c", "a02335d0.c",
             "a045e7dc.c", "a0470b70.c", "a04611cc.c", "a01f6340.c", "a01f3338.c",
             "a01f6088.c", "a01f8f08.c", "a042d0f8.c", "a042ce28.c", "a043173c.c", "a03e5b5c.c", "a0113594.c",
             "a0113808.c", "a012c220.c", "a02b7454.c", "a02d1f50.c"]
    hashes = {}
    for name in files:
        path = src / "full/decompiled" / name
        hashes[str(path.relative_to(ROOT))] = hashlib.sha256(path.read_bytes()).hexdigest()
    report = {
        "kind": "offline static evidence; no runtime validation or camera access",
        "image": str(image.relative_to(ROOT)), "sha256": digest,
        "checks": checks,
        "video_event_table": {hex(0x16 + i): hex(a) for i, a in enumerate(table)},
        "frame_descriptor": {
            "stride_bytes": 32, "sequence_u32": 0, "reserved_u32": 4,
            "pts_u64": 8, "type_u8": 16, "flag_u8": 17,
            "bitstream_address_u32": 20, "size_u32": 24,
            "unknown_u32": 28,
            "type_note": "Video mux treats type 1 as random-access/sync sample; ordinary audio path writes 8 and EOS writes 0xff. Other enum values are not recovered.",
            "timestamp_note": "Both producers copy 64-bit source PTS. Common clock origin, units and DTS generation are not established by these observations.",
        },
        "virtual_fifo_creation": {
            "native_mp4_start": "A01F6340 creates four virtual FIFO handles via A04509DC; each call passes capacity 0x2000 descriptors and virtual flag 1. Video and audio stream IDs are loaded from DAT_A13C82D8 and DAT_A13C7D20.",
            "existing_side_consumer_candidate": "A0233508 (UVCd FIFO start) uses the same A04509DC ABI for stream DAT_A13C82D8, capacity 0x2000 and virtual flag 1, with callback DAT_A0233434; A0232E90 peeks index 0 and removes one entry, while A02335D0 deletes the handle.",
            "creator_abi_observed_fields": "The first config words are stream_id (+0x00), capacity (+0x04), virtual (+0x08), and required callback (+0x0c). A04509DC also reads additional zero/default fields from the 0x58-byte config; their semantics are not recovered.",
            "descriptor_queue_bytes": 0x2000 * 0x20,
            "base_link": "A04509DC finds a base FIFO by stream ID and stores the base object link in the virtual handler; payload bytes are not copied during SyncWritten.",
            "filter_note": "The handler contains a type/filter byte at +0xC0. The exact wildcard/filter initialization semantics are not assumed by the host prototype.",
        },
        "payload_ownership": {
            "encoder_ring": "H264 setup receives bits FIFO base/limit; video events supply payload address (+0x14) and size (+0x18).",
            "fifo_behavior": "AmpFifo_WriteEntry copies only the 0x20-byte descriptor into descriptor storage. AmpFifo_SyncWritten copies descriptors from base to virtual queues, not payload bytes.",
            "reclaim": "Base FIFO reclamation considers virtual read cursors and payload address distance; a lagging virtual reader can constrain reclamation. RemoveEntry advances only the calling FIFO cursor.",
            "host_rule": "Copy payload bytes before advancing the side reader; do not free or reuse firmware ring addresses and do not advance base cursor.",
        },
        "pts_path": {
            "descriptor_to_mux": "A042CE28 calls A03E5B5C (AmpFormat_ConvertPTS) with descriptor PTS at +0x08/+0x0c.",
            "conversion": "A03E5B5C uses mux stream state/timebase fields and writes converted PTS/DTS state; H264 setup exposes pts_delta at config offset +0x60.",
            "unknown": "The static image does not establish the source clock epoch, exact unit selection for every mode, or a safe host-side DTS reconstruction rule.",
        },
        "close_lifecycle": {
            "normal_mp4": "A01F6088 waits for mux completion, deletes mux resources, stops associated pipe/file objects, then deletes virtual FIFO handles with A04514E4.",
            "event_mp4": "A01F8F08 unregisters the EventRecord descriptor, waits/deletes mux resources, stops pipe/file objects, then deletes virtual FIFOs.",
            "safety": "This ordering is static evidence for the stock lifecycle only; a new side consumer must stop before its virtual FIFO is deleted and must not assume callbacks are quiescent without a runtime barrier.",
        },
        "source_hashes": hashes, "evidence": evidence,
        "limits": [
            "No proof of firmware injection, standby encoding or writable runtime hook.",
            "An independent virtual FIFO has its own descriptor queue/read cursor; payload bytes remain shared in the encoder ring.",
            "Slow side consumers can constrain base FIFO reclamation; copy payload promptly, then remove only own entries.",
            "Native mux lifecycle exists but a second concurrent MP4 writer and seamless rollover are not runtime tested.",
            "The UVCd callback/consumer is an existing static example of the creator ABI, not proof that an arbitrary new consumer can safely share the encoder ring without lifecycle synchronization.",
        ],
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    failed = [k for k, v in checks.items() if not v]
    if failed:
        raise SystemExit("Static checks failed: " + ", ".join(failed))
    print(f"{args.output}: {len(checks)} static assertions passed")


if __name__ == "__main__":
    main()
