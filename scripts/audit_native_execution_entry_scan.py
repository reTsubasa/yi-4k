#!/usr/bin/env python3
"""Bounded offline scan for returning stock entry and instruction-sync paths.

This deliberately searches the fixed 1.10.7 Ghidra export rather than invoking
any firmware routine.  It correlates every A32 I-cache opcode in the captured
RTOS window with its containing exported function, direct callers, callback
patterns and all five stock command tables.  It is a negative/triage report:
an opcode hit or an indirect ``blx`` is not execution evidence.
"""
from __future__ import annotations

import csv
import hashlib
import json
import re
import struct
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis"
IMAGE = SOURCE / "rtos-window.bin"
SHA = "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"
BASE = 0xA0100000
OUT = ROOT / "artifacts/device/2026-11-11-native-execution-entry-scan"

# This is the complete A32 scan set from the prior publication audit.  Keeping
# it explicit prevents accidentally turning data matches into reachability.
ICACHE = {
    0xA03D0738: "ICIALLUIS", 0xA03D0904: "ICIALLUIS",
    0xA03D20C8: "ICIALLU", 0xA03D2108: "ICIALLU", 0xA03D2148: "ICIALLU",
    0xA04A2880: "ICIALLU", 0xA04A42D4: "ICIALLU", 0xA04A43CC: "ICIALLU",
    0xA04A442C: "ICIALLU", 0xA04A4490: "ICIALLU",
}
TARGETS = {
    "0xa03cfbd8": "boss_local_tlb_helper",
    "0xa03d06c8": "boss_resume",
    "0xa03d0780": "boss_restore",
    "0xa04a283c": "low_power_cache_lockdown",
    "0xa04a5128": "low_power_sleep_body",
    "0xa04a5410": "low_power_dispatch_with_callbacks",
}


def parse_addr(value: str) -> int:
    return int(value, 16)


def load_exports():
    return json.loads((SOURCE / "full/functions.json").read_text())


def owner(functions, address):
    for item in functions:
        for span in item.get("body_ranges", []):
            try:
                start, end = (parse_addr(x) for x in span.split("-", 1))
            except ValueError:
                continue
            if start <= address < end:
                return {"entry": item["entry"], "name": item.get("name", ""), "body_range": span}
    return None


def lines_for(md, image, lo, hi):
    return [f"{ins.address:08x} {bytes(ins.bytes).hex()} {ins.mnemonic} {ins.op_str}"
            for ins in md.disasm(image[lo - BASE:hi - BASE], lo)]


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    image = IMAGE.read_bytes()
    digest = hashlib.sha256(image).hexdigest()
    if digest != SHA:
        raise SystemExit(f"unexpected fixed RTOS image: {digest}")
    functions = load_exports()
    refs = list(csv.DictReader((SOURCE / "full/references.tsv").open(), delimiter="\t"))
    calls = list(csv.DictReader((SOURCE / "full/calls.tsv").open(), delimiter="\t"))
    tables = json.loads((SOURCE / "command-tables-1107.json").read_text())["tables"]
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)

    def direct_to(target):
        return [dict(caller=r["caller"], site=r["site"], target=r["target"], type=r["type"])
                for r in calls if r["target"] == target]

    icache = []
    for address, operation in ICACHE.items():
        ins = list(md.disasm(image[address - BASE:address - BASE + 4], address))
        if len(ins) != 1:
            raise AssertionError(hex(address))
        context = owner(functions, address)
        icache.append(dict(address=hex(address), operation=operation,
                           bytes=bytes(ins[0].bytes).hex(), instruction=f"{ins[0].mnemonic} {ins[0].op_str}",
                           owner=context,
                           owner_incoming=[] if not context else direct_to(context["entry"])))

    # Export the normal-returning callback and cache candidates in source order.
    windows = {
        "boss_start": (0xA03CF01C, 0xA03CF194),
        "boss_resume": (0xA03CF4A0, 0xA03CF538),
        "boss_restore": (0xA03D0780, 0xA03D0948),
        "boss_callback_and_send": (0xA03CFBD8, 0xA03CFC0C),
        "low_power_dispatch": (0xA04A5410, 0xA04A54D0),
        "low_power_cache_lockdown": (0xA04A283C, 0xA04A28D0),
        "remote_interrupt_send": (0xA0482F3C, 0xA0482FCC),
    }
    exports = {}
    for name, (lo, hi) in windows.items():
        raw = image[lo - BASE:hi - BASE]
        path = OUT / f"{name}.asm"
        path.write_text("\n".join(lines_for(md, image, lo, hi)) + "\n")
        exports[name] = dict(start=hex(lo), end_exclusive=hex(hi), bytes=len(raw),
                             sha256=hashlib.sha256(raw).hexdigest(), asm=str(path.relative_to(ROOT)))

    # Every stock command table is checked against direct-call edges.  A table
    # handler may still call indirectly; that remains an explicit limitation.
    handlers = []
    for table in tables:
        for row in table["records"]:
            handler = row["handler"].lower()
            hits = [dict(site=c["site"], target=c["target"], type=c["type"])
                    for c in calls if c["caller"].lower() == handler and c["target"].lower() in TARGETS]
            handlers.append(dict(table=table["name"], index=row["index"], name=row["name"],
                                 handler=handler, direct_target_hits=hits))

    # The low-power dispatcher has callback parameters, but its only static
    # incoming edges are parameter/data references and one internal thunk.  It
    # is not a shell handler and it does not invalidate I-cache as a publish API.
    callback_edges = {
        "boss_descriptor": {
            "descriptor_factory": "0xa03cfbcc",
            "descriptor_data": "0xa078965c",
            "descriptor_words": ["0xa03cfcac", "0xa03d0998", "0xa03cfc14", "0xa03d02d4",
                                  "0xa03d06c8", "0xa03d0780", "0xa03d0a88", "0xa03cfc0c"],
            "manager_object": "0xa0789610",
            "callback_slot_write_sites": ["0xa03cfcac", "0xa03d08e0"],
            "callback_invocation": "A03CF01C loads descriptor+0x10 and calls it; A03CF4A0 calls descriptor+0x10 on resume",
            "external_parameter": False,
            "returning": True,
            "publication": False,
        },
        "low_power": {
            "entry": "0xa04a5410",
            "incoming": [dict(caller=c["caller"], site=c["site"], type=c["type"])
                         for c in calls if c["target"] == "0xa04a5410"],
            "parameter_references": [dict(site=r["from"], type=r["type"])
                                      for r in refs if r["to"] == "0xa04a5410"],
            "callback_sites": ["0xa04a5438 (blx r1)", "0xa04a5128 receives r1/r2 as callbacks"],
            "external_parameter": False,
            "returning": True,
            "publication": False,
            "normal_callers": ["0xa049a3c8 thunk", "0xa04a5128/0xa04a5410 internal low-power path"],
        },
    }

    direct_inventory = []
    for target, label in TARGETS.items():
        direct_inventory.append(dict(target=target, label=label, callers=direct_to(target)))

    remote = {
        "entry": "0xa0482f3c",
        "direct_callers": direct_to("0xa0482f3c"),
        "core_selection": "calls A04A2990 for current core; mode=1 selects bitwise-complement target mask",
        "operations": ["A0497454 configures target mask", "A0497628 triggers interrupt/event", "A03C3C5C releases lock"],
        "completion_wait_in_body": False,
        "ack_generation_or_status_read_in_body": False,
        "interpretation": "notification sender only; return is not remote handler completion",
    }
    task_core = {
        "boss_resume": {
            "entry": "0xa03d06c8", "task_argument": "param_1 points saved BOSS task/context",
            "normal_condition": "takes event flag (0x40, timeout 5000), then restores context and returns 0",
            "core_selection": "no caller-controlled core argument; context restore owns task/core state",
        },
        "boss_restore": {
            "entry": "0xa03d0780", "normal_condition": "task state at context+0xac must satisfy (state-2 & ~2)==0",
            "side_effects": "suspends/restores BOSS context, writes mappings/TCB, not a standalone entry",
        },
    }

    report = {
        "schema": "native-execution-entry-scan/v2",
        "scope": "offline fixed A32 RTOS window and fixed Ghidra exports; no device contact",
        "device_access": False,
        "target_write": False,
        "payload_or_writer_emitted": False,
        "image": {"path": str(IMAGE.relative_to(ROOT)), "base": hex(BASE), "sha256": digest},
        "icache_scan": {"alignment": 4, "encoding": "A32", "sites": icache,
                         "absent_in_scope": ["ICIMVAU (MCR c7,c5,1)"],
                         "limitations": ["No Thumb/dynamic/uncaptured code; opcode is not reachability or hardware completion."]},
        "returning_candidates": exports,
        "direct_target_inventory": direct_inventory,
        "remote_callback_notification": remote,
        "task_and_core_context": task_core,
        "callback_ownership": callback_edges,
        "stock_command_handler_scan": {
            "tables": [(t["name"], t["count"]) for t in tables],
            "handler_count": len(handlers),
            "handlers_with_direct_sync_candidate": [h for h in handlers if h["direct_target_hits"]],
            "all_handlers_directly_checked": True,
            "limitations": ["Indirect calls/computed handler pointers remain unknown; table inventory is static."]},
        "conclusion": {
            "normal_returning_sync_entry": False,
            "best_next_action": "Do not attempt a stock handler or callback for code publication; only pursue startup-integrated/static extension or obtain a separately approved runtime ownership and completion contract.",
            "reason": "ICIALLUIS/ICIALLU sites remain embedded in BOSS restore, MMU/context restore, or low-power setup. BOSS callback ownership is fixed descriptor state with no external parameter and no completion acknowledgment; low-power callbacks are internal parameters and never reach a stock command handler."
        },
        "script_sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
    }
    (OUT / "scan.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({"icache_sites": len(icache), "command_handlers": len(handlers),
                      "direct_sync_handlers": len(report["stock_command_handler_scan"]["handlers_with_direct_sync_candidate"]),
                      "normal_returning_sync_entry": False, "device_contacted": False}))


if __name__ == "__main__":
    main()
