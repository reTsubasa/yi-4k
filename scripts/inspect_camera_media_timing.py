#!/usr/bin/env python3
"""Inspect a saved original MP4 without decoding content or accessing a camera."""
import argparse
from collections import Counter
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import subprocess

ROOT=Path(__file__).resolve().parents[1]

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--ffprobe',type=Path,default=ROOT/'.tools/ffmpeg-host/ffprobe')
    args=parser.parse_args()
    if args.output.exists():raise RuntimeError('Output already exists; preserve prior evidence')
    command=[str(args.ffprobe.resolve()),'-v','error','-show_streams','-show_packets','-show_format','-of','json',str(args.input.resolve())]
    result=subprocess.run(command,capture_output=True,timeout=60,check=True)
    probe=json.loads(result.stdout);tracks=[]
    for stream in probe['streams']:
        packets=[p for p in probe['packets'] if p['stream_index']==stream['index']]
        fields=['index','codec_name','codec_type','sample_rate','channels','time_base','start_pts','duration_ts','nb_frames']
        track={k:stream[k] for k in fields if k in stream}
        track['packet_count']=len(packets)
        track['packet_duration_counts']=dict(Counter(str(p.get('duration')) for p in packets))
        pts=[int(p['pts']) for p in packets if 'pts' in p]
        dts=[int(p['dts']) for p in packets if 'dts' in p]
        track['first_pts']=pts[0] if pts else None;track['last_pts']=pts[-1] if pts else None
        track['dts_strictly_increasing']=all(b>a for a,b in zip(dts,dts[1:]))
        tb=Fraction(stream['time_base'])
        track['first_pts_seconds']=str(pts[0]*tb) if pts else None
        track['end_pts_seconds']=str(max(int(p['pts'])+int(p.get('duration',0)) for p in packets if 'pts' in p)*tb) if pts else None
        tracks.append(track)
    version=subprocess.run([str(args.ffprobe.resolve()),'-version'],capture_output=True,text=True,check=True).stdout.splitlines()[0]
    with args.input.open('rb') as source:
        digest=hashlib.file_digest(source,'sha256').hexdigest()
    report={'scope':'Host read-only inspection of previously saved original camera MP4; no camera access or new recording',
        'input':str(args.input),'input_sha256':digest,
        'size_bytes':args.input.stat().st_size,'probe_version':version,'probe_argv':command,
        'probe_json_sha256':hashlib.sha256(result.stdout).hexdigest(),'tracks':tracks,
        'limits':['Container timestamps, not raw capture hardware timestamps','No independent current camera-side digest collected in this run',
            'Both tracks starting at zero do not prove physical A/V capture alignment','No remux, edit, synthetic extension to 60 seconds or camera prerecord implementation']}
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'output':str(args.output),'tracks':tracks},ensure_ascii=False))

if __name__=='__main__':main()
