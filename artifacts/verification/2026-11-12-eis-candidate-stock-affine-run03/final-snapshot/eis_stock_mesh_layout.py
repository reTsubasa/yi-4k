#!/usr/bin/env python3
"""Host-only layout adapter for the archived original-generator profiles.

Values stay opaque signed int16 stock units. This module deliberately has no
normalized-Q16 conversion, physical-unit mapping, device API or address writer.
"""
from __future__ import annotations

import struct
from dataclasses import dataclass

PLANE_BYTES = 0x1800
SCRATCH_BYTES = PLANE_BYTES * 2
DESCRIPTOR_BYTES = 0x50


@dataclass(frozen=True)
class PlaneLayout:
    columns: int
    rows: int
    pitch_elements: int
    scratch_offset: int

    def __post_init__(self):
        if any(type(v) is not int for v in (self.columns, self.rows, self.pitch_elements, self.scratch_offset)):
            raise ValueError("layout fields must be integers")
        if min(self.columns, self.rows) < 1 or self.pitch_elements < self.columns:
            raise ValueError("invalid plane dimensions or pitch")
        if self.scratch_offset not in (0, PLANE_BYTES):
            raise ValueError("plane offset must select X or Y")
        if ((self.rows - 1) * self.pitch_elements + self.columns) * 2 > PLANE_BYTES:
            raise ValueError("active rectangle exceeds plane capacity")

    def offsets(self):
        for row in range(self.rows):
            for col in range(self.columns):
                yield self.scratch_offset + (row * self.pitch_elements + col) * 2


def layouts_from_descriptor(descriptor: bytes, *, x_pitch: int, y_pitch: int):
    """Pitch is explicit; the descriptor does not prove one universal rule."""
    if len(descriptor) != DESCRIPTOR_BYTES:
        raise ValueError("descriptor must be exactly 0x50 bytes")
    return (
        PlaneLayout(descriptor[0x30] + 1, descriptor[0x31] + 1, x_pitch, 0),
        PlaneLayout(descriptor[0x35] + 1, descriptor[0x36] + 1, y_pitch, PLANE_BYTES),
    )


def unpack_active(scratch: bytes, layouts: tuple[PlaneLayout, PlaneLayout]):
    if len(scratch) != SCRATCH_BYTES:
        raise ValueError("scratch must contain exactly two 0x1800-byte planes")
    if tuple(layout.scratch_offset for layout in layouts) != (0, PLANE_BYTES):
        raise ValueError("layouts must select X then Y")
    return tuple([struct.unpack_from("<h", scratch, off)[0] for off in layout.offsets()]
                 for layout in layouts)


def repack_active_host(scratch: bytes, layouts: tuple[PlaneLayout, PlaneLayout], values):
    """In-memory host round trip; all inactive/padding bytes remain unchanged."""
    unpack_active(scratch, layouts)  # validates the complete view before writing
    if len(values) != 2:
        raise ValueError("two active-value sequences are required")
    for layout, plane in zip(layouts, values):
        if len(plane) != layout.rows * layout.columns:
            raise ValueError("active value count does not match layout")
        if any(type(value) is not int or not -32768 <= value <= 32767 for value in plane):
            raise ValueError("stock plane values must be signed int16 integers")
    result = bytearray(scratch)
    for layout, plane in zip(layouts, values):
        for off, value in zip(layout.offsets(), plane):
            struct.pack_into("<h", result, off, value)
    return bytes(result)
