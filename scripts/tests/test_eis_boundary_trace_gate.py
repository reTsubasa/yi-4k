"""Offline tests for the stock-only A0384710 boundary trace gate."""
import hashlib
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from eis_boundary_trace_gate import evaluate, load_scalar_validation
from eis_filter_replay import Parameters, load_identity, stock_step
from verify_eis_boundary_trace_export import canonical_records, verify_envelope


ROOT = Path(__file__).resolve().parents[2]


def trace_payload(rows=2200):
    identity, defaults = load_identity()
    samples = []
    for sequence in range(rows):
        adaptive = sequence % 4 == 0
        count = (sequence // 4) % 6 if adaptive else 0
        current = 0 if adaptive else (100 if sequence % 5 else 1_000_000)
        previous = 1_000_000 if sequence % 10 == 0 else (sequence % 101) - 50
        limit = 50 if sequence % 10 == 0 else 1_000_000
        params = Parameters(
            limit=limit, gain=defaults["gain"], adaptive_enabled=adaptive,
            small_motion_degrees=defaults["small_motion_degrees"],
            scale_shift=defaults["scale_shift"],
            small_count_limit=defaults["small_count_limit"],
            adaptive_feedback=defaults["adaptive_feedback"],
            radians_numerator=defaults["radians_numerator"],
            radians_denominator=defaults["radians_denominator"],
        )
        output, count_after, _ = stock_step(previous, current, params, count)
        samples.append({
            "sequence": sequence, "site": 1 + sequence % 2, "mode": 2,
            "input": current, "previous_address": 0xA170B004 + sequence % 2 * 4,
            "previous": previous, "previous_after": previous,
            "previous_unchanged": True, "stock_invocations": 1,
            "observed_output": output, "tick_before": sequence * 2,
            "tick_after": sequence * 2, "count_before": count,
            "count_after": count_after, "limit": limit, "gain": defaults["gain"],
            "adaptive_enabled": adaptive,
            "small_motion_degrees": defaults["small_motion_degrees"],
            "scale_shift": defaults["scale_shift"],
            "small_count_limit": defaults["small_count_limit"],
            "adaptive_feedback": defaults["adaptive_feedback"],
        })
    return {
        "schema": "yi4k.eis-boundary-trace-gate/v1",
        "sample_kind": "caller captured scalar function-boundary trace",
        "target": {"sha256": identity["sha256"], "function": "0xA0384710"},
        "capture": {
            "source": "unit-test", "synthetic": False, "stock_only": True,
            "committed_contiguous": True, "previous_after_available": True,
            "record_bytes": 88, "dropped_records": 0, "busy_seen": False,
        },
        "samples": samples,
    }


class BoundaryTraceGateTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.identity, cls.defaults = load_identity()
        cls.scalar = load_scalar_validation(
            ROOT / "artifacts/device/2026-11-10-eis-filter-replay/validation.json",
            cls.identity,
        )

    def test_complete_stock_trace_passes(self):
        result = evaluate(trace_payload(), self.identity, self.defaults, self.scalar)
        self.assertTrue(result["replacement_gate"]["passed"])
        self.assertEqual(2200, result["validated_rows"])
        self.assertEqual(0, result["row_error_count"])

    def test_output_mismatch_blocks_gate(self):
        payload = trace_payload()
        payload["samples"][7]["observed_output"] += 1
        result = evaluate(payload, self.identity, self.defaults, self.scalar)
        self.assertFalse(result["replacement_gate"]["passed"])
        self.assertEqual(1, result["row_error_count"])

    def test_missing_previous_canary_blocks_gate(self):
        payload = trace_payload()
        payload["capture"]["previous_after_available"] = False
        result = evaluate(payload, self.identity, self.defaults, self.scalar)
        self.assertFalse(result["replacement_gate"]["passed"])
        self.assertIn("capture lacks the post-call previous canary",
                      result["replacement_gate"]["blockers"])

    def test_export_envelope_distinguishes_declared_real_stock_trace(self):
        payload = trace_payload()
        records = payload.pop("samples")
        for index, record in enumerate(records):
            record["commit"] = index + 1
        export = {
            "schema": "yi4k.eis-boundary-trace-export/v1",
            "evidence": {"kind": "real-stock-only", "synthetic": False,
                          "collector": "unit-test"},
            "target": payload["target"], "capture": payload["capture"],
            "export": {"format": "json-records-v1", "read_mode": "producer-quiescent",
                        "producer_quiescent": True, "committed_contiguous": True,
                        "record_capacity": 128, "record_bytes": 88,
                        "committed_count": len(records), "dropped_full": 0,
                        "records_sha256": hashlib.sha256(canonical_records(records)).hexdigest()},
            "records": records,
        }
        gate_payload, blockers = verify_envelope(export, self.identity)
        self.assertEqual([], blockers)
        result = evaluate(gate_payload, self.identity, self.defaults, self.scalar)
        self.assertTrue(result["replacement_gate"]["passed"])

    def test_synthetic_export_is_blocked_even_when_schema_is_valid(self):
        payload = trace_payload()
        records = payload.pop("samples")
        for index, record in enumerate(records):
            record["commit"] = index + 1
        export = {
            "schema": "yi4k.eis-boundary-trace-export/v1",
            "evidence": {"kind": "synthetic-test", "synthetic": True,
                          "collector": "unit-test"},
            "target": payload["target"], "capture": dict(payload["capture"], synthetic=True),
            "export": {"format": "json-records-v1", "read_mode": "producer-quiescent",
                        "producer_quiescent": True, "committed_contiguous": True,
                        "record_capacity": 128, "record_bytes": 88,
                        "committed_count": len(records), "dropped_full": 0,
                        "records_sha256": hashlib.sha256(canonical_records(records)).hexdigest()},
            "records": records,
        }
        gate_payload, blockers = verify_envelope(export, self.identity, allow_synthetic=True)
        self.assertEqual([], blockers)
        result = evaluate(gate_payload, self.identity, self.defaults, self.scalar)
        self.assertFalse(result["replacement_gate"]["passed"])
        self.assertIn("synthetic trace cannot pass the replacement gate",
                      result["replacement_gate"]["blockers"])

    def test_v1_80_byte_export_cannot_pass_without_a_v2_extension(self):
        payload = trace_payload()
        payload["capture"]["record_bytes"] = 80
        result = evaluate(payload, self.identity, self.defaults, self.scalar)
        self.assertFalse(result["replacement_gate"]["passed"])
        self.assertIn("v1 80B shadow records have no previous_after; they cannot pass the replacement gate",
                      result["replacement_gate"]["blockers"])


if __name__ == "__main__":
    unittest.main()
