#!/usr/bin/env python3
"""Original gyro sampler + actual SPI driver in synthetic RAM, warmup branch only.

No device calls or sampling-period simulation. Delayed/error SPI and clock values
are declared models. Does not execute the later EIS / DSP publication branches.
"""
from __future__ import annotations
import json
import struct
from pathlib import Path
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn.arm_const import *
import audit_gyro_input_contract as gyro

OUT = gyro.ROOT / 'artifacts/verification/2026-11-12-eis-gyro-sampler-contract'
SAMPLER, WRAPPER = 0xA0385780, 0xA03AF31C
TICK, RING, STRIDE, CAPACITY = 0xA1A3A528, 0xA1702D00, 137, 132
PINS = {
    0xA0385A98: 'bl #0xa048e3f8',
    0xA0385AA8: 'str r2, [r3]',
    0xA0385AEC: 'blo #0xa0385b54',
    0xA0385B18: 'blx r3',
    0xA0385B64: 'bl #0xa03bc320',
    0xA0385C00: 'blx r3',
    0xA0385C28: 'str r2, [r3, r1, lsl #2]',
    0xA0385C54: 'str r0, [r2, r3, lsl #2]',
    0xA0385CAC: 'str r0, [r2, r3, lsl #2]',
    0xA0385CF8: 'blx #0xa0506674',
    0xA03AF320: 'bl #0xa0385780',
    0xA03AF324: 'mov r0, #0',
    0xA03974C8: 'mov r1, #1',
    0xA03974D0: 'b #0xa03bc4e8',
    0xA03972CC: 'tst r3, #1',
    0xA03804E0: 'cmp r3, #0x83',
    0xA038058C: 'cmp r3, #0x83',
    0xA038063C: 'cmp r3, #0x83',
}


class Sampler(gyro.Harness):
    def __init__(self, data):
        super().__init__(data)
        self.ring_writes = []
        # These are synthetic runtime settings, not writes to a camera.
        self.u.mem_write(0xA0757AF8, bytes(74))
        self.u.mem_write(0xA1702CBC, b'\1')
        self.u.mem_write(0xA1702C44, b'\1')
        desc, _ = self.descriptor()
        self.u.mem_write(0xA1702CC0, desc)
        self.call(0xA037F55C)
        self.put(0xA1704234, 10)
        self.put(0xA1704238, 10)
        self.put(RING + 0x210, CAPACITY)
        self.put(0xA1A355A4, 0x70012000)
        self.put(0x70012004, 0xA047F0F8)
        self.put(0x70012008, 0xA047EDE4)
        self.u.mem_write(gyro.RX, b'\0' + struct.pack('<hhh', -111, 222, -333))

    def put(self, addr, value):
        self.u.mem_write(addr, struct.pack('<I', value & 0xFFFFFFFF))

    def write(self, u, access, addr, size, value, user):
        super().write(u, access, addr, size, value, user)
        if RING <= addr < RING + 9 * STRIDE * 4:
            self.ring_writes.append({'address': hex(addr), 'size': size,
                                     'value': value & ((1 << (8*size))-1)})

    def hook(self, u, pc, size, user):
        super().hook(u, pc, size, user)
        if pc == 0xA02A70EC:
            self.events[-1]['modeled_log_tick'] = self.word(TICK)

    def sample(self, tick, raw=(17, -18, 19), fail=False, latency_ticks=0):
        self.put(TICK, tick)
        index = self.word(RING + 0x214)
        prior = struct.unpack('<hhh', self.u.mem_read(gyro.RX + 1, 6))

        def spi(event, rx):
            command = event['command_hex']
            if command == '8c':
                assert rx == gyro.RX and event['length'] == 7
                if not fail:
                    self.u.mem_write(rx, b'\0' + struct.pack('<hhh', *raw))
                self.put(TICK, tick + latency_ticks)
            elif command == '80':
                self.u.mem_write(rx, b'\0\xD1')
            else:
                assert command in ['7e11', '7e15', '402c', '4108', '420d', '4303']
            return -1 if fail else 0

        self.spi = spi
        before = len(self.ring_writes)
        report = self.call(WRAPPER)
        assert report['return_u32'] == 0
        reads = [e for e in report['events'] if e['kind'] == 'spi' and e['command_hex'] == '8c']
        report.update(input_tick=tick,modeled_latency_ticks=latency_ticks,
                      driver_failure_injected=fail,raw_signed=list(raw),
                      prior_rx_signed=list(prior),index_before=index,
                      index_after=self.word(RING+0x214),
                      ring_writes=self.ring_writes[before:])
        if reads or report['index_after'] != index:
            assert len(reads) <= 1
            used = prior if fail else raw
            expected = ([(v + 32768) << 8 for v in used] if reads else
                        [v << 8 for v in struct.unpack('<HHH', self.u.mem_read(0xA1702C30, 6))])
            values = [self.word(RING + (index + st*STRIDE)*4) for st in range(3)]
            assert values == expected
            assert report['index_after'] == (index+1) % CAPACITY
            assert self.word(0xA1702C40) == tick & 0xFFFFFFFF
            assert self.word(0xA170AB60) == tick & 0xFFFFFFFF
            report['ring_uq8_xyz'] = values
            report['sampler_software_tick'] = self.word(0xA170AB60)
        else:
            assert not report['ring_writes'] and report['index_after'] == index
        # Warmup exits before any frame/geometry/warp preparation branch.
        assert not self.counts[0xA0383A68] and not self.counts[0xA02C61D4]
        return report


def main():
    data = gyro.IMAGE.read_bytes()
    assert gyro.sha(data) == gyro.IMAGE_SHA
    c = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    pins = []
    for address, expected in PINS.items():
        ins = next(c.disasm(data[address-gyro.BASE:address-gyro.BASE+4], address))
        actual = f'{ins.mnemonic} {ins.op_str}'
        assert actual == expected, (hex(address), actual)
        pins.append({'address': hex(address), 'instruction': actual, 'bytes': ins.bytes.hex()})
    reports=[]
    h=Sampler(data)
    h.put(RING+0x214, 130)
    for tick in [1000,1000,1017,1018,1019]:
        reports.append(dict(name='wrap_equal_tick_and_gap',**h.sample(tick)))
    reports.append(dict(name='SPI_error_advances_ring_with_old_sample',**h.sample(1020,(21,22,23),fail=True)))
    h=Sampler(data)
    # Debug output gate uses previous stored tick, not the current sample tick.
    h.u.mem_write(0xA0757B20, struct.pack('<H', 1))
    h.u.mem_write(0xA0757B24, struct.pack('<H', 50))
    h.put(0xA170AB60,100)
    printed=h.sample(101,latency_ticks=7)
    assert len([e for e in printed['events'] if e['kind']=='log' and e['text'].startswith('GyroData=')])==1
    reports.append(dict(name='previous_tick_gate_prints_current101_at_log108',**printed))
    h.put(0xA170AB60,101)
    unprinted=h.sample(150)
    assert not [e for e in unprinted['events'] if e['kind']=='log']
    reports.append(dict(name='current_tick150_does_not_pass_previous101_gate',**unprinted))
    h=Sampler(data)
    h.u.mem_write(0xA0757B22,struct.pack('<H',1))
    skipped=h.sample(2000,(31,32,33))
    assert not [e for e in skipped['events'] if e['kind']=='spi']
    assert skipped['index_after']==1
    assert [h.word(RING+i*STRIDE*4) for i in range(3)]==[0,0,0]
    reports.append(dict(name='debug_skip_read_still_advances_ring',**skipped))
    h=Sampler(data)
    h.u.mem_write(0xA1702C44,b'\0')
    delayed=h.sample(99)
    assert [e for e in delayed['events'] if e['kind']=='sleep']==[dict(kind='sleep',argument=100)]
    reports.append(dict(name='startup_wait_before100_ticks',**delayed))
    opened=h.sample(100)
    assert [e['command_hex'] for e in opened['events'] if e['kind']=='spi']==['80','7e11','7e15','402c','4108','420d','4303']
    assert h.u.mem_read(0xA1702C44,1)==b'\1'
    reports.append(dict(name='startup_open_at100_ticks_no_sample',**opened))
    reports.append(dict(name='first_ready_pass_reads_one_sample',**h.sample(101)))
    h=Sampler(data)
    h.u.mem_write(0xA1702CBC,b'\0')
    reports.append(dict(name='inactive_pass_no_read',**h.sample(3000)))
    windows={'sampler_contiguous_region':(SAMPLER,0xA038E038),'wrapper':(WRAPPER,0xA03AF32C),
             'tick_reader':(0xA048E3F8,0xA048E408),'timer_callback':(0xA03974C4,0xA03974D4),
             'mode_init_ring_allocation':(0xA037FE20,0xA03818C0)}
    audit={'status':'pass_original_gyro_sampler_warmup_integration',
        'script_sha256':gyro.sha(Path(__file__).read_bytes()),'dependency_sha256':gyro.sha(Path(gyro.__file__).read_bytes()),
        'firmware_sha256':gyro.sha(data),'offline_only':True,'device_access':False,
        'instruction_pins':pins,'regions':[dict(name=k,start=hex(a),end_exclusive=hex(b),sha256=gyro.sha(data[a-gyro.BASE:b-gyro.BASE])) for k,(a,b) in windows.items()],
        'cases':reports,'case_count':len(reports),
        'synthetic_profile':{'physical_channel_stride_words':STRIDE,'data_capacity_words':CAPACITY,
            'selected_runtime_length':CAPACITY,'first_slot':130,'bias_shift':10,'gyro_descriptor':'original gyro_get_info',
            'debug_fields_zero_except_explicit_cases':True},
        'models':['synthetic RAM and runtime settings','SPI responses/errors/latency','log capture','sleep records','memset'],
        'original_functions':['sampler warmup path','gyro_open','gyro_read(mode1)','gyro_get_info','GyroParamInit','tick_reader','wrapper','arithmetic helpers'],
        'findings':{'one_poll_per_ready_invocation':True,'same_tick_reads_allowed':True,'no_gap_catchup_observed':True,
            'SPI_error_still_commits_old_sample_and_advances':True,'debug_skip_still_commits_existing_output_and_advances':True,
            'software_tick_captured_before_SPI':True,'per_sample_timestamp_in_raw_ring':False,
            'printf_modulo_uses_previous_software_tick':True,'ordinary_wrapper_always_returns_zero':True},
        'limits':['Only synthetic warmup branch executed; no exposure/frame update/warp publication',
            'Selected length132 is not a claim about current hardware profile',
            'Stride137 contains132data words plus5metadata words; it is not137valid samples',
            'Timer callback/event/dispatcher investigated statically only; no real scheduling or frequency proof',
            'No real sensor freshness/calibration, frame clock anchor, or deployable hook']}
    OUT.mkdir(parents=True,exist_ok=True)
    (OUT/'audit.json').write_text(json.dumps(audit,indent=2)+'\n')
    print(json.dumps({'status':audit['status'],'cases':len(reports),'pins':len(pins),'output':str(OUT/'audit.json')}))


if __name__=='__main__':main()
