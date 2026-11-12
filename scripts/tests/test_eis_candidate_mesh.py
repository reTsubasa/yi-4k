"""Host tests for the offline EIS mesh replacement candidate."""
import copy
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from eis_candidate_mesh import validate_trace
from validate_eis_candidate_mesh import base_trace


class CandidateMeshTests(unittest.TestCase):
    def test_valid_trace_is_deterministic_and_bounded(self):
        payload = base_trace()
        first = validate_trace(payload)
        self.assertEqual(first, validate_trace(copy.deepcopy(payload)))
        self.assertEqual(4, first["frame_count"])
        self.assertTrue(first["gate"]["host_candidate_ready"])
        self.assertFalse(first["gate"]["stock_abi_compatible"])
        self.assertFalse(first["gate"]["replacement_deployment_ready"])

    def test_sequence_and_tick_must_increase(self):
        payload = base_trace()
        payload["samples"][2]["sequence"] = 1
        with self.assertRaisesRegex(ValueError, "sequence must strictly increase"):
            validate_trace(payload)
        payload = base_trace()
        payload["samples"][2]["tick_us"] = payload["samples"][1]["tick_us"]
        with self.assertRaisesRegex(ValueError, "tick_us must strictly increase"):
            validate_trace(payload)

    def test_units_rate_gap_and_nonfinite_values_are_rejected(self):
        payload = base_trace()
        payload["units"]["gyro"] = "raw_counts"
        with self.assertRaisesRegex(ValueError, "units must declare"):
            validate_trace(payload)
        payload = base_trace()
        payload["samples"][2]["gyro_dps"] = [721.0, 0.0, 0.0]
        with self.assertRaisesRegex(ValueError, "gyro rate exceeds"):
            validate_trace(payload)
        payload = base_trace()
        payload["samples"][2]["tick_us"] += 100001
        with self.assertRaisesRegex(ValueError, "sample gap exceeds"):
            validate_trace(payload)
        payload = base_trace()
        payload["samples"][2]["gyro_dps"] = [float("nan"), 0.0, 0.0]
        with self.assertRaisesRegex(ValueError, "must be finite"):
            validate_trace(payload)

    def test_mesh_dimensions_must_be_integer(self):
        payload = base_trace()
        payload["config"]["width"] = True
        with self.assertRaisesRegex(ValueError, "width and height must be integers"):
            validate_trace(payload)

    def test_crop_margin_is_fail_closed(self):
        payload = base_trace()
        payload["config"]["crop_margin"] = 0.01
        payload["samples"] = [
            {"sequence": i, "tick_us": i * 10000 + 1000,
             "gyro_dps": [0.0, 40.0, 0.0]} for i in range(40)
        ]
        with self.assertRaisesRegex(ValueError, "exceeds crop margin"):
            validate_trace(payload)


if __name__ == "__main__":
    unittest.main()
