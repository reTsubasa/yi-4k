#!/usr/bin/env python3
"""Audit the stock virtual-FIFO producer/consumer continuity edges.

This is a bounded, read-only audit of the fixed Ghidra decompiler export.  It
records the virtual handler fields used by Create/WriteEntry/SyncWritten and
the known audio/video call sites.  It does not execute RTOS code, attach to a
camera, or claim that a borrowed payload pointer is a lifetime lease.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled"
OUT = ROOT / "artifacts/device/2026-11-11-prerecord-producer-continuity"
CROSS_EPOCH = ROOT / "artifacts/device/2026-11-11-prerecord-cross-file-epoch/audit.json"
LIFECYCLE = ROOT / "artifacts/device/2026-11-10-prerecord/prerecord-fifo-lifecycle-audit.json"

FILES = {
    "fifo_init": SRC / "a045037c.c",
    "fifo_create": SRC / "a04509dc.c",
    "fifo_sync_written": SRC / "a044e8d4.c",
    "fifo_write_entry": SRC / "a0452254.c",
    "audio_bitstream_ready": SRC / "a045e7dc.c",
    "audio_stop": SRC / "a045f95c.c",
    "video_format_put_end": SRC / "a03ec814.c",
    "video_format_put_decode": SRC / "a03ec9f8.c",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def hits(path: Path, needles: list[str]) -> dict[str, list[int]]:
    rows = path.read_text().splitlines()
    return {
        needle: [line_no for line_no, line in enumerate(rows, 1) if needle in line]
        for needle in needles
        if any(needle in line for line in rows)
    }


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
    checks: list[dict] = []

    checks.append(require(
        "Create allocates virtual slots from the virtual registry and binds a base by stream",
        text["fifo_create"],
        "if (param_1[2] == 0)",
        "DAT_a1966194",
        "piVar12 = (int *)(DAT_a1966194 + uVar19 * 0xf8)",
        "if (*param_1 == *(int *)(iVar3 + 8))",
        "piVar12[4] = iVar3",
    ))
    checks.append(require(
        "Create sizes a 32-byte descriptor pool and stores its pool/token fields",
        text["fifo_create"],
        "piVar12[0x22] = iVar10",
        "piVar12[0x21] = iVar10 << 5",
        "FUN_a029a7d8(DAT_a04514e0,piVar12 + 0x20,piVar12 + 0x28,iVar10 << 5,0x20)",
        "FUN_a04f8dec(piVar12[0x20],0,piVar12[0x21])",
    ))
    checks.append(require(
        "Virtual Create seeds write and read cursors from the base FIFO",
        text["fifo_create"],
        "piVar12[0x26] = uVar8",
        "piVar12[0x27] = iVar11",
        "piVar12[0x24] = *(int *)(iVar3 + 0x90)",
        "piVar12[0x25] = iVar10",
        "piVar12[0x24] = iVar10",
    ))
    checks.append(require(
        "Init creates the base/virtual handler tables and the FIFO worker task",
        text["fifo_init"],
        "DAT_a1966194 = uVar6",
        "matched_analyst_task_create",
        "s_Mw_FifoTask_a061d328",
        "DAT_a19661e0 = param_1[3]",
        "DAT_a19661dc = param_1[2]",
    ))

    checks.append(require(
        "WriteEntry copies one 0x20-byte descriptor and advances the producer cursor",
        text["fifo_write_entry"],
        "*(uint *)(iVar14 + 0x1c) = uVar19",
        "matched_FUN_a044e734(8,0x12,0x92e,iVar9,iVar14,param_2,0x20)",
        "*(uint *)(iVar9 + 0x98) = uVar10 + 1",
        "*(uint *)(iVar9 + 0x9c) = *(int *)(iVar9 + 0x9c) + (uint)(0xfffffffe < uVar10)",
    ))
    checks.append(require(
        "Base WriteEntry queues worker work while virtual WriteEntry calls SyncWritten directly",
        text["fifo_write_entry"],
        "local_50 = 0x4000002",
        "FUN_a03bc598(DAT_a0452b64,&local_50,0)",
        "if (*(int *)(iVar9 + 0x10) == 0)",
        "matched_FUN_a044e8d4(*(undefined4 *)(param_1 + 4),param_2)",
    ))
    checks.append(require(
        "RemoveOnWrite enumerates virtual consumers and reads their +0x90/+0x94 read cursor",
        text["fifo_write_entry"],
        "iVar1 = DAT_a19661dc",
        "iVar6 = DAT_a1966194",
        "if (*(int *)(iVar3 + -0xc) == *(int *)(iVar12 + 8))",
        "uVar19 = *(uint *)(iVar3 + 0x7c)",
        "uVar8 = *(uint *)(iVar3 + 0x80)",
        "local_90 = 0xffffffff",
        "uStack_8c = 0xffffffff",
    ))
    checks.append(require(
        "Producer removal advances the base read cursor when the virtual lag threshold is exceeded",
        text["fifo_write_entry"],
        "*(uint *)(iVar12 + 0x90) = uVar17",
        "*(int *)(iVar12 + 0x94) = iVar3",
        "if (uVar5 < local_68)",
        "uVar10 = uVar10 + 1",
    ))

    checks.append(require(
        "SyncWritten matches active virtual handlers by stream ID",
        text["fifo_sync_written"],
        "iVar3 = DAT_a19661dc",
        "iVar13 = DAT_a1966194",
        "if ((*(int *)(iVar13 + 0xc) != 0) && (*(int *)(iVar13 + 8) == iVar6))",
        "if (*(int *)(iVar13 + 0xc4) == 0)",
    ))
    checks.append(require(
        "SyncWritten copies a descriptor into the virtual ring and advances its cursor",
        text["fifo_sync_written"],
        "matched_FUN_a044e734(8,3,0x406,iVar13,iVar7,param_2,0x20)",
        "*(uint *)(iVar13 + 0x98) = uVar9 + 1",
        "*(uint *)(iVar13 + 0x9c) = *(int *)(iVar13 + 0x9c) + (uint)(0xfffffffe < uVar9)",
    ))
    checks.append(require(
        "SyncWritten emits data, end/sentinel, and full events through the virtual callback",
        text["fifo_sync_written"],
        "(**(code **)(iVar13 + 0xa4))(iVar13,0x4000001,local_2c)",
        "(**(code **)(iVar13 + 0xa4))(iVar13,0x4000002,local_2c)",
        "(**(code **)(iVar13 + 0xa4))(iVar13,0x4000005,0)",
    ))
    checks.append(require(
        "SyncWritten releases the virtual data lock before callback invocation",
        text["fifo_sync_written"],
        "thunk_FUN_a03c3c5c(iVar11)",
        "(**(code **)(iVar13 + 0xa4))(iVar13,0x4000002,local_2c)",
        "(**(code **)(iVar13 + 0xa4))(iVar13,0x4000005,0)",
    ))
    checks.append(require_absent(
        "Audited SyncWritten body has no direct encoder stop/reset/delete call",
        text["fifo_sync_written"],
        "FUN_a04514e4",
        "FUN_a045f95c",
        "FUN_a045d928",
    ))

    checks.append(require(
        "Audio ready path submits descriptors through WriteEntry and propagates errors",
        text["audio_bitstream_ready"],
        "matched_FUN_a0452254(iVar10,&local_48)",
        "if (iVar7 == 0)",
        "s_AmpFifo_WriteEntry_failed_a0621314",
    ))
    checks.append(require(
        "Video format end path computes a 90-kHz PTS and submits a prepared descriptor",
        text["video_format_put_end"],
        "param_3 * 90000",
        "matched_FUN_a045202c(param_1,&local_e0)",
        "matched_FUN_a0452254(param_1,&local_e0)",
    ))
    checks.append(require(
        "Video decode-mark path also prepares then submits a descriptor",
        text["video_format_put_decode"],
        "matched_FUN_a045202c(param_1,&local_d0)",
        "matched_FUN_a0452254(param_1,&local_d0)",
    ))
    checks.append(require(
        "Audio stop path can submit an end marker through the same producer API",
        text["audio_stop"],
        "local_48 = 0xffffff",
        "matched_FUN_a045d928(iVar3)",
        "matched_FUN_a0452254(uVar6,&local_60)",
    ))

    cross = json.loads(CROSS_EPOCH.read_text())
    lifecycle = json.loads(LIFECYCLE.read_text())
    assert cross["conclusions"]["common_audio_video_capture_epoch_proven"] is False
    assert cross["conclusions"]["first_accepted_dma_block_to_first_video_pts_correlated"] is False
    checks.append({
        "name": "cross-file epoch audit remains bounded and unproven",
        "source": str(CROSS_EPOCH.relative_to(ROOT)),
        "assertions": [
            "common_audio_video_capture_epoch_proven == false",
            "first_accepted_dma_block_to_first_video_pts_correlated == false",
        ],
    })

    result = {
        "audit": "prerecord_producer_continuity",
        "scope": "offline Ghidra decompiler evidence for virtual FIFO handles, cursors, producer fanout, and call-site epoch limits",
        "firmware": "Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746",
        "source_root": str(SRC.relative_to(ROOT)),
        "handler_offsets": {
            "+0x80": "descriptor ring pointer",
            "+0x88": "descriptor capacity",
            "+0x90/+0x94": "read cursor low/high (base and virtual handlers)",
            "+0x98/+0x9c": "write cursor low/high (base and virtual handlers)",
            "+0xa4": "callback pointer",
            "+0xc0": "descriptor type filter used by virtual history path",
            "+0xc4": "virtual active/processing gate checked by SyncWritten",
        },
        "producer_edges": [
            ["base WriteEntry", "FIFO worker data-ready message 0x4000002", "worker later invokes SyncWritten"],
            ["WriteEntry RemoveOnWrite", "FIFO worker removal message 0x10000000", "distinct from data-ready fanout"],
            ["virtual WriteEntry", "SyncWritten", "direct call in audited body"],
            ["SyncWritten", "virtual registry", "stream ID match and +0xc4 gate"],
            ["SyncWritten", "virtual descriptor ring", "copy exactly 0x20 bytes; payload address remains descriptor data"],
            ["WriteEntry RemoveOnWrite", "virtual read cursors", "enumerates min cursor and may advance base read cursor"],
        ],
        "call_sites": {
            "audio_ready": "AudioEnc_BitstreamRdyHandler submits descriptor and returns WriteEntry error",
            "video_end": "AmpFormat_PutEndMark computes 90-kHz PTS before PrepareEntry/WriteEntry",
            "video_decode": "AmpFormat_PutDecodeMark uses PrepareEntry/WriteEntry",
            "audio_stop": "AudioEnc_StopEncodeImpl can submit a 0xffffff end marker after stopping encoder state",
        },
        "files": {
            name: {
                "path": str(path.relative_to(ROOT)),
                "sha256": sha256(path),
                "size_bytes": path.stat().st_size,
                "line_hits": hits(path, [
                    "DAT_a1966194",
                    "DAT_a19661dc",
                    "+ 0x98",
                    "0x4000001",
                    "0x4000002",
                    "0x4000005",
                    "matched_FUN_a0452254",
                ]),
            }
            for name, path in FILES.items()
        },
        "cross_epoch_dependency": {
            "path": str(CROSS_EPOCH.relative_to(ROOT)),
            "sha256": sha256(CROSS_EPOCH),
            "common_audio_video_capture_epoch_proven": cross["conclusions"]["common_audio_video_capture_epoch_proven"],
            "first_accepted_dma_block_to_first_video_pts_correlated": cross["conclusions"]["first_accepted_dma_block_to_first_video_pts_correlated"],
        },
        "lifecycle_dependency": {
            "path": str(LIFECYCLE.relative_to(ROOT)),
            "sha256": sha256(LIFECYCLE),
            "callback_after_delete_interleaving_present": any(
                case.get("name") == "delete_does_not_barrier_already_released_sync_callback"
                and case.get("callback_happened_after_successful_delete") is True
                for case in lifecycle.get("cases", [])
            ),
        },
        "checks": checks,
        "conclusions": {
            "virtual_create_binds_base_and_seeds_independent_cursors": True,
            "virtual_descriptor_ring_is_independent_from_base_descriptor_ring": True,
            "virtual_write_cursor_is_advanced_by_sync_written": True,
            "producer_fanout_copies_descriptor_but_not_payload_bytes": True,
            "base_reclamation_considers_virtual_read_cursor_lag": True,
            "producer_continuity_across_encoder_stop_or_rollover_proven": False,
            "stable_payload_lease_proven": False,
            "callback_quiescence_proven": False,
            "common_audio_video_capture_epoch_proven": False,
            "camera_side_prerecord_implemented": False,
        },
        "required_runtime_evidence": [
            "runtime identity of the virtual handler returned by Create and its base handler",
            "descriptor/payload lease that survives Peek unlock until copy and Remove finish",
            "producer ring/cache/DMA lifetime while virtual consumer lags",
            "scheduler evidence that callback and Delete cannot interleave after quiescence",
            "A/V first accepted block and PTS correlation across rollover",
            "encoder continuity and storage/error behavior during a one-minute pre-record commit",
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
