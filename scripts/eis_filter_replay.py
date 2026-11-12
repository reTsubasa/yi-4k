#!/usr/bin/env python3
"""Offline A0384710 scalar reference. Raw gyro logs are not boundary inputs.

The reference models A32 wraparound, signed byte gain, signed division toward
zero, and the optional small-motion branch. It never contacts the camera.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import struct
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin'
IMAGE_SHA256 = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
BASE = 0xA0100000
I32_MIN, I32_MAX = -(1 << 31), (1 << 31) - 1


def signed32(value: int) -> int:
    value &= 0xffffffff
    return value - (1 << 32) if value & (1 << 31) else value


def signed8(value: int) -> int:
    value &= 0xff
    return value - 256 if value & 0x80 else value


def truncdiv(value: int, divisor: int) -> int:
    quotient = abs(value) // abs(divisor)
    return -quotient if (value < 0) != (divisor < 0) else quotient


def lsl32(value: int, amount: int) -> int:
    """A32 register-specified LSL takes its amount from the low byte."""
    amount &= 0xff
    return 0 if amount >= 32 else signed32(value << amount)


def validate_i32(value: Any, label: str) -> int:
    if type(value) is not int or not I32_MIN <= value <= I32_MAX:
        raise ValueError(f'{label} must be a signed 32-bit integer')
    return value


def load_identity(image: Path = IMAGE) -> tuple[dict[str, Any], dict[str, Any]]:
    data = image.read_bytes()
    digest = hashlib.sha256(data).hexdigest()
    if digest != IMAGE_SHA256:
        raise ValueError('1.10.7 image hash mismatch; refusing stale address interpretation')
    at = lambda addr: addr - BASE
    defaults = {
        'gain': struct.unpack_from('<b', data, at(0xA0757B54))[0],
        'small_motion_degrees': struct.unpack_from('<i', data, at(0xA0757AD4))[0],
        'scale_shift': struct.unpack_from('<b', data, at(0xA0757AA1))[0],
        'small_count_limit': data[at(0xA0757AD8)],
        'adaptive_feedback': struct.unpack_from('<i', data, at(0xA0757ADC))[0],
        'radians_numerator': struct.unpack_from('<d', data, at(0xA0384A00))[0],
        'radians_denominator': struct.unpack_from('<d', data, at(0xA0384A08))[0],
    }
    return {'firmware': 'Z16V13L_1.10.7_build-20180202122459_git-a8f840ce_r2746',
            'image': str(image), 'sha256': digest, 'base': hex(BASE),
            'function': '0xA0384710', 'evidence': 'local device-image bytes; no device execution'}, defaults


@dataclass(frozen=True)
class Parameters:
    limit: int
    gain: int = 100
    adaptive_enabled: bool = False
    small_motion_degrees: int = 30
    scale_shift: int = 24
    small_count_limit: int = 5
    adaptive_feedback: int = 90
    radians_numerator: float = math.pi
    radians_denominator: float = 180.0

    def __post_init__(self) -> None:
        validate_i32(self.limit, 'limit')
        if self.limit < 0:
            raise ValueError('limit must be non-negative; runtime negative limits have no supported interpretation')
        if type(self.adaptive_enabled) is not bool:
            raise ValueError('adaptive_enabled must be boolean')
        for key in ('gain', 'scale_shift'):
            value = getattr(self, key)
            if type(value) is not int or not -128 <= value <= 127:
                raise ValueError(f'{key} must be a signed byte')
        for key in ('adaptive_feedback', 'small_motion_degrees'):
            validate_i32(getattr(self, key), key)
        if type(self.small_count_limit) is not int or not 0 <= self.small_count_limit <= 255:
            raise ValueError('small_count_limit must be an unsigned byte')
        if not math.isfinite(self.radians_numerator) or not math.isfinite(self.radians_denominator) or self.radians_denominator == 0:
            raise ValueError('finite, nonzero angular conversion constants required')
        if self.adaptive_enabled and not I32_MIN <= self.threshold_unscaled() <= I32_MAX:
            raise ValueError('adaptive VCVT result would be outside signed32; unsupported exceptional VFP state')

    def threshold_unscaled(self) -> int:
        value = float(lsl32(self.small_motion_degrees, self.scale_shift))
        return math.trunc(value * self.radians_numerator / self.radians_denominator)


def stock_step(previous: int, current: int, params: Parameters, small_count: int = 0) -> tuple[int, int, dict[str, Any]]:
    validate_i32(previous, 'previous')
    validate_i32(current, 'input')
    if type(small_count) is not int or not 0 <= small_count <= 255:
        raise ValueError('small_count must be an unsigned byte')
    feedback = 99
    threshold = None
    if params.adaptive_enabled:
        threshold = truncdiv(params.threshold_unscaled(), 100)
        if (current >= 0 and current < threshold) or (current < 0 and signed32(-threshold) < current):
            small_count = (small_count + 1) & 0xff
        else:
            small_count = 0
        if small_count > params.small_count_limit:
            small_count = params.small_count_limit
            feedback = params.adaptive_feedback
    feedback_product = previous * feedback
    input_product = current * params.gain
    feedback_wrapped = signed32(feedback_product)
    input_wrapped = signed32(input_product)
    feedback_term = truncdiv(feedback_wrapped, 100)
    input_term = truncdiv(input_wrapped, 100)
    addition = feedback_term + input_term
    unclamped = signed32(addition)
    output = max(-params.limit, min(params.limit, unclamped))
    return output, small_count, {
        'feedback_coefficient': feedback, 'small_threshold': threshold,
        'feedback_product_i32': feedback_wrapped, 'input_product_i32': input_wrapped,
        'feedback_term': feedback_term, 'input_term': input_term,
        'unclamped_i32': unclamped,
        'wrapped_feedback_product': feedback_wrapped != feedback_product,
        'wrapped_input_product': input_wrapped != input_product,
        'wrapped_addition': unclamped != addition,
        'clamped': output != unclamped,
    }


def replay(payload: dict[str, Any], identity: dict[str, Any], defaults: dict[str, Any]) -> dict[str, Any]:
    config = payload.get('parameters', {})
    if not isinstance(config, dict) or 'limit' not in config:
        raise ValueError('parameters.limit is required; runtime A170AFEC has not been established by the static image')
    allowed = set(Parameters.__dataclass_fields__)
    if set(config) - allowed:
        raise ValueError(f'unknown parameters: {sorted(set(config) - allowed)}')
    params = Parameters(**(defaults | config))
    samples = payload.get('samples')
    if not isinstance(samples, list) or not samples:
        raise ValueError('nonempty samples [{sequence, input, previous?, tick?, stream?}] required; sparse raw gyro logs are not boundary inputs')
    feedback_mode = payload.get('feedback_mode', 'explicit_previous')
    if feedback_mode not in ('explicit_previous', 'synthetic_chain'):
        raise ValueError('feedback_mode must be explicit_previous or synthetic_chain')
    initial = validate_i32(payload.get('initial_previous', 0), 'initial_previous')
    small_count = payload.get('initial_small_count', 0)
    candidate = payload.get('candidate')
    if candidate is not None:
        if not isinstance(candidate, dict) or set(candidate) != {'alpha'}:
            raise ValueError('candidate must be null or {alpha: number}')
        alpha = candidate['alpha']
        if type(alpha) not in (int, float) or not math.isfinite(alpha) or not 0 < alpha <= 1:
            raise ValueError('candidate.alpha must be finite and in (0,1]')
    else:
        alpha = None
    previous_values: dict[str, int] = {}
    candidate_values: dict[str, float] = {}
    last_sequence = -1
    last_tick: int | None = None
    rows = []
    has_wrapping = False
    observed_mismatches = []
    for sample in samples:
        if not isinstance(sample, dict):
            raise ValueError('each sample must be an object')
        sequence = sample.get('sequence')
        if type(sequence) is not int or sequence <= last_sequence:
            raise ValueError('sample.sequence must strictly increase; order cannot be inferred from JSON file location')
        current = validate_i32(sample.get('input'), 'sample.input')
        tick = sample.get('tick')
        if tick is not None:
            if type(tick) is not int or (last_tick is not None and tick < last_tick):
                raise ValueError('ticks must be nondecreasing; unwrap clock wraparound before replay')
            last_tick = tick
        stream = sample.get('stream', 'default')
        if not isinstance(stream, str) or not stream:
            raise ValueError('sample.stream must be a nonempty string')
        if feedback_mode == 'explicit_previous':
            previous = validate_i32(sample.get('previous'), 'sample.previous')
        else:
            if 'previous' in sample:
                raise ValueError('synthetic_chain cannot mix explicit previous values')
            previous = previous_values.get(stream, initial)
        if 'small_count_before' in sample:
            small_count = sample['small_count_before']
        output, small_count, details = stock_step(previous, current, params, small_count)
        row = {'sequence': sequence, 'tick': tick, 'stream': stream, 'input': current, 'previous': previous,
               'stock_reference': output, 'small_count_after': small_count, 'arithmetic': details}
        has_wrapping |= any(details[key] for key in ('wrapped_feedback_product', 'wrapped_input_product', 'wrapped_addition'))
        if 'observed_output' in sample:
            observed = validate_i32(sample['observed_output'], 'observed_output')
            row['observed_output'] = observed
            row['matches_observed'] = observed == output
            if observed != output:
                observed_mismatches.append(sequence)
        if alpha is not None:
            prior_candidate = candidate_values.get(stream, float(initial))
            candidate_value = prior_candidate + alpha * (current - prior_candidate)
            # Candidate arithmetic is intentionally floating point and saturating,
            # unlike the firmware. The unclipped state is retained only here.
            candidate_value = max(-params.limit, min(params.limit, candidate_value))
            candidate_values[stream] = candidate_value
            row['candidate_ema'] = math.trunc(candidate_value)
            row['candidate_minus_stock'] = row['candidate_ema'] - output
        rows.append(row)
        previous_values[stream] = output
        last_sequence = sequence
    return {
        'target': identity, 'sample_kind': payload.get('sample_kind', 'unverified caller-supplied filter-boundary values'),
        'input_provenance': payload.get('provenance'), 'feedback_mode': feedback_mode,
        'parameters': asdict(params), 'static_defaults': defaults,
        'initial_previous': initial,
        'initial_small_count': payload.get('initial_small_count', 0),
        'candidate': candidate,
        'reference_semantics': 's32(trunc(s32(previous*feedback)/100)+trunc(s32(input*s8_gain)/100)), then signed clamp',
        'summary': {'samples': len(rows), 'streams': len(previous_values), 'arithmetic_wrap_observed': has_wrapping,
                    'observed_mismatch_sequences': observed_mismatches},
        'limitations': [
            'This is host arithmetic replay, not execution on the physical camera.',
            'A0384710 consumes transformed window accumulation, not raw level-shifted gyro or 50ms text diagnostics.',
            'The filter does not store through its previous pointer; explicit trace values preserve caller topology.',
            'synthetic_chain feeds each output back per stream as an experimental assumption; it is not the recovered caller topology.',
            'The adaptive byte counter is shared across ordered calls, including calls in different streams.',
            'Candidate EMA comparison is scalar arithmetic only, not a prediction of image stabilization quality.',
            'Only finite angular conversion and nonnegative runtime limit values are supported.'
        ],
        'rows': rows,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('input', type=Path)
    parser.add_argument('-o', '--output', type=Path, required=True)
    parser.add_argument('--image', type=Path, default=IMAGE)
    args = parser.parse_args()
    try:
        identity, defaults = load_identity(args.image)
        input_bytes = args.input.read_bytes()
        result = replay(json.loads(input_bytes), identity, defaults)
        result['input'] = {'path': str(args.input), 'sha256': hashlib.sha256(input_bytes).hexdigest()}
    except (ValueError, TypeError, OSError) as exc:
        parser.error(str(exc))
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(result['summary'] | {'output': str(args.output), 'device_contacted': False}, ensure_ascii=False))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
