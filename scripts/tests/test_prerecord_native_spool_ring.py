"""Host-only ownership/failure regressions, not encoded media or SD tests."""
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch
from fractions import Fraction

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
import prerecord_native_spool_ring as ring


class NativeSpoolRingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp=tempfile.TemporaryDirectory(prefix='yi4k-ring-unit-')
        cls.library,_=ring.compile_library(Path(cls.tmp.name))

    @classmethod
    def tearDownClass(cls):cls.tmp.cleanup()

    def setUp(self):
        self.temporary=tempfile.TemporaryDirectory(prefix='yi4k-ring-case-')
        self.root=Path(self.temporary.name)
        self.owner=ring.NativePacketRing(self.root,self.library,(b'configuration',b'aac'),[],10**6)

    def tearDown(self):
        self.owner.lib.close_files();self.temporary.cleanup()

    def test_real_repeated_trigger_keeps_first_time_and_source(self):
        self.owner.trigger('voice',Fraction(63))
        original=dict(self.owner.manifest['trigger'])
        self.owner.trigger('shutter',Fraction(64))
        self.assertEqual(self.owner.manifest['trigger'],original)
        self.assertEqual(len([e for e in self.owner.events if e['event']=='trigger_pin']),1)

    def test_checkpoint_reserves_temporary_manifest_bytes_before_write(self):
        before=(self.root/'ring.json').read_bytes()
        self.owner.budget=self.owner.owned_usage()+10
        self.owner.manifest['extra']='x'*1000
        with self.assertRaises((OSError,RuntimeError)):
            self.owner.checkpoint()
        self.assertEqual((self.root/'ring.json').read_bytes(),before)
        self.assertFalse((self.root/'ring.json.new').exists())

    def test_missing_retained_file_rejection_still_writes_audit(self):
        self.owner.manifest.update(state='sealed_for_recovery',pinned=True,
                                  writer_pid=123456789,closed=[{'ledger':'missing','ledger_sha256':'00'*32,
                                  'spool':'missing.spool','spool_sha256':'00'*32,
                                  'seal':'missing.seal','seal_sha256':'00'*32}])
        self.owner.checkpoint()
        import argparse
        args=argparse.Namespace(input=self.root,output=self.root/'export',fail_close=False,
                               interrupt_after_mux=False,reader=Path('unused'))
        def fail_with_recorded_missing(*_):
            raise RuntimeError('simulated missing retained file')
        with patch.object(ring,'scan_owned',side_effect=fail_with_recorded_missing):
            result=ring.export_retained(args)
        self.assertFalse(result['published'])
        self.assertFalse(result['retained_inputs_unchanged'])
        self.assertTrue((args.output/'audit.json').exists())
        self.assertEqual(json.loads((args.output/'audit.json').read_text())['status'],'rejected_retained_for_recovery')

    def test_missing_file_during_final_identity_check_is_reported(self):
        result=ring.retained_hashes([{'path':str(self.root/'missing.spool'),'sha256':'00'*32}])
        self.assertFalse(result[0]['matches'])
        self.assertIn('error',result[0])

    def test_eviction_uses_arrived_packet_start_not_previous_packet_end(self):
        def packet(st,pts,duration):
            return dict(stream=st,index=0,pts=pts,dts=pts,duration=duration,data=b'payload',
                        key=st==0,native_segment=1,native_index=0)
        self.owner.append(packet(1,47040,1024),1)  # AAC .98s ->1.001333s
        self.owner.append(packet(0,29700,1001),1)  # video .99s ->1.023366s
        with patch.object(self.owner,'evict') as evict:
            self.owner.append(packet(1,48064,1024),2)  # observed 1.001333s
        evict.assert_called_once_with(Fraction(48064,48000))

    def test_post_rename_sync_failure_retains_visible_final_for_review(self):
        pending=self.root/'candidate.pending';final=self.root/'clip.mp4'
        pending.write_bytes(b'complete candidate')
        with patch.object(ring,'sync_directory',side_effect=OSError('injected directory sync')):
            with self.assertRaises(OSError):ring.publish_candidate(pending,final)
        self.assertEqual(final.read_bytes(),b'complete candidate')
        self.assertFalse(pending.exists())


if __name__=='__main__':unittest.main()
