"""Host POSIX custody for CLOSED MP4 segments delivered to prerecord_replay.

The existing PreRecordBuffer owns the 60-second policy. This adapter owns only
new-directory files, readback receipts, capacity checks and trigger pins. Its
JSON receipts are media-file custody, not yi4k_spool_seal/C source coverage.
"""
from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import stat

PIN_FILE = 'trigger-pin.json'


def regular_file(path: Path) -> None:
    if not stat.S_ISREG(path.lstat().st_mode):
        raise ValueError('custody path must be a regular file')


def sha(path: Path) -> str:
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def sync_directory(path: Path) -> None:
    fd = os.open(path, os.O_RDONLY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


def verify_receipt(root: Path, receipt: dict) -> Path:
    name = receipt['name']
    if Path(name).name != name or name in ('.', '..'):
        raise ValueError('unsafe custody identity')
    path = root / name
    regular_file(path)
    if path.stat().st_size != receipt['bytes'] or sha(path) != receipt['sha256']:
        raise ValueError('closed segment differs from custody receipt')
    return path


class ClosedMediaStore:
    def __init__(self, root: Path, budget_bytes: int):
        if budget_bytes <= 0:
            raise ValueError('storage budget must be positive')
        # A new owner cannot silently forget an interrupted owner's trigger.
        # Recovery is deliberately read-only/frozen until an external pipeline
        # has established producer quiescence and rebuilt its timeline.
        if list(root.glob('*.custody.json')) or (root / PIN_FILE).exists() or (root / PIN_FILE).is_symlink():
            raise ValueError('existing custody requires explicit frozen recovery')
        self.root = root
        self.budget = budget_bytes
        self.receipts: dict[str, dict] = {}
        self.pinned: set[str] = set()
        self.events: list[dict] = []
        self.peak_observed_bytes = 0
        self.frozen = False

    @classmethod
    def recover(cls, root: Path, budget_bytes: int) -> 'ClosedMediaStore':
        """Read retained custody in a NEW process; never resume eviction/write.

        All valid retained receipts are pinned, including pre-trigger receipts.
        A missing checkpoint is not evidence that a trigger did not happen.
        Producer-open/unreceipted media is listed for retention, never admitted.
        No microphone, camera, RTOS or block-device durability is implied.
        """
        # Reconstruct in memory without creating files or resuming a producer.
        if budget_bytes <= 0:
            raise ValueError('storage budget must be positive')
        store = cls.__new__(cls)
        store.root, store.budget = root, budget_bytes
        store.receipts, store.pinned, store.events = {}, set(), []
        store.peak_observed_bytes, store.frozen = 0, True
        for sidecar in sorted(root.glob('*.custody.json')):
            regular_file(sidecar)
            row = json.loads(sidecar.read_text())
            if sidecar.name != row['name'] + '.custody.json':
                raise ValueError('custody sidecar identity mismatch')
            verify_receipt(root, row)
            store.receipts[row['name']] = row
            store.pinned.add(row['name'])
        checkpoint = root / PIN_FILE
        if checkpoint.exists() or checkpoint.is_symlink():
            regular_file(checkpoint)
            pin = json.loads(checkpoint.read_text())
            if pin.get('schema') != 1 or pin.get('kind') != 'closed_media_trigger_pin':
                raise ValueError('invalid trigger pin checkpoint')
            rows = pin.get('receipts')
            if not isinstance(rows, list) or len({r['name'] for r in rows}) != len(rows):
                raise ValueError('invalid trigger pin receipt set')
            for row in rows:
                if store.receipts.get(row['name']) != row:
                    raise ValueError('trigger pin custody missing or changed')
            store.events.append(dict(event='recovered_trigger_pin', names=[r['name'] for r in rows]))
        unreceipted = sorted(p.name for p in root.glob('part-*.mp4') if p.name not in store.receipts)
        store.events.append(dict(event='recovered_frozen', names=sorted(store.pinned),
                                 unreceipted_retained=unreceipted))
        try:
            store.observe_capacity()
        except OSError as error:
            # A full budget must still permit reading existing recovery data.
            store.events.append(dict(event='recovery_over_budget', error=str(error)))
        return store

    def observe_capacity(self) -> None:
        # Includes producer's currently open file and any files delivered ahead
        # of the reader. This is an observed bound, not a block-device quota.
        used = sum(p.stat().st_size for p in self.root.glob('part-*.mp4'))
        self.peak_observed_bytes = max(self.peak_observed_bytes, used)
        if used > self.budget:
            self.frozen = True
            raise OSError('host segment byte budget exceeded; retain custody')

    def accept(self, name: str, *, pin: bool) -> dict:
        if self.frozen or name in self.receipts or Path(name).name != name:
            raise ValueError('invalid/frozen custody admission')
        path = self.root / name
        try:
            regular_file(path)
            before = sha(path)
            with path.open('r+b') as file:
                os.fsync(file.fileno())
            sync_directory(self.root)
            row = dict(name=name, bytes=path.stat().st_size, sha256=before, pinned=pin)
            verify_receipt(self.root, row)  # Fresh handle and full readback.
            sidecar = self.root / (name + '.custody.json')
            with sidecar.open('x') as file:
                json.dump(row, file, indent=2); file.write('\n')
                file.flush(); os.fsync(file.fileno())
            sync_directory(self.root)
            if json.loads(sidecar.read_text()) != row:
                raise OSError('custody sidecar readback mismatch')
            self.receipts[name] = row
            if pin:
                self.pinned.add(name)
            self.events.append(dict(event='accepted', **row))
            self.observe_capacity()
            return row
        except Exception:
            self.frozen = True
            raise

    def pin_all(self) -> None:
        if self.frozen:
            raise ValueError('frozen custody cannot accept a trigger')
        try:
            # Acknowledge ownership only after the exact pre-trigger receipt
            # set is persisted, synced, and independently read back. Subsequent
            # accepted media records its pin in its own synced sidecar.
            row = dict(schema=1, kind='closed_media_trigger_pin',
                       receipts=[self.receipts[name] for name in sorted(self.receipts)])
            path = self.root / PIN_FILE
            with path.open('x') as file:
                json.dump(row, file, indent=2); file.write('\n')
                file.flush(); os.fsync(file.fileno())
            sync_directory(self.root)
            regular_file(path)
            if json.loads(path.read_text()) != row:
                raise OSError('trigger pin checkpoint readback mismatch')
            self.pinned.update(self.receipts)
            self.events.append(dict(event='trigger_pin', names=sorted(self.pinned), durable_checkpoint=PIN_FILE))
        except Exception:
            self.frozen = True
            raise

    def evict(self, name: str) -> None:
        if self.frozen or name in self.pinned:
            raise ValueError('pinned/frozen segment cannot be evicted')
        try:
            row = self.receipts[name]
            verify_receipt(self.root, row)
            (self.root / name).unlink()
            (self.root / (name + '.custody.json')).unlink()
            sync_directory(self.root)
            del self.receipts[name]
            self.events.append(dict(event='evicted', **row))
        except Exception:
            self.frozen = True
            raise

    def summary(self) -> dict:
        return dict(scope='host closed MP4 custody; no physical SD or C source-coverage proof',
                    budget_bytes=self.budget, peak_observed_segment_bytes=self.peak_observed_bytes,
                    capacity_observation='closed-segment delivery/checkpoints; not a continuous quota',
                    frozen=self.frozen, pinned=sorted(self.pinned),
                    retained_receipts=list(self.receipts.values()), events=self.events)
