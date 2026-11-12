#!/usr/bin/env python3
"""Cross-check the offline EIS producer -> DSP tag -> consumer/lifetime ledger.

This does not execute CPU/ORC code or contact a device. It validates that the
already-produced fixed-byte audits agree on offsets, tag meanings and explicit
unknowns, then emits a bounded closure ledger.
"""
from __future__ import annotations
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ART = ROOT / 'artifacts/device'


def load(name):
    p = ART / name / 'audit.json'
    return p, json.loads(p.read_text())


def main():
    paths = {}
    feedback_path, feedback = load('2026-11-10-eis-orc-feedback')
    completion_path, completion = load('2026-11-10-eis-completion-state')
    publication_path, publication = load('2026-11-10-eis-indirect-dsp-publication')
    vertical_path, vertical = load('2026-11-10-eis-orc-vertical-consumer')
    lifetime_path, lifetime = load('2026-11-10-eis-orc-table-lifetime')
    producer_path, producer = load('2026-11-10-eis-stock-producer-contract')
    for label, path in [('feedback', feedback_path), ('completion', completion_path),
                        ('publication', publication_path), ('vertical', vertical_path),
                        ('lifetime', lifetime_path), ('producer', producer_path)]:
        paths[label] = {'path': str(path.relative_to(ROOT)), 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}

    # CPU publication layout and DSP feedback path must agree exactly.
    cpu = feedback['cpu_layout_instruction_checks']
    assert {x['address'] for x in cpu} == {'0xa02c6068', '0xa02c6080', '0xa02c6084', '0xa02c60dc'}
    assert feedback['setup_path']['eis_update_addr_offset_from_context'] == '0x10d8'
    assert feedback['feedback_preparation']['tag_submission'].find('shared+0x3c') >= 0
    assert feedback['feedback_preparation']['tag_source'].find('+0x20') >= 0
    assert publication['interpretation']['publication_value_is'].startswith('translated state-slot')
    assert publication['interpretation']['slot_warp_pointer_is'].endswith('selected state slot +0x24')
    assert publication['interpretation']['dsp_load_or_latch_observed'] is False

    # Completion parser is a CPU consumer of the shared tail, not proof of DSP
    # write/latch. It rejects both sentinels and resets consumed feedback.
    assert completion['boundaries']['cpu_feedback_read_reset_proven'] is True
    assert completion['boundaries']['publication_tag_and_feedback_format_match'] is True
    assert completion['boundaries']['non_sentinel_feedback_writer_identified'] is False
    assert completion['boundaries']['dsp_echo_proven'] is False
    assert completion['boundaries']['dsp_latch_proven'] is False
    assert completion['boundaries']['slot_release_proven'] is False
    assert completion['boundaries']['video_frame_id_mapping_proven'] is False

    # The byte fields are format identities only. They are not promoted to a
    # frame ID or completion sequence without monotonicity/PTS evidence.
    tag_identity = {
        'cpu_published_tag': {'source': 'state +0x20 copied into selected slot +0x20',
                              'low_8_bits': 'A170AFB1-derived subindex used to select CPU history',
                              'bit_0x100': 'CPU WarpReady interpretation',
                              'status': 'format/field identity only; no frame/PTS identity'},
        'dsp_feedback_candidate': {'source': 'selected snapshot +0x20 staged back to shared +0x3c',
                                   'default_sentinel': '0xffffffff',
                                   'status': 'static echo protocol candidate; non-sentinel writer and runtime echo unproven'},
        'shared_tail': {'publication_word': 'A0699160', 'cpu_alias': 'A170AFC8',
                        'feedback_offset': '+0x3c', 'cpu_reset': 'DEADBEEF',
                        'status': 'shared address/field identity; no atomic exchange or cache invalidate proven'},
    }

    # Independent table/frame lifetime facts from the ORC audits.
    vertical_consumer = vertical['consumer']
    assert vertical['vertical_controlregs_shadow']['filter_selector'] == 24
    assert vertical['vertical_controlregs_shadow']['destination'] == 'shadow_pointer+0x100'
    assert vertical['vertical_controlregs_shadow']['size'] == '0xc40'
    assert vertical['vertical_controlregs_shadow']['diagnostic_is_not_completion'].startswith('done string')
    assert 'relFBuf decrements' in vertical['receiver']['release_scope']
    assert 'not a proven table release' in vertical['receiver']['release_scope']
    assert lifetime['vertical_pointer_retention']['shallow_copy_flag_caveat'].find('excluding bit11') >= 0
    assert 'not decoded done polling' in lifetime['horizontal_copy_preparation']['completion']

    # Producer boundary: stock context scratch + two banks are retained, but
    # no bank reuse/last-read boundary is implied by SetWarp or tag feedback.
    producer_unknowns = producer.get('not_proven', [])
    producer_text = ' '.join(str(x) for x in producer_unknowns).lower()

    lifecycle = {
        'producer': {
            'input': 'A03119A8 calc_info/context mutex -> A032CF38 stock two-plane scratch',
            'publication': 'A0312460 selects bank, copies/cleans; A02C5FD8 publishes selected state-slot pointer',
            'identity_available': ['resolved mode/context', 'calc_info control/version/geometry/theta',
                                   'CPU state +0x20 tag format', 'selected bank index (software state)'],
            'identity_not_available': ['common monotonic frame/PTS ID', 'DSP execution PC or runtime microcode identity'],
        },
        'dsp_feedback': {
            'candidate': 'ORC selected 0x40 snapshot +0x20 -> smem_2_dram(shared+0x3c,4)',
            'guards': ['context+0x68 == 20', 'context+0x10d8 != 0', 'preclear path context+0x10d4 == 0 before tag function'],
            'default': 'FFFFFFFF when publication word is empty or preclear path prepares a zero/invalid result',
            'identity': 'low 8 bits and 0x100 are reusable correlation fields only after runtime pairing',
        },
        'cpu_feedback': {
            'read': 'A02C61D4 via VCAP +0x58, shared +0x3c',
            'filter': 'reject FFFFFFFF and DEADBEEF; low byte -> history index; bit 0x100 -> WarpReady',
            'post_read': 'write DEADBEEF back to shared +0x3c and update local timing state',
            'ack_status': 'CPU read/reset is proven; DSP write/latch/ack is not',
        },
        'table_lifetime': {
            'vertical': 'ORC D7454 retains descriptor +0x0c at frame +0x18; consumer copies 0xc40 to filter24 controlregs shadow +0x100',
            'horizontal': 'command +0x08 enters idspdrv_dram2dram 0xc00 copy through scratch chunks',
            'handoff': 'same frame object family is shallow-copied; receiver relFBuf only decrements framebuffer handle counters',
            'release_boundary': 'unknown: final hardware read, DMA completion, cache visibility and safe slot/table reuse',
        },
    }

    unknowns = [
        'No non-sentinel feedback writer or runtime DSP echo has been identified.',
        'No proof that shared +0x80 publication and +0x3c feedback are atomic, cache-coherent or version-checked.',
        'No common monotonic frame identity: CPU low-byte tag is a bounded/reused subindex; frame array bytes 0x65d/0x65e/0x65f/0x660 select different producer/consumer stages.',
        'No proof that ORC feedback means warp descriptor/table is no longer read.',
        'No final hardware read, copy/DMA completion or cache barrier for vertical/horizontal table paths.',
        'No safe release/reuse point for CPU state slots, frame +0x18 pointer, horizontal destination or producer scratch banks.',
        'No runtime DSP PC/microcode identity or feedback-to-encoded-frame PTS pairing.',
    ]
    out = ART / '2026-11-10-eis-feedback-table-closure'
    out.mkdir(parents=True, exist_ok=True)
    report = {
        'evidence_kind': 'offline cross-audit ledger; reads fixed prior audit JSON only; no device/ORC/CPU execution',
        'inputs': paths,
        'consistency_checks': {
            'cpu_slot_plus_0x20_to_publication_word_plus_0x80': True,
            'dsp_feedback_snapshot_plus_0x20_to_shared_plus_0x3c': True,
            'cpu_rejects_ff_and_deadbeef_then_resets_deadbeef': True,
            'filter24_is_controlregs_shadow_selector': True,
            'vertical_release_is_separate_from_relFBuf': True,
            'horizontal_copy_completion_unproven': True,
        },
        'tag_identity': tag_identity,
        'lifecycle': lifecycle,
        'unknowns': unknowns,
        'device_access': False,
        'writes_to_device': False,
    }
    (out / 'audit.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'output': str(out), 'input_audits': len(paths), 'unknown_boundaries': len(unknowns), 'device_access': False}))


if __name__ == '__main__':
    main()
