#!/usr/bin/env python3
"""Record actual host file/process-exit custody tests; no device connection."""
import argparse
import hashlib
import io
import json
from pathlib import Path
import platform
import sys
import time
import unittest

ROOT = Path(__file__).resolve().parents[1]


class EvidenceResult(unittest.TextTestResult):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.cases, self.subcases = [], []

    def addSuccess(self, test):
        super().addSuccess(test)
        self.cases.append(dict(test=test.id(), passed=True))

    def addSubTest(self, test, subtest, error):
        super().addSubTest(test, subtest, error)
        self.subcases.append(dict(test=test.id(), parameters=dict(subtest.params), passed=error is None))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    paths = [Path(__file__), ROOT / 'scripts/prerecord_media_store.py',
             ROOT / 'scripts/tests/test_prerecord_media_store.py']
    before = {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
    suite = unittest.defaultTestLoader.discover(str(ROOT / 'scripts/tests'),
                                              pattern='test_prerecord_media_store.py')
    log = io.StringIO(); started = time.monotonic()
    result = unittest.TextTestRunner(stream=log, verbosity=2,
                                    resultclass=EvidenceResult).run(suite)
    assert before == {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
    receipt = dict(schema=1, status='pass_host_custody_process_exit_recovery' if result.wasSuccessful() else 'failed',
                   tests=result.testsRun, failures=len(result.failures), errors=len(result.errors),
                   seconds=time.monotonic() - started, implementation_sha256=before,
                   cases=result.cases, subcases=result.subcases,
                   process_exit_cases=[row for row in result.subcases if 'phase' in row['parameters']],
                   host=platform.platform(), python=sys.version, device_access=False,
                   limits=['Actual local subprocess os._exit and POSIX files only; not physical SD power loss.',
                           'Recovery is frozen and preserves all receipted files; it cannot resume producer or eviction.',
                           'Unreceipted media is retained without claiming it is closed or playable.',
                           'Checkpoint protects custody identity; no real encoder/session clock, microphone or GPIO binding.'])
    (args.output / 'tests.log').write_text(log.getvalue())
    (args.output / 'validation.json').write_text(json.dumps(receipt, indent=2) + '\n')
    print(json.dumps({k: receipt[k] for k in ('status', 'tests', 'failures', 'errors')}))
    if not result.wasSuccessful():
        raise SystemExit(1)


if __name__ == '__main__':
    main()
