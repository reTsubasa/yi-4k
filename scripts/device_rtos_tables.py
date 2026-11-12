#!/usr/bin/env python3
"""Extract the already known RTOS command tables from the real 1.10.7 image.

Offline only.  The table locations are accepted only after checking the
device image hash; this prevents accidentally applying the 1.10.7 result to a
different firmware.
"""
from __future__ import annotations

import hashlib
import json
import re
import struct
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASE = 0xA0100000
IMAGE = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin"
OUT = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis"
EXPECTED = "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"
TABLES = {
    "antscmd": (0x46B404, 69, 8),
    "imgcmd": (0x4978E0, 17, 12),
    "ipccmd": (0x4A6C18, 6, 8),
    "drvcmd": (0x537334, 21, 12),
    "shell": (0x5F2EA0, 38, 12),
}


def cstr(image: bytes, address: int) -> str | None:
    off = address - BASE
    if not 0 <= off < len(image):
        return None
    end = image.find(b"\0", off, min(len(image), off + 256))
    if end < 0:
        return None
    raw = image[off:end]
    if not raw or any(x < 32 or x > 126 for x in raw):
        return None
    return raw.decode("ascii")


def extract(image: bytes, name: str, spec: tuple[int, int, int]):
    offset, count, stride = spec
    records = []
    for index in range(count):
        at = offset + index * stride
        name_ptr, handler = struct.unpack_from("<II", image, at)
        row = {
            "index": index,
            "entry_file_offset": hex(at),
            "name_address": hex(name_ptr),
            "name": cstr(image, name_ptr),
            "handler": hex(handler),
        }
        if stride == 12:
            row["third_word"] = hex(struct.unpack_from("<I", image, at + 8)[0])
        records.append(row)
    return {
        "name": name,
        "file_offset": hex(offset),
        "count": count,
        "stride": stride,
        "records": records,
    }


def main() -> None:
    image = IMAGE.read_bytes()
    digest = hashlib.sha256(image).hexdigest()
    if digest != EXPECTED:
        raise SystemExit(f"unexpected 1.10.7 RTOS window SHA-256: {digest}")
    tables = [extract(image, name, spec) for name, spec in TABLES.items()]
    bad = [r for t in tables for r in t["records"] if not r["name"]]
    if bad:
        raise SystemExit(f"unresolved command names: {len(bad)}")
    report = {
        "image": str(IMAGE),
        "sha256": digest,
        "base": hex(BASE),
        "method": "known table locations plus raw name/handler pointers; no runtime execution",
        "tables": tables,
        "fixed_handler_checks": {
            "loadbin": "0xA02A2584",
            "savebin": "0xA02A3DB0",
            "t_dispatch": "0xA029E1A4",
            "t_register": "0xA029E098",
        },
        "limitations": [
            "The table locations were inherited from the matching static image and checked bytewise here.",
            "A handler pointer is not proof that a command is safe or currently registered at runtime.",
            "No device memory was written and no command was invoked by this script.",
        ],
    }
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / "command-tables-1107.json").write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n")
    print(json.dumps({"sha256": digest, "tables": {t["name"]: t["count"] for t in tables}}, indent=2))


if __name__ == "__main__":
    main()
