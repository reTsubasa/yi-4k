#!/usr/bin/env python3
"""Assess a static startup patch offline; emit spans, never a flashable image.

Pins the device partition/window, audits known text padding references, compiles
one marker wrapper, checks ARM branches and verifies reversible in-memory edits.
No camera connection and no target/configuration/firmware writes.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import struct
import subprocess

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/boot-patch-assessment'
ANALYSIS = OUT.parent
BASE = 0xA0100000
WINDOW_SHA = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
PART_SHA = 'e3502a477701d0e3cad704adeb7e35465b89f93efe906ab0dcd3ef0a12266ce6'
PAD_LO, PAD_HI = 0xA064E214, 0xA064F000
CAVE, SITE, STOCK = 0xA064E220, 0xA0187BF4, 0xA0186EE8


def sha(data):
    return hashlib.sha256(data).hexdigest()


def elf_text(path):
    """Extract .text from the assembler output; reject relocations/extra alloc sections."""
    blob = path.read_bytes()
    h = struct.unpack_from('<16sHHIIIIIHHHHHH', blob)
    assert h[0][:7] == b'\x7fELF\x01\x01\x01' and h[1] == 1 and h[2] == 40
    shoff, entsize, count, strindex = h[6], h[11], h[12], h[13]
    assert entsize == 40 and shoff + entsize * count <= len(blob)
    sections = [struct.unpack_from('<10I', blob, shoff + i * entsize) for i in range(count)]
    names = sections[strindex]
    strings = blob[names[4]:names[4] + names[5]]
    text = None
    for s in sections:
        name = strings[s[0]:strings.find(b'\0', s[0])].decode()
        assert not (s[1] in (4, 9) and s[5]), f'Unresolved relocations: {name}'
        assert not (s[2] & 2 and s[5] and name != '.text'), f'Extra allocated section: {name}'
        if name == '.text':
            assert s[1] == 1 and s[2] == 6 and s[5] > 0
            text = blob[s[4]:s[4] + s[5]]
    assert text is not None
    return text


def check_wrapper_abi(code):
    """Bounded AAPCS model of this wrapper, with both callees mocked.

    Checks generated instructions, stack balance and result preservation, not
    ARM hardware, firmware services, caches or scheduling.
    """
    def register(name):
        return {'ip': 'r12', 'lr': 'r14', 'pc': 'r15'}.get(name, name)

    for stock_result in (0, 1, 0xFFFFFFFF, 0x87654321):
        regs = {f'r{i}': 0x11000000 + i for i in range(16)}
        regs['r14'] = SITE + 4
        initial = dict(regs)
        stack, sp, calls = {}, 0x20000000, []
        for ins in code:
            op = ins.operands
            if ins.mnemonic == 'push':
                names = [register(ins.reg_name(o.reg)) for o in op]
                sp -= len(names) * 4
                for n, name in enumerate(names):
                    stack[sp + n * 4] = regs[name]
            elif ins.mnemonic in ('movw', 'movt'):
                name = register(ins.reg_name(op[0].reg))
                regs[name] = op[1].imm if ins.mnemonic == 'movw' else (
                    regs[name] & 0xFFFF) | (op[1].imm << 16)
            elif ins.mnemonic == 'mov':
                regs[register(ins.reg_name(op[0].reg))] = regs[register(ins.reg_name(op[1].reg))]
            elif ins.mnemonic == 'add':
                assert ins.op_str == 'r0, pc, #0x10'
                regs['r0'] = ins.address + 8 + op[2].imm
            elif ins.mnemonic == 'blx':
                assert sp % 8 == 0
                target = regs[register(ins.reg_name(op[0].reg))]
                if target == 0xA02A70EC:
                    assert regs['r0'] == CAVE + 44
                calls.append(target)
                # Both mocks obey callee-saved ABI, clobber all caller-saved regs.
                for name in ('r0', 'r1', 'r2', 'r3', 'r12', 'r14'):
                    regs[name] = 0xDEAD0000 + int(name[1:])
                regs['r0'] = stock_result if target == STOCK else 0xBADF00D
            elif ins.mnemonic == 'pop':
                for n, o in enumerate(op):
                    regs[register(ins.reg_name(o.reg))] = stack[sp + n * 4]
                sp += len(op) * 4
            else:
                raise AssertionError(ins.mnemonic)
        assert calls == [STOCK, 0xA02A70EC]
        assert sp == 0x20000000 and regs['r15'] == SITE + 4
        assert regs['r0'] == stock_result
        assert all(regs[f'r{i}'] == initial[f'r{i}'] for i in range(4, 12))
    return dict(model='bounded instruction/AAPCS simulation with mocked firmware calls',
                cases=4, stock_call_once=True, return_value_and_stack_preserved=True,
                hardware_execution=False)


def main():
    image = (ANALYSIS / 'rtos-window.bin').read_bytes()
    partition = (ANALYSIS.parent / 'sys_sw_partition.bin').read_bytes()
    assert sha(image) == WINDOW_SHA and sha(partition) == PART_SHA
    assert partition[:len(image)] == image
    assert not any(image[PAD_LO - BASE:PAD_HI - BASE])
    OUT.mkdir(exist_ok=True)
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    md.detail = True

    def export(label, lo, hi):
        raw = image[lo - BASE:hi - BASE]
        path = OUT / f'{label}.asm'
        path.write_text('\n'.join(f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}'
                                  for i in md.disasm(raw, lo)) + '\n')
        return dict(start=hex(lo), end_exclusive=hex(hi), sha256=sha(raw),
                    asm=str(path.relative_to(ROOT)))

    comparisons = {int(f['entry'], 16): f for f in json.loads(
        (ANALYSIS / 'function-comparison.json').read_text())}
    fs = json.loads((ROOT / 'artifacts/rtos-reverse/full/functions.json').read_text())
    same_functions = {}
    for at in [0xA018756C, 0xA0186E3C, STOCK, 0xA0295CF8, 0xA04A3FB0,
               0xA03BC6B0, 0xA03BC6DC, 0xA03C3448]:
        f = next(f for f in fs if int(f['entry'], 16) == at)
        body = b''.join(image[int(lo, 16) - BASE:int(hi, 16) - BASE + 1]
                        for lo, hi in (r.split('-') for r in f['body_ranges']))
        assert comparisons[at]['same_body_bytes']
        assert sha(body) == comparisons[at]['device_body_sha256']
        same_functions[hex(at)] = dict(sha256=sha(body), ranges=f['body_ranges'])

    references = []
    for source in [ROOT / 'artifacts/rtos-reverse/full', ANALYSIS / 'full']:
        hits, skipped, total = [], 0, 0
        with (source / 'references.tsv').open() as file:
            next(file)
            for line in file:
                total += 1
                row = line.rstrip().split('\t')
                try:
                    target = int(row[1], 16) & ~1
                except ValueError:
                    skipped += 1
                    continue
                if PAD_LO <= target < PAD_HI:
                    hits.append(row)
        functions = json.loads((source / 'functions.json').read_text())
        overlaps = []
        for f in functions:
            for span in f['body_ranges']:
                lo, hi = (int(x, 16) for x in span.split('-'))
                if lo < PAD_HI and hi >= PAD_LO:
                    overlaps.append(dict(entry=f['entry'], span=span))
        references.append(dict(index=str(source.relative_to(ROOT)), rows=total,
                               non_memory_targets=skipped, padding_xrefs=hits,
                               function_overlaps=overlaps))
    # Additional bounded raw-word search catches constants absent from xref exports.
    raw_pointers = [dict(site=hex(BASE + i * 4), value=hex(w))
                    for i, (w,) in enumerate(struct.iter_unpack('<I', image))
                    if PAD_LO <= (w & ~1) < PAD_HI]
    assert all(not r['padding_xrefs'] and not r['function_overlaps'] for r in references)
    assert not raw_pointers

    # Concrete MMU source constants and their same-body provenance. Mapping builder
    # interpretation remains manual and separate from these exact instruction checks.
    checks = {
        0xA0295D34: ('movw', 'r2, #0xe214'),
        0xA0295D38: ('movt', 'r2, #0xa064'),
        0xA0295E38: ('movw', 'r0, #0x4f68'),
        0xA0295E44: ('movt', 'r0, #0xa082'),
        SITE: ('bl', '#0xa0186ee8'),
        SITE + 4: ('mov', 'r3, #1'),
        0xA0187BF0: ('bl', '#0xa0186e3c'),
        0xA0187BEC: ('bne', '#0xa0187c00'),
    }
    for at, expected in checks.items():
        i = next(md.disasm(image[at - BASE:at - BASE + 4], at))
        assert (i.mnemonic, i.op_str) == expected, hex(at)
    # Small-page low attributes reconstructed from builder A04A3FB0 and attr=1060F:
    # type=2, B=C=1, AP[1:0]=3, S=1, XN=APX=0. Actual page tables not read.
    small_page_attrs = 0x43E
    assert small_page_attrs & 1 == 0  # small-page XN bit

    source = ROOT / 'sdk/offline/yi4k_1107_boot_marker.S'
    obj = OUT / 'boot-marker.o'
    result = subprocess.run(['clang', '--target=armv7-none-eabi', '-mcpu=cortex-a9',
                             '-marm', '-mfloat-abi=soft', '-c', str(source), '-o', str(obj)],
                            check=True, capture_output=True, text=True)
    assert not result.stderr
    payload = elf_text(obj)
    assert len(payload) <= PAD_HI - CAVE
    code = list(md.disasm(payload[:44], CAVE))
    expected = [
        ('push', '{r4, lr}'), ('movw', 'ip, #0x6ee8'), ('movt', 'ip, #0xa018'),
        ('blx', 'ip'), ('mov', 'r4, r0'), ('add', 'r0, pc, #0x10'),
        ('movw', 'ip, #0x70ec'), ('movt', 'ip, #0xa02a'), ('blx', 'ip'),
        ('mov', 'r0, r4'), ('pop', '{r4, pc}'),
    ]
    assert [(i.mnemonic, i.op_str) for i in code] == expected
    marker = b'[yi4k-ext] stock init returned; wrapper reached\n\0'
    assert payload[44:].startswith(marker)
    abi_model = check_wrapper_abi(code)
    (OUT / 'boot-marker.bin').write_bytes(payload)
    (OUT / 'boot-marker.asm').write_text('\n'.join(
        f'{i.address:08x} {i.bytes.hex()} {i.mnemonic} {i.op_str}' for i in code) + '\n')

    def branch(site, target):
        delta = target - site - 8
        assert not delta % 4 and -(1 << 25) <= delta < (1 << 25)
        data = struct.pack('<I', 0xEB000000 | ((delta >> 2) & 0xFFFFFF))
        ins = next(md.disasm(data, site))
        assert ins.mnemonic == 'bl' and ins.operands[0].imm & 0xFFFFFFFF == target
        return data

    assert branch(SITE, STOCK) == image[SITE - BASE:SITE - BASE + 4]
    spans = []
    for label, at, after in [('startup_bl', SITE, branch(SITE, CAVE)),
                              ('text_padding_wrapper', CAVE, payload)]:
        before = image[at - BASE:at - BASE + len(after)]
        spans.append(dict(label=label, va=hex(at), file_offset=hex(at - BASE),
                          bytes=len(after), before_hex=before.hex(), after_hex=after.hex()))
    mutated = bytearray(partition)
    for row in spans:
        off = int(row['file_offset'], 16)
        assert mutated[off:off + row['bytes']] == bytes.fromhex(row['before_hex'])
        mutated[off:off + row['bytes']] = bytes.fromhex(row['after_hex'])
    changed = sum(a != b for a, b in zip(mutated, partition))
    prototype_sha = sha(mutated)
    for row in reversed(spans):
        off = int(row['file_offset'], 16)
        assert mutated[off:off + row['bytes']] == bytes.fromhex(row['after_hex'])
        mutated[off:off + row['bytes']] = bytes.fromhex(row['before_hex'])
    assert bytes(mutated) == partition

    evidence = [export('mmu_layout', 0xA0295CF8, 0xA0295FF8),
                export('startup_hook_context', 0xA0187BC4, 0xA0187C08),
                export('pool_initialization', 0xA018756C, 0xA0187668),
                export('startup_vectors_and_stacks', 0xA01000FC, 0xA0100294)]
    report = dict(
        scope='offline static patch assessment; NOT a firmware image or executed extension',
        device_contacted=False, device_modified=False, flashable_image_generated=False,
        source=dict(partition_sha256=PART_SHA, window_sha256=WINDOW_SHA,
                    partition_bytes=len(partition), window_bytes=len(image)),
        candidate_padding=dict(start=hex(PAD_LO), end_exclusive=hex(PAD_HI), bytes=PAD_HI - PAD_LO,
                               candidate_entry=hex(CAVE), aligned_capacity=PAD_HI - CAVE,
                               all_zero=True, raw_aligned_pointers=raw_pointers,
                               index_checks=references,
                               ownership='linker/MMU padding candidate, NOT proven unused at runtime'),
        mmu=dict(initializer='0xA0295CF8', builder='0xA04A3FB0',
                 text_start='0xA0100000', text_source_end='0xA064E214',
                 text_mapped_end_exclusive='0xA064F000', packed_attributes='0x1060F',
                 reconstructed_small_page_attributes=hex(small_page_attrs),
                 candidate_physical_page='0x0064E000', candidate_xn=0,
                 cave_page_overlap_with_following_mapping=False,
                 runtime_permissions_verified=False),
        prototype=dict(source=str(source.relative_to(ROOT)), payload_bytes=len(payload),
                       payload_sha256=sha(payload), code_bytes=44,
                       patch_spans=spans, original_callee=hex(STOCK), return_site=hex(SITE + 4),
                       changed_bytes=changed, mutated_partition_sha256=prototype_sha,
                       full_modified_image_written=False, in_memory_reversal_exact=True,
                       abi_model=abi_model,
                       behavior='Stock initialization exactly once, one log marker, return; no task creation'),
        future_task=dict(pool='0xA0FD7114', pool_created_before_hook=True,
                         allocation_api='0xA03BC6DC', timeout_proposed=0,
                         control_bytes=216, stack_bytes_proposed=8192,
                         storage='one owned allocation, separate aligned TCB/context/stack regions',
                         sequence=['allocate without wait', 'TaskCreate auto_start=0',
                                   'core exclusion after successful create', 'Resume'],
                         status='design only; no additional task payload implemented'),
        recovery=dict(device_bootloader_captured=False, tested_independent_recovery=False,
                      sys_sw_dump_is_nand_recovery_image=False,
                      remove_sd_reverts_flash_patch=False,
                      force_filename_proves_pre_rtos_recovery=False),
        verified_same_body_functions=same_functions, evidence=evidence,
        remaining=[
            'Confirm candidate padding has no indirect runtime writer or integrity role.',
            'Obtain current bootloader/PTB load length and CRC semantics; 32 MiB MTD size is not load length.',
            'Establish recovery independent of normal RTOS startup and preserve required NAND metadata.',
            'Validate cold boot and BOSS/hibernation resume separately.',
            'Validate logger and execution/return on hardware before any task integration.',
        ])
    (OUT / 'assessment.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(padding_bytes=PAD_HI - PAD_LO, prototype_payload_bytes=len(payload),
                          modified_spans=len(spans), changed_bytes=changed,
                          exact_reversal=True, device_contacted=False)))


if __name__ == '__main__':
    main()
