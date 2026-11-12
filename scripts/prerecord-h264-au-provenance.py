#!/usr/bin/env python3
"""Offline original ARM checks for VideoEnc default/create AU provenance.

Constructed RAM only; no camera IO, enqueue, DSP or bitstream execution.
"""
import hashlib
import importlib.util
import json
from pathlib import Path
import capstone

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('native', ROOT / 'scripts/prerecord-sync-boundary.py')
n = importlib.util.module_from_spec(spec)
spec.loader.exec_module(n)
OUT = ROOT / 'artifacts/device/2026-11-10-prerecord/prerecord-h264-au-provenance-audit.json'


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    image = (ROOT / n.IMAGE).read_bytes()
    assert sha(image) == n.EXPECTED
    cases = []
    # Whole factory-default routine, including both original Thumb memsets.
    # Exercise a null optional input and both branches of its global flag.
    for optional, flag in ((False, 0), (True, 0), (True, 1)):
        m = n.machine(image)
        cfg, extra, state = 0x10001000, 0x10002000, 0x10003000
        m.mem_write(cfg, b'\xa5' * 0xb4)
        n.put(m, cfg + 0x24, extra if optional else 0)
        if optional:
            m.mem_map(0xA1A30000, 0x1000)
            n.put(m, 0xA1A30BB8, state)
            n.put(m, state + 4, flag, 1)
        n.reg(m, n.UC_ARM_REG_R0, cfg)
        n.run(m, 0xA046FD8C)
        assert n.get(m, cfg + 0x53, 1) == 0
        assert n.get(m, cfg + 0x44, 1) == 1
        assert n.get(m, cfg + 0x24) == (extra if optional else 0)
        assert m.reg_read(n.UC_ARM_REG_R0) == 0
        cases.append(dict(operation='complete_original_default_config', optional_input=optional,
                          constructed_global_flag=flag, au_config_0x53=0,
                          preserved_optional_pointer=True, passed=True))

    # Bounded create slice: original memcpy of exactly 100 bytes cfg+4c to
    # context+90, followed by the previously located two-instruction forwarder.
    # Values 1/255 are taints, not alleged camera settings or valid enum values.
    for au in (0, 1, 255):
        m = n.machine(image)
        # Real memcpy wrapper reads a per-core RTOS context flag through MPIDR.
        # Populate all four slots alike; this selects its original scalar copy.
        m.mem_map(0xA1796000, 0x1000)
        for slot in range(4):
            n.put(m, 0xA17962E8 + 4 * slot, 1)
        cfg, ctx, start = 0x10001000, 0x10002000, 0x10003000
        pattern = bytearray((i * 19 + 7) & 255 for i in range(100))
        pattern[7] = au
        m.mem_write(cfg + 0x4c, bytes(pattern))
        m.mem_write(ctx + 0x90, b'\xa5' * 100)
        n.reg(m, n.UC_ARM_REG_R5, cfg)
        n.reg(m, n.UC_ARM_REG_R4, ctx)
        n.run(m, 0xA04700DC, 0xA047011C)
        assert bytes(m.mem_read(ctx + 0x90, 100)) == bytes(pattern)
        n.reg(m, n.UC_ARM_REG_R4, ctx)
        n.reg(m, n.UC_ARM_REG_R5, start)
        n.run(m, 0xA046C6C4, 0xA046C6CC)
        assert n.get(m, start + 6, 1) == au
        cases.append(dict(operation='original_create_copy_then_start_forwarding_slices',
                          constructed_au_input=au, copied_bytes=100, context_0x97=au,
                          start_config_6=au, constructed_per_core_context_flag=1, passed=True))

    decoder = capstone.Cs(capstone.CS_ARCH_ARM, capstone.CS_MODE_ARM)
    expected = {
        0xA046FD98: ('mov', 'r2, #0xb4'),
        0xA046FDA4: ('blx', '#0xa04f8dec'),
        0xA046FE38: ('add', 'r0, r4, #0x4c'),
        0xA046FE44: ('mov', 'r2, #0x64'),
        0xA046FE4C: ('blx', '#0xa04f8dec'),
        0xA04700E0: ('add', 'r1, r5, #0x4c'),
        0xA04700E8: ('mov', 'r2, #0x64'),
        0xA04700EC: ('add', 'r0, r4, #0x90'),
        0xA0470118: ('bl', '#0xa029c680'),
        0xA046C6C4: ('ldrb', 'r3, [r4, #0x97]'),
        0xA046C6C8: ('strb', 'r3, [r5, #6]'),
    }
    checks = []
    for address, pair in expected.items():
        ins = next(decoder.disasm(image[address-n.BASE:address-n.BASE+4], address))
        assert (ins.mnemonic, ins.op_str) == pair
        checks.append(dict(address=hex(address), mnemonic=ins.mnemonic, operands=ins.op_str))

    functions = {int(f['entry'], 16): f for f in json.loads((ROOT / n.EXPORT / 'functions.json').read_text())}
    sources, app_calls = [], []
    for address in (0xA021D274, 0xA046FD8C, 0xA046FECC, 0xA046C454, 0xA02D296C,
                    0xA029C680, 0xA03BC388, 0xA03C0D08, 0xA029BF2C):
        f = functions[address]
        data = b''.join(image[int(r.split('-')[0],16)-n.BASE:int(r.split('-')[1],16)-n.BASE+1]
                        for r in f['body_ranges'])
        sources.append(dict(entry=hex(address), body_ranges=f['body_ranges'], sha256=sha(data),
                            pseudocode=f['decompiled_file'],
                            pseudocode_sha256=sha((ROOT / n.EXPORT / f['decompiled_file']).read_bytes())))
        if address == 0xA021D274:
            # Decode every aligned position independently so literal pools do
            # not terminate the search. Only matched direct BL opcodes count.
            for r in f['body_ranges']:
                lo, hi = (int(x, 16) for x in r.split('-'))
                for pc in range(lo, hi + 1, 4):
                    decoded = list(decoder.disasm(image[pc-n.BASE:pc-n.BASE+4], pc))
                    if decoded and decoded[0].mnemonic == 'bl' and decoded[0].op_str in ('#0xa046fd8c', '#0xa046fecc'):
                        app_calls.append(dict(address=hex(pc), target=decoded[0].op_str))
    assert [v['target'] for v in app_calls].count('#0xa046fd8c') == 1
    assert [v['target'] for v in app_calls].count('#0xa046fecc') == 2
    result = dict(image=str(n.IMAGE), image_sha256=n.EXPECTED,
                  evidence_type='Offline original ARM default routine and bounded create/forwarding slices with constructed RAM',
                  execution_cases=cases, passed_cases=len(cases), instruction_assertions=checks,
                  app_direct_calls=app_calls, sources=sources,
                  provenance=['factory default cfg+0x53 = 0', 'create cfg+0x4c[100] -> context+0x90[100]',
                              'therefore cfg+0x53 -> context+0x97', 'context+0x97 -> start-config+6',
                              'prior header-contract audit: start-config+6 -> command+0x39 au_type'],
                  limitations=['The default zero is a factory routine result, not a captured active camera setting.',
                               'The App direct-call inventory is not an executed App path or a proof of no subsequent overrides.',
                               'AU enum semantics, ORC NAL generation, SPS/PPS repetition and playable split continuity remain unresolved.',
                               'No complete create, task, enqueue, DSP execution, device access or camera write occurred.'])
    OUT.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(dict(output=str(OUT.relative_to(ROOT)), execution_cases=len(cases),
                          arm_assertions=len(checks), app_calls=len(app_calls), default_au=0)))


if __name__ == '__main__':
    main()
