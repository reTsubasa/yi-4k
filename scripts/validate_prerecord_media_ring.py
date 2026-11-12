#!/usr/bin/env python3
"""End-to-end archived H264/AAC -> incremental host ring -> gated MP4.

Reuses prerecord_replay, PreRecordBuffer, typed trigger router, closed media
custody and the existing packet fidelity publication gate. No camera contact.
"""
from __future__ import annotations

import argparse
import copy
import json
import os
from pathlib import Path
import shutil
import sys

from prerecord_media_store import ClosedMediaStore, sha, sync_directory, verify_receipt
from prerecord_replay import FFMPEG, FFPROBE, replay, run
from validate_prerecord_packet_fidelity import validate

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'artifacts/device/2026-11-11-prerecord-real-65s/YDXJ0165.MP4'


def recover(failed: Path, output: Path) -> dict:
    """Rebuild only from independently receipted retained segments, never source.

    Source is read by the publication oracle after candidate construction.
    Recovery writes a new directory; failure retains its partial output.
    """
    manifest = json.loads((failed / 'manifest.json').read_text())
    if manifest['state'] != 'failed':
        raise ValueError('recovery requires a failed replay')
    evidence = copy.deepcopy(json.loads((failed / 'prepublish-manifest.json').read_text()))
    output.mkdir(parents=True, exist_ok=False)
    spool = output / 'segments'; spool.mkdir()
    expected_receipts = {r['name']: r for r in manifest['media_store']['retained_receipts']}
    report = dict(status='recovering', device_access=False, output_payload_source='retained closed segments only',
                  failed_manifest_sha256=sha(failed / 'manifest.json'))
    audit = output / 'recovery.json'
    try:
        custody = ClosedMediaStore.recover(failed / 'segments',
                                          manifest['media_store']['budget_bytes'])
        receipts = custody.receipts
        if receipts != expected_receipts:
            raise ValueError('retained sidecars differ from failed custody manifest')
        report['custody_reopened_frozen'] = custody.frozen
        report['retained_receipt_count'] = len(receipts)
        report['retained_files_pinned'] = sorted(custody.pinned)
        for row in evidence['segments']:
            receipt = receipts[row['name']]
            if receipt['sha256'] != row['sha256']:
                raise ValueError('selection differs from retained custody')
            path = verify_receipt(failed / 'segments', receipt)
            # Recovery has its own owned copy; it cannot mutate source custody.
            shutil.copyfile(path, spool / row['name'])
            verify_receipt(spool, receipt)
        concat = output / 'selected.ffconcat'
        concat.write_text('ffconcat version 1.0\n' + ''.join(
            f"file segments/{r['name']}\ninpoint 0\nduration 0\noption advanced_editlist 0\n"
            for r in evidence['segments']))
        pending = output / 'clip.pending.mp4'
        from decimal import Decimal
        run(['ffmpeg', '-v', 'error', '-nostdin', '-n', '-copyts', '-f', 'concat', '-safe', '0',
             '-protocol_whitelist', 'file', '-auto_convert', '0', '-itsoffset',
             str(Decimal(evidence['timestamp_strategy']['output_offset_us']) / 1_000_000),
             '-i', str(concat), '-map', '0', '-c', 'copy', '-avoid_negative_ts', 'disabled',
             '-movie_timescale', '1000000', '-movflags', '+faststart', str(pending)])
        run(['ffmpeg', '-v', 'error', '-xerror', '-err_detect', 'explode', '-nostdin', '-i', str(pending),
             '-map', '0:v:0', '-map', '0:a:0', '-f', 'null', '-'])
        evidence['state'] = 'validating'
        evidence['clip'] = dict(path=pending.name, sha256=sha(pending), full_decode_passed=True)
        prepublish = output / 'prepublish-manifest.json'
        prepublish.write_text(json.dumps(evidence, indent=2) + '\n')
        gate = validate(prepublish, Path(FFPROBE), phase='prepublish')
        (output / 'prepublish-packet-fidelity.json').write_text(json.dumps(gate, indent=2) + '\n')
        if not gate['passed'] or sha(pending) != gate['clip_sha256']:
            raise ValueError('recovery publication gate rejected')
        with pending.open('r+b') as stream:
            os.fsync(stream.fileno())
        pending.rename(output / 'clip.mp4'); sync_directory(output)
        evidence['state'] = 'complete'; evidence['clip']['path'] = 'clip.mp4'
        (output / 'manifest.json').write_text(json.dumps(evidence, indent=2) + '\n')
        report.update(status='pass_host_recovery', packet_fidelity_passed=True,
                      full_decode_passed=True, clip_sha256=sha(output / 'clip.mp4'))
    except Exception as error:
        report.update(status='rejected_retained_for_recovery', error=str(error))
        raise
    finally:
        audit.write_text(json.dumps(report, indent=2) + '\n')
    return report


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--source', type=Path, default=SOURCE)
    args = ap.parse_args()
    out = args.output.resolve(); out.mkdir(parents=True, exist_ok=False)
    source = args.source.resolve(strict=True)
    tracked = [Path(__file__), *(ROOT / 'scripts' / name for name in (
        'prerecord_replay.py', 'prerecord_buffer.py', 'prerecord_trigger.py',
        'prerecord_media_store.py', 'validate_prerecord_packet_fidelity.py'))]
    before = {str(p.resolve().relative_to(ROOT)): sha(p) for p in tracked}
    report = dict(schema=1, status='running', device_access=False, source=str(source),
                  source_sha256=sha(source), implementation_sha256=before, cases=[],
                  limits=[
                      'Archived ordinary recording is replayed on the host; no live camera producer or physical SD is exercised.',
                      'Typed voice START and shutter press are injected host events, not speech/GPIO recognition.',
                      'POSIX SIGSTOP/SIGCONT pauses FFmpeg at closed-segment notifications; this does not prove RTOS callback quiescence.',
                      'Capacity is measured at delivery checkpoints, not a continuous quota, throughput or power-loss guarantee.',
                      'MP4 file custody receipts are not C packet spool source-coverage seals or a hardware capture epoch.',
                      'Original native event3 two-segment consumer timing remains rejected; this path uses audited FFmpeg streamcopy.',
                  ])
    def checkpoint():
        (out / 'validation.json').write_text(json.dumps(report, indent=2) + '\n')
    checkpoint()
    try:
        def fail_publication(_output):
            raise OSError('injected publication interruption after successful packet gate')
        failed = out / 'voice-interrupted'
        try:
            replay(source, failed, 63_000_000, 64_000_000, incremental=True,
                   trigger_source='voice', before_publish=fail_publication)
        except OSError as error:
            assert 'injected publication interruption' in str(error), error
        else:
            raise AssertionError('publication interruption not reached')
        fm = json.loads((failed / 'manifest.json').read_text())
        assert fm['state'] == 'failed' and not (failed / 'clip.mp4').exists()
        assert (failed / 'clip.pending.mp4').exists() and fm['publication_gate']['passed']
        assert fm['typed_trigger']['source'] == 'camera_voice'
        assert fm['typed_trigger']['alternate_source_duplicate'] == 'duplicate'
        assert fm['full_window_available'] and fm['available_pretrigger_us'] >= 60_000_000
        assert fm['evicted'] and fm['media_store']['pinned']
        recovered = recover(failed, out / 'voice-recovered')
        report['cases'].append(dict(name='voice_interruption_retention_and_recovery', passed=True,
                                    source_before_trigger_us=fm['available_pretrigger_us'],
                                    selected_end_us=fm['selected_end_us'],
                                    stop_overshoot_us=fm['stop_overshoot_us'],
                                    evicted_segments=len(fm['evicted']), recovery=recovered,
                                    media_store=fm['media_store']))
        # A recovery candidate with one changed retained segment must fail
        # before remux, without touching the original failed custody files.
        tampered = out / 'tampered-retained'; tampered.mkdir()
        (tampered / 'segments').mkdir()
        for name in ('manifest.json', 'prepublish-manifest.json'):
            shutil.copyfile(failed / name, tampered / name)
        first = fm['segments'][0]['name']
        # Preserve the receipt for the changed file, so rejection establishes
        # payload readback failure rather than merely a missing sidecar.
        shutil.copyfile(failed / 'segments' / (first + '.custody.json'),
                        tampered / 'segments' / (first + '.custody.json'))
        (tampered / 'segments' / first).write_bytes(b'intentionally corrupted recovery fixture')
        try:
            recover(tampered, out / 'tampered-recovery-rejected')
        except ValueError as error:
            assert 'differs from custody receipt' in str(error)
        else:
            raise AssertionError('tampered recovery custody was accepted')
        assert not (out / 'tampered-recovery-rejected/clip.mp4').exists()
        report['cases'].append(dict(name='changed_retained_segment_rejects_recovery', passed=True,
                                    published=False, original_custody_unchanged=True))
        checkpoint()
        result = replay(source, out / 'shutter', 63_000_000, 64_000_000,
                        incremental=True, trigger_source='shutter')
        assert result['state'] == 'complete' and result['publication_gate']['passed']
        assert result['full_window_available'] and result['available_pretrigger_us'] >= 60_000_000
        assert result['typed_trigger']['source'] == 'shutter'
        assert result['typed_trigger']['alternate_source_duplicate'] == 'duplicate'
        gate = validate(out / 'shutter/manifest.json', Path(FFPROBE))
        assert gate['passed']
        (out / 'shutter/independent-packet-fidelity.json').write_text(json.dumps(gate, indent=2) + '\n')
        assert sha(out / 'shutter/clip.mp4') == sha(out / 'voice-recovered/clip.mp4')
        report['cases'].append(dict(name='shutter_live_delivery_and_publication', passed=True,
                                    full_window_available=True, available_pretrigger_us=result['available_pretrigger_us'],
                                    selected_end_us=result['selected_end_us'], stop_overshoot_us=result['stop_overshoot_us'],
                                    packet_counts={k: v['clip_packet_count'] for k, v in gate['tracks'].items()},
                                    exact_same_clip_as_recovered_voice=True,
                                    media_store=result['media_store']))
        assert report['source_sha256'] == sha(source)
        assert before == {str(p.resolve().relative_to(ROOT)): sha(p) for p in tracked}
        report['status'] = 'pass_archived_media_incremental_ring_publication_and_recovery'
    except Exception as error:
        report.update(status='failed_retained', error=str(error))
        raise
    finally:
        checkpoint()
    print(json.dumps(dict(status=report['status'], cases=len(report['cases']), device_access=False)))


if __name__ == '__main__':
    main()
