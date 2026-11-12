import struct
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from prerecord_frame_desc import (EndOfStream, FrameDesc, FRAME_DESC_EOS_SIZE, OwnedFrame,
                                  RAW_BITS_INFO_EOS_SIZE, VirtualPayloadConsumer, VirtualQueue,
                                  decode_descriptor, encode_descriptor, validate_sequence)


class FrameDescTests(unittest.TestCase):
    def test_layout_round_trip_and_unknown_types_remain_opaque(self):
        entry = FrameDesc(17, 0x123456789ABCDEF0, 8, 0xA5, 0xA1234000, 0x2345, 0xDEADBEEF)
        raw = encode_descriptor(entry)
        self.assertEqual(0x20, len(raw))
        self.assertEqual(entry, decode_descriptor(raw))
        self.assertEqual("opaque", decode_descriptor(raw).mux_hint)

    def test_type_one_is_only_static_mux_hint(self):
        entry = FrameDesc(1, 2, 1, 0, 3, 4, 5)
        decoded = decode_descriptor(encode_descriptor(entry))
        self.assertEqual("sync_or_random_access", decoded.mux_hint)
        self.assertTrue(decoded.is_sync_candidate)
        self.assertFalse(decoded.is_end_of_stream)
        for value in (0, 2, 3, 8, 255):
            decoded = decode_descriptor(encode_descriptor(FrameDesc(1, 2, value, 0, 3, 4, 5)))
            self.assertEqual("opaque", decoded.mux_hint)
            self.assertFalse(decoded.is_sync_candidate)

    def test_end_markers_override_type_one_and_preserve_descriptor_metadata(self):
        self.assertEqual(0x00FFFFFF, FRAME_DESC_EOS_SIZE)
        self.assertEqual(0xFFFFFFFF, RAW_BITS_INFO_EOS_SIZE)
        for size in (FRAME_DESC_EOS_SIZE, RAW_BITS_INFO_EOS_SIZE):
            for frame_type in (0, 1, 2, 255):
                with self.subTest(size=hex(size), frame_type=frame_type):
                    entry = FrameDesc(17, 0x123456789ABCDEF0, frame_type, 0xFF,
                                      0xFFFFFFFF, size, 0xDEADBEEF)
                    decoded = decode_descriptor(encode_descriptor(entry))
                    self.assertEqual(entry, decoded)
                    self.assertTrue(decoded.is_end_of_stream)
                    self.assertFalse(decoded.is_sync_candidate)
                    self.assertEqual("end_of_stream", decoded.mux_hint)
                    self.assertTrue(decoded.to_dict()["is_end_of_stream"])
                    self.assertFalse(decoded.to_dict()["is_sync_candidate"])

    def test_end_notification_precedes_payload_limit_and_reader_without_advancing(self):
        for size in (FRAME_DESC_EOS_SIZE, RAW_BITS_INFO_EOS_SIZE):
            with self.subTest(size=hex(size)):
                end = FrameDesc(7, 99, 1, 1, 0xFFFFFFFF, size, 0xFFFFFFFF)
                next_frame = FrameDesc(8, 100, 2, 1, 0x2000, 4, 0)
                queue = VirtualQueue()
                queue.append(end)
                queue.append(next_frame)
                consumer = VirtualPayloadConsumer(queue, max_payload_size=1)

                def forbidden_reader(_):
                    self.fail("EOS must not call a payload reader, including invalid EOS addresses")

                for _ in range(2):
                    result = consumer.consume_one(forbidden_reader)
                    self.assertIsInstance(result, EndOfStream)
                    self.assertNotIsInstance(result, OwnedFrame)
                    self.assertIs(end, result.descriptor)
                    self.assertFalse(hasattr(result, "payload"))
                    self.assertIs(end, queue.peek())
                    self.assertEqual(2, len(queue))

    def test_owner_explicitly_removes_end_marker_before_following_normal_payload(self):
        end = FrameDesc(7, 99, 1, 1, 0xFFFFFFFF, FRAME_DESC_EOS_SIZE, 0)
        next_frame = FrameDesc(8, 100, 1, 1, 0x2000, 4, 0)
        queue = VirtualQueue()
        queue.append(end)
        queue.append(next_frame)
        consumer = VirtualPayloadConsumer(queue, max_payload_size=4)
        reads = []
        reader = lambda descriptor: reads.append(descriptor) or b"ABCD"
        self.assertIsInstance(consumer.consume_one(reader), EndOfStream)
        self.assertEqual([], reads)
        # This models an explicit owner decision, not an implicit EOS ack.
        self.assertIs(end, queue.remove())
        self.assertEqual(OwnedFrame(next_frame, b"ABCD"), consumer.consume_one(reader))
        self.assertEqual([next_frame], reads)
        self.assertIsNone(consumer.consume_one(reader))

    def test_only_exact_end_lengths_bypass_normal_payload_bound(self):
        for size in (FRAME_DESC_EOS_SIZE - 1, FRAME_DESC_EOS_SIZE + 1,
                     RAW_BITS_INFO_EOS_SIZE - 1):
            with self.subTest(size=hex(size)):
                entry = FrameDesc(7, 99, 1, 1, 0x2000, size, 0)
                self.assertFalse(entry.is_end_of_stream)
                self.assertTrue(entry.is_sync_candidate)
                queue = VirtualQueue()
                queue.append(entry)
                consumer = VirtualPayloadConsumer(queue, max_payload_size=1)
                called = []
                with self.assertRaisesRegex(ValueError, "payload exceeds consumer bound"):
                    consumer.consume_one(lambda descriptor: called.append(True) or b"")
                self.assertEqual([], called)
                self.assertIs(entry, queue.peek())

    def test_sequence_and_queue_ownership(self):
        entries = [FrameDesc(i, i * 1000, 1, 0, 0x1000 + i, 5, 0) for i in range(3)]
        validate_sequence(entries)
        with self.assertRaises(ValueError):
            validate_sequence([entries[0], entries[0]])
        first, second = VirtualQueue(), VirtualQueue()
        for entry in entries:
            first.append(entry)
            second.append(entry)
        self.assertEqual(first.remove(), entries[0])
        self.assertEqual(len(first), 2)
        self.assertEqual(len(second), 3)
        with self.assertRaises(BufferError):
            tiny = VirtualQueue(1)
            tiny.append(entries[0])
            tiny.append(entries[1])

    def test_truncated_and_invalid_values_rejected(self):
        with self.assertRaises(ValueError):
            decode_descriptor(b"\0" * 31)
        with self.assertRaises(ValueError):
            encode_descriptor(FrameDesc(1, 2, 3, 4, 5, -1, 6))

    def test_timestamp_and_payload_bounds_round_trip_without_truncation(self):
        entry = FrameDesc(0xFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0xFF, 0xFF,
                          0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF)
        self.assertEqual(entry, decode_descriptor(encode_descriptor(entry)))

    def test_empty_virtual_queue_remove_is_explicit_and_non_destructive(self):
        queue = VirtualQueue()
        with self.assertRaises(IndexError):
            queue.remove()
        self.assertEqual(0, len(queue))

    def test_payload_is_copied_before_cursor_advances(self):
        entry = FrameDesc(7, 99, 1, 0, 0x2000, 4, 0)
        queue = VirtualQueue()
        queue.append(entry)
        ring = bytearray(b"ABCD")
        consumer = VirtualPayloadConsumer(queue)
        owned = consumer.consume_one(lambda descriptor: ring)
        self.assertIsInstance(owned, OwnedFrame)
        self.assertEqual(b"ABCD", owned.payload)
        self.assertEqual(0, len(queue))
        ring[:] = b"WXYZ"
        self.assertEqual(b"ABCD", owned.payload)

    def test_failed_payload_copy_does_not_advance_cursor(self):
        entry = FrameDesc(8, 100, 2, 0, 0x3000, 5, 0)
        queue = VirtualQueue()
        queue.append(entry)
        consumer = VirtualPayloadConsumer(queue, max_payload_size=5)
        with self.assertRaises(ValueError):
            consumer.consume_one(lambda descriptor: b"shor")
        self.assertEqual(entry, queue.peek())
        with self.assertRaises(ValueError):
            consumer.consume_one(lambda descriptor: b"0123456789")
        self.assertEqual(entry, queue.peek())

    def test_payload_bound_is_checked_before_reader(self):
        entry = FrameDesc(9, 101, 2, 0, 0x4000, 6, 0)
        queue = VirtualQueue()
        queue.append(entry)
        consumer = VirtualPayloadConsumer(queue, max_payload_size=5)
        called = []
        with self.assertRaises(ValueError):
            consumer.consume_one(lambda descriptor: called.append(True) or b"012345")
        self.assertEqual([], called)
        self.assertEqual(entry, queue.peek())


if __name__ == "__main__":
    unittest.main()
