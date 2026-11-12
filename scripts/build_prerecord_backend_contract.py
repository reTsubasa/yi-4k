#!/usr/bin/env python3
"""Build the offline evidence manifest for the minimum prerecord backend.

The output is a design contract assembled from already-produced audits.  It is
not an implementation and deliberately marks every runtime/device gate that
has no evidence yet.  No camera or firmware is accessed.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "artifacts/device/2026-11-11-prerecord-backend-contract"

EVIDENCE = {
    "fifo_consumer": ROOT / "artifacts/device/2026-11-10-prerecord/prerecord-fifo-consumer-validation.json",
    "fifo_rollover": ROOT / "artifacts/device/2026-11-10-prerecord/prerecord-fifo-rollover-ownership-audit.json",
    "session_rollover": ROOT / "artifacts/device/2026-11-10-prerecord/prerecord-session-rollover-audit.json",
    "capture_epoch": ROOT / "artifacts/device/2026-11-10-prerecord/prerecord-capture-epoch-audit.json",
    "start_anchor": ROOT / "artifacts/device/2026-11-10-prerecord/prerecord-start-anchor-audit.json",
    "frame_desc": ROOT / "artifacts/device/2026-11-10-prerecord/prerecord-dsp-framedesc-contract-audit.json",
    "loop_recovery": ROOT / "artifacts/device/2026-11-11-prerecord-loop-recovery/audit.json",
    "cross_file_epoch": ROOT / "artifacts/device/2026-11-11-prerecord-cross-file-epoch/audit.json",
    "payload_reclaim": ROOT / "artifacts/device/2026-11-11-prerecord-payload-reclaim/audit.json",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(path: Path) -> dict:
    return json.loads(path.read_text())


def check(name: str, condition: bool, detail: str) -> dict:
    if not condition:
        raise AssertionError(f"{name}: {detail}")
    return {"name": name, "status": "passed", "detail": detail}


def main() -> None:
    data = {name: load(path) for name, path in EVIDENCE.items()}
    checks = [
        check(
            "fifo host and ARM model agree",
            data["fifo_consumer"].get("case_count") == 20
            and data["fifo_consumer"].get("host_execution_count") == 20
            and data["fifo_consumer"].get("arm_execution_count") == 20
            and data["fifo_consumer"].get("device_access") is False,
            "20 host + 20 compiled ARM cases, no device access",
        ),
        check(
            "session rollover evidence is offline",
            data["session_rollover"].get("snippet_cases_passed") == 21,
            "21 original-instruction rollover cases passed",
        ),
        check(
            "capture epoch remains an open boundary",
            data["capture_epoch"].get("snippet_cases_passed") == 11,
            "11 capture/DMA source-gate cases are evidence, not runtime epoch proof",
        ),
        check(
            "cross-file epoch marks missing correlation",
            data["cross_file_epoch"]["conclusions"].get("common_audio_video_capture_epoch_proven") is False
            and data["cross_file_epoch"]["conclusions"].get("first_accepted_dma_block_to_first_video_pts_correlated") is False,
            "common epoch and first-DMA-to-video correlation are false",
        ),
        check(
            "loop recovery marks file identity unresolved",
            data["loop_recovery"]["conclusions"].get("next_file_filter_and_cursor_recovery_semantics_closed") is False
            and data["loop_recovery"]["conclusions"].get("runtime_file_identity_and_storage_errors_verified") is False,
            "recovery cursor/file identity and storage errors remain unverified",
        ),
        check(
            "frame descriptor result is offline",
            data["frame_desc"].get("device_access") is False,
            "FrameDesc contract uses offline original-instruction evidence",
        ),
        check(
            "stock virtual cursor does not grant payload retention",
            data["payload_reclaim"]["conclusions"].get("held_virtual_descriptor_is_not_payload_lease") is True
            and data["payload_reclaim"]["conclusions"].get("owned_payload_copy_before_retirement_required") is True
            and data["payload_reclaim"]["conclusions"].get("actual_dsp_overwrite_or_copy_deadline_proven") is False,
            "Original ARM retirement counterexample rejects descriptor-only retention; hardware copy deadline remains unproven",
        ),
    ]

    states = [
        {"state": "OFF", "entry": "no consumer, no writer, no owned handle", "exit": "prepare accepted", "failure": "remain OFF"},
        {"state": "ARMING", "entry": "validate record mode, base stream and SD; create virtual FIFO; open own manifest", "exit": "all ownership tokens recorded", "failure": "CREATE_UNCERTAIN; retain any handle and stop retry"},
        {"state": "ARMED", "entry": "callback admitted and read guard available", "exit": "first stable descriptor begins rolling writer", "failure": "QUIESCE/READ_GUARD failure; do not delete"},
        {"state": "ROLLING", "entry": "copy payload and persist complete segments", "exit": "trigger, rollover, EOS or stop", "failure": "COPY_RETRY, STORAGE_FULL or CURSOR_UNCERTAIN"},
        {"state": "ROLLOVER_PENDING", "entry": "stock mux limit/event-3 at sync boundary", "exit": "old file closed and new header/manifest committed", "failure": "ROLLOVER_FAILED; retain old segment and stop publishing new one"},
        {"state": "COMMITTING", "entry": "camera voice START or shutter event accepted once", "exit": "pre-trigger segments frozen and post-trigger writer active", "failure": "COMMIT_UNCERTAIN; preserve manifest and do not toggle STOP"},
        {"state": "FINALIZING", "entry": "explicit STOP or EOS", "exit": "all selected files playable and manifest durable", "failure": "FINALIZE_FAILED; retain files as pending"},
        {"state": "QUIESCING", "entry": "block new callbacks and wait in-flight owner accesses", "exit": "callback count zero and handle/registry verified", "failure": "QUIESCE_FAILED; never call Delete"},
        {"state": "CLOSED", "entry": "quiesce passed, Delete succeeded, manifest closed", "exit": "new generation only", "failure": "local idempotent close"},
        {"state": "RECOVERY_REQUIRED", "entry": "reboot, SD error or uncertain backend return", "exit": "own manifest and files independently verified", "failure": "preserve orphan/unknown files; no factory loop delete"},
    ]

    transitions = [
        {"from": "OFF", "event": "prepare", "to": "ARMING", "guard": "recording pipeline active; no existing owner"},
        {"from": "ARMING", "event": "create/open success", "to": "ARMED", "guard": "base stream valid; manifest/session identity persisted"},
        {"from": "ARMED", "event": "stable descriptor", "to": "ROLLING", "guard": "begin_read→peek→copy→persist→remove→end_read"},
        {"from": "ROLLING", "event": "sync-frame limit", "to": "ROLLOVER_PENDING", "guard": "mux thread owns close/open; do not call raw callback"},
        {"from": "ROLLING", "event": "START event", "to": "COMMITTING", "guard": "first typed camera voice/shutter START wins; App does not parse voice"},
        {"from": "ROLLING", "event": "STOP/EOS", "to": "FINALIZING", "guard": "EOS has no payload and is not an implicit ack"},
        {"from": "FINALIZING", "event": "durable output", "to": "QUIESCING", "guard": "callback admission closed"},
        {"from": "QUIESCING", "event": "barrier passed", "to": "CLOSED", "guard": "only then Delete unique handle"},
        {"from": "*", "event": "uncertain return, power/SD failure", "to": "RECOVERY_REQUIRED", "guard": "retain handle/manifest; no automatic retry or factory deletion"},
    ]

    failure_contract = [
        {"condition": "Create returns error or ambiguous handle", "action": "enter CREATE_UNCERTAIN; retain output handle, disable retry/Delete", "evidence": "offline consumer cases create_failure_*; camera runtime missing"},
        {"condition": "Peek empty", "action": "remain ROLLING/ARMED; no cursor movement", "evidence": "offline consumer peek_empty"},
        {"condition": "payload copy/read guard fails", "action": "mark gap/fail prerecord if stable ownership cannot be re-established; never retry a raw stock pointer merely because virtual cursor is unchanged", "evidence": "original ARM payload retirement counterexample; generic consumer retry requires an independently valid lease"},
        {"condition": "persist fails", "action": "do not Remove; retry only an owned payload or independently revalidated lease, otherwise enter STORAGE_ERROR", "evidence": "offline persist_failure_then_retry; stock virtual cursor alone is insufficient"},
        {"condition": "Remove returns nonzero", "action": "enter CURSOR_UNCERTAIN; never re-save/re-remove same frame", "evidence": "offline remove_failure_after_cursor_advance"},
        {"condition": "EOS/special end", "action": "stop consuming; no payload read and no implicit Remove", "evidence": "offline high_level_eos/raw_eos + FrameDesc contract"},
        {"condition": "rollover close/open fails", "action": "retain closed segment and manifest; stop publishing next segment", "evidence": "stock assert/error paths static only"},
        {"condition": "callback quiesce fails", "action": "do not Delete virtual FIFO; keep owner and retry barrier", "evidence": "offline quiesce_failure_then_retry; runtime barrier missing"},
        {"condition": "Delete fails", "action": "retain handle/registry state; enter DELETE_FAILED", "evidence": "offline delete_failure_handle_retained"},
        {"condition": "reboot or SD removal", "action": "mark in-progress files UNKNOWN, verify only own manifest identities, never call factory loop deletion", "evidence": "loop recovery static audit; physical recovery missing"},
    ]

    runtime_gates = [
        {"gate": "virtual FIFO create/base validity", "status": "missing", "required": "real stream ID, registry, handle and failure cleanup on camera"},
        {"gate": "descriptor/payload stable lease", "status": "stock_virtual_cursor_rejected_hardware_copy_window_missing", "required": "immediate copy to owned storage before retirement, with measured DMA/cache stability for the whole copy; begin/end software guards alone do not protect stock payload"},
        {"gate": "callback quiescence before Delete", "status": "missing", "required": "in-flight callback count and no stale callback after Delete"},
        {"gate": "segment first access unit", "status": "missing", "required": "new file receives NAL7/NAL8 then IDR/NAL5 in real order"},
        {"gate": "A/V capture epoch", "status": "missing", "required": "gate 0→1, first accepted DMA block, first video PTS and audio frame counter correlation"},
        {"gate": "continuous producer across rollover", "status": "missing", "required": "no hidden encoder restart; PTS/AAC config continuity"},
        {"gate": "storage/power recovery", "status": "missing", "required": "full card, unplug, reboot and partial MP4 handling"},
        {"gate": "camera voice/shutter delivery", "status": "missing", "required": "typed START event and physical shutter debounce bound to commit"},
    ]

    result = {
        "contract": "yi4k_prerecord_minimum_camera_backend",
        "version": 2,
        "generated_scope": "offline design contract assembled from existing evidence",
        "candidate_status": "offline_contract_only_not_device_ready",
        "applicability": {
            "stock_virtual_fifo_as_payload_lease": "rejected_by_original_arm_retirement_counterexample",
            "generic_consumer_model": "requires independently protected or already-owned payload; it is not a deployable stock FIFO backend",
            "candidate_ingress": "synchronous early copy before chaining stock video callback, followed by a nonblocking owned-frame spool",
            "ingress_ready": False,
            "unresolved": "hardware stable copy window, safe single-slot callback installation, audio ingress and common A/V epoch",
        },
        "evidence": {
            name: {"path": str(path.relative_to(ROOT)), "sha256": sha256(path), "size_bytes": path.stat().st_size}
            for name, path in EVIDENCE.items()
        },
        "checks": checks,
        "states": states,
        "transitions": transitions,
        "failure_contract": failure_contract,
        "runtime_gates": runtime_gates,
        "invariants": [
            "one serialized owner for virtual FIFO Create/Peek/Remove/Delete",
            "never advance base FIFO or free encoder payload addresses",
            "holding a stock virtual descriptor never substitutes for payload ownership or a hardware-stable copy window",
            "persist payload before Remove; Remove nonzero makes cursor uncertain",
            "EOS is a stop marker, not an empty queue or implicit ack",
            "rollover is mux-owned and only publishes a segment after a valid sync/header boundary",
            "only camera-typed START or shutter event triggers commit; Android does not parse voice",
            "factory loop deletion and recovery cursor are never used for prerecord spool cleanup",
            "uncertain resource ownership is preserved for recovery instead of guessed cleanup",
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
    output = OUT / "contract.json"
    output.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n")
    print(json.dumps({"output": str(output), "checks": len(checks), "states": len(states), "transitions": len(transitions), "status": "passed"}, ensure_ascii=False))


if __name__ == "__main__":
    main()
