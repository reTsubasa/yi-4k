#!/usr/bin/env python3
"""Reproduce original ARM edit constructor and fixed ordinary-consumer endpoint.

No native code patch, device IO, or replacement of the strict consumer gate.
FFmpeg upstream source is retained for formula evidence, not a claim that its
source hash authenticates the local tessus binary build configuration.
"""
import argparse
from fractions import Fraction
import hashlib
import json
from pathlib import Path
from unicorn.arm_const import *
import audit_prerecord_session_timeline as timeline
import audit_prerecord_minute_aac_schedule as schedule

def sha(data): return hashlib.sha256(data).hexdigest()
def require(test,message):
    if not test: raise RuntimeError(message)

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output',type=Path,required=True)
    p.add_argument('--consumer-source',type=Path,required=True)
    args=p.parse_args();args.output.mkdir(exist_ok=True,parents=True)
    image=timeline.life.arm.IMAGE.read_bytes();require(sha(image)==timeline.life.arm.DIGEST,'firmware hash differs')
    # Synthetic states equal the archived second segment after stock Reset:
    # common240000 ticks; video start1600, final962560; media length960960.
    m=timeline.Machine(image);dest,track,movie=0x1000c000,0x1000d000,0x10000000
    m.put(track+4,240000);m.put(track+0x18,1600,8);m.put(track+0x28,962560,8);m.put(movie+0x330,0,1)
    m.uc.reg_write(UC_ARM_REG_SP,timeline.life.arm.STACK);m.uc.reg_write(UC_ARM_REG_LR,timeline.life.arm.RETURN)
    for reg,value in zip((UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3),(dest,track,0,0)):m.uc.reg_write(reg,value)
    for i,value in enumerate((30000,1,movie)):m.put(timeline.life.arm.STACK+i*4,value)
    m.uc.emu_start(0xa0425e18,timeline.life.arm.RETURN,count=100000)
    require(m.uc.reg_read(UC_ARM_REG_PC)==timeline.life.arm.RETURN,'ARM did not return')
    edits=dict(entries=m.get(dest+0x14),empty_duration=m.get(dest+0x18,8),media_duration=m.get(dest+0x30,8),
               empty_media_time=m.get(dest+0x20,8),media_time=m.get(dest+0x38,8))
    require(edits==dict(entries=2,empty_duration=200,media_duration=120120,
        empty_media_time=(1<<64)-1,media_time=0),'native edit constructor output changed')
    folder=schedule.r.ROOT/'artifacts/verification/2026-11-11-prerecord-minute-aac-schedule-run01'
    path=folder/'native-segment-2.mp4';raw=path.read_bytes()
    normal=schedule.g.probe(path);bare=schedule.g.probe(path,True)
    v=[p for p in normal['packets'] if p['stream_index']==0];u=[p for p in bare['packets'] if p['stream_index']==0]
    require(int(v[0]['pts'])==200 and int(v[-1]['pts'])==119319 and int(v[-1]['duration'])==801,'ordinary consumer baseline changed')
    require(int(u[-1]['duration'])==1001,'STTS consumer reading changed')
    require(int(normal['streams'][0]['duration_ts'])==120120,'ordinary duration anchor changed')
    require(120120-119319==801 and 120120+200-119319==1001,'endpoint formula changed')
    source=args.consumer_source.read_text()
    needles=[
        'st->duration = FFMIN(st->duration, edit_list_dts_entry_end - start_dts);',
        'ffstream(st)->index_entries[sc->current_sample].timestamp : st->duration;',
        'pkt->duration = next_dts - pkt->dts;']
    evidence=[]
    for needle in needles:
        lines=[i for i,line in enumerate(source.splitlines(),1) if needle in line]
        require(lines,'consumer source formula absent');evidence.append(dict(text=needle,lines=lines))
    functions={f['entry']:f for f in json.loads((timeline.life.arm.EXPORT/'functions.json').read_text())}
    function=functions['0xa0425e18'];body=b''
    for span in function['body_ranges']:
        lo,hi=[int(x,16) for x in span.split('-')];body+=image[lo-0xa0100000:hi-0xa0100000+1]
    output=dict(status='pass_native_edit_constructor_and_consumer_endpoint_reproduction',offline_only=True,device_access=False,
        script_sha256=sha(Path(__file__).read_bytes()),firmware_sha256=sha(image),
        native_function=dict(entry='0xa0425e18',ranges=function['body_ranges'],arm_sha256=sha(body),
            decompiled_sha256=sha((timeline.life.arm.EXPORT/function['decompiled_file']).read_bytes())),
        synthetic_track=dict(common_clock=240000,start=1600,end=962560,movie_clock=30000),original_ARM_result=edits,
        archived_file=dict(path=str(path),sha256=sha(raw)),
        ordinary_consumer=dict(first_video_pts=200,last_video_pts=119319,last_video_duration=801,media_duration_ts=120120,
            exact_duration=1001,loss_ticks=200,loss_seconds='1/150',strict_gate='reject'),
        ignore_editlist_diagnostic=dict(last_video_duration=1001,used_as_publication_gate=False),
        consumer_source=dict(url='https://raw.githubusercontent.com/FFmpeg/FFmpeg/n6.1/libavformat/mov.c',
            sha256=sha(args.consumer_source.read_bytes()),formula_lines=evidence,
            binary_identity_is_separately_pinned=True,source_build_identity_not_authenticated=True),
        conclusion='Stock ARM emits self-consistent full media edit plus 200-tick empty edit. Fixed consumer reports final duration from unshifted st.duration minus edit-shifted final DTS, matching 801 ticks. Reordering AAC cannot erase actual source video delay; separate continuous final export retains common source chronology and has no nonzero empty edit.',
        no_gate_relaxation=True)
    (args.output/'audit.json').write_text(json.dumps(output,indent=2)+'\n');print(json.dumps(output,indent=2))
if __name__=='__main__':main()
