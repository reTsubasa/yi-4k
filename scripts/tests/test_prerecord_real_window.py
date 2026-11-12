"""Regression for a real archive's nonzero ring selection and terminal AAC."""
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from prerecord_replay import replay, FFPROBE
from validate_prerecord_packet_fidelity import validate

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / 'artifacts/device/2026-11-11-prerecord-real-65s/YDXJ0165.MP4'


@unittest.skipUnless(SOURCE.is_file(), 'retained ordinary camera archive required')
class RealWindowTests(unittest.TestCase):
    def test_nonzero_sixty_second_selection_preserves_full_terminal_aac(self):
        with tempfile.TemporaryDirectory(prefix='yi4k-real-window-') as tmp:
            output = Path(tmp) / 'replay'
            result = replay(SOURCE, output, 63_000_000, 64_000_000)
            self.assertTrue(result['full_window_available'])
            self.assertGreater(result['selected_start_us'], 0)
            self.assertTrue(result['evicted'])
            gate = validate(output / 'manifest.json', Path(FFPROBE))
            self.assertTrue(gate['passed'])
            self.assertEqual(1856, gate['tracks']['video']['clip_packet_count'])
            self.assertEqual(2902, gate['tracks']['audio']['clip_packet_count'])
            self.assertEqual([{'video_source_packet': 64, 'audio_source_packet': 101,
                               'offset_min_seconds': '-2', 'offset_max_seconds': '-2'}],
                             gate['common_timestamp_offset_candidates'])
            for track in gate['tracks'].values():
                candidate = track['faithful_timing_candidates'][0]
                self.assertEqual('0', candidate['offset_spread_seconds'])
                self.assertEqual('0', candidate['max_duration_error_seconds'])


if __name__ == '__main__':
    unittest.main()
