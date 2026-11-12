"""Bounded ABI adapter tests using original-generator archived outputs."""
import struct
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from audit_eis_candidate_archive import stock_views
from eis_stock_mesh_layout import PlaneLayout, layouts_from_descriptor, unpack_active, repack_active_host


class StockMeshLayoutTests(unittest.TestCase):
    def test_nine_original_generator_archives_round_trip(self):
        result = stock_views()
        self.assertEqual(9, result["case_count"])
        self.assertFalse(result["normalized_candidate_convertible"])

    def test_unknown_pitch_and_out_of_bounds_rectangle_rejected(self):
        with self.assertRaisesRegex(ValueError, "dimensions or pitch"):
            PlaneLayout(31, 36, 30, 0)
        with self.assertRaisesRegex(ValueError, "capacity"):
            PlaneLayout(128, 128, 128, 0)

    def test_short_descriptor_and_scratch_rejected(self):
        with self.assertRaisesRegex(ValueError, "descriptor"):
            layouts_from_descriptor(bytes(0x4f), x_pitch=32, y_pitch=32)
        layouts = (PlaneLayout(1, 1, 1, 0), PlaneLayout(1, 1, 1, 0x1800))
        with self.assertRaisesRegex(ValueError, "scratch"):
            unpack_active(bytes(0x2fff), layouts)

    def test_signed_extrema_round_trip_and_padding_remains_owned(self):
        layouts = (PlaneLayout(2, 1, 3, 0), PlaneLayout(2, 1, 4, 0x1800))
        source = bytes([0xa5]) * 0x3000
        values = ([-32768, 32767], [-1, 0])
        packed = repack_active_host(source, layouts, values)
        self.assertEqual(values, unpack_active(packed, layouts))
        self.assertEqual(struct.pack("<hh", -32768, 32767), packed[:4])
        self.assertEqual(source[4:0x1800], packed[4:0x1800])
        self.assertEqual(source[0x1804:], packed[0x1804:])

    def test_q16_values_cannot_be_silently_relabelled_stock_units(self):
        layouts = (PlaneLayout(1, 1, 1, 0), PlaneLayout(1, 1, 1, 0x1800))
        for invalid in (65536, 0.5, True):
            with self.assertRaisesRegex(ValueError, "signed int16"):
                repack_active_host(bytes(0x3000), layouts, ([invalid], [0]))
        with self.assertRaisesRegex(ValueError, "count"):
            repack_active_host(bytes(0x3000), layouts, ([], [0]))


if __name__ == "__main__":
    unittest.main()
