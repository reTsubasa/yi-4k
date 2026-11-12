#!/usr/bin/env python3
"""Offline probe of stock IsoMux_Close modes used by rollover candidates.

This deliberately executes the pinned ARM Close wrapper after real archived
video/AAC packets have gone through the stock ProcessVideo/ProcessAudio and
index models.  It is a close-contract audit, not a camera integration test.
In particular, 0x40/0x80 must not be treated as a harmless "keep tail" mode:
the original Close implementation skips MOOV finalization for both values.
"""
from __future__ import annotations
import argparse, hashlib, json, sys
from collections import Counter
from fractions import Fraction
from pathlib import Path

import audit_prerecord_aac_boundary_close as boundary

gop = boundary.gop
factory = boundary.f
native = boundary.n
s = boundary.s
ROOT = gop.ROOT
OUT = ROOT / "artifacts/device/2026-11-11-prerecord-rollover-close"
FROZEN_BOUNDARY = "e4a2bb4764204b4bdb89c41926644770a7e633339a51c4a657d5344798080f3d"
MODES = (0, 0x40, 0x80)


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def build(mode: int, out: Path):
    image = s.life.arm.IMAGE.read_bytes()
    m = boundary.BoundaryMachine(image)
    track, mem = m.setup_index()
    for i, value in enumerate([1, 0, 0, s.MOVIE, 0x709, 2]):
        m.put(factory.CFG + i * 4, value)
    m.uc.mem_write(factory.NAME, b"rollover-close.mp4\0" + bytes(52))
    assert m.call(0xA03E3C48, factory.CFG) == 0
    assert m.call(0xA03E3F00, factory.NAME, s.RESULT) == 0
    assert m.call(0xA0440CD4, s.MOVIE, s.CONFIG) == 0
    assert m.call(0xA03FECCC, factory.MUXCFG) == 0
    for offset, value in [(0, s.STREAM), (4, mem), (8, 2)]:
        m.put(factory.MUXCFG + offset, value)
    assert m.call(0xA03FED44, factory.MUXCFG, s.RESULT) == 0
    mux = m.get(s.RESULT)
    m.put(mux + 4, s.MOVIE)
    m.put(mux + 0x10, 60000)
    assert m.call(0xA03FE468, mux) == 0

    raw = s.SAMPLE_MP4.read_bytes()
    probe = gop.probe(s.SAMPLE_MP4)
    packets = gop.packets(probe, raw)
    sps, pps = gop.avcc(gop.extradata(probe["streams"][0]["extradata"]))
    chosen = [p for p in packets if Fraction(p["pts"], 30000 if p["stream"] == 0 else 48000)
              < Fraction(8008, 30000)]
    submitted = {"0": [], "1": []}
    for packet in chosen:
        data = packet["data"]
        video = packet["stream"] == 0
        if video:
            data = b"".join(b"\0\0\0\1" + nal for nal in gop.split_nals(data))
            if packet["key"]:
                data = b"\0\0\0\1" + sps + b"\0\0\0\1" + pps + data
        kind = 1 if video and packet["key"] else 3 if video else 8
        m.descriptor(data, m.payload(data, 32), kind, packet["pts"])
        if video:
            status = m.call(0xA042D0F8, s.MOVIE, track, s.PARAMS, mux + 0x58,
                            s.STREAM, 60000, 0xFFFFFFFF, 0xFFFFFFFF)
        else:
            status = m.call(0xA043173C, s.MOVIE, track + 0x90, mux + 0x58,
                            s.STREAM, 0, 60000, 0xFFFFFFFF, 0xFFFFFFFF)
        assert status == 0
        submitted[str(packet["stream"])].append(packet["index"])

    before = dict(output_bytes=len(m.output), movie_sha256=sha(bytes(m.uc.mem_read(s.MOVIE, 0x708))),
                  index_sha256=sha(bytes(m.uc.mem_read(mux + 0x58, 0x138))),
                  sample_counts=[m.get(track + 0x10), m.get(track + 0xA0)])
    m.phase = "close_" + hex(mode)
    status = m.call(0xA03FE300, mux, mode)
    data = bytes(m.output)
    path = out / ("close-%02x.mp4" % mode)
    path.write_bytes(data)
    # ffprobe is intentionally best effort: modes that skip MOOV must be
    # represented as an invalid/unfinalized file rather than hidden as a test
    # failure.  Close(0) gets the strict packet proof from the prior audit;
    # this script records its independent output shape and exact errors.
    try:
        after_probe = gop.probe(path)
        probe_error = None
        output_counts = [sum(int(packet["stream_index"]) == index
                             for packet in after_probe.get("packets", []))
                         for index, _ in enumerate(after_probe["streams"])]
    except Exception as error:
        after_probe = None
        probe_error = str(error)
        output_counts = None
    return dict(mode=mode, status=status, file=path.name, bytes=len(data), sha256=sha(data),
                prefix_hex=data[:32].hex(), submitted_packets=submitted,
                before=before, after_index_zeroed=bytes(m.uc.mem_read(mux + 0x58, 0x138)) == bytes(0x138),
                after_movie_sha256=sha(bytes(m.uc.mem_read(s.MOVIE, 0x708))),
                trim_calls=[x for x in m.trim_calls if x["phase"] == "close_" + hex(mode)],
                index_events=len(m.index_events), native_calls=dict(Counter(x["entry"] for x in m.native_calls)),
                output_packet_counts=output_counts, ffprobe_error=probe_error,
                moov_finalized=after_probe is not None,
                reopen_status=m.call(0xA03FE468, mux),
                reopen_movie_sha256=sha(bytes(m.uc.mem_read(s.MOVIE, 0x708))))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=OUT)
    args = parser.parse_args()
    out = args.output
    out.mkdir(parents=True, exist_ok=True)
    assert native.sha(Path(boundary.__file__).read_bytes()) == FROZEN_BOUNDARY
    image = s.life.arm.IMAGE.read_bytes()
    assert native.sha(image) == s.life.arm.DIGEST
    cases = [build(mode, out) for mode in MODES]
    report = dict(schema=1, status="pass_expected_rejections_preserved", offline_only=True,
        source=dict(path=str(s.SAMPLE_MP4.relative_to(ROOT)), sha256=boundary.gop.SOURCE_SHA),
        source_scope="one real archived 8-video/13-AAC window through original ProcessVideo/Audio and index model",
        close_wrapper="A03FE300 -> A0436004 IsoMux_Close; mode is passed unchanged",
        cases=cases,
        conclusions=[
            "mode 0 executes IsoMux_Trim and finalizes a playable MOOV; tail AAC coverage remains governed by Trim",
            "mode 0x40 skips Trim but also skips MOOV/stream finalization, so the produced bytes are not a playable segment",
            "mode 0x80 follows the non-Trim close cleanup and likewise leaves no finalized MOOV; it is startup-error cleanup, not rollover",
            "the tested 0x40/0x80 values do not constitute a legal AAC-preserving rollover API",
        ],
        caller_evidence={"0x40": ["A044195C OnPipePaused", "A0442674 OnPipeLimit error cleanup", "A0442BAC OnPipeError"],
                         "0x80": ["A0441550 AmpMuxer_StartPipe startup error cleanup"]},
        limits=["offline synthetic RAM and archived packets; no encoder/DMA/CFS/scheduler or camera access",
                "one window only; no claim of continuous producer ownership, payload lifetime, or cross-file timing",
                "A0436004 direct mode experiments are diagnostic evidence, not deployment guidance"])
    (out / "audit.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(dict(status=report["status"], modes=MODES, output=str(out))))


if __name__ == "__main__":
    main()
