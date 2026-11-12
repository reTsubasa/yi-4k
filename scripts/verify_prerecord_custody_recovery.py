#!/usr/bin/env python3
"""Independently inspect pinned recovery output and fail-closed publication controls."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

import audit_prerecord_real_gop as g

ROOT = Path(__file__).resolve().parents[1]

def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()

def verify(positive, omitted, corrupted):
    script = ROOT / 'scripts/recover_prerecord_custody.py'
    cases = []
    for directory, expected in [(positive, True), (omitted, False), (corrupted, False)]:
        audit = directory / 'audit.json'
        report = json.loads(audit.read_text())
        assert report['script_sha256'] == digest(script), 'Recovery script changed since execution'
        assert report['device_access'] is False and report['source_used_for_output'] is False
        assert (report['strict_packet_time_gate']['status'] == 'pass') == expected
        assert (directory / 'recovered.mp4').exists() == expected
        assert (directory / 'recovered.pending.mp4').exists() != expected
        output = directory / ('recovered.mp4' if expected else 'recovered.pending.mp4')
        assert digest(output) == report['pending_sha256']
        if expected:
            assert report['output_counts'] == {'0': 16, '1': 26}
            # Re-read all source/output packets independently of the recorded gate.
            source = g.s.SAMPLE_MP4
            assert digest(source) == g.SOURCE_SHA
            oracle = g.packets(g.probe(source), source.read_bytes())
            selected = [p for p in oracle if p['index'] < (16 if p['stream'] == 0 else 26)]
            probe = g.probe(output)
            actual = g.packets(probe, output.read_bytes())
            gate = g.exact_gate(actual, selected, probe['streams'], g.Fraction(0))
            assert gate['status'] == 'pass'
            assert g.frame_hashes(output) == g.frame_hashes(source, 16)
            reference = directory / 'oracle-reference.aac'
            assert reference.read_bytes() == b''.join(g.adts(p['data']) for p in selected if p['stream'] == 1)
            assert g.pcm(output) == g.pcm(reference, True)
            subprocess.run([str(g.s.FFMPEG), '-v', 'error', '-xerror', '-i', str(output), '-f', 'null', '-'], check=True)
        else:
            assert report['status'] == 'rejected_retained_for_recovery'
            if directory == omitted: assert report['output_counts'] == {'0': 16, '1': 24}
            else:
                assert report['output_counts'] == {'0': 16, '1': 26}
                assert report['strict_packet_time_gate']['payload_equal'] is False
        cases.append(dict(audit=str(audit.relative_to(ROOT)), audit_sha256=digest(audit),
                          output_sha256=digest(output), publication_expected=expected))
    return dict(schema=1, status='pass', device_access=False, cases=cases,
                verifier_sha256=digest(Path(__file__)), recovery_script_sha256=digest(script),
                scope='Independent re-read of 42 packet payload/times, frame/PCM decode, and negative publication controls')

if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--positive', type=Path, required=True)
    ap.add_argument('--omitted', type=Path, required=True)
    ap.add_argument('--corrupted', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    result = verify(args.positive.resolve(), args.omitted.resolve(), args.corrupted.resolve())
    with args.output.open('x') as stream:
        stream.write(json.dumps(result, indent=2) + '\n')
    print(json.dumps(dict(status=result['status'], cases=len(result['cases']))))
