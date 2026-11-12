#!/usr/bin/env python3
"""Host-side START trigger contract for the prerecord prototype.

This module routes already-delivered camera/test events. It does not perform
speech recognition and does not access a camera, microphone, firmware voice
model, or shutter device.
"""
from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
import unicodedata


CAMERA_VOICE_PHRASES = frozenset(("开始录像", "start recording"))


class CameraEventType(str, Enum):
    """Typed events delivered by the camera action layer."""

    START_RECORDING = "start_recording"


class TriggerSource(str, Enum):
    CAMERA_VOICE = "camera_voice"
    SHUTTER = "shutter"


class ShutterAction(str, Enum):
    PRESS = "press"


class Decision(str, Enum):
    ACCEPTED = "accepted"
    DUPLICATE = "duplicate"
    PHRASE_MISMATCH = "phrase_mismatch"
    INVALID_EVENT = "invalid_event"


@dataclass(frozen=True)
class CameraEvent:
    """A typed event already emitted by the camera firmware/action layer.

    The firmware is responsible for recognizing the voice phrase and mapping
    it to ``START_RECORDING``. This host model only routes the resulting event.
    """

    event_type: CameraEventType
    at_us: int


@dataclass(frozen=True)
class TriggerResult:
    decision: Decision
    source: TriggerSource
    at_us: int | None
    phrase: str | None = None

    @property
    def accepted(self) -> bool:
        return self.decision is Decision.ACCEPTED


class PreRecordTriggerRouter:
    """Convert camera voice/shutter events into one idempotent START.

    The router deliberately does not toggle. Once a START is accepted, every
    later trigger is a duplicate until reset() is called. A caller should pass
    ``result.at_us`` to ``PreRecordBuffer.start`` only when ``accepted`` is true.
    """

    def __init__(self, *, phrases: frozenset[str] = CAMERA_VOICE_PHRASES):
        if not phrases or any(not isinstance(item, str) or not item for item in phrases):
            raise ValueError("phrases must be a non-empty set of non-empty strings")
        self._phrases = frozenset(_normalize_phrase(item) for item in phrases)
        if not self._phrases or any(not item for item in self._phrases):
            raise ValueError("phrases must contain text after normalization")
        self._started = False
        self._generation = 0

    @property
    def started(self) -> bool:
        return self._started

    @property
    def generation(self) -> int:
        """Reset generation, useful for correlating a new capture session."""
        return self._generation

    def _validate_time(self, at_us: int) -> bool:
        return isinstance(at_us, int) and not isinstance(at_us, bool) and at_us >= 0

    def _start(self, source: TriggerSource, at_us: int, phrase: str | None = None) -> TriggerResult:
        if not self._validate_time(at_us):
            return TriggerResult(Decision.INVALID_EVENT, source, None, phrase)
        if self._started:
            return TriggerResult(Decision.DUPLICATE, source, at_us, phrase)
        self._started = True
        return TriggerResult(Decision.ACCEPTED, source, at_us, phrase)

    def on_camera_event(self, event: CameraEvent) -> TriggerResult:
        """Route a typed camera ``START_RECORDING`` event.

        This is the canonical production input. It contains no phrase text:
        camera firmware recognition and phrase-to-event mapping happen before
        this method is called.
        """
        if not isinstance(event, CameraEvent) or event.event_type is not CameraEventType.START_RECORDING:
            at_us = event.at_us if isinstance(event, CameraEvent) and self._validate_time(event.at_us) else None
            return TriggerResult(Decision.INVALID_EVENT, TriggerSource.CAMERA_VOICE, at_us)
        return self._start(TriggerSource.CAMERA_VOICE, event.at_us)

    def on_camera_voice_event(self, phrase: str, at_us: int) -> TriggerResult:
        """Synthetic test adapter for a phrase recognized by camera firmware.

        Production code should call :meth:`on_camera_event` with a typed event.
        This helper only lets offline fixtures exercise the canonical phrase
        mapping; it does not perform speech recognition.

        Normalization deliberately matches the Android router: NFKC, lowercase,
        trim, punctuation/separator to spaces, then whitespace collapse. The
        resulting text must still equal one of the two complete phrases; extra
        words and Chinese word separators remain mismatches.
        """
        if not isinstance(phrase, str):
            return TriggerResult(Decision.PHRASE_MISMATCH, TriggerSource.CAMERA_VOICE, None)
        normalized = _normalize_phrase(phrase)
        if normalized not in self._phrases:
            return TriggerResult(Decision.PHRASE_MISMATCH, TriggerSource.CAMERA_VOICE, at_us if self._validate_time(at_us) else None, phrase)
        return self._start(TriggerSource.CAMERA_VOICE, at_us, phrase)

    def on_shutter(self, at_us: int, action: ShutterAction | str = ShutterAction.PRESS) -> TriggerResult:
        """Accept a shutter press; release/unknown actions are ignored."""
        try:
            action = ShutterAction(action)
        except (TypeError, ValueError):
            return TriggerResult(Decision.INVALID_EVENT, TriggerSource.SHUTTER, at_us if self._validate_time(at_us) else None)
        if action is not ShutterAction.PRESS:
            return TriggerResult(Decision.INVALID_EVENT, TriggerSource.SHUTTER, at_us if self._validate_time(at_us) else None)
        return self._start(TriggerSource.SHUTTER, at_us)

    def reset(self) -> None:
        """Start a new host session; the next valid event can emit START."""
        self._started = False
        self._generation += 1


def _normalize_phrase(phrase: str) -> str:
    """Normalize voice text exactly as ``CaptureTriggerRouter.normalize``.

    Java's ``[\\p{L}\\p{N}]`` keeps Unicode letters and numbers. Python's
    ``isalpha``/``isnumeric`` cover the same intended classes for this
    contract; all other characters become separators before whitespace is
    collapsed.
    """
    value = unicodedata.normalize("NFKC", phrase).lower().strip()
    value = "".join(char if char.isalpha() or char.isnumeric() else " " for char in value)
    return " ".join(value.split())

