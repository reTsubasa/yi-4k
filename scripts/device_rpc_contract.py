#!/usr/bin/env python3
"""Export manually reconstructed RPC tables with checks against captured 1.10.7 bytes.

Offline only. This checks image identity, annotated STR offsets and materialized
callback constants; it does not infer general data flow or execute the firmware.
Run with .venv-reverse/bin/python (Capstone is already installed there).
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from capstone.arm import ARM_OP_IMM, ARM_OP_MEM, ARM_OP_REG

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis'
BASE = 0xA0100000
EXPECTED = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'

# Annotated from constructor stores and RPC registration arguments, not symbols
# supplied by an SDK. Handler labels stay unknown unless separately established.
SERVICES = [
    ('test', 0x10000001, 0xA0245CF4, 0xA024621C, [
        (0xA0245620, 1, 0xA02461F8), (0xA024566C, 0, 0xA0246208)]),
    ('sharepreview', 0x1000000C, 0xA0247E54, 0xA0248018, [
        (0xA0247A20, 0, 0xA0247F5C), (0xA024840C, 0, 0xA0247FA0),
        (0xA02478F4, 0, 0xA0247FF0)]),
    ('linux_command_handler', 0x1000000B, 0xA0476380, 0xA0476404, [
        (0xA0477A44, 0, 0xA04763EC)]),
    ('net_control', 0x10000005, 0xA0476BB4, 0xA0476CB0, [
        (0xA0477B48, 1, 0xA0476C88), (0xA0477B9C, 1, 0xA0476C9C)]),
    ('data_notify', 0x10000006, 0xA04771D0, 0xA04772C4, [
        (0xA0477780, 1, 0xA0477298), (0xA0477950, 1, 0xA04772AC)]),
    ('event_notifier', 0x10000009, 0xA0478580, 0xA0478620, [
        (0xA0478418, 1, 0xA0478604)]),
    ('net_fifo', 0x10000004, 0xA04793A0, 0xA047955C, [
        (0xA0478744, 0, 0xA047947C), (0xA0478820, 0, 0xA04794A0),
        (0xA0478CB0, 0, 0xA0479530), (0xA0478CF4, 0, 0xA04794A8),
        (0xA0478D38, 0, 0xA0479498), (0xA0478DC0, 0, 0xA04794B0),
        (0xA0478E70, 0, 0xA04794B8), (0xA0478F20, 0, 0xA04794C0),
        (0xA0478F64, 0, 0xA0479534), (0xA0479004, 0, 0xA04794DC),
        (0xA04786AC, 0, 0xA04794E0), (0xA0478938, 0, 0xA04794E8),
        (0xA0478B00, 0, 0xA0479538), (0xA0478BAC, 0, 0xA0479540),
        (0xA0478C20, 0, 0xA047953C)]),
]
CORE = [0xA03CAAB4, 0xA03CA870, 0xA03CAE84, 0xA03CA6E8,
        0xA03CAC1C, 0xA03CADCC, 0xA04A283C, 0xA04B3B94]


def main():
    image = (OUT / 'rtos-window.bin').read_bytes()
    if hashlib.sha256(image).hexdigest() != EXPECTED:
        raise SystemExit('Unexpected RTOS image; no output generated')
    functions = {int(r['entry'], 16): r for r in json.loads(
        (ROOT / 'artifacts/rtos-reverse/full/functions.json').read_text())}
    comparisons = {int(r['entry'], 16): r for r in json.loads(
        (OUT / 'function-comparison.json').read_text())}
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    md.detail = True
    evidence_dir = OUT / 'rpc-contract-evidence'
    evidence_dir.mkdir(exist_ok=True)
    exports = {}
    for address in sorted(set(CORE + [s[2] for s in SERVICES])):
        comparison = comparisons[address]
        if not comparison['same_body_bytes']:
            raise SystemExit(f'Function requires fresh comparison: {address:#x}')
        instructions, raw = [], b''
        for span in functions[address]['body_ranges']:
            lo, hi = (int(a, 16) for a in span.split('-'))
            part = image[lo - BASE:hi - BASE + 1]
            raw += part
            instructions.extend(md.disasm(part, lo))
        digest = hashlib.sha256(raw).hexdigest()
        if digest != comparison['device_body_sha256']:
            raise SystemExit(f'Function digest mismatch: {address:#x}')
        text = '\n'.join(f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}'
                         for i in instructions) + '\n'
        (evidence_dir / f'{address:08x}.asm').write_text(text)
        exports[address] = (instructions, digest)

    services = []
    for name, program, constructor, call, rows in SERVICES:
        instructions, digest = exports[constructor]
        by_address = {i.address: i for i in instructions}
        call_ins = by_address[call]
        assert call_ins.mnemonic == 'bl' and (call_ins.operands[0].imm & 0xFFFFFFFF) == 0xA03CAAB4
        # Constant occurrence corroborates annotations, but is not a data-flow proof.
        low_halves, constants = {}, set()
        for i in instructions:
            op = i.operands
            if i.mnemonic == 'movw' and op[0].type == ARM_OP_REG:
                low_halves[op[0].reg] = op[1].imm
            elif i.mnemonic == 'movt' and op[0].reg in low_halves:
                constants.add(low_halves[op[0].reg] | (op[1].imm << 16))
            elif i.mnemonic == 'mov' and len(op) == 2 and op[1].type == ARM_OP_IMM:
                constants.add(op[1].imm & 0xFFFFFFFF)
        assert program in constants, hex(program)
        callbacks = []
        for index, (handler, mode, store) in enumerate(rows):
            i = by_address[store]
            assert i.mnemonic == 'str' and i.operands[1].type == ARM_OP_MEM
            assert i.operands[1].mem.disp == index * 8, hex(store)
            assert handler in constants, hex(handler)
            callbacks.append(dict(procedure=index + 1, handler=hex(handler),
                                  mode_raw=mode, store_site=hex(store),
                                  table_offset=index * 8))
        services.append(dict(name=name, program=hex(program), version=1,
                             constructor=hex(constructor), registration_call=hex(call),
                             constructor_sha256=digest, callbacks=callbacks))
    report = dict(image_sha256=EXPECTED, analysis='offline annotated static reconstruction',
                  device_contacted=False, services=services,
                  function_evidence={hex(a): {'sha256': digest,
                      'asm': str((evidence_dir / f'{a:08x}.asm').relative_to(ROOT))}
                      for a, (_, digest) in exports.items()},
                  limitations=[
                      'Tables are manual reconstructions corroborated by constants and STR offsets.',
                      'Mode words require per-service interpretation; this is not a complete type system.',
                      'No firmware execution, current registration state, or general loader is established.',
                      'Constructor constant checks do not prove all control/data-flow relationships.'
                  ])
    (OUT / 'rpc-contract-1107.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(services=len(services), callbacks=sum(len(s['callbacks']) for s in services),
                          verified_function_bodies=len(exports), device_contacted=False)))


if __name__ == '__main__':
    main()
