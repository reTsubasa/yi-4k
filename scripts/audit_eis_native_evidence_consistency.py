#!/usr/bin/env python3
"""Cross-check offline EIS native-entry evidence and its documentation.

This is a provenance audit only.  It reads the fixed 1.10.7 image, existing
offline JSON receipts and Markdown claims; it never opens a device transport,
writes firmware/RAM, emits a payload, or executes target code.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin"
IMAGE_SHA = "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(checks: list[dict], name: str, ok: bool, detail: str) -> None:
    checks.append({"name": name, "passed": bool(ok), "detail": detail})
    if not ok:
        raise AssertionError(f"{name}: {detail}")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--output", required=True, type=Path)
    args = ap.parse_args()
    out = args.output if args.output.is_absolute() else ROOT / args.output
    out.mkdir(parents=True, exist_ok=True)

    checks: list[dict] = []
    image_digest = digest(IMAGE)
    require(checks, "fixed_image_sha256", image_digest == IMAGE_SHA,
            f"{image_digest} == {IMAGE_SHA}")

    evidence = [
        {
            "id": "first_entry",
            "script": ROOT / "scripts/audit_native_first_entry_contract.py",
            "receipt": ROOT / "artifacts/device/2026-11-10-native-first-entry-contract/audit.json",
            "doc": ROOT / "docs/device-1107-first-entry-implementation-contract.md",
            "receipt_sha": None,
            "script_field": "script_sha256",
        },
        {
            "id": "task_stop",
            "script": ROOT / "scripts/audit_native_task_stop_proof.py",
            "receipt": ROOT / "artifacts/verification/2026-11-11-native-task-stop-proof-run03/audit.json",
            "doc": ROOT / "docs/device-1107-native-task-stop-proof.md",
            "receipt_sha": "1bd819bd1f9879d9e78e88439b3bf07a2cc08ff669ea9a4f753008012bfca2d7",
            "script_field": "script_sha256",
        },
        {
            "id": "completed_task_reuse",
            "script": ROOT / "scripts/audit_native_completed_task_reuse.py",
            "receipt": ROOT / "artifacts/verification/2026-11-11-native-completed-task-reuse-run05/audit.json",
            "doc": ROOT / "docs/device-1107-completed-task-reuse-boundary.md",
            "receipt_sha": "24a220cf1fe6bb4f1a76814a614b00fe91ac25eaa9fe8e9015078b871220c9fd",
            "script_field": "script_sha256",
        },
        {
            "id": "entry_scan",
            "script": ROOT / "scripts/audit_native_execution_entry_scan.py",
            "receipt": ROOT / "artifacts/device/2026-11-11-native-execution-entry-scan/scan.json",
            "doc": ROOT / "docs/device-1107-native-execution-entry-scan.md",
            "receipt_sha": "75a1c0193a6b8d14523c23b34e0ed40feafdaf92bcfa26d9296659414c7fbcba",
            "script_field": "script_sha256",
        },
    ]
    rows = []
    for item in evidence:
        script = item["script"]
        receipt = item["receipt"]
        doc = item["doc"]
        require(checks, f"{item['id']}_files_exist",
                script.is_file() and receipt.is_file() and doc.is_file(),
                f"{script.relative_to(ROOT)}, {receipt.relative_to(ROOT)}, {doc.relative_to(ROOT)}")
        report = json.loads(receipt.read_text())
        script_sha = digest(script)
        require(checks, f"{item['id']}_script_sha256",
                report.get(item["script_field"]) == script_sha,
                f"receipt={report.get(item['script_field'])} source={script_sha}")
        image_field = report.get("image_sha256", report.get("cpu_sha256"))
        if image_field is None and isinstance(report.get("image"), dict):
            image_field = report["image"].get("sha256")
        require(checks, f"{item['id']}_image_sha256", image_field == IMAGE_SHA,
                f"{image_field} == {IMAGE_SHA}")
        require(checks, f"{item['id']}_offline_flags",
                report.get("device_access") is False,
                f"device_access={report.get('device_access')!r}")
        if item["id"] == "first_entry":
            require(checks, "first_entry_schema",
                    report.get("schema") == "native-first-entry-contract/v2",
                    f"schema={report.get('schema')!r}")
            require(checks, "first_entry_no_writer", report.get("target_write") is False and
                    report.get("payload_or_writer_emitted") is False,
                    f"target_write={report.get('target_write')!r}, payload_or_writer_emitted={report.get('payload_or_writer_emitted')!r}")
        else:
            require(checks, f"{item['id']}_receipt_sha256", digest(receipt) == item["receipt_sha"],
                    f"{digest(receipt)} == {item['receipt_sha']}")
            if item["id"] == "entry_scan":
                require(checks, "entry_scan_no_writer", report.get("target_write") is False and
                        report.get("payload_or_writer_emitted") is False,
                        f"target_write={report.get('target_write')!r}, payload_or_writer_emitted={report.get('payload_or_writer_emitted')!r}")
        text = doc.read_text()
        for needle in (IMAGE_SHA, script.relative_to(ROOT).as_posix(), receipt.relative_to(ROOT).as_posix()):
            require(checks, f"{item['id']}_doc_refs_{needle[:12]}", needle in text,
                    f"{doc.relative_to(ROOT)} contains {needle}")
        require(checks, f"{item['id']}_doc_keeps_boundary",
                any(word in text for word in ("未完成", "尚未", "不能", "不构成部署")),
                "documentation retains an incomplete/non-deployment boundary")
        rows.append({"id": item["id"], "script": str(script.relative_to(ROOT)),
                     "receipt": str(receipt.relative_to(ROOT)),
                     "script_sha256": script_sha, "receipt_sha256": digest(receipt),
                     "device_access": report.get("device_access")})

    # Keep the roadmap's hard boundary synchronized with the receipts.  These
    # are intentionally exact phrases: deleting them would make an overclaim
    # visible in this gate instead of silently changing the scope of evidence.
    roadmap = ROOT / "docs/eis-execution-plan.md"
    matrix = ROOT / "docs/goal-evidence-matrix.md"
    prereq = ROOT / "docs/device-1107-native-execution-prereq-matrix.md"
    roadmap_text = roadmap.read_text()
    matrix_text = matrix.read_text()
    prereq_text = prereq.read_text()
    require(checks, "roadmap_boundary_files", roadmap.is_file() and matrix.is_file() and prereq.is_file(),
            "roadmap, goal matrix and native prereq matrix exist")
    for name, needle in {
        "roadmap_keeps_native_incomplete": "不能把 2b 升级为真机完成",
        "roadmap_keeps_icache_boundary": "I-cache 发布",
        "roadmap_keeps_rollback_boundary": "回滚证据",
    }.items():
        require(checks, name, needle in roadmap_text, f"eis-execution-plan.md contains {needle}")
    for name, needle in {
        "goal_matrix_eis_row": "| EIS 最小原生执行闭环 |",
        "goal_matrix_eis_unfinished": "| 未完成 |",
        "goal_matrix_icache_gap": "I-cache 可见性",
    }.items():
        require(checks, name, needle in matrix_text, f"goal-evidence-matrix.md contains {needle}")
    for name, needle in {
        "prereq_p1_missing": "| P1 | 存在外部可达、参数受控的首次入口 | 缺失",
        "prereq_p5_missing": "| P5 | 指令缓存/分支状态同步 | 缺失",
        "prereq_p11_missing": "| P11 | 冷启动和失败恢复 | 缺失",
    }.items():
        require(checks, name, needle in prereq_text, f"native-execution-prereq-matrix.md contains {needle}")

    passed = len(checks)
    report = {
        "schema": "eis-native-evidence-consistency/v1",
        "status": "passed",
        "scope": "offline provenance checks over fixed 1.10.7 image, receipts and Markdown",
        "device_access": False,
        "target_write": False,
        "payload_or_writer_emitted": False,
        "image": {"path": str(IMAGE.relative_to(ROOT)), "sha256": image_digest},
        "evidence": rows,
        "check_count": passed,
        "checks": checks,
        "limitations": [
            "Hash and wording consistency do not prove a device entry, cache publication, SMP completion, or rollback.",
            "The receipts remain bounded Unicorn/Capstone or static evidence and do not upgrade the native execution goal.",
        ],
        "script_sha256": digest(Path(__file__)),
    }
    out_file = out / "audit.json"
    out_file.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n")
    print(json.dumps({"status": report["status"], "check_count": passed,
                      "device_access": False, "output": str(out_file.relative_to(ROOT))}, ensure_ascii=False))


if __name__ == "__main__":
    main()
