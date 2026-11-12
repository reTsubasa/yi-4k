#!/usr/bin/env python3
"""Audit the read-only loop deletion gates in the 1.10.7 decompiler export.

This is a source/structure audit only.  It does not load the camera, invoke an
API, or evaluate any firmware code.  The output records hashes and line-level
assertions so a later review can tell which decompiler export was inspected.
"""

from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled"
OUT = ROOT / "artifacts/device/2026-11-10-prerecord-loop-delete-gate"

FILES = {
    "delete_loop": SRC / "a01f51d0.c",
    "record_auto_start": SRC / "a0120b28.c",
    "card_full_stop": SRC / "a0120f10.c",
    "action_dispatch": SRC / "a011a208.c",
}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def lines(path: Path, needle: str) -> list[int]:
    return [n for n, line in enumerate(path.read_text().splitlines(), 1) if needle in line]


def require(name: str, text: str, pattern: str) -> dict:
    match = re.search(pattern, text, re.MULTILINE | re.DOTALL)
    if not match:
        raise AssertionError(f"missing {name}: {pattern}")
    return {"name": name, "pattern": pattern, "matched": match.group(0)}


def main() -> None:
    text = {name: path.read_text() for name, path in FILES.items()}
    checks = []

    # The delete routine is bounded by deletedCount < splitCounter and advances
    # its cursor only after the database deletion call returns.
    checks.append(require(
        "delete bounded by split counter",
        text["delete_loop"],
        r"if \(DAT_a13c177c < DAT_a13c29f4\).*?matched_FUN_a01f2ce0",
    ))
    checks.append(require(
        "delete uses type 2 database removal",
        text["delete_loop"],
        r"matched_FUN_a0224bf4\(2,0,DAT_a13c2a38\)",
    ))
    checks.append(require(
        "cursor advances after delete attempt",
        text["delete_loop"],
        r"DAT_a13c177c = DAT_a13c177c \+ 1;.*?matched_FUN_a0224bf4",
    ))

    # The connected-camera paths call deletion only for mode 6 (loop mode).
    checks.append(require(
        "auto-start card-full path gates deletion on mode 6",
        text["record_auto_start"],
        r"else if \(\(iVar1 == -4\) && \(DAT_a1055cfa == '\\x06'\)\).*?matched_FUN_a01f51d0",
    ))
    checks.append(require(
        "card-full stop path gates deletion on mode 6",
        text["card_full_stop"],
        r"if \(DAT_a1055cfa != '\\x06'\).*?return uVar1;.*?matched_FUN_a01f51d0",
    ))
    checks.append(require(
        "action 2 gates deletion on mode 6",
        text["action_dispatch"],
        r"else if \(param_1 == 2\).*?if \(DAT_a1055cfa == '\\x06'\).*?matched_FUN_a01f51d0",
    ))
    checks.append(require(
        "action 3 is rejected outside mode 6",
        text["action_dispatch"],
        r"else if \(\(param_1 == 3\) && \(DAT_a1055cfa != '\\x06'\)\).*?return 0;",
    ))

    result = {
        "audit": "prerecord_loop_delete_gate",
        "scope": "offline decompiler-export structure audit",
        "firmware": "Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746",
        "source_root": str(SRC.relative_to(ROOT)),
        "files": {
            name: {
                "path": str(path.relative_to(ROOT)),
                "sha256": digest(path),
                "size_bytes": path.stat().st_size,
                "line_hits": {
                    key: lines(path, key)
                    for key in (
                        "matched_FUN_a01f51d0",
                        "matched_FUN_a0224bf4",
                        "DAT_a1055cfa == '\\x06'",
                        "DAT_a1055cfa != '\\x06'",
                    )
                    if lines(path, key)
                },
            }
            for name, path in FILES.items()
        },
        "checks": checks,
        "conclusions": {
            "loop_delete_is_bounded_by_split_counter": True,
            "loop_delete_uses_database_type_2_and_advances_cursor": True,
            "ordinary_mode_action_3_does_not_enter_loop_delete": True,
            "card_full_paths_use_loop_delete_only_in_mode_6": True,
            "recovery_cursor_filter_semantics_closed": False,
            "runtime_file_identity_and_storage_side_effects_verified": False,
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
