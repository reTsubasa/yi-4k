#!/usr/bin/env python3
"""Offline, hash-pinned comparison of real-device SYS_SW against the old export.

Function boundaries come from the OLD Ghidra analysis. Equality of those bytes
does not prove equal dependencies, runtime values, or that all functions exist.
Never writes to the camera.
"""
from pathlib import Path
import hashlib
import json
import struct
import capstone

ROOT = Path(__file__).resolve().parents[1]
DEVICE = ROOT / 'artifacts/device/2026-11-09-linux'
OUT = DEVICE / 'rtos-analysis'
BASE = 0xA0100000
PART_SHA = 'e3502a477701d0e3cad704adeb7e35465b89f93efe906ab0dcd3ef0a12266ce6'
OLD_SHA = 'c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141'
FOCUS = {
    0xA037D9E0: 'eis_controller_init', 0xA037FE20: 'eis_mode_rowtime_init',
    0xA0385780: 'eis_gyro_sample_processing', 0xA03852F8: 'eis_per_frame',
    0xA0384710: 'eis_rotation_filter', 0xA038EA48: 'eis_calibration_xy_grid',
    0xA0391CF0: 'eis_row_dependent_warp', 0xA0392CB0: 'eis_rotation_grid_coordinator',
    0xA0396EE8: 'eis_algo2_task', 0xA0396F34: 'eis_main_task',
    0xA03975BC: 'eis_task_create_1', 0xA0397688: 'eis_task_create_2',
    0xA0394CC0: 'eis_debug_dispatch', 0xA03B0CE0: 'image_command_dispatch',
    0xA037BA48: 'image_sof', 0xA037B998: 'image_eof',
    0xA03119A8: 'warp_calculate', 0xA0312460: 'warp_set', 0xA031282C: 'warp_get',
    0xA047F2A0: 'gyro_get_info', 0xA047F0F8: 'gyro_open',
    0xA047EDE4: 'gyro_read_indirect_candidate',
    0xA0247E54: 'sharepreview_register', 0xA0247A20: 'sharepreview_get_meminfo',
    0xA024840C: 'sharepreview_enable', 0xA02478F4: 'sharepreview_get_status',
    0xA0248530: 'sharepreview_init', 0xA0247B8C: 'sharepreview_update_buffer',
    0xA02484E8: 'sharepreview_default_config',
    0xA0247E04: 'sharepreview_frame_callback',
    0xA0247D78: 'sharepreview_copy_and_reset_counter',
    0xA02480C8: 'sharepreview_enable_internal',
    0xA0248314: 'sharepreview_disable_internal',
    0xA0238160: 'videoanal_is_initialized',
    0xA02382F8: 'videoanal_register_callback',
    0xA01A18F8: 'app_test_dispatch',
    0xA01A4F34: 'shell_app_dispatch',
    0xA0295CF8: 'rtos_mmu_mapping_initializer',
    0xA04A3B24: 'rtos_virtual_to_physical',
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def warp_differences(old, new, functions):
    """Conservatively classify changed A32 words in three known warp bodies."""
    md = capstone.Cs(capstone.CS_ARCH_ARM, capstone.CS_MODE_ARM)
    md.detail = True
    evidence = []
    for entry in [0xA03119A8, 0xA0312460, 0xA031282C]:
        f = next(f for f in functions if int(f['entry'], 16) == entry)
        changes = []
        for bounds in f['body_ranges']:
            lo, hi = [int(x, 16) for x in bounds.split('-')]
            for addr in range(lo, hi + 1, 4):
                off = addr - BASE
                if old[off:off+4] == new[off:off+4]:
                    continue
                row = dict(site=hex(addr), old_hex=old[off:off+4].hex(),
                           new_hex=new[off:off+4].hex(), classification='unresolved')
                decoded = [list(md.disasm(data[off:off+4], addr)) for data in [old, new]]
                if all(len(x) == 1 and x[0].mnemonic == 'movw' for x in decoded):
                    left, right = [x[0] for x in decoded]
                    reg = right.operands[0].reg
                    if left.operands[0].reg == reg:
                        for ins in md.disasm(new[off+4:off+68], addr+4):
                            if ins.mnemonic == 'movt' and ins.operands[0].reg == reg:
                                upper = ins.operands[1].imm << 16
                                pointers = [upper | x.operands[1].imm for x in [left, right]]
                                strings = []
                                for data, ptr in zip([old, new], pointers):
                                    start = ptr - BASE
                                    end = data.find(b'\0', start, start+1024) if 0 <= start < len(data) else -1
                                    strings.append(data[start:end] if end >= start else None)
                                if strings[0] is not None and strings[0] == strings[1] and strings[0]:
                                    row.update(classification='same_string_at_changed_address',
                                               old_pointer=hex(pointers[0]), new_pointer=hex(pointers[1]),
                                               string=strings[0].decode('ascii', 'replace'))
                                break
                            if reg in ins.regs_access()[1] or ins.mnemonic in ('bl', 'blx', 'b'):
                                break
                changes.append(row)
        evidence.append(dict(entry=hex(entry), changed_words=len(changes), differences=changes,
                             all_changes_same_string_address=all(
                                 r['classification']=='same_string_at_changed_address' for r in changes)))
    return evidence


def main():
    new = (DEVICE / 'sys_sw_partition.bin').read_bytes()
    old = (ROOT / 'artifacts/firmware/v1.10.52/_part_lrtos.a9s').read_bytes()
    assert sha(new) == PART_SHA and sha(old) == OLD_SHA, 'Wrong firmware identity'
    OUT.mkdir(exist_ok=True)
    # All non-FF bytes fit in this page-rounded window. This is an analysis
    # window, NOT a claim about the exact executable or flash-update length.
    end = (len(new.rstrip(b'\xff')) + 0xFFF) & ~0xFFF
    window = new[:end]
    (OUT / 'rtos-window.bin').write_bytes(window)
    fs = json.loads((ROOT / 'artifacts/rtos-reverse/full/functions.json').read_text())
    results, seeds = [], ['a01000fc\tdevice_reset_entry']
    for f in fs:
        entry = int(f['entry'], 16)
        ranges = [[int(v, 16) for v in r.split('-')] for r in f['body_ranges']]
        a = b''
        b = b''
        for lo, hi in ranges:
            a += old[lo - BASE:hi - BASE + 1]
            b += new[lo - BASE:hi - BASE + 1]
        same = a == b
        results.append(dict(entry=f['entry'], old_name=f['name'], body_ranges=f['body_ranges'],
                            body_bytes=len(a), same_body_bytes=same,
                            old_body_sha256=sha(a), device_body_sha256=sha(b)))
        if same:
            name = FOCUS.get(entry, 'matched_' + f['name'])
            thumb = f.get('thumb_context') == '1'
            seeds.append(f'{entry | int(thumb):08x}\t{name}')
    focus = []
    index = {int(f['entry'], 16): f for f in results}
    for entry, name in FOCUS.items():
        f = index.get(entry)
        focus.append(dict(role=name, entry=hex(entry), comparison=f,
                          status='same_old_function_body' if f and f['same_body_bytes'] else
                          'changed_old_function_body' if f else 'old_function_not_discovered'))
    (OUT / 'same-body-seeds.tsv').write_text('\n'.join(seeds) + '\n')
    (OUT / 'function-comparison.json').write_text(json.dumps(results, indent=2) + '\n')
    (OUT / 'focus-comparison.json').write_text(json.dumps(focus, indent=2) + '\n')
    (OUT / 'warp-differences.json').write_text(json.dumps(warp_differences(old, new, fs), indent=2) + '\n')
    (OUT / 'focus-seeds.tsv').write_text('\n'.join(f'{k:08x}\t{v}' for k, v in FOCUS.items()) + '\n')
    gyro_table = [struct.unpack_from('<I', new, 0xA078B0BC - BASE + 4*i)[0] for i in range(8)]
    manifest = dict(
        source='../sys_sw_partition.bin', partition_sha256=PART_SHA, partition_bytes=len(new),
        analysis_window=dict(file='rtos-window.bin', offset=0, bytes=end, sha256=sha(window),
                             base=hex(BASE), last_non_ff_end=hex(len(new.rstrip(b'\xff'))),
                             structured_end_candidate=hex(len(old)),
                             note='Window includes near-FF tail with isolated cleared bits; exact executable extent is not established.'),
        mapping_evidence=dict(reset_branch_target=hex(BASE + 0xFC),
                              vector_literal_0x238=hex(struct.unpack_from('<I', new, 0x238)[0]),
                              vector_literal_points_to_file_offset='0x294',
                              clear_start=hex(struct.unpack_from('<I', new, 0x22C)[0]),
                              clear_last_word=hex(struct.unpack_from('<I', new, 0x230)[0])),
        old_reference=dict(sha256=OLD_SHA, bytes=len(old), functions=len(fs)),
        function_comparison=dict(same_body=sum(r['same_body_bytes'] for r in results),
                                 changed_body=sum(not r['same_body_bytes'] for r in results)),
        gyro_ops_table=dict(address='0xa078b0bc', entries=[hex(x) for x in gyro_table]),
        selected_data_ranges=[dict(start=hex(lo), end_exclusive=hex(hi),
                                   same_bytes=old[lo-BASE:hi-BASE] == new[lo-BASE:hi-BASE],
                                   device_sha256=sha(new[lo-BASE:hi-BASE]))
                              for lo,hi in [(0xA0757A00,0xA0757E00),
                                            (0xA078B0BC,0xA078B0DC),
                                            (0xA047EDE4,0xA047F0F8)]],
        limitations=['Old function boundaries are reused only for byte comparison.',
                     'Identical bodies can call changed functions or reference changed data.',
                     'Static addresses are not validated live addresses or permission to patch.',
                     'No on-device execution by this script.'])
    (OUT / 'comparison-manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
    print(json.dumps(manifest['function_comparison']))
    for f in focus:
        print(f['entry'], f['role'], f['status'])


if __name__ == '__main__':
    main()
