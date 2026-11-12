#!/usr/bin/env python3
"""Host reference for a bounded segment prerecord buffer; no device access.

The encoder adapter must deliver closed, independently decodable segments on a
single continuous timeline. This module owns metadata only, never deletes files,
and leaves open-segment capture, muxing, storage and durability to that adapter.
"""
from __future__ import annotations

from dataclasses import dataclass
from enum import Enum


def _valid_segment_name(name: object) -> bool:
    """Return whether a segment identity is safe for an owning spool.

    Storage adapters may use ``Segment.name`` to remove evicted files.  Keep
    that identity a plain filename so an invalid producer cannot make an
    adapter delete a parent or sibling path.  The buffer itself never touches
    the filesystem, but enforcing the boundary here keeps every adapter on
    the same contract.
    """
    return (
        isinstance(name, str)
        and bool(name)
        and name not in {".", ".."}
        and "/" not in name
        and "\\" not in name
    )


class State(str, Enum):
    ARMING = "arming"
    PREBUFFERING = "prebuffering"
    RECORDING = "recording"
    STOPPING = "stopping"
    FINALIZING = "finalizing"
    COMPLETE = "complete"


@dataclass(frozen=True)
class Segment:
    name: str
    start_us: int
    end_us: int
    starts_with_keyframe: bool


class PreRecordBuffer:
    """Single-owner START/STOP state machine using integer microseconds.

    ingest() returns metadata evicted from the uncommitted window. A storage
    adapter may remove only its own files for these entries. Once committed,
    selected entries remain pinned through finalization. RAM use after START
    grows with the recording duration (metadata, not encoded video).
    """

    def __init__(self, window_us: int = 60_000_000):
        if window_us <= 0:
            raise ValueError("window must be positive")
        self.window_us = window_us
        self.state = State.ARMING
        self.segments: list[Segment] = []
        self.trigger_us: int | None = None
        self.stop_us: int | None = None
        self.last_end_us: int | None = None

    def _evict(self, now_us: int) -> list[Segment]:
        cutoff = now_us - self.window_us
        count = 0
        for segment in self.segments:
            if segment.end_us > cutoff:
                break
            count += 1
        removed = self.segments[:count]
        del self.segments[:count]
        return removed

    def ingest(self, segment: Segment) -> list[Segment]:
        if self.state not in (State.ARMING, State.PREBUFFERING, State.RECORDING, State.STOPPING):
            raise ValueError("no segments accepted after finalization")
        if (not _valid_segment_name(segment.name)
                or segment.start_us < 0
                or segment.end_us <= segment.start_us):
            raise ValueError("invalid segment interval or identity")
        if not segment.starts_with_keyframe:
            raise ValueError("segment must begin at an independently decodable keyframe")
        if self.last_end_us is not None and segment.start_us != self.last_end_us:
            raise ValueError("segment timeline has a gap or overlap")
        if any(item.name == segment.name for item in self.segments):
            raise ValueError("duplicate segment identity")
        if not self.segments and self.trigger_us is not None and segment.start_us > self.trigger_us:
            raise ValueError("initial segment starts after START; recording coverage is missing")
        self.segments.append(segment)
        self.last_end_us = segment.end_us
        if self.state in (State.ARMING, State.PREBUFFERING):
            self.state = State.PREBUFFERING
            return self._evict(segment.end_us)
        if self.state == State.STOPPING and segment.end_us >= self.stop_us:
            self.state = State.FINALIZING
        return []

    def start(self, at_us: int) -> tuple[bool, list[Segment]]:
        """START from voice/button/App is idempotent; never toggles to STOP."""
        if self.state in (State.RECORDING, State.STOPPING, State.FINALIZING, State.COMPLETE):
            return False, []
        if at_us < 0 or (self.last_end_us is not None and at_us < self.last_end_us):
            raise ValueError("START predates the last delivered segment")
        evicted = self._evict(at_us)
        self.trigger_us = at_us
        self.state = State.RECORDING
        return True, evicted

    def stop(self, at_us: int) -> bool:
        if self.stop_us is not None:
            return False
        if self.state != State.RECORDING:
            raise ValueError("STOP requires an active recording")
        if at_us < self.trigger_us or (self.last_end_us is not None and at_us < self.last_end_us):
            raise ValueError("STOP predates START or a delivered segment")
        self.stop_us = at_us
        self.state = State.FINALIZING if self.last_end_us == at_us else State.STOPPING
        return True

    def complete(self) -> None:
        if self.state != State.FINALIZING or not self.segments:
            raise ValueError("final segment must cover STOP before publishing")
        if self.segments[0].start_us > self.trigger_us:
            raise ValueError("selected segments do not cover START")
        self.state = State.COMPLETE

    def summary(self) -> dict:
        first = self.segments[0].start_us if self.segments else None
        end = self.segments[-1].end_us if self.segments else None
        pre = self.trigger_us - first if first is not None and self.trigger_us is not None else None
        return {
            "state": self.state.value,
            "window_us": self.window_us,
            "trigger_us": self.trigger_us,
            "requested_stop_us": self.stop_us,
            "selected_start_us": first,
            "selected_end_us": end,
            "available_pretrigger_us": pre,
            "full_window_available": pre is not None and pre >= self.window_us,
            "stop_overshoot_us": end - self.stop_us if end is not None and self.stop_us is not None else None,
            "segments": [vars(segment) for segment in self.segments],
        }
