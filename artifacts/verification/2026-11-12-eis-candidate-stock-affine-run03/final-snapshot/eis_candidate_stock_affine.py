#!/usr/bin/env python3
"""Offline affine candidate -> stock calibration input, for a bounded test profile.

Produces host data only. It cannot publish a DSP table or write a device. The
mapping is a CPU-coordinate hypothesis pending real-camera sign/axis acceptance.
"""
from __future__ import annotations

from dataclasses import asdict, dataclass
import math
import struct

from eis_candidate_mesh import MeshConfig


@dataclass(frozen=True)
class StockAffineCalibration:
    width: int
    height: int
    columns: int
    rows: int
    horizontal_exponent: int
    vertical_exponent: int
    stock_theta_radians: float
    grid_q4: tuple[tuple[int, int], ...]
    hypothesis: str = 'stock calibration displacements interpreted as output-to-source; CPU-only'

    def grid_bytes(self) -> bytes:
        return b''.join(struct.pack('<hh', *point) for point in self.grid_q4)

    def metadata(self) -> dict:
        value = asdict(self)
        value.pop('grid_q4')
        return value


def candidate_calibration(config: MeshConfig, correction: list[float] | tuple[float, ...]) -> StockAffineCalibration:
    """Construct pre-rotation Q4 calibration vectors with explicit geometry.

    The candidate applies roll before translation, while stock rotates the
    already displaced grid. Inverse-rotate the translation first. A 3x3 grid at
    1024-pixel intervals covers all stock queries (including guard rows) without
    the signed32 rotation overflow found with far-away synthetic grid nodes.
    """
    if config.width != 1920 or config.height != 1080:
        raise ValueError('only the reviewed 1920x1080 equal-geometry profile is supported')
    if len(correction) != 3 or any(type(v) not in (int, float) or not math.isfinite(v) for v in correction):
        raise ValueError('correction must contain three finite radians')
    pitch, yaw, roll = correction
    if abs(roll) > 0.125 or abs(pitch) > 0.125 or abs(yaw) > 0.125:
        raise ValueError('correction is outside the bounded affine test profile')
    cosine, sine = math.cos(roll), math.sin(roll)
    tx, ty = -yaw * config.focal_length_px, pitch * config.focal_length_px
    pre_x, pre_y = cosine * tx + sine * ty, -sine * tx + cosine * ty
    points = []
    for row in range(3):
        for col in range(3):
            x, y = col * 1024 - 960, row * 1024 - 540
            dx, dy = round((-config.crop_margin * x + pre_x) * 16), round((-config.crop_margin * y + pre_y) * 16)
            if not -32768 <= dx <= 32767 or not -32768 <= dy <= 32767:
                raise ValueError('calibration displacement exceeds stock signed16')
            # Bound every intermediate product used by the original rotation.
            # Quantization is truncated Q16 exactly as the stock cos/sin path.
            if roll:
                c, s = math.trunc(cosine * 65536), math.trunc(sine * 65536)
                xq, yq = x * 16 + dx, y * 16 + dy
                terms = [xq * c, yq * s, yq * c, xq * s,
                         xq * c - yq * s, yq * c + xq * s]
                if any(not -(1 << 31) <= term < (1 << 31) for term in terms):
                    raise ValueError('stock rotation signed32 arithmetic would wrap')
            points.append((dx, dy))
    # Guard rows are actual CPU sampler queries, not part of the visible image.
    # Reject if the affine interpretation would place any queried source point
    # outside image support; a later unknown DSP interpolator is not assumed.
    for rows in (35, 36):
        for row in range(rows):
            for col in range(31):
                px, py = source_point(config, correction, col * 64, row * 32)
                if not 0 <= px <= 1920 or not 0 <= py <= 1080:
                    raise ValueError('affine mapping exceeds source support at a stock query')
    return StockAffineCalibration(1920, 1080, 3, 3, 10, 10, -roll, tuple(points))


def source_point(config: MeshConfig, correction: list[float] | tuple[float, ...], x: float, y: float) -> tuple[float, float]:
    pitch, yaw, roll = correction
    x, y = (x - config.width / 2) * (1 - config.crop_margin), (y - config.height / 2) * (1 - config.crop_margin)
    c, s = math.cos(roll), math.sin(roll)
    return (c * x - s * y - yaw * config.focal_length_px + config.width / 2,
            s * x + c * y + pitch * config.focal_length_px + config.height / 2)


def _s16(value: int) -> int:
    return ((value + 32768) % 65536) - 32768


def _trunc_div(num: int, den: int) -> int:
    return -(abs(num) // den) if num < 0 else num // den


def rotated_grid(calibration: StockAffineCalibration) -> tuple[tuple[int, int], ...]:
    if not calibration.stock_theta_radians:
        return calibration.grid_q4
    theta = -calibration.stock_theta_radians
    c, s = math.trunc(math.cos(theta) * 65536), math.trunc(math.sin(theta) * 65536)
    values = []
    for index, (dx, dy) in enumerate(calibration.grid_q4):
        row, col = divmod(index, calibration.columns)
        x, y = col * 1024 * 16 - 960 * 16 + dx, row * 1024 * 16 - 540 * 16 + dy
        # candidate_calibration has already rejected signed32 wrap.
        rx, ry = (x * c - y * s) >> 16, (y * c + x * s) >> 16
        if not -32768 <= rx - x + dx <= 32767 or not -32768 <= ry - y + dy <= 32767:
            raise ValueError('rotated calibration displacement exceeds signed16')
        values.append((rx - x + dx, ry - y + dy))
    return tuple(values)


def remapped_grid(calibration: StockAffineCalibration) -> tuple[tuple[int, int], ...]:
    """Stock two-stage remap: reparameterize horizontal offsets by displaced Y.

    Vertical offsets are preserved. With monotone displaced-Y knots, this is
    inverse linear interpolation within each column, including one phantom knot
    at either end for the original extrapolation branch.
    """
    grid = rotated_grid(calibration)
    result = list(grid)
    for col in range(3):
        knots = [(row * 1024 * 16 + grid[row * 3 + col][1], grid[row * 3 + col][0]) for row in range(3)]
        if not all(a[0] < b[0] for a, b in zip(knots, knots[1:])):
            raise ValueError('vertical remap requires monotone displaced-Y knots')
        knots.insert(0, (2 * knots[0][0] - knots[1][0], 2 * knots[0][1] - knots[1][1]))
        knots.append((2 * knots[-1][0] - knots[-2][0], 2 * knots[-1][1] - knots[-2][1]))
        for row in range(3):
            query = row * 1024 * 16
            pair = next(((a, b) for a, b in zip(knots, knots[1:]) if a[0] <= query <= b[0]), None)
            if pair is None:
                raise ValueError('vertical remap exceeds one-knot extrapolation')
            a, b = pair
            value = _trunc_div((b[0] - query) * a[1] + (query - a[0]) * b[1], b[0] - a[0])
            if not -32768 <= value <= 32767:
                raise ValueError('remapped X displacement exceeds signed16')
            result[row * 3 + col] = (value, grid[row * 3 + col][1])
    return tuple(result)


def two_stage_displacement(config: MeshConfig, correction: list[float] | tuple[float, ...], x: float, y: float, component: int) -> float:
    if component == 1:
        return source_point(config, correction, x, y)[1] - y
    pitch, _, roll = correction
    a, c, s = 1 - config.crop_margin, math.cos(roll), math.sin(roll)
    # Stock remap samples dx at the inverse Y of the un-remapped affine map.
    old_y = config.height / 2 + (y - config.height / 2 - s * a * (x - config.width / 2) - pitch * config.focal_length_px) / (c * a)
    return source_point(config, correction, x, old_y)[0] - x


def interpolate_q4(calibration: StockAffineCalibration, x: int, y: int, component: int) -> int:
    """Exact signed-truncating two-stage interpolation from original ARM ABI."""
    values = remapped_grid(calibration)
    col, fx = divmod(x, 1024)
    row, fy = divmod(y, 1024)
    if not 0 <= col < 2 or not 0 <= row < 2 or component not in (0, 1):
        raise ValueError('query outside the reviewed calibration cells')
    a, b = values[row * 3 + col][component], values[row * 3 + col + 1][component]
    c, d = values[(row + 1) * 3 + col][component], values[(row + 1) * 3 + col + 1][component]
    ab = _s16(a + _trunc_div(fx * (b - a), 1024))
    cd = _s16(c + _trunc_div(fx * (d - c), 1024))
    return _s16(ab + _trunc_div(fy * (cd - ab), 1024))
