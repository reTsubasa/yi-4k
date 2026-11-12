"""Host trigger contract tests; no camera or microphone access."""
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from prerecord_trigger import CameraEvent, CameraEventType, Decision, PreRecordTriggerRouter, ShutterAction, TriggerSource


class TriggerRouterTests(unittest.TestCase):
    def test_typed_camera_start_recording_event_is_canonical_input(self):
        router = PreRecordTriggerRouter()
        result = router.on_camera_event(CameraEvent(CameraEventType.START_RECORDING, 10_000))
        self.assertTrue(result.accepted)
        self.assertEqual(TriggerSource.CAMERA_VOICE, result.source)
        self.assertIsNone(result.phrase)
        self.assertEqual(Decision.DUPLICATE, router.on_camera_event(
            CameraEvent(CameraEventType.START_RECORDING, 11_000)).decision)

    def test_unknown_typed_camera_event_is_rejected(self):
        router = PreRecordTriggerRouter()
        result = router.on_camera_event(CameraEvent("stop_recording", 10))
        self.assertEqual(Decision.INVALID_EVENT, result.decision)
        self.assertFalse(router.started)

    def test_exact_voice_phrases_accept_once(self):
        # Synthetic fixture adapter: firmware recognition is outside this module.
        router = PreRecordTriggerRouter()
        result = router.on_camera_voice_event("开始录像", 10_000)
        self.assertTrue(result.accepted)
        self.assertEqual(TriggerSource.CAMERA_VOICE, result.source)
        self.assertEqual(10_000, result.at_us)
        self.assertEqual(Decision.DUPLICATE, router.on_camera_voice_event("start recording", 11_000).decision)

    def test_voice_normalization_matches_android_and_still_rejects_near_misses(self):
        # Android uses NFKC, lowercase, trim, punctuation-to-space, and
        # whitespace collapse before comparing the complete phrase.
        for phrase in ("Start recording", " start   recording! ", "ＳＴＡＲＴ　ＲＥＣＯＲＤＩＮＧ。", "开始录像。"):
            result = PreRecordTriggerRouter().on_camera_voice_event(phrase, 10)
            self.assertEqual(Decision.ACCEPTED, result.decision, phrase)
        for phrase in ("please start recording", "start recording now", "开始 录像"):
            result = PreRecordTriggerRouter().on_camera_voice_event(phrase, 10)
            self.assertEqual(Decision.PHRASE_MISMATCH, result.decision, phrase)

    def test_invalid_voice_cannot_start(self):
        router = PreRecordTriggerRouter()
        self.assertEqual(Decision.PHRASE_MISMATCH, router.on_camera_voice_event("录像", 10).decision)
        self.assertFalse(router.started)
        self.assertEqual(Decision.ACCEPTED, router.on_camera_voice_event("start recording", 20).decision)

    def test_shutter_press_is_same_idempotent_start(self):
        router = PreRecordTriggerRouter()
        self.assertEqual(Decision.ACCEPTED, router.on_shutter(30).decision)
        self.assertEqual(Decision.DUPLICATE, router.on_shutter(31).decision)
        self.assertEqual(Decision.DUPLICATE, router.on_camera_voice_event("开始录像", 32).decision)

    def test_shutter_release_and_bad_time_are_rejected(self):
        router = PreRecordTriggerRouter()
        self.assertEqual(Decision.INVALID_EVENT, router.on_shutter(30, "release").decision)
        self.assertEqual(Decision.INVALID_EVENT, router.on_shutter(-1).decision)
        self.assertEqual(Decision.INVALID_EVENT, router.on_camera_voice_event("开始录像", -1).decision)
        self.assertFalse(router.started)

    def test_reset_allows_one_new_start_and_increments_generation(self):
        router = PreRecordTriggerRouter()
        self.assertEqual(Decision.ACCEPTED, router.on_shutter(30).decision)
        self.assertEqual(0, router.generation)
        router.reset()
        self.assertEqual(1, router.generation)
        self.assertEqual(Decision.ACCEPTED, router.on_camera_voice_event("start recording", 100).decision)

    def test_nfkc_equivalent_text_is_still_the_same_complete_phrase(self):
        router = PreRecordTriggerRouter()
        # Full-width ASCII is folded by NFKC, as in Android's normalizer.
        self.assertEqual(Decision.ACCEPTED, router.on_camera_voice_event("ＳＴＡＲＴ　ＲＥＣＯＲＤＩＮＧ", 1).decision)

    def test_custom_phrase_cannot_normalize_to_empty_text(self):
        with self.assertRaises(ValueError):
            PreRecordTriggerRouter(phrases=frozenset(("!!!",)))


if __name__ == "__main__":
    unittest.main()
