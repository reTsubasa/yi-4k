#!/usr/bin/env python3
"""Independent local review and negative cases for native spool ring exports.

Does not contact devices, ingest an encoder or change original evidence. Small
negative views use hard links for immutable files and private changed copies.
"""
import argparse
from collections import Counter
from fractions import Fraction
import hashlib
import json
import os
from pathlib import Path
import shutil
import struct
import subprocess
import sys
import zlib

import prerecord_native_spool_ring as ring
import verify_prerecord_native_window_compact as independent

ROOT=ring.ROOT


def require(value,message):
    if not value:raise RuntimeError(message)


def digest(path):return ring.digest(path)


def load(path):return json.loads(path.read_text())


def inspect_ring(folder):
    record=load(folder/'ring.json')
    require(record['state']=='sealed_for_recovery' and record['pinned'],'ring not sealed and pinned')
    require(record['peak_observed_owned_bytes']<=record['budget_bytes'],'budget receipt exceeded')
    require(record['trigger']['decision']=='accepted' and len([e for e in record['events'] if e['event']=='trigger_pin'])==1
            and len([e for e in record['events'] if e['event']=='duplicate_START_ignored'])==1,'trigger route not idempotent')
    evicted=[e['segment'] for e in record['events'] if e['event']=='evicted_owned_closed_segment']
    require(evicted==[1],'unexpected retained window')
    require(all(not (folder/f'part-{number:04d}.{suffix}').exists() for number in evicted for suffix in ('spool','seal','source.json')),'evicted files remain')
    require(not record.get('eviction_pending'),'unfinished eviction')
    rows=[];file_pins=[]
    for entry in record['closed']:
        for field in ('ledger','spool','seal'):
            name=entry[field];require(Path(name).name==name and not (folder/name).is_symlink(),'unsafe identity')
            require(digest(folder/name)==entry[field+'_sha256'],'retained bytes changed')
            file_pins.append(dict(path=str(folder/name),sha256=entry[field+'_sha256']))
        ledger=load(folder/entry['ledger']);raw=(folder/entry['spool']).read_bytes();at=0
        # Independent header/CRC/identity/transcript comparison, no C scanner.
        for ordinal,expected in enumerate(ledger['records'],1):
            header=bytearray(raw[at:at+160]);require(len(header)==160,'short header')
            stored=struct.unpack_from('<I',header,148)[0];struct.pack_into('<I',header,148,0)
            require(zlib.crc32(header)==stored and header[:8]==b'YI4KPS01','header corrupt')
            require(struct.unpack_from('<QQQQ',header,16)==(ledger['session'],ledger['segment'],ledger['epoch'],ordinal),'identity/ordinal mismatch')
            require(bytes(header[112:144]).hex()==ledger['config_digest']==record['configuration_sha256'],'config identity changed')
            kind,scale=struct.unpack_from('<II',header,48);dts,pts=struct.unpack_from('<QQ',header,56)
            duration,length,sequence=struct.unpack_from('<III',header,72)
            require((kind,scale,dts,pts,duration,length,sequence,header[96],header[97])==
                    tuple(expected[k] for k in ('kind','scale','dts','pts','duration','bytes','sequence','type'))+(1,),
                    'independent metadata mismatch')
            payload=raw[at+160:at+160+length];marker=raw[at+160+length:at+184+length]
            require(len(payload)==length and hashlib.sha256(payload).hexdigest()==expected['sha256'],'independent payload mismatch')
            require(zlib.crc32(payload)==struct.unpack_from('<I',header,144)[0],'payload CRC mismatch')
            require(marker[:8]==b'Y4KCOM01' and struct.unpack_from('<QI',marker,8)==(ordinal,stored)
                    and zlib.crc32(marker[:20])==struct.unpack_from('<I',marker,20)[0],'commit marker mismatch')
            rows.append(dict(stream=kind-1,index=sequence,pts=pts,dts=dts,duration=duration,data=payload,
                             sha256=expected['sha256'],key=expected['key'],native_segment=expected['native_segment']))
            at+=184+length
        require(at==len(raw),'unaccounted bytes')
    rows.sort(key=lambda row:(Fraction(row['pts'],ring.window.RATES[row['stream']]),row['stream']))
    return record,rows,file_pins


def negative_view(root,source,record,label):
    folder=root/label;folder.mkdir()
    for entry in record['closed']:
        for field in ('ledger','spool','seal'):os.link(source/entry[field],folder/entry[field])
    copied=json.loads(json.dumps(record))
    return folder,copied


def negative_export(args,folder,record,label):
    (folder/'ring.json').write_text(json.dumps(record))
    output=args.output/(label+'-rejected')
    argv=[sys.executable,str(ROOT/'scripts/prerecord_native_spool_ring.py'),'export',
          '--input',str(folder),'--output',str(output),'--reader',str(args.reader)]
    child=subprocess.run(argv,capture_output=True,text=True)
    report=load(output/'audit.json')
    require(child.returncode==2 and not report['published'] and not (output/'clip.mp4').exists(),label+' published')
    require('native_execution' not in report and not (output/'session.pending.mp4').exists(),label+' reached native Open')
    return dict(case=label,exit_code=child.returncode,error=report['error'],native_Open_reached=False,
                report=str(output/'audit.json'),report_sha256=digest(output/'audit.json'))


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    for name in ('voice','shutter','recovered','shutter-export','interrupted','close-failure','reader','output'):
        parser.add_argument('--'+name,type=Path,required=True)
    args=parser.parse_args();args.output.mkdir(parents=True,exist_ok=False)
    evidence={};packets={};pins=[]
    for label in ('voice','shutter'):
        record,rows,files=inspect_ring(getattr(args,label)/'spool')
        ingest=load(getattr(args,label)/'ingest.json')
        require(digest(getattr(args,label)/'spool/ring.json')==ingest['ring_manifest_sha256'],'ingest receipt changed')
        require(record['trigger']['source']==label and ingest['consumed_packets']==4919,'wrong fixture/source')
        evidence[label]=record;packets[label]=rows;pins.extend(files)
    accepted={}
    for label,name in (('voice','recovered'),('shutter','shutter_export')):
        folder=getattr(args,name);report=load(folder/'audit.json');output=folder/'clip.mp4'
        require(report['published'] and report['status']=='pass_C_spool_ring_original_ARM_export','export did not publish')
        require(report['reader_pid']!=evidence[label]['writer_pid'] and report['writer_pid']==evidence[label]['writer_pid'],'not new reader process')
        require(report['retained_inputs_unchanged'] and not report['source_used_as_mux_input'],'input ownership failed')
        require(report['script_sha256']==digest(ROOT/'scripts/prerecord_native_spool_ring.py'),'executed source changed')
        require(digest(output)==report['output_sha256'],'export bytes changed')
        selected,origin=independent.expected_selection(packets[label],Fraction(63),Fraction(64),Fraction(60))
        raw=output.read_bytes();probe=independent.probe(output,ROOT/'.tools/ffmpeg8-host/ffprobe')
        actual=ring.g.packets(probe,raw)
        gate=ring.compact.r.comparison(actual,selected,probe['streams'],origin)
        require(gate['status']=='pass','independent exact spool-to-MP4 gate rejected')
        require(Counter(row['stream'] for row in selected)=={0:1831,1:2863},'selected counts changed')
        require(not report['native_execution']['caller_metadata_adapter'],'metadata adapter used')
        require(report['decode']['ffmpeg8_video_matches_source'] and report['decode']['ffmpeg8_audio_matches_whole_aac'],'complete decode failed')
        require(report['ordinary_ffprobe61_gate']['status']=='reject' and report['ordinary_avfoundation_output_gate']['status']=='reject','consumer limits erased')
        known=ROOT/'artifacts/verification/2026-11-12-prerecord-native-window-compact-run02/compact.ffmpeg8-reviewed.mp4'
        require(digest(output)==digest(known),'same selected source produced changed native output')
        accepted[label]=dict(sha256=digest(output),bytes=output.stat().st_size,packets=dict(Counter(row['stream'] for row in actual)),
                             common_origin=ring.g.rational(origin),C_readers=len(report['C_readers']),
                             complete_decode_receipt=True,independently_decoded_previous_output_byte_identical=True)
    require(accepted['voice']['sha256']==accepted['shutter']['sha256'],'trigger routes differ')
    for name in ('interrupted','close_failure'):
        folder=getattr(args,name);report=load(folder/'audit.json')
        require(not report['published'] and (folder/'session.pending.mp4').exists() and not (folder/'clip.mp4').exists(),'failed output custody lost')
        if name=='close_failure':require(report['native_execution']['close_status']==-12,'short-close fault not reached')
        else:require(report['status']=='interrupted_after_native_close_retained','process-exit point changed')
        require(report['script_sha256']==digest(ROOT/'scripts/prerecord_native_spool_ring.py'),'failure executed source changed')
    require(digest(args.interrupted/'session.pending.mp4')==accepted['voice']['sha256'],'fresh recovery changed complete prepublish candidate')
    negative=[];record=evidence['voice'];source=args.voice/'spool'
    folder,copy=negative_view(args.output,source,record,'unpinned')
    copy['pinned']=False;negative.append(negative_export(args,folder,copy,'unpinned'))
    folder,copy=negative_view(args.output,source,record,'truncated-boundary')
    entry=copy['closed'][1];path=folder/entry['spool'];raw=path.read_bytes();path.unlink()
    length=struct.unpack_from('<I',raw,76)[0];path.write_bytes(raw[:184+length])
    entry['spool_sha256']=digest(path) # rebind outer hash so C seal sees the incomplete coverage
    negative.append(negative_export(args,folder,copy,'truncated-boundary'))
    require('C seal reader rejected' in negative[-1]['error'],'C full-coverage check was bypassed')
    folder,copy=negative_view(args.output,source,record,'crc-repaired-payload')
    entry=copy['closed'][1];path=folder/entry['spool'];raw=bytearray(path.read_bytes());path.unlink()
    length=struct.unpack_from('<I',raw,76)[0];raw[160]^=1
    struct.pack_into('<I',raw,144,zlib.crc32(raw[160:160+length]));struct.pack_into('<I',raw,148,0)
    crc=zlib.crc32(raw[:160]);struct.pack_into('<I',raw,148,crc)
    struct.pack_into('<I',raw,160+length+16,crc)
    struct.pack_into('<I',raw,160+length+20,zlib.crc32(raw[160+length:160+length+20]))
    path.write_bytes(raw);entry['spool_sha256']=digest(path)
    negative.append(negative_export(args,folder,copy,'crc-repaired-payload'))
    require('C seal reader rejected' in negative[-1]['error'],'C SHA transcript did not reject repaired CRC payload')
    for row in pins:require(digest(row['path'])==row['sha256'],'original retained input mutated')
    result=dict(status='pass_independent_C_spool_ring_native_export_review',device_access=False,
                verifier_sha256=digest(__file__),accepted=accepted,negative=negative,
                retained_file_checks=len(pins),source_spools_unchanged=True,
                limits=['Archive replay and host typed triggers only; not realtime FIFO/RTOS/physical SD',
                        'C closure request comes from host accepted-source ledger, not actual callback-stop proof',
                        'POSIX process-exit/short-Close recovery; not camera loss-of-power acceptance',
                        'New positive files fully decoded by exporter; independent review checks exact packet/timing and byte identity to previously independently decoded candidate',
                        'No Android/player UI or new physical camera acceptance in this experiment'])
    ring.durable_json(args.output/'review.json',result)
    print(json.dumps(dict(status=result['status'],accepted=list(accepted),negative=len(negative))))


if __name__=='__main__':main()
