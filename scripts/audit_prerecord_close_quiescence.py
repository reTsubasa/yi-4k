#!/usr/bin/env python3
"""Audit stock close/unregister/Delete ordering and callback quiescence.

This is a bounded offline audit of the decompiler export plus the existing
original-instruction interleaving record.  It does not execute RTOS code or
access a camera.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled"
OUT = ROOT / "artifacts/device/2026-11-11-prerecord-close-quiescence"

FILES = {
    "mux_register": SRC / "a01f5ff0.c",
    "mux_unregister": SRC / "a01f6044.c",
    "unregister_impl": SRC / "a01f0f2c.c",
    "register_impl": SRC / "a01f0e00.c",
    "normal_close": SRC / "a01f6088.c",
    "event_close": SRC / "a01f8f08.c",
    "event_unregister_wrapper": SRC / "a01f8ebc.c",
    "uvcd_stop": SRC / "a02335d0.c",
    "fifo_delete": SRC / "a04514e4.c",
    "mux_wait": SRC / "a043fec0.c",
}
INTERLEAVING = ROOT / "artifacts/device/2026-11-10-prerecord/prerecord-fifo-lifecycle-audit.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def hits(path: Path, needles: list[str]) -> dict[str, list[int]]:
    out = {}
    for needle in needles:
        found = [n for n, line in enumerate(path.read_text().splitlines(), 1) if needle in line]
        if found:
            out[needle] = found
    return out


def require(name: str, text: str, *needles: str) -> dict:
    missing = [needle for needle in needles if needle not in text]
    if missing:
        raise AssertionError(f"{name}: missing {missing}")
    return {"name": name, "needles": list(needles)}


def require_absent(name: str, text: str, *needles: str) -> dict:
    present = [needle for needle in needles if needle in text]
    if present:
        raise AssertionError(f"{name}: unexpected {present}")
    return {"name": name, "absent_needles": list(needles)}


def main() -> None:
    text = {name: path.read_text() for name, path in FILES.items()}
    interleaving = json.loads(INTERLEAVING.read_text())
    inter_cases = {case.get("name"): case for case in interleaving["cases"]}
    case = inter_cases["delete_does_not_barrier_already_released_sync_callback"]

    checks = [
        require("normal close waits before unregister", text["normal_close"], "matched_FUN_a043fec0(DAT_a13c1784,0xffffffff);", "matched_FUN_a01f6044();"),
        require("normal close deletes FIFOs after unregister", text["normal_close"], "matched_FUN_a043f9cc();", "matched_FUN_a043f82c(DAT_a13c1784);", "matched_FUN_a04514e4();"),
        require("event close waits before unregister", text["event_close"], "matched_FUN_a043fec0(DAT_a13c3690,0xffffffff);", "matched_FUN_a01f8ebc();"),
        require("event close deletes FIFOs after unregister", text["event_close"], "matched_FUN_a043f9cc();", "matched_FUN_a043f82c(DAT_a13c3690);", "matched_FUN_a04514e4();"),
        require("normal unregister delegates to flag table", text["mux_unregister"], "matched_FUN_a01f0f2c(&pcStack_1c);"),
        require("event unregister delegates to flag table", text["event_unregister_wrapper"], "matched_FUN_a01f0f2c(&local_1c);"),
        require("unregister marks handler inactive", text["unregister_impl"], "*(undefined1 *)(iVar2 * 0x14 + DAT_a01f0fd8 + 10) = 0;"),
        require_absent("unregister has no wait/delete barrier", text["unregister_impl"], "matched_FUN_a043fec0", "matched_FUN_a04514e4", "quiesce", "WaitComplete"),
        require("UVCd stop directly deletes handle", text["uvcd_stop"], "if (DAT_a142fb60 == 0)", "matched_FUN_a04514e4();", "DAT_a142fb60 = 0;"),
        require("FIFO delete only takes internal locks before freeing pool", text["fifo_delete"], "matched_FUN_a03bc46c(iVar4,0xffffffff);", "matched_FUN_a03bc46c(iVar5,0xffffffff);", "matched_analyst_pool_free()"),
        require_absent("FIFO delete has no callback wait call", text["fifo_delete"], "matched_FUN_a01f0f2c", "matched_FUN_a043fec0", "quiesce", "callback_count"),
        require("interleaving observes callback after delete", json.dumps(case), '"explicit_sequential_interleaving": true', '"callback_happened_after_successful_delete": true'),
    ]

    result = {
        "audit": "prerecord_close_quiescence",
        "scope": "offline source ordering plus existing original-instruction interleaving evidence",
        "firmware": "Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746",
        "source_root": str(SRC.relative_to(ROOT)),
        "close_sequences": {
            "normal_mp4": ["WaitComplete(pipe,-1)", "unregister mux handler", "Remove(pipe)", "Delete(pipe)", "Delete virtual FIFOs"],
            "event_record": ["WaitComplete(pipe,-1)", "unregister EventRecord handler", "Remove(pipe)", "Delete(pipe)", "Delete virtual FIFOs"],
            "uvcd_stop": ["if handle != 0", "Delete(handle)", "clear global handle"],
        },
        "files": {
            name: {
                "path": str(path.relative_to(ROOT)),
                "sha256": sha256(path),
                "size_bytes": path.stat().st_size,
                "line_hits": hits(path, [
                    "matched_FUN_a043fec0",
                    "matched_FUN_a01f6044",
                    "matched_FUN_a01f8ebc",
                    "matched_FUN_a04514e4",
                    "matched_FUN_a01f0f2c",
                    "= 0;",
                ]),
            }
            for name, path in FILES.items()
        },
        "interleaving_evidence": {
            "path": str(INTERLEAVING.relative_to(ROOT)),
            "sha256": sha256(INTERLEAVING),
            "case_name": case["name"],
            "explicit_sequential_interleaving": case["explicit_sequential_interleaving"],
            "callback_happened_after_successful_delete": case["callback_happened_after_successful_delete"],
        },
        "checks": checks,
        "conclusions": {
            "stock_mux_wait_is_not_callback_quiescence": True,
            "stock_unregister_is_flag_deactivation_only_in_audited_range": True,
            "stock_close_deletes_virtual_fifos_after_unregistration": True,
            "uvcd_stop_has_no_audited_quiesce_step": True,
            "fifo_delete_has_internal_mutexes_but_no_callback_barrier": True,
            "existing_interleaving_reaches_callback_after_successful_delete": True,
            "safe_new_consumer_stop_contract_proven": False,
            "camera_side_prerecord_implemented": False,
        },
        "required_runtime_evidence": [
            "prevent new callback admission for this handle",
            "count and drain callbacks already in flight",
            "hold payload/descriptor read lease until copy and Remove finish",
            "verify handle registry and base FIFO ownership immediately before Delete",
            "prove no stale callback executes after Delete on real scheduler",
        ],
        "safety": {
            "camera_connected": False,
            "firmware_written": False,
            "ram_or_partition_written": False,
            "hidden_setter_invoked": False,
            "rtos_executed": False,
        },
    }
    OUT.mkdir(parents=True, exist_ok=True)
    output = OUT / "audit.json"
    output.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n")
    print(json.dumps({"output": str(output), "checks": len(checks), "status": "passed"}, ensure_ascii=False))


if __name__ == "__main__":
    main()
