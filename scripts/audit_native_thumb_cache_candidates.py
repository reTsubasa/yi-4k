#!/usr/bin/env python3
"""Offline T32 I-cache/predictor opcode scan and A32 overlap counterexamples.

No firmware execution, device contact, cache emulation, writer or patch output.
An encoding match does not prove reachability or the active instruction state.
"""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path
import struct
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM, CS_MODE_THUMB

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis'
BASE = 0xA0100000
SHA = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
OPERATIONS = {(1, 0): 'ICIALLUIS', (5, 0): 'ICIALLU', (5, 1): 'ICIMVAU',
              (5, 4): 'legacy_prefetch_flush', (5, 6): 'BPIALL', (1, 6): 'BPIALLIS'}
EXPECTED_T32 = {0xA04A42D6, 0xA04A43CE, 0xA04A442E, 0xA04A4492, 0xA04DF232}

def sha(data): return hashlib.sha256(data).hexdigest()

def decode(md, data, address):
    return [dict(address=hex(i.address), size=i.size, bytes=bytes(i.bytes).hex(),
                 instruction=f'{i.mnemonic} {i.op_str}') for i in md.disasm(data, address)]

def selected(word):
    if ((word & 0x0F100F10) != 0x0E000F10 or (word >> 16) & 15 != 7
            or (word >> 21) & 7): return None
    return OPERATIONS.get((word & 15, (word >> 5) & 7))

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args(); args.output.mkdir(parents=True, exist_ok=False)
    image_path = SOURCE / 'rtos-window.bin'; functions_path = SOURCE / 'full/functions.json'
    image = image_path.read_bytes(); assert sha(image) == SHA
    functions = json.loads(functions_path.read_text())
    arm = Cs(CS_ARCH_ARM, CS_MODE_ARM); thumb = Cs(CS_ARCH_ARM, CS_MODE_THUMB)
    # Positive decoder controls for every selected architectural encoding. They
    # test the scan mask/halfword order, not any hardware/cache behavior.
    controls = []
    for (crm, op2), label in OPERATIONS.items():
        word = 0xEE070F10 | crm | (op2 << 5)
        data = struct.pack('<HH', word >> 16, word & 0xFFFF)
        decoded = decode(thumb, data, 0x1000)
        assert len(decoded) == 1 and decoded[0]['size'] == 4
        assert decoded[0]['instruction'].startswith('mcr p15, #0, r0, c7,')
        assert selected(word) == label
        controls.append(dict(operation=label, t32_bytes=data.hex(), decoded=decoded))
    hits = []
    for offset in range(0, len(image) - 3, 2):
        first, second = struct.unpack_from('<HH', image, offset)
        word = (first << 16) | second
        if word >> 28 != 0xE: continue  # T32 MCR fixed prefix, not A32 cond bits.
        operation = selected(word)
        if operation is None: continue
        address = BASE + offset
        decoded = decode(thumb, image[offset:offset+4], address)
        assert len(decoded) == 1 and decoded[0]['size'] == 4
        assert decoded[0]['instruction'].startswith('mcr p15, #0,')
        owners = []
        for function in functions:
            for span in function['body_ranges']:
                lo, hi = (int(v, 16) for v in span.split('-'))
                if lo <= address and address + 3 <= hi:
                    owners.append(dict(entry=function['entry'], name=function['name'],
                                       thumb_context=function['thumb_context'], body_range=span))
        aligned = address & ~3
        overlap = decode(arm, image[aligned-BASE:aligned-BASE+8], aligned)
        assert len(overlap) == 2 and all(row['size'] == 4 for row in overlap)
        assert owners and all(owner['thumb_context'] == '0' for owner in owners)
        assert address == aligned + 2
        if operation == 'BPIALLIS':
            assert address == 0xA04DF232
            assert overlap[0]['instruction'] == 'vmla.f32 s10, s15, s9'
            assert overlap[1]['instruction'] == 'bne #0xa04df180'
        else:
            assert operation == 'ICIALLU'
            assert overlap[0]['instruction'].startswith('mcr p15, #0,')
            assert 'c7, c5, #0' in overlap[0]['instruction']
        hits.append(dict(address=hex(address), operation=operation, t32_decode=decoded,
                         exported_owners=owners, actual_a32_overlap=overlap,
                         classification='interior_halfword_of_exported_A32_instruction'))
    assert {int(hit['address'], 16) for hit in hits} == EXPECTED_T32
    a32 = []
    for offset in range(0, len(image) - 3, 4):
        word = struct.unpack_from('<I', image, offset)[0]
        operation = selected(word)
        if operation is not None:
            a32.append(dict(address=hex(BASE+offset), operation=operation,
                            decoded=decode(arm, image[offset:offset+4], BASE+offset)))
    assert len(a32) == 11
    report = dict(schema=1, status='pass', device_access=False, firmware_execution=False,
                  image_sha256=SHA, script_sha256=sha(Path(__file__).read_bytes()),
                  functions_sha256=sha(functions_path.read_bytes()),
                  scope=dict(image_bytes=len(image), t32_start_alignment=2,
                             t32_windows_scanned=(len(image)-4)//2+1,
                             operations=list(OPERATIONS.values()),
                             exported_arm_functions=sum(f['thumb_context']=='0' for f in functions),
                             exported_thumb_functions=sum(f['thumb_context']=='1' for f in functions)),
                  decoder_controls=controls, t32_candidate_count=len(hits),
                  t32_candidates=hits, independent_t32_entry_candidates=0,
                  a32_control_count=len(a32), a32_controls=a32,
                  conclusion='No new T32 cache-publication candidate in the captured image: four hits overlap existing A32 ICIALLU operations and the fifth crosses a VMLA/BNE pair in an exported A32 function.',
                  limits=['Opcode scan and exported instruction-state metadata only; no active page table, cache or core state is observed.',
                          'An unindexed branch into the middle of A32 code in Thumb state is not excluded, but is not an established safe callable entry.',
                          'No dynamically generated, uncaptured or coprocessor op1!=0 instruction sequences are covered.',
                          'No minimal entry, instruction publication, exit/quiescence or independent recovery gate is unlocked.'])
    (args.output/'audit.json').write_text(json.dumps(report, indent=2)+'\n')
    for hit in hits:
        (args.output/(hit['address'][2:]+'.asm')).write_text(
            '\n'.join(row['address']+' '+row['bytes']+' '+row['instruction'] for row in hit['actual_a32_overlap'])+'\n')
    print(json.dumps(dict(status='pass', t32_candidates=len(hits), new_independent_candidates=0,
                          image_bytes=len(image), device_access=False)))

if __name__ == '__main__': main()
