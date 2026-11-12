"""Custody/eviction failure boundaries for actual closed host files."""
import json
from pathlib import Path
import sys
import subprocess
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from prerecord_media_store import ClosedMediaStore, verify_receipt


class ClosedMediaStoreTests(unittest.TestCase):
    def test_pinned_trigger_history_cannot_be_deleted(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); file = root / 'part-000001.mp4'; file.write_bytes(b'owned closed media')
            store = ClosedMediaStore(root, 4096)
            row = store.accept(file.name, pin=False)
            store.pin_all()
            with self.assertRaisesRegex(ValueError, 'pinned'):
                store.evict(file.name)
            self.assertEqual(file, verify_receipt(root, row))
            self.assertTrue((root / (file.name + '.custody.json')).exists())

    def test_mutated_segment_prevents_eviction_and_preserves_file(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); file = root / 'part-000001.mp4'; file.write_bytes(b'original')
            store = ClosedMediaStore(root, 4096); store.accept(file.name, pin=False)
            file.write_bytes(b'altered!')
            with self.assertRaisesRegex(ValueError, 'differs'):
                store.evict(file.name)
            self.assertTrue(store.frozen)
            self.assertTrue(file.exists())
            self.assertFalse(any(e['event'] == 'evicted' for e in store.events))

    def test_capacity_rejects_without_deleting_unacknowledged_custody(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); file = root / 'part-000001.mp4'; file.write_bytes(b'oversized')
            store = ClosedMediaStore(root, 2)
            with self.assertRaisesRegex(OSError, 'budget'):
                store.accept(file.name, pin=False)
            self.assertTrue(store.frozen)
            self.assertTrue(file.exists())
            with self.assertRaises(ValueError):
                store.evict(file.name)

    def test_sync_failure_freezes_without_issuing_receipt_or_deleting(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); file = root / 'part-000001.mp4'; file.write_bytes(b'closed')
            store = ClosedMediaStore(root, 4096)
            with patch('prerecord_media_store.os.fsync', side_effect=OSError('injected sync')):
                with self.assertRaisesRegex(OSError, 'injected sync'):
                    store.accept(file.name, pin=False)
            self.assertTrue(store.frozen)
            self.assertEqual({}, store.receipts)
            self.assertTrue(file.exists())
            self.assertFalse((root / (file.name + '.custody.json')).exists())

    def test_unpinned_eviction_checks_and_removes_only_receipted_owned_file(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); file = root / 'part-000001.mp4'; file.write_bytes(b'owned')
            unrelated = root / 'unrelated'; unrelated.write_bytes(b'keep')
            store = ClosedMediaStore(root, 4096); store.accept(file.name, pin=False)
            store.evict(file.name)
            self.assertFalse(file.exists())
            self.assertEqual(b'keep', unrelated.read_bytes())
            self.assertEqual('evicted', store.events[-1]['event'])

    def test_fresh_owner_rejects_existing_custody(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / 'part-000000.mp4').write_bytes(b'closed')
            store = ClosedMediaStore(root, 4096)
            store.accept('part-000000.mp4', pin=False)
            with self.assertRaisesRegex(ValueError, 'explicit frozen recovery'):
                ClosedMediaStore(root, 4096)

    def test_recovery_protects_trigger_history_and_post_trigger_media(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); store = ClosedMediaStore(root, 4096)
            for index in range(2):
                name = f'part-{index:06d}.mp4'
                (root / name).write_bytes(bytes([index]) * 32)
                store.accept(name, pin=bool(index))
                if not index:
                    store.pin_all()
            (root / 'part-000002.mp4').write_bytes(b'unclosed producer output')
            recovered = ClosedMediaStore.recover(root, 4096)
            self.assertTrue(recovered.frozen)
            self.assertEqual(set(store.receipts), recovered.pinned)
            self.assertEqual(['part-000002.mp4'], recovered.events[-1]['unreceipted_retained'])
            for name in recovered.pinned:
                with self.assertRaises(ValueError):
                    recovered.evict(name)
            with self.assertRaises(ValueError):
                recovered.accept('part-000002.mp4', pin=True)

    def test_pin_sync_failure_never_acknowledges_trigger(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); (root / 'part-000000.mp4').write_bytes(b'closed')
            store = ClosedMediaStore(root, 4096); store.accept('part-000000.mp4', pin=False)
            with patch('prerecord_media_store.sync_directory', side_effect=OSError('pin sync failure')):
                with self.assertRaisesRegex(OSError, 'pin sync failure'):
                    store.pin_all()
            self.assertTrue(store.frozen)
            self.assertFalse(any(e['event'] == 'trigger_pin' for e in store.events))
            self.assertTrue((root / 'part-000000.mp4').exists())
            self.assertTrue(ClosedMediaStore.recover(root, 4096).frozen)

    def test_recovery_rejects_missing_or_changed_trigger_receipt(self):
        for change in ('missing', 'changed'):
            with self.subTest(change=change), tempfile.TemporaryDirectory() as tmp:
                root = Path(tmp); (root / 'part-000000.mp4').write_bytes(b'closed')
                store = ClosedMediaStore(root, 4096); store.accept('part-000000.mp4', pin=False)
                store.pin_all()
                sidecar = root / 'part-000000.mp4.custody.json'
                if change == 'missing':
                    sidecar.unlink()
                else:
                    row = json.loads(sidecar.read_text()); row['pinned'] = True
                    sidecar.write_text(json.dumps(row))
                with self.assertRaisesRegex(ValueError, 'trigger pin custody missing or changed'):
                    ClosedMediaStore.recover(root, 4096)
                self.assertTrue((root / 'part-000000.mp4').exists())

    def test_full_budget_does_not_prevent_frozen_recovery(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); (root / 'part-000000.mp4').write_bytes(b'closed')
            store = ClosedMediaStore(root, 4096); store.accept('part-000000.mp4', pin=True)
            recovered = ClosedMediaStore.recover(root, 1)
            self.assertTrue(recovered.frozen)
            self.assertEqual({'part-000000.mp4'}, recovered.pinned)
            self.assertEqual('recovery_over_budget', recovered.events[-1]['event'])

    def test_symlink_media_and_checkpoint_are_rejected_without_changing_target(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp); target = root / 'unrelated'; target.write_bytes(b'keep')
            (root / 'part-000000.mp4').symlink_to(target)
            store = ClosedMediaStore(root, 4096)
            with self.assertRaisesRegex(ValueError, 'regular file'):
                store.accept('part-000000.mp4', pin=False)
            (root / 'trigger-pin.json').symlink_to(target)
            with self.assertRaisesRegex(ValueError, 'regular file'):
                ClosedMediaStore.recover(root, 4096)
            self.assertEqual(b'keep', target.read_bytes())

    def test_new_process_exit_boundaries_preserve_custody(self):
        # os._exit terminates without Python cleanup or final replay manifest.
        # These are real process exits, not physical SD power-loss tests.
        program = '''
import os, sys
from pathlib import Path
import prerecord_media_store as module
root, phase = Path(sys.argv[1]), sys.argv[2]
store = module.ClosedMediaStore(root, 4096)
(root / 'part-000000.mp4').write_bytes(b'closed history')
if phase == 'before_admission': os._exit(71)
store.accept('part-000000.mp4', pin=False)
if phase == 'after_admission': os._exit(71)
if phase == 'during_pin_write':
    (root / module.PIN_FILE).write_bytes(b'{')
    os._exit(71)
if phase == 'after_pin_file_sync':
    module.sync_directory = lambda path: os._exit(71)
store.pin_all()
if phase == 'after_pin_ack': os._exit(71)
(root / 'part-000001.mp4').write_bytes(b'post trigger')
if phase == 'post_payload_before_receipt': os._exit(71)
store.accept('part-000001.mp4', pin=True)
os._exit(71)
'''
        for phase in ('before_admission', 'after_admission', 'during_pin_write',
                      'after_pin_file_sync', 'after_pin_ack', 'post_payload_before_receipt',
                      'after_post_receipt'):
            with self.subTest(phase=phase), tempfile.TemporaryDirectory() as tmp:
                root = Path(tmp)
                child = subprocess.run([sys.executable, '-c', program, tmp, phase],
                                       env={**__import__('os').environ,
                                            'PYTHONPATH': str(Path(__file__).resolve().parents[1])},
                                       capture_output=True, text=True)
                self.assertEqual(71, child.returncode, child.stderr)
                before = {p.name: p.read_bytes() for p in root.iterdir()}
                if phase == 'during_pin_write':
                    with self.assertRaises(json.JSONDecodeError):
                        ClosedMediaStore.recover(root, 4096)
                else:
                    recovered = ClosedMediaStore.recover(root, 4096)
                    self.assertTrue(recovered.frozen)
                    for name in recovered.receipts:
                        with self.assertRaises(ValueError):
                            recovered.evict(name)
                self.assertEqual(before, {p.name: p.read_bytes() for p in root.iterdir()})


if __name__ == '__main__':
    unittest.main()
