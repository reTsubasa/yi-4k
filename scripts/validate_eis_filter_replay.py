#!/usr/bin/env python3
"""Compare host model with the actual pinned A32 function in Unicorn.

Runs only local firmware bytes in an emulator. No camera, hooks, device APIs,
flash files, or modified full firmware image are produced.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import random
import struct
from dataclasses import replace
from pathlib import Path
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, __version__ as unicorn_version
from unicorn.arm_const import (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2,
                               UC_ARM_REG_SP, UC_ARM_REG_LR, UC_ARM_REG_CPSR, UC_ARM_REG_PC,
                               UC_ARM_REG_FPEXC, UC_ARM_REG_FPSCR, UC_ARM_REG_C1_C0_2)
from eis_filter_replay import (BASE, IMAGE, I32_MIN, I32_MAX, Parameters, load_identity,
                               replay, signed32, stock_step, truncdiv)

ENTRY, END = 0xA0384710, 0xA0384A00
STACK, PREVIOUS, RETURN = 0x10010000, 0x10000000, 0x10020000
CHECKS = {
    0xA038494C: ('lsl', 'r3, r3, #1'),
    0xA0384950: ('add', 'r3, r3, r2'),
    0xA0384954: ('lsl', 'r2, r3, #5'),
    0xA0384958: ('add', 'r1, r3, r2'),
    0xA0384964: ('smull', 'r2, r3, r1, r3'),
    0xA0384968: ('asr', 'r2, r3, #5'),
    0xA038496C: ('asr', 'r3, r1, #0x1f'),
    0xA0384970: ('rsb', 'r0, r3, r2'),
    0xA038497C: ('ldrb', 'r3, [r3]'),
    0xA0384980: ('sxtb', 'r3, r3'),
    0xA0384988: ('mul', 'r1, r2, r3'),
    0xA0384994: ('smull', 'r2, r3, r1, r3'),
    0xA03849A4: ('add', 'r3, r0, r3'),
    0xA03849BC: ('cmp', 'r2, r3'),
    0xA03849C0: ('ble', '#0xa03849d0'),
    0xA03849D4: ('rsb', 'r2, r3, #0'),
    0xA03849DC: ('cmp', 'r2, r3'),
    0xA03849E0: ('ble', '#0xa03849f0'),
}


class NativeFunction:
    def __init__(self, data: bytes):
        self.uc = Uc(UC_ARCH_ARM, UC_MODE_ARM)
        self.uc.mem_map(BASE, (len(data) + 0xfff) & ~0xfff)
        self.uc.mem_write(BASE, data)
        self.uc.mem_map(0xA1700000, 0x10000)
        self.uc.mem_map(0x10000000, 0x30000)
        self.uc.reg_write(UC_ARM_REG_C1_C0_2, 0xf << 20)
        self.uc.reg_write(UC_ARM_REG_FPEXC, 1 << 30)

    def step(self, previous: int, current: int, params: Parameters, count: int) -> tuple[int, int]:
        uc = self.uc
        def put32(address: int, value: int) -> None:
            uc.mem_write(address, struct.pack('<I', value & 0xffffffff))
        put32(PREVIOUS, previous)
        put32(0xA170AFEC, params.limit)
        uc.mem_write(0xA170AF88, bytes((int(params.adaptive_enabled), count)))
        uc.mem_write(0xA0757B54, bytes((params.gain & 0xff,)))
        put32(0xA0757AD4, params.small_motion_degrees)
        uc.mem_write(0xA0757AA1, bytes((params.scale_shift & 0xff,)))
        uc.mem_write(0xA0757AD8, bytes((params.small_count_limit,)))
        put32(0xA0757ADC, params.adaptive_feedback)
        uc.mem_write(0xA0384A00, struct.pack('<d', params.radians_numerator))
        uc.mem_write(0xA0384A08, struct.pack('<d', params.radians_denominator))
        uc.reg_write(UC_ARM_REG_CPSR, 0x13)
        uc.reg_write(UC_ARM_REG_FPSCR, 0)
        uc.reg_write(UC_ARM_REG_R0, 2)
        uc.reg_write(UC_ARM_REG_R1, current & 0xffffffff)
        uc.reg_write(UC_ARM_REG_R2, PREVIOUS)
        uc.reg_write(UC_ARM_REG_SP, STACK)
        uc.reg_write(UC_ARM_REG_LR, RETURN)
        uc.emu_start(ENTRY, RETURN, count=1000)
        if uc.reg_read(UC_ARM_REG_PC) != RETURN:
            raise AssertionError('A32 function did not reach the return sentinel')
        if uc.reg_read(UC_ARM_REG_SP) != STACK:
            raise AssertionError('A32 function did not restore stack')
        if signed32(struct.unpack('<I', uc.mem_read(PREVIOUS, 4))[0]) != previous:
            raise AssertionError('unexpected write through previous pointer')
        return signed32(uc.reg_read(UC_ARM_REG_R0)), uc.mem_read(0xA170AF89, 1)[0]


def validate(output: Path) -> dict:
    identity, defaults = load_identity()
    data = IMAGE.read_bytes()
    disassembler = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    checked = []
    for address, expected in CHECKS.items():
        instruction = next(disassembler.disasm(data[address-BASE:address-BASE+4], address))
        actual = instruction.mnemonic, instruction.op_str
        if actual != expected:
            raise AssertionError(f'{address:#x}: {actual} != {expected}')
        checked.append({'address': hex(address), 'instruction': ' '.join(actual), 'bytes': instruction.bytes.hex()})
    native = NativeFunction(data)
    cases = 0
    examples = []
    baseline = Parameters(limit=I32_MAX, **defaults)
    values = [I32_MIN, I32_MIN + 1, -100000000, -21691755, -101, -100, -1, 0, 1, 99, 100, 101, 21691755, 100000000, I32_MAX]
    gains = [-128, -1, 0, 1, 100, 127]
    def compare(previous: int, current: int, params: Parameters, count: int) -> None:
        nonlocal cases
        modeled, next_count, details = stock_step(previous, current, params, count)
        actual, native_count = native.step(previous, current, params, count)
        if (modeled, next_count) != (actual, native_count):
            raise AssertionError({'previous': previous, 'input': current, 'params': str(params), 'count': count,
                                  'model': [modeled, next_count], 'native': [actual, native_count]})
        cases += 1
        if (details['wrapped_feedback_product'] or details['wrapped_input_product']) and len(examples) < 8:
            examples.append({'previous': previous, 'input': current, 'gain': params.gain, 'limit': params.limit,
                             'modeled': modeled, 'emulated': actual, 'details': details})
    for previous in values:
        for current in values:
            for gain in gains:
                compare(previous, current, replace(baseline, gain=gain), 91)
    for limit in (0, 1, 100, I32_MAX):
        for previous in values:
            compare(previous, -previous if previous != I32_MIN else I32_MAX, replace(baseline, limit=limit), 255)
    adaptive = replace(baseline, adaptive_enabled=True)
    threshold = truncdiv(adaptive.threshold_unscaled(), 100)
    for current in (-threshold-1, -threshold, -threshold+1, -1, 0, 1, threshold-1, threshold, threshold+1, I32_MIN, I32_MAX):
        for count in (0, 4, 5, 6, 254, 255):
            for previous in (I32_MIN, -100, 0, 100, I32_MAX):
                compare(previous, current, adaptive, count)
    rng = random.Random(1107)
    for _ in range(1500):
        params = replace(baseline, gain=rng.randrange(-128, 128), limit=rng.randrange(0, I32_MAX + 1),
                         adaptive_enabled=bool(rng.getrandbits(1)), small_count_limit=rng.randrange(256),
                         adaptive_feedback=rng.randrange(I32_MIN, I32_MAX + 1))
        compare(rng.randrange(I32_MIN, I32_MAX+1), rng.randrange(I32_MIN, I32_MAX+1), params, rng.randrange(256))
    rejected = []
    invalid_inputs = [
        {'parameters': {'limit': 100}, 'events': [{'kind': 'gyro', 'axis_0_raw': 32768}]},
        {'parameters': {'limit': 100}, 'samples': [{'sequence': 0, 'input': 1}]},
        {'parameters': {'limit': 100}, 'samples': [{'sequence': 1, 'input': 1, 'previous': 0}, {'sequence': 1, 'input': 2, 'previous': 0}]},
        {'parameters': {'limit': 100}, 'samples': [{'sequence': 0, 'input': I32_MAX+1, 'previous': 0}]},
        {'parameters': {'limit': -1}, 'samples': [{'sequence': 0, 'input': 0, 'previous': 0}]},
    ]
    for case in invalid_inputs:
        try:
            replay(case, identity, defaults)
        except (ValueError, TypeError) as exc:
            rejected.append(str(exc))
        else:
            raise AssertionError('invalid input was accepted')
    result = {'target': identity, 'validation': 'actual pinned A32 bytes in Unicorn compared with host arithmetic model',
              'unicorn_version': unicorn_version, 'function_sha256': hashlib.sha256(data[ENTRY-BASE:END-BASE]).hexdigest(),
              'instruction_checks': checked, 'differential_cases': cases, 'mismatches': 0,
              'invalid_input_checks': rejected, 'overflow_examples': examples,
              'limitations': ['CPU emulation is not physical camera execution or scheduling/cache validation.',
                             'Ordinary/adaptive finite default angular conversion, nonnegative limits, and selected boundary/random integer cases tested.',
                             'Raw gyro-to-window transformation and outer call topology are not validated by this scalar comparison.']}
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    result = validate(args.output)
    print(json.dumps({'cases': result['differential_cases'], 'mismatches': result['mismatches'],
                      'instruction_checks': len(result['instruction_checks']), 'output': str(args.output), 'device_contacted': False}))
