#!/usr/bin/env python3
"""Cross-check PTB CRC metadata against bounded local partition captures."""
from __future__ import annotations

import argparse
import binascii
import hashlib
import json
from pathlib import Path


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("ptb", type=Path)
    ap.add_argument("--sys-sw", type=Path)
    ap.add_argument("--output", type=Path, required=True)
    args = ap.parse_args()
    ptb = json.loads(args.ptb.read_text())
    checks = []
    if args.sys_sw:
        row = next(r for r in ptb["records"] if r["name"] == "SYS_SW")
        data = args.sys_sw.read_bytes()
        n = row["actual_size"]
        got = binascii.crc32(data[:n]) & 0xFFFFFFFF
        expected = int(row["data_crc32"], 16)
        checks.append({
            "name": "SYS_SW",
            "source": str(args.sys_sw),
            "source_bytes": len(data),
            "actual_size_from_ptb": n,
            "source_sha256": hashlib.sha256(data).hexdigest(),
            "crc32_computed_over_actual_size": f"0x{got:08x}",
            "crc32_from_ptb": f"0x{expected:08x}",
            "matches": got == expected,
        })
    result = {
        "ptb_source_sha256": ptb["sha256"],
        "checks": checks,
        "scope": "Only local captures supplied to this command; no claim about un-captured partitions or NAND OOB.",
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"checks": len(checks), "all_match": all(x["matches"] for x in checks)}))


if __name__ == "__main__":
    main()
