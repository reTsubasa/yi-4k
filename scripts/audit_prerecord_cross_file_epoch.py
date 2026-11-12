#!/usr/bin/env python3
"""Audit the cross-file audio/video start-to-PTS graph.

The audit records only direct, visible relationships in the fixed Ghidra
decompiler export.  It is deliberately conservative: an absent field in one
function is reported as an unproven edge, not as proof that no other firmware
path can synchronize the streams.  No device code is executed.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled"
OUT = ROOT / "artifacts/device/2026-11-11-prerecord-cross-file-epoch"

FILES = {
    "audio_start": SRC / "a045da98.c",
    "audio_gate_writer": SRC / "a02941f4.c",
    "audio_pts": SRC / "a029016c.c",
    "audio_fifo_callback": SRC / "a045e7dc.c",
    "video_pipeline_open": SRC / "a046f4a8.c",
    "video_event_callback": SRC / "a046e6fc.c",
    "audio_pipeline_match": SRC / "a045fd38.c",
    "video_dsp_to_event": SRC / "a02ca5a0.c",
    "video_pts_repair": SRC / "a02c7660.c",
}


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
    checks = []

    checks.append(require(
        "audio start builds fixed PTS clock and opens source gate",
        text["audio_start"],
        "local_24 = 90000;",
        "matched_FUN_a0290b60(iVar1,&local_34)",
        "matched_FUN_a045d7b8(iVar2 + 10,iVar2 + 0xc)",
    ))
    checks.append(require(
        "audio source writer is gated by IoNode flag",
        text["audio_gate_writer"],
        "cVar1 = *(char *)(iVar3 + 4);",
        "if (cVar1 == '\\x01')",
        "matched_FUN_a029c680(iVar5,param_2,param_3)",
    ))
    checks.append(require(
        "audio PTS is synthesized from frame counter and setup fields",
        text["audio_pts"],
        "uVar4 = *(uint *)(iVar3 + 0x20);",
        "*(uint *)(iVar3 + 0x20) = uVar4 + 1;",
        "matched_FUN_a0295800(param_1,0,local_40)",
    ))
    checks.append(require(
        "audio callback copies event fields into FIFO descriptor",
        text["audio_fifo_callback"],
        "iVar11 = param_1[1];",
        "iVar12 = param_1[2];",
        "iVar2 = param_1[3];",
        "matched_FUN_a0452254(iVar10,&local_48)",
    ))
    checks.append(require(
        "video stores pipeline identity and registers event 0x13",
        text["video_pipeline_open"],
        "*(undefined4 *)(iVar1 + 0xc) = param_2;",
        "matched_FUN_a02c11b0(0x13,matched_FUN_a046e6fc,0,iVar1,param_4)",
    ))
    checks.append(require(
        "event 0x13 matches pipeline and invokes audio instance search",
        text["video_event_callback"],
        "if (*(uint *)(param_1 + 4) == (uint)bVar1 && bVar1 == 0)",
        "matched_FUN_a045fd38(uVar5)",
    ))
    checks.append(require(
        "audio instance search matches pipeline and opens source gate",
        text["audio_pipeline_match"],
        "param_1 != *(int *)(puVar3 + 10)",
        "matched_FUN_a045d7b8(puVar3,puVar3 + 2)",
    ))
    checks.append(require(
        "video DSP path repairs PTS before event 4",
        text["video_dsp_to_event"],
        "uVar14 = FUN_a02c7660(piVar10,&DAT_a06890e0 + iVar1)",
        "FUN_a02c1358(4,&local_58)",
    ))
    checks.append(require(
        "video PTS repair keeps per-stream previous PTS/base state",
        text["video_pts_repair"],
        "uVar4 = *(uint *)(param_2 + 8);",
        "uVar5 = *(uint *)(param_2 + 0xc);",
        "*(uint *)(param_1 + 0x18) = uVar4;",
    ))
    # The event-to-audio edge is a pipeline identity edge only in this export;
    # the callback does not consume event PTS or a DMA block index.
    checks.append(require_absent(
        "event callback has no audited PTS/DMA field use",
        text["video_event_callback"],
        "param_1 + 8",
        "param_1 + 0xc",
        "DAT_a1458568",
    ))
    checks.append(require_absent(
        "pipeline match has no audited PTS/DMA field use",
        text["audio_pipeline_match"],
        "param_1 + 8",
        "param_1 + 0xc",
        "A06890E0",
    ))

    result = {
        "audit": "prerecord_cross_file_epoch",
        "scope": "offline cross-file decompiler graph and bounded missing-edge audit",
        "firmware": "Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746",
        "source_root": str(SRC.relative_to(ROOT)),
        "graph": [
            ["audio_start", "audio_gate_writer", "source gate -> PCM payload copy"],
            ["audio_start", "audio_pts", "setup clock/frame counter -> synthetic audio PTS"],
            ["audio_pts", "audio_fifo_callback", "audio event fields -> FrameDesc/FIFO"],
            ["video_pipeline_open", "video_event_callback", "pipeline event 0x13"],
            ["video_event_callback", "audio_pipeline_match", "pipeline identity -> audio source gate"],
            ["video_dsp_to_event", "video_pts_repair", "DSP raw PTS -> repaired video PTS"],
        ],
        "files": {
            name: {
                "path": str(path.relative_to(ROOT)),
                "sha256": sha256(path),
                "size_bytes": path.stat().st_size,
                "line_hits": hits(path, [
                    "matched_FUN_a045d7b8",
                    "matched_FUN_a029c680",
                    "matched_FUN_a0295800",
                    "matched_FUN_a02c11b0(0x13",
                    "matched_FUN_a045fd38",
                    "matched_FUN_a02c7660",
                    "FUN_a02c1358(4",
                ]),
            }
            for name, path in FILES.items()
        },
        "checks": checks,
        "conclusions": {
            "audio_gate_and_video_event_share_pipeline_identity": True,
            "audio_pts_is_frame_counter_derived": True,
            "video_pts_is_dsp_descriptor_derived_and_repaired": True,
            "audited_event_gate_edge_carries_no_pts_or_dma_block": True,
            "common_audio_video_capture_epoch_proven": False,
            "first_accepted_dma_block_to_first_video_pts_correlated": False,
            "runtime_producer_restart_and_fifo_ownership_proven": False,
            "camera_side_prerecord_implemented": False,
        },
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
