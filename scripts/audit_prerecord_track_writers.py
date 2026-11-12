#!/usr/bin/env python3
"""Audit the pinned 1.10.7 image entirely on the host; never contacts a camera.

Run with .venv-reverse/bin/python scripts/audit_prerecord_track_writers.py.
Requires capstone and unicorn. Existing Ghidra exports are input evidence.
"""

import argparse
import hashlib
import json
import math
import struct
from pathlib import Path

import capstone
import unicorn
from unicorn import UC_ARCH_ARM, UC_MODE_ARM, Uc
from unicorn.arm_const import (
    UC_ARM_REG_LR,
    UC_ARM_REG_PC,
    UC_ARM_REG_R0,
    UC_ARM_REG_R1,
    UC_ARM_REG_R5,
    UC_ARM_REG_SP,
)


ROOT = Path(__file__).resolve().parents[1]
BASE = 0xA0100000
EXPECTED_SHA256 = "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"
IMAGE_PATH = Path("artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin")
EXPORT = Path("artifacts/device/2026-11-09-linux/rtos-analysis/full")
RETURN_PC = 0x10010000
U64 = (1 << 64) - 1


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def new_machine(image):
    machine = Uc(UC_ARCH_ARM, UC_MODE_ARM)
    machine.mem_map(BASE, (len(image) + 4095) & ~4095)
    machine.mem_write(BASE, image)
    machine.mem_map(0x10000000, 0x20000)
    machine.mem_map(0xA0FD7000, 0x1000)
    machine.mem_map(0xA13C8000, 0x1000)
    machine.reg_write(UC_ARM_REG_SP, 0x1001F000)
    machine.reg_write(UC_ARM_REG_LR, RETURN_PC)
    return machine


def read_int(machine, address, width=4):
    return int.from_bytes(machine.mem_read(address, width), "little")


def write_int(machine, address, value, width=4):
    machine.mem_write(address, (value % (1 << (width * 8))).to_bytes(width, "little"))


def run(machine, entry, stop=RETURN_PC):
    machine.emu_start(entry, stop, count=1_000_000)
    assert machine.reg_read(UC_ARM_REG_PC) == stop


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "artifacts/device/2026-11-10-prerecord/track-writers-audit.json",
    )
    args = parser.parse_args()
    image = (ROOT / IMAGE_PATH).read_bytes()
    assert sha256(image) == EXPECTED_SHA256, "Wrong firmware image"
    functions = {
        item["entry"]: item
        for item in json.loads((ROOT / EXPORT / "functions.json").read_text())
    }
    entries = [
        0xA018623C, 0xA02257EC, 0xA0225B38, 0xA0225BB8, 0xA0225E8C,
        0xA021F854, 0xA020FE74, 0xA01F3338, 0xA01F845C,
        0xA0440C90, 0xA0440CD4, 0xA044042C, 0xA03E58F0, 0xA03E5AB8,
        0xA042D0F8, 0xA043173C, 0xA0440948, 0xA044180C,
    ]
    sources = []
    for entry in entries:
        info = functions[hex(entry)]
        chunks = []
        for body_range in info["body_ranges"]:
            start, end = (int(part, 16) for part in body_range.split("-"))
            chunks.append(image[start - BASE:end - BASE + 1])
        pseudocode = EXPORT / info["decompiled_file"]
        sources.append({
            "entry": hex(entry),
            "body_ranges_inclusive": info["body_ranges"],
            "body_ranges_concatenated_sha256": sha256(b"".join(chunks)),
            "pseudocode_path": str(pseudocode),
            "pseudocode_sha256": sha256((ROOT / pseudocode).read_bytes()),
        })

    # These callback labels have real code/listing but no functions.json entry.
    label_ranges = []
    for start, stop in [(0xA018488C, 0xA018489C), (0xA0184F10, 0xA01857D4)]:
        label_ranges.append({
            "start": hex(start), "stop_exclusive": hex(stop),
            "sha256": sha256(image[start - BASE:stop - BASE]),
            "indexed_as_function": False,
        })

    decoder = capstone.Cs(capstone.CS_ARCH_ARM, capstone.CS_MODE_ARM)
    instruction_expectations = [
        (0xA0225B40, "ldr", "r3, [r3, #0xcc]"),
        (0xA0225BC0, "ldr", "r3, [r3, #0xd4]"),
        (0xA018488C, "movw", "r3, #0x4b38"),
        (0xA0184890, "movt", "r3, #0xa06e"),
        (0xA0184894, "add", "r0, r3, r0, lsl #4"),
        (0xA01F38E0, "ldr", "r2, [fp, #0x10]"),
        (0xA01F38EC, "str", "r2, [sp, #0x2c]"),
        (0xA01F38F8, "ldr", "r2, [fp, #0xc]"),
        (0xA01F38FC, "str", "r2, [sp, #0x30]"),
        (0xA01F3900, "ldr", "r2, [fp, #0x10]"),
        (0xA01F3904, "str", "r2, [sp, #0x48]"),
        (0xA01F3918, "ldr", "r2, [r3, #4]"),
        (0xA01F391C, "strh", "r2, [sp, #0x50]"),
        (0xA01F3924, "strb", "sl, [sp, #0x54]"),
        (0xA01F3928, "strb", "r7, [sp, #0x55]"),
        (0xA04410B4, "str", "r2, [r4, #0x40]"),
        (0xA04410C4, "strb", "r3, [r4, #0x7d]"),
        (0xA04410FC, "strb", "ip, [r4, #0x7e]"),
        (0xA044110C, "strh", "ip, [r4, #0x78]"),
        (0xA0441180, "bl", "#0xa03e5ab8"),
        (0xA042D378, "ldrd", "r2, r3, [r5, #0x58]"),
        (0xA042D388, "ldr", "r3, [r5, #0x48]"),
        (0xA042D390, "ldrdeq", "r2, r3, [r1, #8]"),
        (0xA042D394, "strdeq", "r2, r3, [r5, #0x58]"),
        (0xA0440960, "umlal", "r2, r3, r4, r1"),
        (0xA0440988, "strd", "r4, r5, [r0, #0x20]"),
        (0xA04418F8, "strd", "r2, r3, [ip, #0xe0]"),
        (0xA0441908, "strd", "r4, r5, [ip, #0xd0]"),
        (0xA044190C, "strd", "r4, r5, [ip, #0xd8]"),
    ]
    instructions = []
    for address, mnemonic, operands in instruction_expectations:
        instruction = next(decoder.disasm(image[address - BASE:address - BASE + 4], address))
        assert (instruction.mnemonic, instruction.op_str) == (mnemonic, operands), (
            hex(address), instruction.mnemonic, instruction.op_str
        )
        instructions.append({
            "address": hex(address), "bytes": bytes(instruction.bytes).hex(),
            "mnemonic": mnemonic, "operands": operands,
        })

    tables = []
    for selector, address in [(0, 0xA06DCF78), (1, 0xA06E51B8)]:
        rows = []
        for mode in range(88):
            offset = address - BASE + mode * 24
            values = struct.unpack_from("<4H4I", image, offset)
            rows.append({
                "internal_mode_index": mode,
                "entry_address": hex(address + mode * 24),
                "dimension_halfwords": list(values[:4]),
                "opaque_u32_at_08": values[4],
                "period_at_0c": values[5],
                "scale_at_10": values[6],
                "opaque_u32_at_14": values[7],
            })
        tables.append({
            "selector_test_value": selector,
            "address": hex(address), "stride_bytes": 24, "count": 88,
            "sha256": sha256(image[address - BASE:address - BASE + 88 * 24]),
            "rows": rows,
        })
    metadata_address = 0xA06E4B38
    metadata = [
        struct.unpack_from("<4I", image, metadata_address - BASE + mode * 16)
        for mode in range(88)
    ]
    assert set(metadata) == {(0, 1, 8, 8)}

    results = []
    machine = new_machine(image)
    run(machine, 0xA018623C, 0xA01864F0)
    registry = machine.reg_read(UC_ARM_REG_R0)
    callback_video = read_int(machine, registry + 0xCC)
    callback_metadata = read_int(machine, registry + 0xD4)
    assert (callback_video, callback_metadata) == (0xA0184F10, 0xA018488C)
    results.append({
        "name": "sensor_registration_prefix", "stop_before": "0xa01864f0",
        "callback_at_cc": hex(callback_video),
        "callback_at_d4": hex(callback_metadata), "passed": True,
    })

    for selector in (0, 1):
        for mode in (0, 1, 5, 86, 87):
            machine = new_machine(image)
            write_int(machine, 0xA13C88C9, selector, 1)
            machine.reg_write(UC_ARM_REG_R0, mode)
            run(machine, callback_video)
            pointer = machine.reg_read(UC_ARM_REG_R0)
            row = tables[selector]["rows"][mode]
            assert pointer == int(row["entry_address"], 16)
            assert read_int(machine, pointer + 0x0C) == row["period_at_0c"]
            assert read_int(machine, pointer + 0x10) == row["scale_at_10"]
            results.append({
                "name": "sensor_video_getter", "selector": selector, "mode": mode,
                "returned_pointer": hex(pointer), "period": row["period_at_0c"],
                "scale": row["scale_at_10"], "passed": True,
            })

    init_cases = [
        ("main_30000_1001", 30000, 1001, "main", 1, 0),
        ("main_25000_1000", 25000, 1000, "main", 1, 0),
        ("main_90000_1001", 90000, 1001, "main", 1, 0),
        ("event_30000_1001", 30000, 1001, "event", 1, 0),
        ("event_25000_1000", 25000, 1000, "event", 1, 0),
        ("synthetic_count_3", 30000, 1001, "main", 3, 0),
        ("synthetic_mode_1", 30000, 1001, "main", 1, 1),
    ]
    for name, video_scale, video_period, path, count, mode in init_cases:
        machine = new_machine(image)
        movie, config = 0x10000000, 0x10002000
        audio_sample_rate = 48000
        audio_scale = audio_sample_rate if path == "main" else video_scale
        audio_period = 1024 if path == "main" else video_scale * 1024 // audio_sample_rate
        write_int(machine, movie, 1, 1)
        write_int(machine, config + 0xD0, 2, 1)
        values = {
            0: 2, 4: video_scale, 8: video_period,
            0x10: 0x101, 0x14: 0x2000, 0x18: 0x3000,
            0x1C: 8, 0x20: video_scale, 0x28: count | (8 << 16),
            0x2C: 1 | (mode << 8), 0x30: 1,
            0x34: 0x22, 0x38: audio_scale, 0x3C: audio_period,
            0x44: 0x102, 0x48: 0x4000, 0x4C: 0x5000,
            0x50: audio_sample_rate, 0x54: 0x201, 0x64: 2,
        }
        for offset, value in values.items():
            write_int(machine, config + offset, value)
        machine.reg_write(UC_ARM_REG_R0, movie)
        machine.reg_write(UC_ARM_REG_R1, config)
        run(machine, 0xA0440CD4)
        assert machine.reg_read(UC_ARM_REG_R0) == 0
        destination_scale = math.lcm(video_scale, audio_scale)
        track = movie + 0x78
        final_video_period = video_period * (destination_scale // video_scale) * (2 if mode == 1 else 1)
        fields = {hex(offset): read_int(machine, track + offset, width) for offset, width in [
            (4, 4), (8, 4), (0x0C, 4), (0x40, 4), (0x58, 8), (0x68, 8),
            (0x78, 2), (0x7D, 1), (0x7E, 1), (0x7F, 1),
        ]}
        assert fields == {
            "0x4": destination_scale, "0x8": video_scale, "0xc": final_video_period,
            "0x40": video_scale, "0x58": 0,
            "0x68": (-final_video_period * (count - 1)) & U64,
            "0x78": count, "0x7d": mode, "0x7e": 0, "0x7f": 1,
        }
        audio = track + 0x90
        audio_fields = {hex(offset): read_int(machine, audio + offset) for offset in (4, 8, 0xC, 0x40)}
        assert audio_fields == {
            "0x4": destination_scale, "0x8": audio_scale,
            "0xc": audio_period * (destination_scale // audio_scale),
            "0x40": audio_sample_rate,
        }
        results.append({
            "name": name, "entry": "0xa0440cd4", "synthetic_configuration": True,
            "video_input_scale": video_scale, "video_input_period": video_period,
            "audio_input_scale": audio_scale, "audio_input_period": audio_period,
            "video_track_fields": fields, "audio_track_fields": audio_fields, "passed": True,
        })
        if name == "main_30000_1001":
            descriptor = 0x10004000
            first_pts = 0x123456789
            write_int(machine, descriptor + 8, first_pts, 8)
            stack_pointer = machine.reg_read(UC_ARM_REG_SP)
            write_int(machine, stack_pointer + 0x24, descriptor)
            machine.reg_write(UC_ARM_REG_R5, track)
            run(machine, 0xA042D378, 0xA042D398)
            frame_results = []
            for index in range(3):
                raw_pts = first_pts + index * video_period
                write_int(machine, descriptor + 8, raw_pts, 8)
                write_int(machine, descriptor + 0x10, 2, 1)
                machine.reg_write(UC_ARM_REG_R0, track)
                machine.reg_write(UC_ARM_REG_R1, descriptor)
                machine.reg_write(UC_ARM_REG_LR, RETURN_PC)
                run(machine, 0xA03E5B5C)
                converted = machine.reg_read(UC_ARM_REG_R0) | (machine.reg_read(UC_ARM_REG_R1) << 32)
                assert converted == index * final_video_period
                assert read_int(machine, track + 0x20, 8) == converted
                machine.reg_write(UC_ARM_REG_R0, track)
                machine.reg_write(UC_ARM_REG_R1, 1)
                machine.reg_write(UC_ARM_REG_LR, RETURN_PC)
                run(machine, 0xA0440948)
                frame_results.append({
                    "index": index, "descriptor_pts": raw_pts,
                    "accepted_pts": converted, "next_dts": read_int(machine, track + 0x20, 8),
                })
            results.append({
                "name": "configured_video_time_sequence",
                "initialization": name, "initial_descriptor_pts": first_pts,
                "full_convert_and_update_functions": True, "frames": frame_results,
                "does_not_include": "Encoder, mux file output, FIFO operations or real camera timing",
                "passed": True,
            })

    for origin, frames, expected in [(0, 0, 0x123456789), (0, 1, 0), (700, 0, 700)]:
        machine = new_machine(image)
        track, descriptor = 0x10000000, 0x10002000
        write_int(machine, track + 0x58, origin, 8)
        write_int(machine, track + 0x48, frames)
        write_int(machine, descriptor + 8, 0x123456789, 8)
        write_int(machine, 0x1001F000 + 0x24, descriptor)
        machine.reg_write(UC_ARM_REG_R5, track)
        run(machine, 0xA042D378, 0xA042D398)
        actual = read_int(machine, track + 0x58, 8)
        assert actual == expected
        results.append({
            "name": "first_descriptor_origin_prefix", "initial_origin": origin,
            "initial_frame_count": frames, "descriptor_pts": 0x123456789,
            "actual_origin": actual, "passed": True,
        })

    for track_type, period in [(1, 8008), (2, 5120)]:
        machine = new_machine(image)
        track, initial_dts, entries = 0x10000000, 0x100000123, 3
        write_int(machine, track + 0x89, track_type, 1)
        write_int(machine, track + 0xC, period)
        write_int(machine, track + 0x20, initial_dts, 8)
        machine.reg_write(UC_ARM_REG_R0, track)
        machine.reg_write(UC_ARM_REG_R1, entries)
        run(machine, 0xA0440948)
        actual_dts = read_int(machine, track + 0x20, 8)
        assert actual_dts == initial_dts + period * entries
        assert read_int(machine, track + 0x28, 8) == actual_dts
        assert read_int(machine, track + 0x48) == (entries if track_type == 1 else 0)
        results.append({
            "name": "dts_progression", "track_type": track_type,
            "period": period, "entries": entries, "initial_dts": initial_dts,
            "actual_dts": actual_dts, "passed": True,
        })

    machine = new_machine(image)
    movie, pipe, mux = 0x10000000, 0x10002000, 0x10003000
    track = movie + 0x78
    write_int(machine, pipe, mux)
    write_int(machine, pipe + 0x10, 1, 1)
    write_int(machine, pipe + 0x72, 5, 1)
    write_int(machine, mux + 4, movie)
    write_int(machine, movie, 1, 1)
    write_int(machine, movie + 0x6F4, 1, 1)
    write_int(machine, track + 0x89, 1, 1)
    write_int(machine, track + 0x20, 80080, 8)
    write_int(machine, track + 0x68, 0, 8)
    write_int(machine, track + 0x48, 10)
    write_int(machine, track + 0x58, 123456, 8)
    write_int(machine, track + 0x60, 72072, 8)
    write_int(machine, track + 0x7E, 1, 1)
    write_int(machine, movie + 0x2B8, 0, 8)
    machine.reg_write(UC_ARM_REG_R0, pipe)
    run(machine, 0xA044180C, 0xA0441888)
    resume_fields = {hex(offset): read_int(machine, track + offset, width) for offset, width in [
        (0x68, 8), (0x48, 4), (0x58, 8), (0x60, 8), (0x7E, 1)
    ]}
    assert resume_fields == {"0x68": (-80080) & U64, "0x48": 0, "0x58": 0, "0x60": 0, "0x7e": 0}
    assert read_int(machine, movie + 0x2B8, 8) == 80080
    assert read_int(machine, pipe + 0x72, 1) == 2
    results.append({
        "name": "resume_prefix", "stop_before": "0xa0441888",
        "video_track_fields": resume_fields, "saved_dts": 80080, "passed": True,
    })

    audio_descriptor_loads = []
    audio_body = functions["0xa043173c"]["body_ranges"]
    for body_range in audio_body:
        start, end = (int(part, 16) for part in body_range.split("-"))
        for instruction in decoder.disasm(image[start - BASE:end - BASE + 1], start):
            # Source listing/pseudocode confirms r3 is descriptor only in the
            # short load blocks cited in the report; do not infer aliasing here.
            if instruction.mnemonic in {"bl", "blx"}:
                audio_descriptor_loads.append({"address": hex(instruction.address), "call": instruction.op_str})
    assert all(item["call"] != "#0xa03e5b5c" for item in audio_descriptor_loads)

    report = {
        "schema_version": 1, "audit_date": "2026-11-10",
        "method": "Pinned existing Ghidra exports, direct instruction checks and host Unicorn. No fresh REA/Ghidra session, camera connection, camera execution, device writes or patch.",
        "image": {"path": str(IMAGE_PATH), "base": hex(BASE), "sha256": sha256(image)},
        "script": {"path": str(Path(__file__).resolve().relative_to(ROOT)), "sha256": sha256(Path(__file__).read_bytes())},
        "tools": {"unicorn": unicorn.__version__, "capstone": capstone.__version__},
        "pinned_functions": sources, "unindexed_code_labels": label_ranges,
        "instruction_checks": instructions,
        "sensor_video_tables": tables,
        "sensor_metadata_table": {
            "address": hex(metadata_address), "stride": 16, "count": 88,
            "all_rows_u32": [0, 1, 8, 8],
            "sha256": sha256(image[metadata_address - BASE:metadata_address - BASE + 88 * 16]),
        },
        "audio_sample_rate_entries": [
            {"index": index, "address": hex(0xA06D450C + index * 28),
             "sample_rate": struct.unpack_from("<I", image, 0xA06D450C - BASE + index * 28)[0]}
            for index in range(3)
        ],
        "host_emulation": {
            "helper_stubs": False, "instruction_limit_per_case": 1_000_000,
            "cases": results, "passed": len(results),
            "limitation": "Constructed inputs; real movie init/helpers execute, while getter and origin/resume prefixes stop at explicit boundaries. No real encoder, mux file or pause/resume lifecycle is run.",
        },
        "audio_consumer_calls": audio_descriptor_loads,
        "field_writers": {
            "video_track_40": "InitMovieInfo copies cfg+20; primary open cfg+20 and cfg+04 both come from selected sensor row+10.",
            "video_track_58": "InitPTS clears; ProcessVideo stores first descriptor PTS when origin==0 and frame_count_48==0; ResumePipe clears again.",
            "video_track_68": "InitPTS uses -low32(period*(count78-1)) if control7e==0; ResumePipe adds saved_DTS-current_DTS modulo 2^64.",
            "video_track_78": "InitMovieInfo copies cfg+28; primary open gets count from sensor metadata row+04, all 88 pinned rows hold 1.",
            "video_track_7d": "InitMovieInfo copies cfg+2d; primary/event open explicitly set 0 in inspected path.",
            "video_track_7e": "InitMovieInfo copies cfg+2e, zeroed by GetDefaultMovieInfoCfg in inspected open path; ResumePipe resets zero.",
        },
        "unresolved": [
            "Runtime active selector/mode, secondary-stream overrides and encoding producer clock epoch.",
            "Whether all callback table entries are exposed or usable camera recording modes.",
            "Hardware encoder PTS-to-sensor-scale behavior across mode switches and discontinuities.",
            "A/V sample boundary and real FIFO start skew; audio ordinary mux does not reuse video ConvertPTS.",
            "Whether native EventRecord period truncation is corrected elsewhere.",
            "Second mux writer/60-second ring lifecycle, memory and output validity on a camera.",
        ],
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({
        "output": str(args.output), "instruction_checks": len(instructions),
        "host_cases_passed": len(results), "sensor_table_rows": 176,
    }))


if __name__ == "__main__":
    main()
