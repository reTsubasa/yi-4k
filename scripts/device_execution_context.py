#!/usr/bin/env python3
"""Hash-pinned offline evidence for HCMgr lifetime and A32 I-cache operations.

No device access. An aligned opcode scan is not a complete control-flow analysis,
and does not cover Thumb code or an uncaptured image. Labels are analyst supplied.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import struct

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis'
BASE = 0xA0100000
EXPECTED = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
FUNCTIONS = {
    0xA018756C: 'app_main_boot',
    0xA01E5CE8: 'hcmgr_attach',
    0xA01E5D44: 'hcmgr_detach_request',
    0xA01E5DA4: 'hcmgr_enqueue',
    0xA01E6258: 'hcmgr_clear_state',
    0xA01E627C: 'hcmgr_init',
    0xA01E653C: 'hcmgr_send_wait',
    0xA03D0548: 'boss_restore_context',
    0xA03D06C8: 'boss_resume',
    0xA03D0780: 'boss_restore',
    0xA04A283C: 'low_power_icache_lockdown_candidate',
    0xA04A41E8: 'mmu_initialization_primary',
    0xA04A43FC: 'mmu_initialization_secondary',
}
# Manually delimited code, NOT new function discovery. Literal words excluded.
RANGES = {
    'hcmgr_trampoline': (0xA01E5BD4, 0xA01E5C04),
    'app_detach_notify': (0xA019C3A8, 0xA019C3BC),
    'updater_detach_notify': (0xA01BD570, 0xA01BD584),
    'hcmgr_send_alias': (0xA01E6598, 0xA01E65A0),
    'boss_legacy_restore_excerpt': (0xA03D2040, 0xA03D2150),
}
EXPECTED_ICACHE = {
    0xA03D0738: 'boss_resume', 0xA03D0904: 'boss_restore',
    0xA03D20C8: 'legacy_context_restore',
    0xA03D2108: 'legacy_context_restore',
    0xA03D2148: 'legacy_context_restore',
    0xA04A2880: 'low_power_lockdown_candidate',
    0xA04A42D4: 'mmu_primary', 0xA04A43CC: 'mmu_primary_alternate',
    0xA04A442C: 'mmu_secondary', 0xA04A4490: 'mmu_secondary_alternate',
}


def main():
    image = (OUT / 'rtos-window.bin').read_bytes()
    if hashlib.sha256(image).hexdigest() != EXPECTED:
        raise SystemExit('Unexpected RTOS image; refusing evidence generation')
    functions = {int(r['entry'], 16): r for r in json.loads(
        (ROOT / 'artifacts/rtos-reverse/full/functions.json').read_text())}
    comparisons = {int(r['entry'], 16): r for r in json.loads(
        (OUT / 'function-comparison.json').read_text())}
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    md.detail = True
    evidence_dir = OUT / 'execution-context-evidence'
    evidence_dir.mkdir(exist_ok=True)

    def raw(lo, hi):
        assert BASE <= lo < hi <= BASE + len(image)
        return image[lo - BASE:hi - BASE]

    def word(at):
        return struct.unpack('<I', raw(at, at + 4))[0]

    def check(at, mnemonic, operands):
        ins = list(md.disasm(raw(at, at + 4), at))
        assert len(ins) == 1 and (ins[0].mnemonic, ins[0].op_str) == (mnemonic, operands), hex(at)

    def export(label, spans):
        data = b''.join(raw(lo, hi) for lo, hi in spans)
        listing = []
        for lo, hi in spans:
            decoded = list(md.disasm(raw(lo, hi), lo))
            assert sum(i.size for i in decoded) == hi - lo, label
            listing.extend(f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}' for i in decoded)
        path = evidence_dir / f'{label}.asm'
        path.write_text('\n'.join(listing) + '\n')
        return dict(sha256=hashlib.sha256(data).hexdigest(),
                    ranges=[[hex(lo), hex(hi)] for lo, hi in spans], range_end='exclusive',
                    asm=str(path.relative_to(ROOT)))

    exports = {}
    for at, label in FUNCTIONS.items():
        comparison = comparisons[at]
        assert comparison['same_body_bytes'], hex(at)
        spans = []
        for span in functions[at]['body_ranges']:
            lo, hi = (int(x, 16) for x in span.split('-'))
            spans.append((lo, hi + 1))
        record = export(label, spans)
        assert record['sha256'] == comparison['device_body_sha256'], hex(at)
        exports[label] = dict(entry=hex(at), old_export_body_identical=True, **record)
    for label, span in RANGES.items():
        exports[label] = dict(manually_delimited=True, **export(label, [span]))

    # Cross-check the specific control/data flow underlying the report.
    assert word(0xA01E5C04) == word(0xA01E5D40) == word(0xA01E5DA0) == 0xA13A21C0
    assert word(0xA01E6508) == 0xA13A20EC
    check(0xA0187BDC, 'bl', '#0xa01e5ce8')
    check(0xA0187BE0, 'bl', '#0xa01e627c')
    check(0xA0187BCC, 'movwle', 'r0, #0xd13c')
    check(0xA0187BD4, 'movtle', 'r0, #0xa06c')
    check(0xA0187BD0, 'movwgt', 'r0, #0x1810')
    check(0xA0187BD8, 'movtgt', 'r0, #0xa06d')
    check(0xA01E5BD8, 'ldr', 'r3, [r3, #0x1ac]')
    check(0xA01E5BE4, 'ldr', 'r3, [r3]')
    check(0xA01E5BE8, 'bx', 'r3')
    check(0xA01E5D0C, 'str', 'r5, [r4, #0x1ac]')
    check(0xA01E5D64, 'ldr', 'r3, [r3, #4]')
    check(0xA01E5D68, 'blx', 'r3')
    check(0xA01E6360, 'mov', 'r0, #1')
    check(0xA01E6378, 'str', 'r0, [sp, #0xc]')
    check(0xA01E638C, 'bl', '#0xa03bc2bc')
    check(0xA01E63A0, 'bl', '#0xa03bc7d8')
    for at in (0xA019C3A8, 0xA01BD570):
        check(at, 'mov', 'r0, #1')
        check(at + 8, 'movt', 'r0, #0xf001')
        check(at + 16, 'b', '#0xa01e6598')
    descriptors = []
    for at, entry, detach in [(0xA06CD13C, 0xA019D1E0, 0xA019C3A8),
                               (0xA06D1810, 0xA01BD5A4, 0xA01BD570)]:
        assert (word(at), word(at + 4)) == (entry, detach)
        descriptors.append(dict(address=hex(at), entry=hex(entry), detach_request=hex(detach),
                                descriptor_prefix_hex=raw(at, at + 8).hex()))

    trampoline = dict(
        firmware='Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746',
        image_sha256=EXPECTED, device_contacted=False,
        trampoline='0xA01E5BD4', descriptor_setter='0xA01E5CE8',
        selector_region=['0xA0187BC8', '0xA0187BDC'], selector_callsite='0xA0187BDC',
        manager_object='0xA13A21C0', descriptor_field_offset='0x1AC',
        descriptor_pointer_slot='0xA13A236C', mutex='0xA13A22F0',
        task=dict(object='0xA13A20EC', priority=110, arg=0, stack='0xA13901C0',
                  stack_bytes=65536, auto_start=1, later_core_exclusion_mask=1),
        descriptors=descriptors, detach_message='0xF0010001',
        observations=[
            'Boot attaches a fixed descriptor before creating the host-control-manager task.',
            'Entry dispatch is a tail branch without acquiring the attach/detach mutex.',
            'Detach holds the mutex while invoking descriptor+4; it does not clear the pointer.',
            'Both descriptor+4 callbacks enqueue exit message F0010001 with an infinite wait.',
            'TaskCreate auto_start=1 precedes core exclusion; no additional TaskResume is present.',
            'A01E6258 clears 0x12220 bytes starting at A13901C0 before attach/init.',
        ],
        limitations=[
            'Static bytes and ABI reconstruction only; no task was redirected or restarted.',
            'No safe hot replacement or custom native first execution is established.',
            'Descriptor size beyond the first two pointer words is not established.',
            'Ghidra PARAM xref A06DD13C disagrees with bytes; actual selected pointer is A06CD13C.',
        ], function_evidence=exports)
    (OUT / 'task-trampoline-1107.json').write_text(json.dumps(trampoline, indent=2) + '\n')

    operations, legacy_sync = [], []
    # All 4-byte aligned words of the captured window. The mask selects MCR p15,
    # op1=0, c7. Data and dormant code can also match; no reachability claim.
    for index, (w,) in enumerate(struct.iter_unpack('<I', image)):
        if (w & 0x0F100F10) != 0x0E000F10 or (w >> 16) & 15 != 7 or (w >> 21) & 7:
            continue
        crm, op2 = w & 15, (w >> 5) & 7
        if (crm, op2) not in ((1, 0), (5, 0), (5, 1), (5, 4)):
            continue
        at = BASE + index * 4
        decoded = list(md.disasm(struct.pack('<I', w), at))
        assert len(decoded) == 1 and decoded[0].mnemonic.startswith('mcr')
        row = dict(site=hex(at), raw=raw(at, at + 4).hex(),
                   instruction=f'{decoded[0].mnemonic} {decoded[0].op_str}')
        if (crm, op2) == (5, 4):
            legacy_sync.append(dict(**row, operation='legacy prefetch flush / instruction synchronization'))
        else:
            operation = {(1, 0): 'ICIALLUIS', (5, 0): 'ICIALLU', (5, 1): 'ICIMVAU'}[(crm, op2)]
            operations.append(dict(**row, operation=operation, context=EXPECTED_ICACHE.get(at, 'unknown')))
    assert {int(r['site'], 16) for r in operations} == set(EXPECTED_ICACHE)
    assert len(legacy_sync) == 1 and legacy_sync[0]['site'] == '0xa01001ac'
    # The only inner-shareable operations observed belong to BOSS restoration.
    assert [r['site'] for r in operations if r['operation'] == 'ICIALLUIS'] == ['0xa03d0738', '0xa03d0904']
    cache_report = dict(
        image_sha256=EXPECTED, device_contacted=False,
        scan=dict(bytes=len(image), alignment=4, encoding='A32 only',
                  selected_cp15_encodings=['p15,0,Rt,c7,c1,0', 'p15,0,Rt,c7,c5,0',
                                            'p15,0,Rt,c7,c5,1', 'p15,0,Rt,c7,c5,4']),
        instruction_invalidation_candidates=operations, legacy_synchronization=legacy_sync,
        function_evidence={k: v for k, v in exports.items() if k.startswith(('boss_', 'mmu_', 'low_power_'))},
        conclusion='No standalone returning cache-publication API identified within this scan scope.',
        limitations=[
            'An opcode match does not prove reachable code, CPU execution or correct hardware configuration.',
            'Thumb encodings, dynamically generated code, uncaptured regions and per-core remote work are not covered.',
            'Architectural operation names do not establish actual SMP broadcast domain or completion.',
            'BOSS restore changes task contexts and translation state; MMU functions rebuild/activate page tables.',
            'No existing function here is approved as a generic clear_cache implementation.',
        ])
    (OUT / 'code-publication-1107.json').write_text(json.dumps(cache_report, indent=2) + '\n')
    print(json.dumps(dict(verified_function_bodies=len(FUNCTIONS), manually_delimited_ranges=len(RANGES),
                          icache_invalidation_sites=len(operations), device_contacted=False)))


if __name__ == '__main__':
    main()
