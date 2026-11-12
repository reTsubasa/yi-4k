#!/usr/bin/env python3
"""Reproduce bounded, static 1.10.7 prerecord findings; never connects to camera."""
import argparse
import hashlib
import json
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = 0xA0100000
SHA256 = "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--output", type=Path, default=ROOT / "artifacts/device/2026-11-10-prerecord/static-audit.json")
    args = ap.parse_args()
    source = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis"
    image = source / "rtos-window.bin"
    data = image.read_bytes()
    digest = hashlib.sha256(data).hexdigest()
    if digest != SHA256:
        raise SystemExit("Unexpected RTOS image SHA-256")

    def word(address):
        return struct.unpack_from("<I", data, address - BASE)[0]

    def cstring(address):
        return data[address - BASE:].split(b"\0", 1)[0].decode("ascii")

    from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
    cs = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    ranges = {
        "schema_prerecord": (0xA018CC8C, 0xA018CCCC),
        "runtime_setter": (0xA021F768, 0xA021F784),
        "recorder_dispatch": (0xA01282E0, 0xA01282FC),
        "recorder_default": (0xA012A094, 0xA012A09C),
        "eventrecord_start_callback": (0xA01F8E68, 0xA01F8E80),
        "eventrecord_unregister_descriptor": (0xA01F8EBC, 0xA01F8F08),
        "mux_unregister": (0xA01F0F2C, 0xA01F0FD4),
        "sps_pps_prefixes": (0xA03E6AF4, 0xA03E6BA4),
    }
    assembly = {}
    for name, (start, end) in ranges.items():
        assembly[name] = [f"0x{i.address:08x}  {i.mnemonic} {i.op_str}" for i in cs.disasm(data[start - BASE:end - BASE], start)]
    table = 0xA01282FC
    entries = {f"0x{i:02x}": f"0x{word(table + 4 * i):08x}" for i in (0x1D, 0x1E, 0x1F, 0x2B, 0x2C, 0x2D)}
    checks = {
        "schema_string": cstring(0xA055D774) == "VideoPref.PreRecord",
        "op_2c_is_default": word(table + 4 * 0x2C) == 0xA012A094,
        "eventrecord_start_op_1d_is_default": word(table + 4 * 0x1D) == 0xA012A094,
        "time_lapse_op_2d_has_handler": word(table + 4 * 0x2D) == 0xA0129FF8,
        "eventrecord_descriptor_calls_unregister": any("bl #0xa01f0f2c" in line for line in assembly["eventrecord_unregister_descriptor"]),
        "unregister_clears_enable_byte": any("strb r2, [r3, #0xa]" in line for line in assembly["mux_unregister"]),
        "sps_pps_four_writes": sum("bl #0xa03e6938" in line for line in assembly["sps_pps_prefixes"]) == 4,
    }
    refs = []
    selected_targets = {"0xa02b7454", "0xa03e8834", "0xa03f1944", "0xa01f0e00", "0xa01f0f2c"}
    selected_calls = {address: [] for address in sorted(selected_targets)}
    for line in (source / "full/references.tsv").read_text().splitlines()[1:]:
        parts = line.split("\t")
        if len(parts) >= 3 and parts[1].lower() == "0xa13c82ba":
            refs.append({"from": parts[0], "to": parts[1], "type": parts[2]})
        if len(parts) >= 3 and parts[1].lower() in selected_targets and parts[2].endswith("CALL"):
            selected_calls[parts[1].lower()].append({"from": parts[0], "type": parts[2]})
    decompiled = source / "full/decompiled"
    stream_functions = {
        "h264_setup": {
            "address": "0xA02B7454",
            "file": "a02b7454.c",
            "markers": ["bits_fifo_base", "info_fifo_base", "stat_fifo_base", "idr_interval"],
            "interpretation": "Static encoder setup fields; output FIFO subscription ABI not recovered.",
        },
        "feed_idr_frame": {
            "address": "0xA03E8834",
            "file": "a03e8834.c",
            "markers": ["AmpH264_PutGOPHeader", "AmpFormat_PutSPSPPS", "AmpFormat_WriteFrame"],
            "interpretation": "Static IDR input/feed path reading a stream into FIFO; not a verified encoder output segmenter.",
        },
        "fifo_param": {
            "address": "0xA03F1944",
            "file": "a03f1944.c",
            "markers": ["AmpFifoPool_GetFifoParam", "Wrong_FIFO_handler"],
            "interpretation": "Generic FIFO parameter query; known direct caller is demux data-request path.",
        },
        "fifo_data_event": {
            "address": "0xA03F0C7C",
            "file": "a03f0c7c.c",
            "markers": ["AmpFifoPool_OnDataEventImpl", "Give_event_flag_fail"],
            "interpretation": "Generic FIFO event notification, not a proven encoder subscriber interface.",
        },
        "eventrecord_open": {
            "address": "0xA01F845C",
            "file": "a01f845c.c",
            "markers": ["AppLibFormatMuxMp4_Open_EventRec", "FUN_a043f724"],
            "interpretation": "Static event mux resource construction; initial handler registration and standby use remain unknown.",
        },
        "eventrecord_gate": {
            "address": "0xA012C98C",
            "file": "a012c98c.c",
            "markers": ["Block_ev", "0x1d"],
            "interpretation": "Static gate requires current recording state before sending operation 0x1d.",
        },
    }
    stream_contract = {}
    for name, spec in stream_functions.items():
        path = decompiled / spec["file"]
        text = path.read_text(errors="replace") if path.exists() else ""
        stream_contract[name] = {
            "address": spec["address"],
            "file": str(path.relative_to(ROOT)),
            "markers": {marker: marker in text for marker in spec["markers"]},
            "source_present": path.exists(),
            "evidence_type": "existing Ghidra export, static; substring inventory is not runtime validation",
            "interpretation": spec["interpretation"],
        }
    available = 234_597_172
    result = {
        "evidence_type": "local Capstone and existing Ghidra export; static, not execution",
        "image": str(image.relative_to(ROOT)), "sha256": digest,
        "assembly": assembly, "checks": checks,
        "dispatch_table_base": hex(table), "selected_dispatch_entries": entries,
        "runtime_prerecord_byte_references_in_existing_export": refs,
        "stream_contract": stream_contract,
        "selected_direct_call_sites_in_existing_export": selected_calls,
        "negative_search_limit": "Only resolved references in existing Ghidra export; indirect/aliased data accesses and unrecognized code are not excluded.",
        "memory_scenarios": [
            {"video_mbps_decimal": mbps, "seconds": 60, "video_bytes": mbps * 1_000_000 * 60 // 8,
             "fraction_of_previously_observed_idle_available": mbps * 1_000_000 * 60 / 8 / available}
            for mbps in (20, 30, 60, 100)
        ],
        "memory_limit": "Previously observed idle available total is not a contiguous allocation or recording-time headroom guarantee; audio, mux metadata, alignment and working memory excluded.",
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    if not all(checks.values()):
        raise SystemExit("Static assertions failed; inspect audit")
    print(args.output)


if __name__ == "__main__":
    main()
