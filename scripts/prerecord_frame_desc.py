#!/usr/bin/env python3
"""Decode and validate the 1.10.7 AmpFifo 0x20-byte frame descriptor.

This is a host-side representation of a statically recovered layout. It does
not read camera memory or dereference payload addresses. End markers take
precedence over type classification: a normal video type 1 is only a static
sync/random-access candidate, and an EOS can also carry type 1. Other type/flag
values stay opaque.
"""
from __future__ import annotations

from dataclasses import dataclass
from collections.abc import Callable
import struct


DESCRIPTOR_SIZE = 0x20
FRAME_DESC_EOS_SIZE = 0x00FFFFFF
RAW_BITS_INFO_EOS_SIZE = 0xFFFFFFFF


@dataclass(frozen=True)
class FrameDesc:
    sequence: int
    pts: int
    type: int
    flags: int
    payload_address: int
    payload_size: int
    opaque: int

    @property
    def is_end_of_stream(self) -> bool:
        # The high-level marker is normalized by BitsMgr. Also reject the raw
        # lower-level marker defensively; never interpret either as byte count.
        return self.payload_size in (FRAME_DESC_EOS_SIZE, RAW_BITS_INFO_EOS_SIZE)

    @property
    def is_sync_candidate(self) -> bool:
        return not self.is_end_of_stream and self.type == 1

    @property
    def mux_hint(self) -> str:
        if self.is_end_of_stream:
            return "end_of_stream"
        return "sync_or_random_access" if self.is_sync_candidate else "opaque"

    def to_dict(self) -> dict:
        return {
            "sequence": self.sequence,
            "pts": self.pts,
            "type": self.type,
            "flags": self.flags,
            "payload_address": hex(self.payload_address),
            "payload_size": self.payload_size,
            "opaque": self.opaque,
            "is_end_of_stream": self.is_end_of_stream,
            "is_sync_candidate": self.is_sync_candidate,
            "mux_hint": self.mux_hint,
        }


def decode_descriptor(raw: bytes, offset: int = 0) -> FrameDesc:
    if offset < 0 or offset + DESCRIPTOR_SIZE > len(raw):
        raise ValueError("descriptor is truncated")
    sequence, reserved, pts, type_byte, flag_byte, _reserved2, address, size, opaque = struct.unpack_from(
        "<IIQBBHIII", raw, offset
    )
    return FrameDesc(sequence, pts, type_byte, flag_byte, address, size, opaque)


def encode_descriptor(desc: FrameDesc) -> bytes:
    if not 0 <= desc.sequence <= 0xFFFFFFFF or not 0 <= desc.pts <= 0xFFFFFFFFFFFFFFFF:
        raise ValueError("sequence/PTS outside unsigned descriptor range")
    if not 0 <= desc.type <= 0xFF or not 0 <= desc.flags <= 0xFF:
        raise ValueError("type/flags outside byte range")
    if not 0 <= desc.payload_address <= 0xFFFFFFFF or not 0 <= desc.payload_size <= 0xFFFFFFFF:
        raise ValueError("payload address/size outside descriptor range")
    if not 0 <= desc.opaque <= 0xFFFFFFFF:
        raise ValueError("opaque field outside descriptor range")
    return struct.pack("<IIQBBHIII", desc.sequence, 0, desc.pts, desc.type, desc.flags, 0,
                       desc.payload_address, desc.payload_size, desc.opaque)


def validate_sequence(entries: list[FrameDesc]) -> None:
    previous = None
    for entry in entries:
        if previous is not None and entry.sequence <= previous:
            raise ValueError("descriptor sequence is not strictly increasing")
        previous = entry.sequence


class VirtualQueue:
    """Bounded metadata queue for a single virtual FIFO consumer.

    Each consumer owns its cursor. remove() advances only this queue; the base
    producer may reclaim a descriptor only after every virtual consumer has
    advanced past it. Payload copying is deliberately outside this model.
    """

    def __init__(self, capacity: int = 64):
        if capacity <= 0:
            raise ValueError("capacity must be positive")
        self.capacity = capacity
        self._entries: list[FrameDesc] = []

    def append(self, entry: FrameDesc) -> None:
        if len(self._entries) >= self.capacity:
            raise BufferError("virtual FIFO is full")
        self._entries.append(entry)

    def peek(self) -> FrameDesc | None:
        return self._entries[0] if self._entries else None

    def remove(self) -> FrameDesc:
        if not self._entries:
            raise IndexError("virtual FIFO is empty")
        return self._entries.pop(0)

    def __len__(self) -> int:
        return len(self._entries)


@dataclass(frozen=True)
class OwnedFrame:
    """A descriptor paired with bytes copied out of the producer ring."""

    descriptor: FrameDesc
    payload: bytes


@dataclass(frozen=True)
class EndOfStream:
    """A non-consuming end notification; no payload has been read or copied.

    The descriptor remains at the queue head. The owner decides when/how to
    close or drain its consumer; a later consume_one() returns EOS again until
    that owner explicitly removes the marker. This does not acknowledge it.
    """

    descriptor: FrameDesc


class VirtualPayloadConsumer:
    """Copy one virtual-FIFO payload before advancing the consumer cursor.

    ``read_payload`` is supplied by a host fixture or a future firmware
    adapter. It must return exactly ``descriptor.payload_size`` bytes. The
    queue is advanced only after a successful normal-frame copy, so a short
    read, an exception, or a configured size limit leaves the descriptor
    available for retry. The returned bytes own their storage and remain valid
    if the producer ring is subsequently reused. EOS returns EndOfStream before
    any size limit or reader call, without advancing the queue or copying bytes.
    """

    def __init__(self, queue: VirtualQueue, max_payload_size: int = 16 * 1024 * 1024):
        if max_payload_size <= 0:
            raise ValueError("max_payload_size must be positive")
        self.queue = queue
        self.max_payload_size = max_payload_size

    def consume_one(self, read_payload: Callable[[FrameDesc], bytes]) -> OwnedFrame | EndOfStream | None:
        descriptor = self.queue.peek()
        if descriptor is None:
            return None
        if descriptor.is_end_of_stream:
            return EndOfStream(descriptor)
        if descriptor.payload_size > self.max_payload_size:
            raise ValueError("payload exceeds consumer bound")
        payload = read_payload(descriptor)
        if not isinstance(payload, (bytes, bytearray, memoryview)):
            raise TypeError("payload reader must return bytes-like data")
        copied = bytes(payload)
        if len(copied) != descriptor.payload_size:
            raise ValueError("payload length does not match descriptor")
        removed = self.queue.remove()
        if removed != descriptor:
            raise RuntimeError("virtual cursor changed during payload copy")
        return OwnedFrame(descriptor, copied)
