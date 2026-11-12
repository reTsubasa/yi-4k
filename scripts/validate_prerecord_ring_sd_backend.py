#!/usr/bin/env python3
"""Validate a bounded, host POSIX simulation of the prerecord SD ring.

This is deliberately a strict storage simulation, not a camera or SD driver.
Each segment is an append-only packet file plus a YI4KSE01-style sidecar seal.
The simulation exercises segment rollover, one-packet AAC lookahead, leases,
oldest-first eviction, ambiguous write freezing, and a new-reader seal check.
It does not claim to implement the RTOS callback or physical SD contract.
"""
from __future__ import annotations

from collections import OrderedDict
from dataclasses import dataclass
import hashlib
import json
import os
from pathlib import Path
import platform
import struct
import sys
import tempfile
import zlib

ROOT = Path(__file__).resolve().parents[1]
OUT_DEFAULT = ROOT / "artifacts/verification/2026-11-12-ring-sd-run01"
HEADER = struct.Struct("<8sQQQBBIQQII32sI")
MARKER = struct.Struct("<8sQII")
RECORD_MAGIC = b"Y4KR001\0"
COMMIT_MAGIC = b"Y4KRCM01"
SEAL_MAGIC = b"YI4KSE01"
SEAL_FINISH = b"Y4KSFIN1"
SCOPE_SNAPSHOT = 1
VIDEO = 1
AUDIO = 2


class RingError(RuntimeError):
    pass


class StorageAmbiguous(RingError):
    pass


@dataclass(frozen=True)
class Packet:
    track: int
    sequence: int
    pts: int
    duration: int
    epoch: int
    payload: bytes

    @property
    def end(self) -> int:
        return self.pts + self.duration


def crc(data: bytes) -> int:
    return zlib.crc32(data) & 0xFFFFFFFF


def config_digest() -> bytes:
    return hashlib.sha256(b"host-synthetic-av-config-v1").digest()


def fsync_parent(path: Path) -> None:
    """Model directory-entry durability required after O_EXCL/unlink."""
    fd = os.open(path.parent, os.O_RDONLY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


class Segment:
    """One append-only file with explicit sync/readback and a sidecar seal."""

    def __init__(self, root: Path, session: int, segment: int, epoch: int,
                 fail_sync_at: int = 0):
        self.root = root
        self.session = session
        self.segment = segment
        self.epoch = epoch
        self.cfg = config_digest()
        self.spool_path = root / f"segment-{segment:04d}.spool"
        self.seal_path = root / f"segment-{segment:04d}.seal"
        self.fd = os.open(self.spool_path, os.O_CREAT | os.O_EXCL | os.O_RDWR, 0o600)
        self.seal_fd: int | None = None
        self.records: list[Packet] = []
        self.track_last: dict[int, tuple[int, int]] = {}
        self.transcript = hashlib.sha256(self._identity_bytes())
        self.payload_bytes = 0
        self.sealed = False
        self.frozen = False
        self.sync_calls = 0
        self.fail_sync_at = fail_sync_at
        fsync_parent(self.spool_path)

    def _identity_bytes(self) -> bytes:
        return b"YI4KCOV1" + struct.pack("<QQQ", self.session, self.segment, self.epoch) + self.cfg

    def _sync(self) -> None:
        self.sync_calls += 1
        if self.fail_sync_at and self.sync_calls == self.fail_sync_at:
            raise StorageAmbiguous(f"sync failure at call {self.sync_calls}")
        os.fsync(self.fd)

    def append(self, packet: Packet) -> None:
        if self.sealed or self.frozen:
            raise RingError("segment is closed or frozen")
        if packet.epoch != self.epoch or packet.track not in (VIDEO, AUDIO):
            raise RingError("epoch/track mismatch")
        if not packet.payload or packet.duration <= 0 or packet.pts < 0:
            raise RingError("invalid packet")
        prior = self.track_last.get(packet.track)
        if prior and (packet.sequence != prior[0] + 1 or packet.pts != prior[1]):
            raise RingError("per-track continuity mismatch")
        ordinal = len(self.records) + 1
        header0 = HEADER.pack(RECORD_MAGIC, self.session, self.segment, ordinal,
                              packet.track, 0, self.epoch, packet.sequence,
                              packet.pts, packet.duration, len(packet.payload), self.cfg, 0)
        header_crc = crc(header0[:-4] + packet.payload)
        header = header0[:-4] + struct.pack("<I", header_crc)
        marker0 = MARKER.pack(COMMIT_MAGIC, ordinal, header_crc, crc(packet.payload))
        at = os.lseek(self.fd, 0, os.SEEK_END)
        try:
            if os.write(self.fd, header) != len(header) or os.write(self.fd, packet.payload) != len(packet.payload):
                raise StorageAmbiguous("short record write")
            self._sync()
            if os.write(self.fd, marker0) != len(marker0):
                raise StorageAmbiguous("short commit write")
            self._sync()
            os.lseek(self.fd, at, os.SEEK_SET)
            check = os.read(self.fd, len(header) + len(packet.payload) + MARKER.size)
            if check != header + packet.payload + marker0:
                raise StorageAmbiguous("record readback mismatch")
            os.lseek(self.fd, 0, os.SEEK_END)
        except Exception:
            self.frozen = True
            raise
        canonical = header0[:-4]
        self.transcript.update(canonical)
        self.transcript.update(packet.payload)
        self.records.append(packet)
        self.track_last[packet.track] = (packet.sequence, packet.end)
        self.payload_bytes += len(packet.payload)

    def _request(self, closure_id: int) -> dict:
        tracks = []
        for track in (VIDEO, AUDIO):
            rows = [p for p in self.records if p.track == track]
            tracks.append({
                "records": len(rows),
                "first_pts": rows[0].pts if rows else 0,
                "end_pts": rows[-1].end if rows else 0,
                "first_sequence": rows[0].sequence if rows else 0,
                "last_sequence": rows[-1].sequence if rows else 0,
            })
        return {"session": self.session, "segment": self.segment, "epoch": self.epoch,
                "config_digest": self.cfg.hex(), "closure_id": closure_id,
                "scope": SCOPE_SNAPSHOT, "records": len(self.records),
                "payload_bytes": self.payload_bytes, "tracks": tracks}

    def seal(self, closure_id: int) -> dict:
        if self.frozen or self.sealed or not self.records:
            raise RingError("cannot seal segment")
        digest = self.transcript.digest()
        request = self._request(closure_id)
        body = bytearray(256)
        body[0:8] = SEAL_MAGIC
        struct.pack_into("<IIQQQ", body, 8, 1, 256, self.session, self.segment, self.epoch)
        body[40:72] = self.cfg
        struct.pack_into("<QIIQQQ", body, 72, closure_id, SCOPE_SNAPSHOT, 0,
                         len(self.records), self.payload_bytes,
                         HEADER.size * len(self.records) + self.payload_bytes + MARKER.size * len(self.records))
        for i, track in enumerate(request["tracks"]):
            p = 112 + i * 40
            struct.pack_into("<QQQII", body, p, track["records"], track["first_pts"],
                             track["end_pts"], track["first_sequence"], track["last_sequence"])
        body[192:224] = digest
        struct.pack_into("<I", body, 248, crc(body[:248]))
        marker = SEAL_FINISH + struct.pack("<QII", closure_id, struct.unpack_from("<I", body, 248)[0], 0)
        marker = marker[:20] + struct.pack("<I", crc(marker[:20]))
        self.seal_fd = os.open(self.seal_path, os.O_CREAT | os.O_EXCL | os.O_RDWR, 0o600)
        fsync_parent(self.seal_path)
        try:
            if os.write(self.seal_fd, body) != 256:
                raise StorageAmbiguous("short seal body")
            os.fsync(self.seal_fd)
            if os.write(self.seal_fd, marker) != MARKER.size:
                raise StorageAmbiguous("short seal marker")
            os.fsync(self.seal_fd)
            os.lseek(self.seal_fd, 0, os.SEEK_SET)
            if os.read(self.seal_fd, 256 + MARKER.size) != bytes(body) + marker:
                raise StorageAmbiguous("seal readback mismatch")
            os.fsync(self.seal_fd)
        except Exception:
            self.frozen = True
            raise
        self.sealed = True
        return request | {"transcript_sha256": digest.hex(), "spool_bytes": os.stat(self.spool_path).st_size}

    def verify(self, request: dict) -> dict:
        if not self.sealed or self.seal_fd is None:
            raise RingError("unsealed segment")
        os.lseek(self.seal_fd, 0, os.SEEK_SET)
        seal = os.read(self.seal_fd, 256 + MARKER.size)
        if len(seal) != 256 + MARKER.size:
            raise RingError("incomplete sidecar")
        body, finish = seal[:256], seal[256:]
        if body[:8] != SEAL_MAGIC or struct.unpack_from("<I", body, 8)[0] != 1:
            raise RingError("sidecar header mismatch")
        body_crc = struct.unpack_from("<I", body, 248)[0]
        if body_crc != crc(body[:248]):
            raise RingError("sidecar body crc mismatch")
        fmagic, fclosure, fbody_crc, fmarker_crc = MARKER.unpack(finish)
        if fmagic != SEAL_FINISH or fclosure != request["closure_id"] or fbody_crc != body_crc or fmarker_crc != crc(finish[:20]):
            raise RingError("sidecar marker mismatch")
        if (struct.unpack_from("<QQQ", body, 16) != (self.session, self.segment, self.epoch)
                or body[40:72] != self.cfg
                or struct.unpack_from("<Q", body, 72)[0] != request["closure_id"]
                or struct.unpack_from("<I", body, 80)[0] != SCOPE_SNAPSHOT
                or struct.unpack_from("<Q", body, 88)[0] != len(self.records)
                or struct.unpack_from("<Q", body, 96)[0] != self.payload_bytes
                or struct.unpack_from("<Q", body, 104)[0] != self.spool_path.stat().st_size
                or body[192:224] != bytes.fromhex(request["transcript_sha256"])):
            raise RingError("sidecar request mismatch")
        os.lseek(self.fd, 0, os.SEEK_SET)
        h = hashlib.sha256(self._identity_bytes())
        rows: list[Packet] = []
        last: dict[int, tuple[int, int]] = {}
        while True:
            header = os.read(self.fd, HEADER.size)
            if not header:
                break
            if len(header) != HEADER.size:
                raise RingError("torn header")
            magic, session, segment, ordinal, track, _, epoch, seq, pts, dur, size, cfg, stored = HEADER.unpack(header)
            payload = os.read(self.fd, size)
            marker = os.read(self.fd, MARKER.size)
            if len(payload) != size or len(marker) != MARKER.size:
                raise RingError("torn payload/marker")
            if magic != RECORD_MAGIC or session != self.session or segment != self.segment or epoch != self.epoch or cfg != self.cfg:
                raise RingError("identity mismatch")
            if stored != crc(header[:-4] + payload):
                raise RingError("header crc mismatch")
            cmagic, cord, hcrc, pcrc = MARKER.unpack(marker)
            if cmagic != COMMIT_MAGIC or cord != ordinal or hcrc != stored or pcrc != crc(payload):
                raise RingError("commit marker mismatch")
            prior = last.get(track)
            if prior and (seq != prior[0] + 1 or pts != prior[1]):
                raise RingError("scan continuity mismatch")
            last[track] = (seq, pts + dur)
            canonical = header[:-4]
            h.update(canonical); h.update(payload)
            rows.append(Packet(track, seq, pts, dur, epoch, payload))
        if rows != self.records or h.hexdigest() != request["transcript_sha256"]:
            raise RingError("source coverage mismatch")
        return {"valid": 1, "records": len(rows), "spool_bytes": self.spool_path.stat().st_size,
                "transcript_sha256": h.hexdigest(), "closure_id": request["closure_id"]}

    def close(self) -> None:
        if self.seal_fd is not None:
            os.close(self.seal_fd); self.seal_fd = None
        os.close(self.fd)


class Ring:
    def __init__(self, root: Path, capacity: int = 4, segment_us: int = 15_000_000):
        self.root = root; self.capacity = capacity; self.segment_us = segment_us
        self.session = 1107; self.next_id = 1; self.epoch = 1
        self.segments: OrderedDict[int, Segment] = OrderedDict()
        self.leases: dict[int, int] = {}
        self.manifest: list[dict] = []
        self.current: Segment | None = None
        self.pending_audio: Packet | None = None

    def _open(self) -> Segment:
        if len(self.segments) >= self.capacity:
            victim = next((sid for sid, seg in self.segments.items()
                           if seg is not self.current and seg.sealed and self.leases.get(sid, 0) == 0), None)
            if victim is None:
                raise RingError("ring backpressure: oldest segment leased or unsealed")
            seg = self.segments.pop(victim); self.manifest.append({"event": "evict", "segment": victim,
                                                                     "epoch": seg.epoch, "seal_verified": True})
            seg.close(); os.unlink(seg.spool_path); os.unlink(seg.seal_path)
            fsync_parent(seg.spool_path)
        seg = Segment(self.root, self.session, self.next_id, self.epoch)
        self.segments[self.next_id] = seg; self.current = seg; self.next_id += 1
        return seg

    def start(self) -> None:
        self._open()

    def ingest(self, packet: Packet) -> str:
        if self.current is None: self.start()
        assert self.current is not None
        if packet.epoch != self.epoch:
            raise RingError("packet epoch differs; explicit event3 rollover required")
        boundary = ((self.current.segment - 1) * self.segment_us + self.segment_us)
        if packet.end > boundary:
            if packet.track == AUDIO:
                self.pending_audio = packet
                return "held-aac-boundary"
            self.rollover(packet.epoch)
        assert self.current is not None
        self.current.append(packet)
        return "appended"

    def rollover(self, epoch: int | None = None) -> None:
        if self.current is None or not self.current.records:
            raise RingError("cannot rollover empty segment")
        if not self.current.sealed:
            closure = self.current.segment + 1000
            request = self.current.seal(closure)
            self.current.verify(request)
        previous = self.current
        if epoch is not None: self.epoch = epoch
        self.current = None
        try:
            self._open()
        except Exception:
            # Keep the sealed active segment available for a retry when a
            # trigger lease temporarily blocks eviction.
            self.current = previous
            raise
        if self.pending_audio is not None:
            held = self.pending_audio; self.pending_audio = None
            if held.epoch != self.epoch: raise RingError("held AAC epoch mismatch")
            self.current.append(held)

    def flush_current(self) -> None:
        """Seal the active segment before a trigger snapshot is leased."""
        if self.current is None or not self.current.records:
            raise RingError("cannot flush empty segment")
        if not self.current.sealed:
            closure = self.current.segment + 1000
            request = self.current.seal(closure)
            self.current.verify(request)

    def lease_snapshot(self) -> tuple[list[Packet], list[int]]:
        ids = list(self.segments)
        rows: list[Packet] = []
        for sid in ids:
            seg = self.segments[sid]
            if not seg.sealed: continue
            self.leases[sid] = self.leases.get(sid, 0) + 1
            rows.extend(seg.records)
        return rows, ids

    def release(self, ids: list[int]) -> None:
        for sid in ids:
            self.leases[sid] = max(0, self.leases.get(sid, 0) - 1)

    def close(self) -> None:
        for seg in self.segments.values(): seg.close()


def reopen_verify(root: Path, segment: int) -> dict:
    """Verify one sealed segment from files after the writer is closed.

    This deliberately reconstructs identity, continuity and the transcript
    from spool/seal bytes.  It does not use a live Segment object's records,
    counters or file descriptors, so it models the recovery reader that runs
    after a process restart.
    """
    spool_path = root / f"segment-{segment:04d}.spool"
    seal_path = root / f"segment-{segment:04d}.seal"
    seal = seal_path.read_bytes()
    if len(seal) != 256 + MARKER.size:
        raise RingError("reopen sidecar length mismatch")
    body, finish = seal[:256], seal[256:]
    if body[:8] != SEAL_MAGIC:
        raise RingError("reopen sidecar magic mismatch")
    version, body_size = struct.unpack_from("<II", body, 8)
    if (version, body_size) != (1, 256):
        raise RingError("reopen sidecar version mismatch")
    body_crc = struct.unpack_from("<I", body, 248)[0]
    if body_crc != crc(body[:248]):
        raise RingError("reopen sidecar body crc mismatch")
    fmagic, closure_id, fbody_crc, fmarker_crc = MARKER.unpack(finish)
    if (fmagic != SEAL_FINISH or fbody_crc != body_crc
            or fmarker_crc != crc(finish[:20])):
        raise RingError("reopen sidecar finish mismatch")
    session, sid, epoch = struct.unpack_from("<QQQ", body, 16)
    config = body[40:72]
    record_count, payload_bytes, spool_bytes = struct.unpack_from("<QQQ", body, 88)
    expected_transcript = body[192:224]
    raw = spool_path.read_bytes()
    if len(raw) != spool_bytes:
        raise RingError("reopen spool size mismatch")
    transcript = hashlib.sha256(b"YI4KCOV1" + struct.pack("<QQQ", session, sid, epoch) + config)
    offset = 0
    count = 0
    payload_total = 0
    last: dict[int, tuple[int, int]] = {}
    while offset < len(raw):
        header = raw[offset:offset + HEADER.size]
        if len(header) != HEADER.size:
            raise RingError("reopen torn header")
        (magic, h_session, h_segment, ordinal, track, _, h_epoch, sequence,
         pts, duration, size, h_config, stored_crc) = HEADER.unpack(header)
        payload_start = offset + HEADER.size
        payload = raw[payload_start:payload_start + size]
        marker_start = payload_start + size
        marker = raw[marker_start:marker_start + MARKER.size]
        if len(payload) != size or len(marker) != MARKER.size:
            raise RingError("reopen torn payload or marker")
        if ((magic, h_session, h_segment, h_epoch, h_config) !=
                (RECORD_MAGIC, session, sid, epoch, config)):
            raise RingError("reopen record identity mismatch")
        if stored_crc != crc(header[:-4] + payload):
            raise RingError("reopen header crc mismatch")
        marker_magic, marker_ordinal, marker_header_crc, marker_payload_crc = MARKER.unpack(marker)
        if (marker_magic != COMMIT_MAGIC or marker_ordinal != ordinal
                or marker_header_crc != stored_crc or marker_payload_crc != crc(payload)):
            raise RingError("reopen commit marker mismatch")
        prior = last.get(track)
        if prior and (sequence != prior[0] + 1 or pts != prior[1]):
            raise RingError("reopen continuity mismatch")
        last[track] = (sequence, pts + duration)
        transcript.update(header[:-4]); transcript.update(payload)
        count += 1
        payload_total += size
        offset = marker_start + MARKER.size
    if (count != record_count or payload_total != payload_bytes
            or transcript.digest() != expected_transcript
            or closure_id != struct.unpack_from("<Q", body, 72)[0]):
        raise RingError("reopen seal coverage mismatch")
    return {"segment": sid, "session": session, "epoch": epoch,
            "records": count, "payload_bytes": payload_total,
            "closure_id": closure_id, "transcript_sha256": transcript.hexdigest()}


def packets(until_us: int, epoch: int) -> list[Packet]:
    out = []
    for sec in range(until_us // 1_000_000):
        payload_v = bytes(((sec * 17) + i) & 255 for i in range(40))
        payload_a = bytes(((sec * 31) + i) & 255 for i in range(12))
        out.append(Packet(VIDEO, sec, sec * 1_000_000, 1_000_000, epoch, payload_v))
        out.append(Packet(AUDIO, sec, sec * 1_000_000, 1_000_000, epoch, payload_a))
    return sorted(out, key=lambda p: (p.pts, p.track))


def run(output: Path) -> dict:
    output.mkdir(parents=True, exist_ok=False)
    cases = []
    with tempfile.TemporaryDirectory(prefix="yi4k-ring-") as temp:
        root = Path(temp)
        ring = Ring(root)
        ring.start()
        # Four 15-second segments make a 60-second bounded pretrigger window.
        for p in packets(60_000_000, 1):
            if p.pts and p.pts % 15_000_000 == 0 and p.track == VIDEO:
                ring.rollover(1)
            ring.ingest(p)
        ring.flush_current()
        rows, ids = ring.lease_snapshot()
        assert len(ids) == 4 and len(rows) == 120
        assert min(p.pts for p in rows) == 0 and max(p.end for p in rows) == 60_000_000
        try:
            ring.rollover(1)
            raise AssertionError("leased ring unexpectedly evicted")
        except RingError as exc:
            assert "backpressure" in str(exc)
        ring.release(ids)
        ring.rollover(2)  # event3/config epoch gate; opens segment 5 and evicts segment 1.
        assert 1 not in ring.segments and ring.manifest[-1]["event"] == "evict"
        ring.ingest(Packet(VIDEO, 60, 60_000_000, 1_000_000, 2, b"event3-video"))
        held = Packet(AUDIO, 60, 74_500_000, 1_000_000, 2, b"cross-boundary-aac")
        # A packet that crosses the split is held and then transferred after event3.
        result = ring.ingest(held)
        assert result == "held-aac-boundary"
        ring.rollover(2)
        assert ring.current is not None and ring.current.records[-1] == held
        cases.append({"name": "60s_snapshot_lease_epoch_rollover", "segments_before": ids,
                      "snapshot_records": len(rows), "evicted": 1, "held_aac_transferred": True,
                      "backpressure_while_leased": True, "device_access": False})
        ring.close()
        # Close every writer descriptor, then reconstruct a sealed segment
        # from spool/seal bytes only.  This is the process-restart recovery
        # reader, independent of the in-memory Segment object above.
        reopened = reopen_verify(root, 4)
        assert reopened["records"] == 30 and reopened["payload_bytes"] == 780
        cases.append({"name": "closed_writer_restart_reader_reconstructs_segment",
                      "segment": reopened["segment"], "records": reopened["records"],
                      "payload_bytes": reopened["payload_bytes"],
                      "transcript_sha256": reopened["transcript_sha256"],
                      "device_access": False})

    with tempfile.TemporaryDirectory(prefix="yi4k-ring-fail-") as temp:
        root = Path(temp); ring = Ring(root, capacity=2); ring.start()
        ring.current.fail_sync_at = 3
        ring.ingest(Packet(VIDEO, 0, 0, 1_000_000, 1, b"video"))
        try:
            ring.ingest(Packet(AUDIO, 0, 0, 1_000_000, 1, b"audio"))
        except StorageAmbiguous:
            pass
        else:
            raise AssertionError("injected sync failure was not surfaced")
        assert ring.current.frozen and ring.current.spool_path.exists()
        assert not ring.manifest
        cases.append({"name": "ambiguous_sync_freezes_and_retains", "frozen": True,
                      "retained_spool": True, "eviction_manifest_empty": True, "device_access": False})
        ring.close()

    with tempfile.TemporaryDirectory(prefix="yi4k-ring-tamper-") as temp:
        root = Path(temp); seg = Segment(root, 1107, 1, 1)
        seg.append(Packet(VIDEO, 0, 0, 1_000_000, 1, b"sealed-video"))
        request = seg.seal(1001)
        with seg.seal_path.open("r+b") as f:
            f.seek(192); byte = f.read(1); f.seek(192); f.write(bytes([byte[0] ^ 1])); f.flush(); os.fsync(f.fileno())
        try:
            seg.verify(request)
        except RingError:
            pass
        else:
            raise AssertionError("tampered sidecar was accepted")
        cases.append({"name": "tampered_sidecar_rejected", "valid": False,
                      "device_access": False})
        seg.close()

    with tempfile.TemporaryDirectory(prefix="yi4k-ring-reopen-tamper-") as temp:
        root = Path(temp); seg = Segment(root, 1107, 7, 3)
        seg.append(Packet(VIDEO, 4, 4_000_000, 1_000_000, 3, b"restart-reader-payload"))
        seg.seal(1007); seg.close()
        with (root / "segment-0007.spool").open("r+b") as f:
            f.seek(HEADER.size); byte = f.read(1); f.seek(HEADER.size)
            f.write(bytes([byte[0] ^ 1])); f.flush(); os.fsync(f.fileno())
        try:
            reopen_verify(root, 7)
        except RingError as exc:
            assert "crc" in str(exc)
        else:
            raise AssertionError("restart reader accepted tampered spool")
        cases.append({"name": "restart_reader_rejects_tampered_spool_after_writer_close",
                      "valid": False, "device_access": False})

    script_sha = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    return {"schema": 1, "status": "pass_host_bounded_ring_sd_simulation", "device_access": False,
            "source_sha256": {"scripts/validate_prerecord_ring_sd_backend.py": script_sha},
            "host": {"python": sys.version.split()[0], "platform": platform.platform()},
            "cases": cases, "assertions": 15,
            "limitations": [
                "POSIX files and fsync are a host SD-adapter simulation, not a physical card or camera backend.",
                "Synthetic one-second video/AAC fixtures exercise ownership and boundaries; they are not source encoder output or AAC parser evidence.",
                "The ring orchestrator does not install RTOS callbacks, prove scheduler quiescence, or authenticate a hardware A/V clock.",
                "Seals prove only the simulation's expected source ledger and retained files; no MP4 publication or complete recording claim.",
            ]}


def main() -> None:
    import argparse
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--output", type=Path, default=OUT_DEFAULT)
    args = ap.parse_args()
    result = run(args.output.resolve())
    (args.output / "validation.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({"status": result["status"], "cases": len(result["cases"]),
                      "assertions": result["assertions"], "device_access": False}))


if __name__ == "__main__":
    main()
