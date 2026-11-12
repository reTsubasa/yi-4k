#!/usr/bin/env python3
"""Read-only verifier for fields actually exposed by Android public media APIs.

No DTS / packet-duration claim. AAC oracle is independently restarted selected
source packets, not continuous whole-source PCM cropped after decoding.
"""
import argparse,hashlib,json,subprocess
from collections import Counter
from fractions import Fraction
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
SOURCE_SHA='7fd902023185c36555eac6709120ab197ef408f37b3b3bae9d0cac9e61067a9c'
CANDIDATE_SHA='cffc226da6e496cd6df8d4294c1d295c4bdefe7ece4efe289f597b7b85e3ee5a'
ORIGIN=Fraction(1096,375)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--run',type=Path,required=True);a=p.parse_args();folder=a.run.resolve()
 session=json.loads((folder/'session.json').read_text());source=json.loads((folder/'source.json').read_text());candidate=json.loads((folder/'candidate.json').read_text())
 assert session['status']=='completed_owned_android_consumer_runs' and session['emulator_stopped'] and session['inputs_unchanged']
 for row in session['inputs']+session['sources']:assert sha(row['path'])==row['sha256'],row
 assert session['inputs'][0]['sha256']==SOURCE_SHA and session['inputs'][1]['sha256']==CANDIDATE_SHA
 assert all(j['status']=='completed_platform_reads_and_decodes' for j in (source,candidate))
 oracle=ROOT/'.tools/ffmpeg-host/ffprobe';oracle_json=folder/'source-ffprobe.json'
 run=subprocess.run([str(oracle),'-v','error','-show_packets','-show_streams','-of','json',session['inputs'][0]['path']],capture_output=True,check=True,timeout=90)
 oracle_json.write_bytes(run.stdout);probe=json.loads(run.stdout)
 version=subprocess.run([str(oracle),'-version'],capture_output=True,check=True).stdout.decode().splitlines()[0]
 results=[]
 for st,(first,count) in enumerate(((88,1831),(137,2863))):
  original=source['tracks'][st];actual=candidate['tracks'][st];packets=actual['packets'];expected=original['packets'][first:first+count]
  assert original['kind']==actual['kind']==('video','audio')[st]
  assert len(packets)==len(expected)==count
  assert all((p['sha256'],p['bytes'])==(q['sha256'],q['bytes']) for p,q in zip(expected,packets))
  assert all(p['flags'] in (0,1) for p in packets+expected),'encrypted or unknown input flags'
  timing=[v for v in probe['packets'] if v['stream_index']==st];tb=Fraction(probe['streams'][st]['time_base'])
  assert len(timing)==original['count']==len(original['packets'])
  assert all(p['ptsUs']==int(Fraction(int(q['pts']))*tb*1000000) for p,q in zip(original['packets'],timing))
  selected=timing[first:first+count]
  assert all(p['ptsUs']==int((Fraction(int(q['pts']))*tb-ORIGIN)*1000000) for p,q in zip(packets,selected))
  decoded_source=source['decoded'][st];decoded=candidate['decoded'][st]
  assert decoded_source['firstInputIndex']==first and decoded['firstInputIndex']==0
  assert decoded_source['codec']==decoded['codec'] and decoded_source['fedInputs']==decoded['fedInputs']==count
  assert decoded_source['outputEOS'] and decoded['outputEOS'] and decoded['outputCount']==decoded_source['outputCount']==count
  assert [v['sha256'] for v in decoded['outputs']]==[v['sha256'] for v in decoded_source['outputs']]
  assert [v['ptsUs'] for v in decoded['outputs']]==[v['ptsUs'] for v in packets]
  end=Fraction(int(selected[-1]['pts'])+int(selected[-1]['duration']))*tb-ORIGIN
  row=dict(kind=actual['kind'],packets=count,first_source_index=first,last_source_index=first+count-1,
   compressed_payload_SHA_and_sizes_equal=True,all_PTS_match_source_common_offset_after_integer_microsecond_projection=True,
   first_PTS_us=packets[0]['ptsUs'],last_PTS_us=packets[-1]['ptsUs'],DTS_available=False,packet_duration_available=False,
   codec=decoded['codec'],decoded_outputs=count,all_decoded_active_pixel_or_PCM_buffer_SHA_equal_independent_source_segment=True,
   decoded_PTS_equal_extractor=True,track_format=actual['format'],
   source_oracle_expected_final_endpoint_seconds=float(end),track_format_duration_us=int(actual['format']['durationUs']))
  if st==0:
   assert int(actual['format']['width'])==1920 and int(actual['format']['height'])==1080
   assert all(v['width']==1920 and v['height']==1080 for v in decoded['outputs'])
   row['active_YUV_hashes_exclude_row_and_slice_padding']=True
  else:
   assert int(actual['format']['encoder-delay'])==0 and int(actual['format']['encoder-padding'])==0
   assert decoded['pcmBytes']==decoded_source['pcmBytes']==2863*1024*2*2
   assert decoded['pcmSHA256']==decoded_source['pcmSHA256']
   row.update(pcm_bytes=decoded['pcmBytes'],pcm_sha256=decoded['pcmSHA256'],sample_frames=decoded['pcmBytes']//4)
  results.append(row)
 # Device-side sha256sum records are checked independently of host input files.
 device_hashes=(folder/'device-input-sha256.txt').read_text()
 for row in session['inputs']:assert row['sha256'] in device_hashes
 review=dict(status='pass_android_available_fields_and_independent_segment_decode',offline_only=True,real_camera_access=False,
  simulated_device_serial=session['serial'],sdk=candidate['sdk'],fingerprint=candidate['fingerprint'],
  verifier_sha256=sha(__file__),inputs=session['inputs'],
  records=[dict(path=str(folder/name),sha256=sha(folder/name)) for name in ('session.json','source.json','candidate.json','device-input-sha256.txt','source-ffprobe.json')],
  sources=session['sources'],source_PTS_oracle=dict(binary=str(oracle),sha256=sha(oracle),version=version),
  common_source_offset=dict(numerator=ORIGIN.numerator,denominator=ORIGIN.denominator),tracks=results,
  audio_oracle='source MediaExtractor skips137 packets before a NEW decoder is created; feed2863 selected AAC. Candidate separately starts a NEW same decoder. Not continuous whole-source decoded PCM cropped to interval.',
  video_oracle='source MediaExtractor skips88 packets to preceding IDR before a NEW decoder; feed1831 selected video samples; candidate separately starts same decoder.',
  emulator_stopped=session['emulator_stopped'],inputs_unchanged=session['inputs_unchanged'],
  limitations=['MediaExtractor public API exposes integer microsecond PTS, not DTS or individual packet durations; this is not the full rational-time gate.',
   'Track format durationUs reflects media duration and is not independently established as complete edited presentation endpoint.',
   'MediaCodec ByteBuffer/Image full decode only; no Surface render, Media3 end-to-end playback, Android sound output, physical phone, camera trigger/SD or native deployment acceptance.',
   'Audio comparison uses independently restarted selected AAC; no claim of bit identity to continuous full-source PCM subset.',
   'Android AAC PCM SHA need not equal FFmpeg or AVFoundation decoder output; same implementation source/candidate comparison is used.',
   'Pinned emulator/API34 codec implementation only; old ffprobe6.1 and AVFoundation limitations remain separate.'])
 (folder/'review.json').write_text(json.dumps(review,indent=2)+'\n')
 print(json.dumps({'status':review['status'],'tracks':[(t['kind'],t['packets']) for t in results],'emulator_stopped':review['emulator_stopped']}))
if __name__=='__main__':main()
