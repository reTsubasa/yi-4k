#!/usr/bin/env python3
"""Original ARM cursor/registry edge cases with explicit external test doubles.

Only synthetic RAM is touched. This neither invokes a camera nor proves an
RTOS payload lease, scheduler barrier, actual backpressure or playable rollover.
"""
from __future__ import annotations

import hashlib
import importlib.util
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("fifo_lifecycle", ROOT / "scripts/prerecord-fifo-lifecycle.py")
life = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(life)
SRC = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/full/decompiled"
OUT = ROOT / "artifacts/device/2026-11-11-prerecord-cursor-registry/audit.json"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    image = life.arm.IMAGE.read_bytes()
    assert hashlib.sha256(image).hexdigest() == life.arm.DIGEST
    cases = []

    def machine():
        m = life.Machine(image)
        m.existing()
        m.put(life.BASE_FIFO + 0x80, 0x10009000)
        m.put(life.BASE_FIFO + 0x84, 256)
        return m

    def record(name, m, status, **extra):
        assert not any(m.locks.values()), (name, m.locks)
        cases.append(dict(name=name, status=status,
            virtual_read=m.get(life.VIRTUAL + 0x90, 8),
            virtual_write=m.get(life.VIRTUAL + 0x98, 8),
            virtual_pause_gate=m.get(life.VIRTUAL + 0xc4),
            virtual_in_use=m.get(life.VIRTUAL + 12),
            registry0=hex(m.get(life.REGISTRY)),
            callbacks=m.callbacks, external_events=m.events, **extra))

    for name in ("base_no_virtual", "base_lagged_virtual", "virtual_capped_by_base", "base_stale_inactive_virtual"):
        m = machine()
        handle = life.BASE_FIFO
        if name == "base_no_virtual":
            m.put(life.GLOBAL + 0x50, 0)
        elif name == "virtual_capped_by_base":
            handle = life.VIRTUAL
            m.put(life.BASE_FIFO + 0x98, 12, 8)
        else:
            m.put(life.VIRTUAL + 0x98, 12, 8)
            if name == "base_stale_inactive_virtual":
                m.put(life.VIRTUAL + 12, 0)
        status = m.run(0xA04534AC, handle, life.OUTPUT)
        result = [m.get(life.OUTPUT + i * 4) for i in range(3)]
        assert status == 0 and result == [8, 4, 4 if name == "base_no_virtual" else 1]
        record("get_info_" + name, m, status, result=result,
            constructed_inconsistent_state=name == "base_stale_inactive_virtual")

    m = machine()
    m.put(life.VIRTUAL + 0xc4, 1)
    m.put(life.VIRTUAL + 0xa4, life.CALLBACK)
    m.put(life.CONFIG + 16, 1, 1)
    m.put(life.CONFIG + 24, 128)
    before = bytes(m.uc.mem_read(life.QUEUE, 256))
    m.run(0xA044E8D4, life.BASE_FIFO, life.CONFIG)
    assert not m.callbacks and m.get(life.VIRTUAL + 0x98, 8) == 9
    assert bytes(m.uc.mem_read(life.QUEUE, 256)) == before
    record("sync_written_pause_gate_skips_descriptor_and_callback", m, None,
        void_api=True, descriptor_queue_preserved=True)

    m = machine()
    m.put(life.VIRTUAL + 0xc4, 1)
    status = m.run(0xA0452E9C, life.VIRTUAL, life.CONFIG)
    assert status == 0 and m.get(life.VIRTUAL + 0x90, 8) == 9
    assert m.get(life.VIRTUAL + 0x98, 8) == 9 and m.get(life.VIRTUAL + 0xc4) == 0
    assert m.get(life.REGISTRY) == life.VIRTUAL and not m.callbacks
    record("resume_default_reanchors_to_current_base_write", m, status,
        selector=0, zero_pending_descriptors=True, no_lease_acquired=True)

    m = machine()
    m.uc.mem_write(0x10009000, bytes([0x5a]) * 256)
    status = m.run(0xA0452B68, life.BASE_FIFO)
    assert status == 0
    assert all(m.get(handler + offset, 8) == 0
        for handler in (life.BASE_FIFO, life.VIRTUAL) for offset in (0x90, 0x98))
    assert bytes(m.uc.mem_read(life.QUEUE, 256)) == bytes(256)
    assert bytes(m.uc.mem_read(0x10009000, 256)) == bytes(256)
    assert m.get(life.REGISTRY) == life.VIRTUAL and not m.callbacks
    record("erase_base_resets_matched_virtual_cursor_without_unregister", m, status,
        base_and_virtual_descriptor_queues_zero=True)

    m = machine()
    m.put(life.REGISTRY, 0)
    status = m.run(0xA0451960, life.VIRTUAL, life.OUTPUT, 0)
    assert status == 0 and m.get(life.OUTPUT) == life.QUEUE + 5 * 32
    record("peek_does_not_require_registry_identity", m, status,
        descriptor_pointer=hex(m.get(life.OUTPUT)), constructed_inconsistent_state=True)

    m = machine()
    m.put(life.REGISTRY, 0x10005000)
    status = m.run(0xA04514E4, life.VIRTUAL)
    assert status == 0 and m.get(life.REGISTRY) == 0 and m.get(life.VIRTUAL + 12) == 0
    record("delete_checks_registry_nonzero_not_pointer_identity", m, status,
        registry_before="0x10005000", constructed_inconsistent_state=True,
        limitation="An adversarial synthetic registry state, not evidence of observed device corruption")

    source_needles = {
        "a044e734.c": ["*(char *)(param_4 + 0xf4) == '\\x01'", "DAT_a19c6340 = DAT_a19c6340 + 1"],
        "a0452e9c.c": ["*(int *)(iVar9 + 0xc4) == 0", "*(undefined4 *)(iVar9 + 0xc4) = 0"],
        "a04534ac.c": ["param_2[2] = uVar6", "matched_FUN_a04534ac(*(int *)(iVar5 + 0x10),&local_2c)"],
        "a0452b68.c": ["*(undefined4 *)(iVar5 + 0x90) = 0", "*(undefined4 *)(iVar5 + 0x98) = 0"],
        "a0451960.c": ["*param_2 = iVar5", "matched_thunk_FUN_a03c3c5c(iVar3 + 0x14)"],
        "a04514e4.c": ["if ((&DAT_a196608c)[*param_1] == 0)", "(&DAT_a196608c)[*param_1] = 0"],
    }
    sources = []
    for name, needles in source_needles.items():
        path = SRC / name
        source = path.read_text()
        assert all(needle in source for needle in needles), name
        sources.append(dict(path=str(path.relative_to(ROOT)), sha256=sha(path),
            verified_needles=needles,
            line_hits={needle:[i for i,line in enumerate(source.splitlines(),1) if needle in line]
                for needle in needles}))

    ownership_path = ROOT / "artifacts/device/2026-11-10-prerecord/prerecord-fifo-rollover-ownership-audit.json"
    ownership = json.loads(ownership_path.read_text())
    assert ownership["callback_range"] == ["0xa01f569c", "0xa01f5ff0"]
    assert len(ownership["normal_full_close_delete_sites"]) == 6
    forbidden = {"0xa04509dc", "0xa04514e4", "0xa0451c94", "0xa0452b68", "0xa01f6088", "0xa01f6340"}
    assert not any(edge["target"] in forbidden for edge in ownership["callback_direct_edges"])

    windows = [(0xA044E734,0xA044E8D4),(0xA0452B68,0xA0452E9C),
        (0xA0452E9C,0xA04534AC),(0xA04534AC,0xA045366C)]
    result = dict(audit="prerecord_cursor_registry", image_sha256=life.arm.DIGEST,
        evidence_type="Original ARM functions executed with constructed RAM and existing explicit OS/allocator/callback test doubles; bounded static field verification",
        dependency_script=dict(path="scripts/prerecord-fifo-lifecycle.py",sha256=sha(ROOT / "scripts/prerecord-fifo-lifecycle.py")),
        cases=cases, original_arm_cases=len(cases), sources=sources,
        byte_windows=[dict(start=hex(lo),end_exclusive=hex(hi),sha256=hashlib.sha256(image[lo-life.arm.BASE:hi-life.arm.BASE]).hexdigest()) for lo,hi in windows],
        rollover_dependency=dict(path=str(ownership_path.relative_to(ROOT)),sha256=sha(ownership_path),
            callback_range=ownership["callback_range"], forbidden_direct_targets_absent=sorted(forbidden),
            full_close_delete_sites=len(ownership["normal_full_close_delete_sites"]),
            limitation="Uses prior bounded direct-call audit; does not prove runtime cursor/payload identity or a complete indirect-call closure"),
        conclusions=dict(c4_is_pause_resume_gate_not_callback_counter=True,
            f4_is_trace_enable_not_payload_lease=True,
            get_info_free_credit_takes_minimum_across_base_and_virtual=True,
            cursor_reset_is_independent_from_registry_unregister=True,
            registry_nonzero_is_not_identity_or_generation_validation=True,
            real_callback_inflight_counter_found=False, real_payload_lease_found=False,
            device_pre_record_or_runtime_backpressure_proven=False),
        limitations=["Synthetic invalid registry/inactive-stream cases prove API precondition boundaries, not that those states occur normally on a camera.",
            "OS locks are bookkeeping, callbacks and allocation are test doubles; no DMA, cache, scheduler or actual storage is executed.",
            "Resume selector 0 alone is executed; history selectors 1/2/3 are static evidence only.",
            "Erasing descriptors and resetting cursors is not a safe lease/callback barrier and is not proposed for device use.",
            "No direct access to the camera; no firmware, RAM or partition writes."],
        safety=dict(camera_connected=False,device_written=False,rtos_executed_on_device=False))
    OUT.parent.mkdir(parents=True,exist_ok=True)
    OUT.write_text(json.dumps(result,indent=2,ensure_ascii=False)+"\n")
    print(json.dumps(dict(output=str(OUT.relative_to(ROOT)),original_arm_cases=len(cases),source_checks=len(sources),status="passed")))


if __name__ == "__main__":
    main()
