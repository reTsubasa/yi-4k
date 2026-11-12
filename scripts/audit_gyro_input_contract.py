#!/usr/bin/env python3
"""Execute pinned stock gyro wrappers in synthetic RAM; no camera interaction.

Only SPI, sleep, diagnostic output and memset are host models. Arithmetic helpers
and the four audited ARM functions execute their original image bytes.
"""
from __future__ import annotations

import hashlib
import json
import struct
from collections import Counter
from pathlib import Path

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE, UC_HOOK_MEM_WRITE
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin'
BASE = 0xA0100000
IMAGE_SHA = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
OUT = ROOT / 'artifacts/verification/2026-11-12-gyro-input-contract'
DESC, RX, OUTPUT = 0xA1A355AC, 0xA1A35610, 0x70010000
STOP, SP = 0x70000000, 0x7000F000
RANGES = {
    'gyro_read': (0xA047EDE4, 0xA047F0F8),
    'gyro_open': (0xA047F0F8, 0xA047F2A0),
    'gyro_get_info': (0xA047F2A0, 0xA047F418),
    'GyroParamInit': (0xA037F55C, 0xA037F8BC),
}
PINS = {
    0xA047F130: 'bl #0xa048e12c',
    0xA047F138: 'cmp r2, #0xd1',
    0xA047F170: 'bl #0xa048e12c',
    0xA047F22C: 'bl #0xa048e12c',
    0xA047F25C: 'bl #0xa048e12c',
    0xA047F260: 'mov r0, r4',
    0xA047EF64: 'mov r2, #7',
    0xA047EF6C: 'bl #0xa048e12c',
    0xA047EF7C: 'cmp r2, #0x100',
    0xA047F2D4: 'blx #0xa04f8dec',
    0xA047F35C: 'strh ip, [r4, #0x3c]',
    0xA037F618: 'blx #0xa0506f38',
    0xA037F688: 'blx #0xa0506f38',
    0xA037F7C0: 'lsr r2, r3, #1',
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def expected_descriptor():
    # Independent field oracle from the pinned stores; all values are integers.
    d = bytearray(62)
    for off, value in {0: 3, 5: 1, 11: 1, 12: 1, 13: 255, 14: 1,
                       15: 1, 17: 2, 18: 30, 19: 16, 20: 3,
                       46: 255, 47: 1}.items():
        d[off] = value
    for off, value in {0x16: 8000, 0x18: 8000, 0x1A: 0x8A3C,
                       0x1C: 0x75C4, 0x1E: 135, 0x20: 127, 0x22: 100,
                       0x24: 250, 0x28: 1, 0x32: 0x87AE, 0x34: 0x7852,
                       0x36: 0x41EC, 0x38: 0x3E14, 0x3C: 0x8000}.items():
        struct.pack_into('<H', d, off, value)
    return bytes(d)


class Harness:
    def __init__(self, data):
        self.u = Uc(UC_ARCH_ARM, UC_MODE_ARM)
        self.u.mem_map(0xA0000000, 0x02000000)
        self.u.mem_write(BASE, data)
        self.u.mem_map(STOP, 0x20000)
        self.data = data
        self.events = []
        self.counts = Counter()
        self.spi = None
        self.u.hook_add(UC_HOOK_CODE, self.hook)
        self.u.hook_add(UC_HOOK_MEM_WRITE, self.write)

    def write(self, u, access, addr, size, value, _):
        assert not (addr < BASE + len(self.data) and addr + size > BASE), \
            ('original image modified', hex(addr), size)

    def word(self, addr):
        return struct.unpack('<I', self.u.mem_read(addr, 4))[0]

    def ret(self, result=0):
        self.u.reg_write(UC_ARM_REG_R0, result & 0xFFFFFFFF)
        self.u.reg_write(UC_ARM_REG_PC, self.u.reg_read(UC_ARM_REG_LR))

    def hook(self, u, pc, size, _):
        self.counts[pc] += 1
        regs = [u.reg_read(r) for r in (UC_ARM_REG_R0, UC_ARM_REG_R1,
                                       UC_ARM_REG_R2, UC_ARM_REG_R3)]
        if pc == 0xA048E12C:
            bus, config, length, tx = regs
            sp = u.reg_read(UC_ARM_REG_SP)
            rx, timeout = self.word(sp), self.word(sp + 4)
            assert bus == 1 and config == 0xA078B0B0
            first = bytes(u.mem_read(tx, 1))[0]
            command = bytes(u.mem_read(tx, 2 if first < 0x80 else 1))
            event = {'kind': 'spi', 'bus': bus, 'config': hex(config),
                     'length': length, 'command_hex': command.hex(),
                     'rx': hex(rx), 'timeout_argument': timeout}
            assert self.spi is not None, 'undeclared SPI model'
            result = self.spi(event, rx)
            event['return_u32'] = result & 0xFFFFFFFF
            self.events.append(event)
            self.ret(result)
        elif pc == 0xA03BC320:
            self.events.append({'kind': 'sleep', 'argument': regs[0]})
            self.ret()
        elif pc == 0xA02A70EC:
            text = bytes(u.mem_read(regs[0], 160)).split(b'\0')[0]
            self.events.append({'kind': 'log', 'text': text.decode('ascii', 'replace'),
                                'r1': regs[1]})
            self.ret()
        elif pc == 0xA04F8DEC:
            assert regs == [DESC, 0, 62, 0xA1A35630]
            u.mem_write(regs[0], bytes([regs[1]]) * regs[2])
            self.events.append({'kind': 'memset', 'length': regs[2]})
            self.ret(regs[0])

    def call(self, entry, *args):
        before = len(self.events)
        for reg, value in zip((UC_ARM_REG_R0, UC_ARM_REG_R1,
                               UC_ARM_REG_R2, UC_ARM_REG_R3), args):
            self.u.reg_write(reg, value)
        self.u.reg_write(UC_ARM_REG_SP, SP)
        self.u.reg_write(UC_ARM_REG_LR, STOP)
        self.u.emu_start(entry, STOP, count=100000)
        assert self.u.reg_read(UC_ARM_REG_PC) == STOP, 'execution budget exhausted'
        for a, b in RANGES.values():
            assert bytes(self.u.mem_read(a, b-a)) == self.data[a-BASE:b-BASE]
        return {'return_u32': self.u.reg_read(UC_ARM_REG_R0),
                'events': self.events[before:]}

    def descriptor(self):
        self.u.mem_write(OUTPUT, b'\xA5' * 64)
        report = self.call(0xA047F2A0, OUTPUT)
        desc = bytes(self.u.mem_read(OUTPUT, 62))
        assert desc == expected_descriptor()
        assert bytes(self.u.mem_read(OUTPUT + 62, 2)) == b'\xA5\xA5'
        assert report['return_u32'] == 0
        return desc, report


def open_case(data, name, chip_id=0xD1, id_result=0, config_result=0, id_written=True):
    h = Harness(data)

    def spi(event, rx):
        if event['command_hex'] == '80':
            assert event['length'] == 2 and rx != 0 and event['timeout_argument'] == 800
            if id_written:
                h.u.mem_write(rx, bytes([0, chip_id]))
            return id_result
        assert event['length'] == 2 and rx == 0 and event['timeout_argument'] == 1000
        return config_result

    h.spi = spi
    result = h.call(0xA047F0F8)
    success = id_written and chip_id == 0xD1
    assert result['return_u32'] == (0 if success else 0xFFFFFFFF)
    commands = [e['command_hex'] for e in result['events'] if e['kind'] == 'spi']
    assert commands == (['80', '7e11', '7e15', '402c', '4108', '420d', '4303']
                        if success else ['80'])
    sleeps = [e['argument'] for e in result['events'] if e['kind'] == 'sleep']
    assert sleeps == ([5, 5] if success else [])
    if not success:
        assert bytes(h.u.mem_read(0xA1A3560C, 2)) == b'\xFF\xFF'
    return {'name': name, 'model': {'chip_id': chip_id, 'id_written': id_written,
                                   'id_result': id_result, 'config_result': config_result},
            **result}


def read_case(data, name, raw, swapped=False, failure=False, partial=False):
    h = Harness(data)
    h.descriptor()
    if swapped:
        h.u.mem_write(DESC + 4, struct.pack('<H', 1))
    prior = (-111, 222, -333)
    h.u.mem_write(RX, b'\0' + struct.pack('<hhh', *prior))

    def spi(event, rx):
        assert event['command_hex'] == '8c' and event['length'] == 7
        assert rx == RX and event['timeout_argument'] == 1000
        payload = b'\0' + struct.pack('<hhh', *raw)
        if partial:
            h.u.mem_write(rx, payload[:3])
        elif not failure:
            h.u.mem_write(rx, payload)
        return -1 if failure else 0

    h.spi = spi
    h.u.mem_write(OUTPUT, b'\xA5' * 64)
    result = h.call(0xA047EDE4, 1, OUTPUT)
    effective = (raw[0], prior[1], prior[2]) if partial else prior if failure else raw
    axes = [effective[1], effective[0], effective[2]] if swapped else list(effective)
    expected = [(v + 0x8000) & 0xFFFF for v in axes]
    words = list(struct.unpack('<HHH', h.u.mem_read(OUTPUT, 6)))
    assert words == expected and result['return_u32'] == 0
    assert bytes(h.u.mem_read(OUTPUT + 6, 58)) == b'\xA5' * 58
    assert len(result['events']) == 1
    return {'name': name, 'raw_signed': list(raw), 'axis_swapped': swapped,
            'spi_failure': failure, 'partial_rx_write': partial,
            'prior_rx_signed': list(prior), 'expected_effective_signed': axes,
            'output_u16': words, 'recentered_signed': [v - 32768 for v in words],
            'timestamp_or_freshness_available': False, **result}


def main():
    data = IMAGE.read_bytes()
    assert sha(data) == IMAGE_SHA
    dis = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    pins = []
    for address, expected in PINS.items():
        ins = next(dis.disasm(data[address-BASE:address-BASE+4], address))
        actual = f'{ins.mnemonic} {ins.op_str}'
        assert actual == expected, (hex(address), actual, expected)
        pins.append({'address': hex(address), 'instruction': actual, 'bytes': ins.bytes.hex()})
    OUT.mkdir(parents=True, exist_ok=True)
    h = Harness(data)
    desc, report = h.descriptor()
    (OUT / 'descriptor.bin').write_bytes(desc)
    # The one-time guard preserves an already-populated descriptor on later calls.
    h.u.mem_write(DESC + 0x24, struct.pack('<H', 123))
    cached = h.call(0xA047F2A0, OUTPUT)
    assert not cached['events'] and bytes(h.u.mem_read(OUTPUT + 0x24, 2)) == struct.pack('<H', 123)
    h.u.mem_write(0xA1702CC0, desc)
    parameter_report = h.call(0xA037F55C)
    offsets = list(struct.unpack('<6I', h.u.mem_read(0xA17040C8, 24)))
    senses = list(struct.unpack('<3I', h.u.mem_read(0xA1704554, 12)))
    assert offsets == [8388608, 0] * 3 and senses == [33536] * 3
    assert h.counts[0xA0506F38] == 2 and h.counts[0xA0506690] == 1
    open_cases = [open_case(data, 'nominal'),
                  open_case(data, 'all_configuration_writes_fail', config_result=-1),
                  open_case(data, 'wrong_chip_id', chip_id=0),
                  open_case(data, 'chip_id_read_fails_without_rx', id_result=-1, id_written=False),
                  open_case(data, 'chip_id_data_returned_with_error', id_result=-1)]
    vectors = [(0, 0, 0), (1, -1, 16), (-32768, 32767, -1),
               (32767, -32768, 0), (131, -131, 262), (-111, 222, -333)]
    read_cases = [read_case(data, f'{"swap" if swapped else "direct"}_{i}', vector, swapped)
                  for swapped in (False, True) for i, vector in enumerate(vectors)]
    read_cases += [read_case(data, 'SPI_error_stale_complete_sample', (17, 18, 19), failure=True),
                   read_case(data, 'SPI_error_partial_mixed_sample', (17, 18, 19), failure=True, partial=True)]
    source = json.loads((OUT / 'reference/source.json').read_text())
    pdf = OUT / 'reference/bst-bmi160-ds000.pdf'
    assert sha(pdf.read_bytes()) == '0c3dca28517322bdcfcef9be8b1dd2b872ff9df9464d0088c17ccc4a67472f3b'
    audit = {
        'status': 'pass_bounded_original_ARM_execution', 'script_sha256': sha(Path(__file__).read_bytes()),
        'image': str(IMAGE.relative_to(ROOT)), 'image_sha256': sha(data),
        'function_pins': [{'name': name, 'entry': hex(a), 'end_exclusive': hex(b),
                           'sha256': sha(data[a-BASE:b-BASE])} for name, (a,b) in RANGES.items()],
        'instruction_pins': pins,
        'models': ['synthetic zero-initialized RAM', 'SPI response / failure injection',
                   'sleep records only; no elapsed-time claim', 'logs captured', 'memset'],
        'original_arithmetic_helpers_executed': ['0xA0506F38 unsigned 64-bit division',
                                                  '0xA0506690 signed division'],
        'descriptor': {'length': len(desc), 'hex': desc.hex(), 'sha256': sha(desc),
                       'initial_call': report, 'cached_call': cached},
        'parameter_init': {'offsets_low_high_xyz': offsets, 'sensitivity_q8_xyz': senses,
                            'stock_counts_per_degree_per_second': 131,
                            'formula': '((135 << 8) + (127 << 8)) >> 1 = 33536',
                            'execution': parameter_report},
        'open_cases': open_cases, 'read_cases': read_cases,
        'case_count': 2 + 1 + len(open_cases) + len(read_cases),
        'reference': {'source': source, 'sha256': sha(pdf.read_bytes()),
                      'printed_pages': [9, 21, 49, 50, 52, 60, 61, 86],
                      'nominal_range_dps': 250, 'vendor_typical_counts_per_dps': 131.2,
                      'written_ODR_code': 13, 'nominal_ODR_hz_for_code': 3200,
                      'ODR_readback_or_sample_rate_measured': False},
        'conclusions': {'mode1': 'read 0x0C..0x11; little-endian gyro XYZ, optional XY swap, add 0x8000 modulo 65536',
                        'mode1_recenter': 'unsigned output - 32768 recovers signed raw axis value',
                        'driver_error_propagation': False, 'driver_mode1_sample_timestamp': False,
                        'driver_mode1_data_ready_check': False, 'hardware_calibrated': False,
                        'real_camera_execution': False, 'deployable': False},
        'unknowns': ['actual sensor package / silicon revision', 'register readback / ERR_REG / PMU_STATUS',
                     'actual ODR / freshness / poll timing', 'camera-to-gyro axes and signs',
                     'temperature-dependent bias and sensitivity', 'frame / gyro clock alignment',
                     'DSP coordinate direction and crop geometry'],
    }
    (OUT / 'audit.json').write_text(json.dumps(audit, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'status': audit['status'], 'cases': audit['case_count'],
                      'pins': len(pins), 'sensitivity_q8': senses, 'out': str(OUT / 'audit.json')}))


if __name__ == '__main__':
    main()
