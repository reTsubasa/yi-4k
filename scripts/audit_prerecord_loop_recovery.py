#!/usr/bin/env python3
"""Audit loop-record startup/recovery cursor handling in the decompiler export.

This is an offline source-structure audit.  It records the exact decompiler
files and hashes used, then asserts the recovery flag, cursor, split-counter,
and deferred-delete relationships.  It never connects to or writes a camera.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled"
OUT = ROOT / "artifacts/device/2026-11-11-prerecord-loop-recovery"

FILES = {
    "set_restart_flag": SRC / "a01f4b8c.c",
    "configure_loop": SRC / "a01f4bc8.c",
    "open_mux": SRC / "a01f3338.c",
    "record_start": SRC / "a0124470.c",
    "delete_loop": SRC / "a01f51d0.c",
    "action_dispatch": SRC / "a011a208.c",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def line_hits(path: Path, needles: list[str]) -> dict[str, list[int]]:
    result = {}
    for needle in needles:
        hit = [n for n, line in enumerate(path.read_text().splitlines(), 1) if needle in line]
        if hit:
            result[needle] = hit
    return result


def require(name: str, text: str, *needles: str) -> dict:
    missing = [needle for needle in needles if needle not in text]
    if missing:
        raise AssertionError(f"{name}: missing {missing}")
    return {"name": name, "needles": list(needles)}


def main() -> None:
    text = {name: path.read_text() for name, path in FILES.items()}
    checks = []

    checks.append(require(
        "restart flag is explicitly set from caller state",
        text["set_restart_flag"],
        "DAT_a13c298c._0_1_ = param_1 != 0;",
        "s__sIsRestartRecord___d",
    ))
    checks.append(require(
        "record start passes card/restart bit into restart setter",
        text["record_start"],
        "matched_FUN_a01f4b8c((DAT_a069b3c8 & 0x200) != 0);",
    ))
    checks.append(require(
        "fresh loop setup clears counters",
        text["configure_loop"],
        "if ((char)DAT_a13c298c == '\\x01') goto LAB_a01f4cc0;",
        "DAT_a13c2a50 = 0;",
        "DAT_a13c29f4 = 0;",
        "DAT_a13c177c = 0;",
    ))
    checks.append(require(
        "loop duration maps to segment duration and retention count",
        text["configure_loop"],
        "if (param_2 == 5)",
        "DAT_a13c2a4c = 60000;",
        "DAT_a13c2a4c = 300000;",
        "DAT_a13c176c = param_2 / 5;",
    ))
    checks.append(require(
        "fresh loop open seeds delete cursor from primary file",
        text["open_mux"],
        "if (DAT_a13c2a40 == 4)",
        "if ((char)DAT_a13c298c == '\\0')",
        "DAT_a13c2a38 = DAT_a13c2a50;",
        "uVar7 = (uint)((char)DAT_a13c298c != '\\0');",
    ))
    checks.append(require(
        "open increments split count before deferred cleanup check",
        text["open_mux"],
        "DAT_a13c29f4 = DAT_a13c29f4 + 1;",
        "if ((((uVar7 == 1) && (DAT_a13c176c != 0xffffffff))",
        "matched_thunk_FUN_a01e656c(0x48010003,2,0);",
    ))
    checks.append(require(
        "deferred cleanup compares retained count against un-deleted splits",
        text["open_mux"],
        "DAT_a13c176c < (uint)((int)DAT_a13c29f4 - (int)DAT_a13c177c)",
    ))
    checks.append(require(
        "deferred action 2 reaches loop deletion only in mode 6",
        text["action_dispatch"],
        "else if (param_1 == 2)",
        "if (DAT_a1055cfa == '\\x06')",
        "matched_FUN_a01f51d0();",
    ))
    checks.append(require(
        "delete routine uses persisted cursor and split bound",
        text["delete_loop"],
        "if (DAT_a13c177c < DAT_a13c29f4)",
        "matched_FUN_a01f2ce0(DAT_a13c2a38)",
        "matched_FUN_a0224bf4(2,0,DAT_a13c2a38)",
    ))

    result = {
        "audit": "prerecord_loop_recovery",
        "scope": "offline decompiler-export structure audit",
        "firmware": "Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746",
        "source_root": str(SRC.relative_to(ROOT)),
        "files": {
            name: {
                "path": str(path.relative_to(ROOT)),
                "sha256": sha256(path),
                "size_bytes": path.stat().st_size,
                "line_hits": line_hits(path, [
                    "DAT_a13c298c",
                    "DAT_a13c2a38",
                    "DAT_a13c2a50",
                    "DAT_a13c29f4",
                    "DAT_a13c177c",
                    "matched_FUN_a01f51d0",
                    "matched_thunk_FUN_a01e656c(0x48010003,2,0)",
                ]),
            }
            for name, path in FILES.items()
        },
        "checks": checks,
        "conclusions": {
            "restart_flag_controls_counter_reset": True,
            "fresh_loop_open_seeds_cursor_from_primary_file": True,
            "restart_loop_open_preserves_prior_cursor_and_counters": True,
            "restart_open_can_schedule_deferred_delete_action_2": True,
            "deferred_delete_is_bounded_by_split_count_and_retention_count": True,
            "next_file_filter_and_cursor_recovery_semantics_closed": False,
            "runtime_file_identity_and_storage_errors_verified": False,
            "camera_side_prerecord_implemented": False,
        },
        "safety": {
            "camera_connected": False,
            "firmware_written": False,
            "ram_or_partition_written": False,
            "hidden_setter_invoked": False,
        },
    }
    OUT.mkdir(parents=True, exist_ok=True)
    output = OUT / "audit.json"
    output.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n")
    print(json.dumps({"output": str(output), "checks": len(checks), "status": "passed"}, ensure_ascii=False))


if __name__ == "__main__":
    main()
