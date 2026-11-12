#!/usr/bin/env python3
"""Audit SharePreview dependencies against the retained device 1.10.7 image.

Offline only. Retained Ghidra pseudocode supplies hypotheses; fresh Capstone
disassembly supplies the byte evidence. Named fields and failure consequences
remain analyst interpretations, not observed execution or exhaustive proofs.
"""
import argparse
import hashlib
import json
import pathlib
import re
import shutil

from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM, __version__ as capstone_version

ROOT = pathlib.Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis'
BASE = 0xA0100000
SHA256 = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
PARTITION_SHA256 = 'e3502a477701d0e3cad704adeb7e35465b89f93efe906ab0dcd3ef0a12266ce6'
FUNCTIONS = {
    0xA018756C: 'application_pool_setup',
    0xA019D1E0: 'netbase_caller_path_one',
    0xA01BD5A4: 'netbase_caller_path_two',
    0xA01E66F4: 'application_pool_publish',
    0xA0238170: 'videoanal_initialize',
    0xA023CECC: 'netbase_initialize_ambalink',
    0xA02478F4: 'sharepreview_get_status',
    0xA0247B8C: 'sharepreview_update_buffer',
    0xA0247D78: 'sharepreview_copy_and_reset_counter',
    0xA0247E04: 'sharepreview_frame_callback',
    0xA0247E54: 'sharepreview_register',
    0xA0248030: 'sharepreview_unregister_frame_callback',
    0xA0248314: 'sharepreview_disable',
    0xA0248530: 'sharepreview_initialize',
    0xA02489DC: 'stock_rtmp_initialize_sharepreview',
    0xA0295B38: 'ambalink_default_config',
    0xA029A7D8: 'aligned_application_allocation',
    0xA03BC6B0: 'byte_pool_create_wrapper',
    0xA03BC6DC: 'byte_pool_allocate_time_conversion',
    0xA03BC77C: 'aligned_no_wait_allocation',
    0xA03C3448: 'byte_pool_allocate_checked_entry',
    0xA03C3524: 'byte_pool_create_checked_entry',
    0xA03CAAB4: 'rpc_service_register',
    0xA03CAE84: 'rpc_service_worker',
    0xA03CD2D8: 'ambalink_allocate',
    0xA03CD46C: 'ambalink_pool_install',
}


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output', type=pathlib.Path, required=True)
    args = ap.parse_args()
    data = (SOURCE / 'rtos-window.bin').read_bytes()
    assert hashlib.sha256(data).hexdigest() == SHA256, 'Device image changed'
    partition = (SOURCE.parent / 'sys_sw_partition.bin').read_bytes()
    assert hashlib.sha256(partition).hexdigest() == PARTITION_SHA256
    assert partition[:len(data)] == data
    index = {int(r['entry'], 16): r for r in
             json.loads((SOURCE / 'full/functions.json').read_text())}
    focused = {int(r['entry'], 16): r for r in
               json.loads((SOURCE / 'focused/functions.json').read_text())}
    origins = {address: 'full/functions.json' for address in index}
    for address in FUNCTIONS.keys() - index.keys():
        # The later focused pass recovered additional functions. Its index
        # lacks ranges: only accept a contiguous A32 listing whose extent
        # agrees with the recorded function size, rather than guessing it.
        row = dict(focused[address])
        listing = SOURCE / ('focused/%08x.asm' % address)
        sites = [int(m.group(1), 16) for line in listing.read_text().splitlines()
                 if (m := re.match(r'^0x([0-9a-fA-F]+)\s', line))]
        assert sites == list(range(address, address + row['body_bytes'], 4)), listing
        row['body_ranges'] = ['%08x-%08x' % (address, address + row['body_bytes'] - 1)]
        index[address] = row
        origins[address] = 'focused/functions.json + verified contiguous focused listing'
    args.output.mkdir(parents=True, exist_ok=True)
    dis = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    decoded = {}
    evidence = []
    for address, role in FUNCTIONS.items():
        row = index[address]
        segments = []
        text = []
        for interval in row['body_ranges']:
            first, last = (int(x, 16) for x in interval.split('-'))
            segment = data[first-BASE:last-BASE+1]
            segments.append(segment)
            instructions = list(dis.disasm(segment, first))
            assert sum(i.size for i in instructions) == len(segment), hex(address)
            for i in instructions:
                decoded[i.address] = (i.mnemonic, i.op_str)
                text.append('0x%08x  %s %s' % (i.address, i.mnemonic, i.op_str))
        name = '%08x' % address
        (args.output / (name+'.asm')).write_text('\n'.join(text)+'\n')
        # Use the later focused export when one exists; no new decompilation.
        pseudocode = SOURCE / ('focused/'+name+'.c')
        if not pseudocode.exists():
            pseudocode = SOURCE / ('full/decompiled/'+name+'.c')
        if pseudocode.exists():
            shutil.copyfile(pseudocode, args.output / (name+'.c'))
        evidence.append({
            'entry': hex(address), 'role_inferred': role,
            'body_ranges': row['body_ranges'],
            'boundary_source': origins[address],
            'body_bytes': sum(map(len, segments)),
            'body_sha256': hashlib.sha256(b''.join(segments)).hexdigest(),
            'assembly': name+'.asm',
            'retained_pseudocode_source': str(pseudocode.relative_to(ROOT))
                if pseudocode.exists() else None,
        })

    # These checks bind the manual claims to actual device instruction sites.
    checks = {
        0xA029A800: ('mov', 'r3, #0x1f4'),
        0xA029A804: ('bl', '#0xa03bc6dc'),
        0xA03BC788: ('mov', 'r3, #0'),
        0xA03BC790: ('bl', '#0xa03c3448'),
        0xA0247E84: ('bl', '#0xa03cd2d8'),
        0xA0247EF4: ('bl', '#0xa03cd2d8'),
        0xA0247F4C: ('str', 'r4, [r1, #4]'),
        0xA0248018: ('bl', '#0xa03caab4'),
        0xA0248024: ('mov', 'r0, r4'),
        0xA02486B4: ('bl', '#0xa0247e54'),
        0xA02486C0: ('strb', 'r3, [r4]'),
        0xA02489F8: ('mov', 'r1, #0xc'),
        0xA0187698: ('bl', '#0xa01e66f4'),
        0xA01E6704: ('str', 'r0, [r2]'),
        0xA019D958: ('ldr', 'r0, [r5]'),
        0xA019D964: ('bl', '#0xa023cecc'),
        0xA01BD62C: ('ldr', 'r0, [r6]'),
        0xA01BD630: ('bl', '#0xa023cecc'),
    }
    for address, expected in checks.items():
        assert decoded[address] == expected, (hex(address), decoded[address], expected)

    # This callback was not assigned a function in the retained index. Preserve
    # a bounded A32 excerpt and its strings without claiming a complete CFG.
    first, end = 0xA013887C, 0xA0138A4C
    segment = data[first-BASE:end-BASE]
    lines = ['0x%08x  %s %s' % (i.address, i.mnemonic, i.op_str)
             for i in dis.disasm(segment, first)]
    (args.output / 'stock-rtmp-caller-excerpt.asm').write_text('\n'.join(lines)+'\n')
    off = 0xA0543EC4-BASE
    rtmp_label = data[off:data.index(0, off)].decode('ascii')
    assert rtmp_label == '###Rtmp Live Mode\r\n'

    frame_bytes = 1024 * 752
    # Model the conversion sequence, including its 32-bit intermediate value.
    convert_wait = lambda ms: ((((ms * 1000) & 0xffffffff) * 0x10624DD3) >> 32) >> 6
    assert convert_wait(500) == 500
    selected_calls = []
    targets = {hex(x) for x in FUNCTIONS}
    for line in (SOURCE / 'full/calls.tsv').read_text().splitlines()[1:]:
        parts = line.split('\t')
        if len(parts) == 4 and parts[0] in targets:
            selected_calls.append(dict(zip(('caller', 'site', 'target', 'type'), parts)))
    report = {
        'evidence_type': 'Offline device bytes plus retained Ghidra exports',
        'producer': {'script': str(pathlib.Path(__file__).resolve().relative_to(ROOT)),
                     'script_sha256': hashlib.sha256(pathlib.Path(__file__).read_bytes()).hexdigest(),
                     'capstone_version': capstone_version, 'mode': 'ARM A32 little-endian'},
        'target': {'window_sha256': SHA256, 'partition_sha256': PARTITION_SHA256,
                   'image_base': hex(BASE)},
        'functions': evidence,
        'instruction_checks': {hex(k): list(v) for k, v in checks.items()},
        'calls_from_selected_functions': selected_calls,
        'dependencies': {
            'application_pool_object': '0xa0fd7114',
            'application_pool_create_call': '0xa0187650',
            'videoanal_initialized_flag': '0xa14307b8',
            'videoanal_flag_set_after': 'queue, mutex and frame task creation succeed',
            'ambalink_pool_source': 'NetBase InitAmbaLink arg0 -> 0xa1445324 -> 0xa17e014c',
            'ambalink_pool_same_as_application_pool': 'Yes on the two recovered stock paths: application setup publishes 0xa0fd7114 through 0xa01e66f4 to 0xa13a23e4; both NetBase callers load it.',
            'pool_identity_caveat': 'Static value flow; no current live pool state was read and unindexed indirect writers are not excluded.',
        },
        'allocation': {
            'frame_bytes': frame_bytes,
            'share_request_bytes': frame_bytes*3+0x38,
            'share_pool_request_bytes_with_alignment_slack': frame_bytes*3+0x38+0x40,
            'reader_request_bytes': 8,
            'reader_pool_request_bytes_with_alignment_slack': 8+0x40,
            'application_pool_request_sum_excluding_allocator_metadata': frame_bytes*3+0x38+0x40+8+0x40,
            'application_wait_raw': 500,
            'converted_wait_ticks': convert_wait(500),
            'wait_limit_caveat': 'Finite allocation wait is not a whole-command deadline or a fault watchdog.',
            'rpc_stack_request': 0x2000,
            'rpc_temporary_procedures_request': 24,
            'rpc_service_object_request_with_default_payload': 0x39c+0x770,
            'rpc_copied_procedures_request': 24,
            'rpc_worker_reply_request_with_default_payload': 0x770,
            'rpc_allocations_wait': 0,
            'rpc_allocations_error_handling': 'Multiple callers use returned pointers without checking NULL; task-create/register return values are ignored.',
        },
        'stock_rtmp': {'caller_excerpt_start': hex(first), 'caller_label': rtmp_label,
                       'initializer': '0xa02489dc', 'selector': 2,
                       'period': 12, 'width': 1024, 'height': 752,
                       'mode_activated_on_device': False},
        'lifecycle_findings': {
            'disable': 'Unregisters the VideoAnal frame callback and sets state 1; does not release frame/reader buffers, RPC stack, or RPC service.',
            'repeat_init_nonzero_state': 'Resets active and reader indices and flushes headers; not a deinit/reinit path.',
            'init_registration_error': 'Init sets state 1 after sharepreview_register; inner register return value is discarded.',
            'frame_gate': 'Counter increments before geometry check; equality to period is required; reset happens only in the copy wrapper.',
            'copy_capacity': 'Copy uses input pitch*height; no explicit destination-capacity check found in the inspected copy function.',
        },
        'runtime': {'new_rtos_calls': False, 'memory_mapping': False,
                    'latest_recovery': 'artifacts/device/2026-11-10-sharepreview-recovery/final-status/session.json',
                    'failure_cause_of_prior_network_loss': 'unknown'},
        'limitations': [
            'Saved pseudocode has inferred types; assembly is authoritative for the checked sites.',
            'No new REA session was used; this report has filesystem evidence, not REA Evidence IDs.',
            'Static failure paths are possible mechanisms, not demonstrated causes of the earlier incident.',
            'No current RTOS pool capacity, fragmentation, live task state or input image geometry was read.',
            'Finite allocator waits do not prove absence of other blocking or faults in transitive callees.',
            'Stock RTMP caller excerpt is not a complete recovery of that callback or its mode-switch preconditions.',
        ],
    }
    (args.output / 'audit.json').write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps({'functions': len(evidence), 'instruction_sites_checked': len(checks),
                      'application_pool_requests': report['allocation']['application_pool_request_sum_excluding_allocator_metadata'],
                      'output': str(args.output / 'audit.json')}))


if __name__ == '__main__':
    main()
