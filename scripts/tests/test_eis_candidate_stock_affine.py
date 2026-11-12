"""Input/coordinate failure boundaries for the offline stock affine adapter."""
import math
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from eis_candidate_mesh import MeshConfig
from eis_candidate_stock_affine import candidate_calibration, interpolate_q4, remapped_grid, rotated_grid, source_point, two_stage_displacement


class StockAffineTests(unittest.TestCase):
    def setUp(self):
        self.config = MeshConfig(1920, 1080, crop_margin=0.12)

    def test_stationary_crop_has_exact_centered_signed_q4_control_nodes(self):
        c = candidate_calibration(self.config, [0., 0., 0.])
        self.assertEqual(c.grid_q4[0], (round(960 * 0.12 * 16), round(540 * 0.12 * 16)))
        self.assertEqual(len(c.grid_bytes()), 3 * 3 * 4)
        self.assertEqual(rotated_grid(c), c.grid_q4)
        self.assertEqual([p[1] for p in remapped_grid(c)], [p[1] for p in c.grid_q4])

    def test_remap_is_required_for_roll(self):
        c = candidate_calibration(self.config, [0.004, -0.007, 0.015])
        self.assertNotEqual(rotated_grid(c), remapped_grid(c))
        self.assertEqual([p[1] for p in remapped_grid(c)], [p[1] for p in rotated_grid(c)])
        ideal_dx = two_stage_displacement(self.config, [0.004,-0.007,0.015], 640, 320, 0)
        self.assertLess(abs(interpolate_q4(c, 640, 320, 0)/16 - ideal_dx), 0.25)

    def test_sign_and_translation_order_are_not_silently_changed(self):
        correction = [0.004, -0.007, 0.015]
        c = candidate_calibration(self.config, correction)
        self.assertEqual(c.stock_theta_radians, -correction[2])
        ideal = source_point(self.config, correction, 960, 540)
        self.assertAlmostEqual(ideal[0], 960 - correction[1] * 960)
        self.assertAlmostEqual(ideal[1], 540 + correction[0] * 960)

    def test_unknown_geometry_and_guard_support_are_rejected(self):
        with self.assertRaisesRegex(ValueError, '1920x1080'):
            candidate_calibration(MeshConfig(3840,2160), [0.,0.,0.])
        with self.assertRaisesRegex(ValueError, 'stock query'):
            candidate_calibration(MeshConfig(1920,1080,crop_margin=0.01), [0.,0.,0.])

    def test_nonfinite_and_out_of_bound_angles_are_rejected(self):
        for correction in ([float('nan'),0.,0.], [0.,float('inf'),0.], [True,0.,0.]):
            with self.assertRaisesRegex(ValueError, 'finite'):
                candidate_calibration(self.config, correction)
        with self.assertRaisesRegex(ValueError, 'bounded affine'):
            candidate_calibration(self.config, [0.,0.,0.2])

    def test_query_cannot_reach_an_unallocated_calibration_cell(self):
        c = candidate_calibration(self.config, [0.,0.,0.])
        for x,y,axis in [(2048,0,0),(-1,0,0),(0,2048,1),(0,0,2)]:
            with self.assertRaisesRegex(ValueError, 'outside'):
                interpolate_q4(c,x,y,axis)


if __name__ == '__main__':
    unittest.main()
