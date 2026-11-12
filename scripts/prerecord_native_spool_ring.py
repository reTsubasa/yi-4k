#!/usr/bin/env python3
"""Host archived-packet ring using the C spool/seal and original ARM final mux.

No live encoder, RTOS, hardware trigger, camera or physical SD binding. Ingest
uses closed native archive inputs; export in a new process uses retained spool
payload only. The original recording is opened later as a validation oracle.
"""
from __future__ import annotations
import argparse
import ctypes as C
from fractions import Fraction
import hashlib
import json
import os
from pathlib import Path
import platform
import shutil
import subprocess
import sys
import traceback

import export_prerecord_native_window_compact as compact
import validate_spool_seal as seal
from prerecord_trigger import CameraEvent, CameraEventType, Decision, PreRecordTriggerRouter

base, window, g, n = compact.base, compact.window, compact.g, compact.n
ROOT = base.ROOT
WRAPPER_EXTRA = r'''
typedef int32_t (*emit_sample)(uint64_t,uint32_t,uint32_t,uint64_t,uint32_t,uint32_t,uint32_t,const uint8_t *,uint32_t);
static emit_sample emit_callback;
static int32_t emit(void *context,uint64_t ordinal,const yi4k_spool_sample *v){
 (void)context;return emit_callback(ordinal,v->packet.source_kind,v->packet.descriptor.sequence,
 v->pts,v->scale,v->duration,v->packet.descriptor.type,v->packet.payload,v->packet.descriptor.payload_size);
}
int scan_values(const char *path,emit_sample callback,uint64_t *words){
 yi4k_spool_scan_result result;int r;active=0;p.fd=open(path,O_RDONLY);if(p.fd<0)return -90;
 emit_callback=callback;memset(&result,0,sizeof(result));
 r=yi4k_spool_scan(&pio,&request.identity,scratch,sizeof(scratch),emit,0,&result);
 words[0]=result.records;words[1]=result.committed_bytes;words[2]=result.file_bytes;
 words[3]=result.trailing_bytes;words[4]=result.corrupt;close_files();return r;
}
'''
CALLBACK = C.CFUNCTYPE(C.c_int32, seal.U64, seal.U32, seal.U32, seal.U64,
                      seal.U32, seal.U32, seal.U32, seal.PTR, seal.U32)


def digest(path):
    with Path(path).open('rb') as source:
        return hashlib.file_digest(source, 'sha256').hexdigest()


def sync_directory(path):
    fd = os.open(path, os.O_RDONLY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


def durable_json(path, value, *, replace=False):
    data = (json.dumps(value, sort_keys=True, indent=2) + '\n').encode()
    target = path.with_suffix(path.suffix + '.new') if replace else path
    with target.open('xb') as output:
        output.write(data); output.flush(); os.fsync(output.fileno())
    sync_directory(path.parent)
    if replace:
        target.replace(path); sync_directory(path.parent)
    base.require(path.read_bytes() == data, 'JSON readback changed')


def compile_library(output):
    wrapper = output / 'spool-ring-posix.c'
    wrapper.write_text(seal.WRAPPER + WRAPPER_EXTRA)
    library = output / 'spool-ring-posix.dylib'
    argv = [shutil.which('clang'), '-arch', platform.machine(), '-shared', '-fPIC',
            '-std=c11', '-O2', '-Wall', '-Wextra', '-Werror', '-fno-builtin',
            '-I' + str(ROOT / 'sdk'), str(wrapper),
            str(ROOT / 'sdk/yi4k_packet_spool.c'), str(ROOT / 'sdk/yi4k_spool_seal.c'),
            '-o', str(library)]
    result = subprocess.run(argv, capture_output=True, text=True)
    base.require(result.returncode == 0, result.stdout + result.stderr)
    return library, argv


def load_library(path):
    lib = seal.library(path)
    lib.scan_values.argtypes = [C.c_char_p, CALLBACK, C.POINTER(seal.U64)]
    lib.scan_values.restype = C.c_int
    return lib


def public(packet):
    return dict(kind=packet['stream'] + 1, sequence=packet['index'],
                pts=packet['pts'], dts=packet['dts'], scale=window.RATES[packet['stream']],
                duration=packet['duration'], type=8 if packet['stream'] else 1 if packet['key'] else 3,
                key=bool(packet['key']), bytes=len(packet['data']), sha256=n.sha(packet['data']),
                native_segment=packet['native_segment'], native_index=packet['native_index'])


def position(row):
    return Fraction(row['pts'], row['scale'])


def end(row):
    return Fraction(row['pts'] + row['duration'], row['scale'])


def decode_bytes(row):
    return bytes.fromhex(row)


def retained_hashes(inputs):
    checks=[]
    for row in inputs:
        try:
            actual=digest(row['path'])
            checks.append(dict(path=row['path'],matches=actual==row['sha256'],actual_sha256=actual))
        except OSError as error:
            checks.append(dict(path=row['path'],matches=False,error=str(error)))
    return checks


def publish_candidate(pending,final):
    base.require(not final.exists(),'final path exists')
    pending.rename(final)
    sync_directory(final.parent)


def scan_owned(lib, root, entry):
    ledger_path = root / entry['ledger']
    base.require(digest(ledger_path) == entry['ledger_sha256'], 'source ledger changed')
    ledger = json.loads(ledger_path.read_text())
    spool, sidecar = root / entry['spool'], root / entry['seal']
    base.require(digest(spool) == entry['spool_sha256'] and digest(sidecar) == entry['seal_sha256'],
                 'retained spool/seal changed')
    seal.configure(lib, ledger)
    words = (seal.U64 * 5)(); transcript = (C.c_ubyte * 32)()
    status = lib.verify(os.fsencode(spool), os.fsencode(sidecar), words, transcript)
    base.require(status == 0 and words[0] == 1 and words[1] == 2 and words[3] == len(ledger['records']),
                 'new C seal reader rejected coverage')
    rows = []; errors = []
    @CALLBACK
    def collect(ordinal, kind, sequence, pts, scale, duration, type_, payload, length):
        try:
            expected = ledger['records'][ordinal - 1]
            base.require((kind, sequence, pts, scale, duration, type_, length) ==
                         tuple(expected[k] for k in ('kind','sequence','pts','scale','duration','type','bytes')),
                         'C scan values differ from independent source ledger')
            data = C.string_at(payload, length)
            base.require(n.sha(data) == expected['sha256'], 'scan payload differs from accepted source')
            rows.append(dict(stream=kind-1, index=sequence, pts=pts, dts=pts, duration=duration,
                             data=data, key=expected['key'], sha256=expected['sha256'],
                             native_segment=expected['native_segment'], native_index=expected['native_index']))
            return 0
        except Exception as error:
            errors.append(str(error)); return -77
    scan_words = (seal.U64 * 5)()
    status = lib.scan_values(os.fsencode(spool), collect, scan_words)
    base.require(status == 0 and not errors and scan_words[0] == len(rows) == len(ledger['records'])
                 and scan_words[1] == scan_words[2] and not scan_words[3] and not scan_words[4],
                 'new C spool scanner rejected: ' + repr(errors))
    return rows, dict(segment=ledger['segment'], records=len(rows), reader_pid=os.getpid(),
                      transcript_sha256=bytes(transcript).hex(), scope=int(words[1]))


class NativePacketRing:
    """Serialized POSIX owner; exact clock metadata policy, immutable C segments."""
    def __init__(self, root, library, configuration, source_inputs, budget):
        self.root = root; self.lib = load_library(library); self.budget = budget
        self.closed = []; self.events = []; self.pinned = False; self.active = None
        self.router = PreRecordTriggerRouter()
        self.peak = 0
        self.config = tuple(configuration)
        cfg = b''.join(len(x).to_bytes(4, 'little') + x for x in configuration)
        self.cfg_digest = n.sha(cfg)
        self.manifest = dict(schema=1, state='prebuffering', writer_pid=os.getpid(),
                             configuration_hex=[x.hex() for x in configuration],
                             configuration_sha256=self.cfg_digest, budget_bytes=budget,
                             library=str(library.resolve()), library_sha256=digest(library),
                             input_receipts=source_inputs, live_encoder=False,
                             closed=self.closed, events=self.events, pinned=False)
        self.checkpoint()

    def checkpoint(self):
        self.manifest['closed'] = self.closed
        self.manifest['pinned'] = self.pinned
        # During exclusive temporary-file creation the old manifest coexists
        # with the replacement. Reserve its entire logical length before I/O.
        used=self.owned_usage()
        for _ in range(4):
            self.manifest['peak_observed_owned_bytes']=self.peak
            length=len((json.dumps(self.manifest,sort_keys=True,indent=2)+'\n').encode())
            updated=max(self.peak,used+length)
            if updated==self.peak:break
            self.peak=updated
        self.manifest['peak_observed_owned_bytes']=self.peak
        length=len((json.dumps(self.manifest,sort_keys=True,indent=2)+'\n').encode())
        base.require(used+length<=self.budget,'logical byte budget rejects checkpoint; retain old manifest')
        durable_json(self.root/'ring.json', self.manifest, replace=(self.root/'ring.json').exists())

    def owned_usage(self):
        return sum(path.stat().st_size for path in self.root.iterdir() if path.is_file())

    def append(self, packet, segment):
        if self.active is not None and self.active['segment'] != segment:
            self.finish_segment(Fraction(packet['pts'],window.RATES[packet['stream']]))
        if self.active is None:
            self.active = dict(session=1107, segment=segment, epoch=1,
                               config_digest=self.cfg_digest, closure_id=10000+segment, scope=2, records=[])
            self.spool = self.root/f'part-{segment:04d}.spool'
            self.sidecar = self.root/f'part-{segment:04d}.seal'
            seal.configure(self.lib, self.active)
            base.require(self.lib.create(os.fsencode(self.spool), os.fsencode(self.sidecar)) == 0,
                         'exclusive spool/sidecar creation failed')
        row = public(packet)
        base.require(self.owned_usage() + row['bytes'] + 184 <= self.budget,
                     'spool ring budget exhausted; files retained')
        memory = seal.buf(packet['data'])
        status = self.lib.add(row['kind'],row['sequence'],row['pts'],row['scale'],row['duration'],row['type'],memory,len(memory))
        C.memset(memory, 0xcc, len(memory))
        base.require(status == 0, 'C source coverage/spool append failed; freeze and retain')
        self.active['records'].append(row)
        self.peak = max(self.peak, self.owned_usage())

    def finish_segment(self, arrived_source_time=None):
        ledger = self.active
        base.require(ledger is not None, 'no active segment')
        ledger_path = self.root/f"part-{ledger['segment']:04d}.source.json"
        # Expected closure is accepted-source metadata, never reconstructed
        # from the file scanner or a surviving spool prefix.
        ledger_length=len((json.dumps(ledger,sort_keys=True,indent=2)+'\n').encode())
        base.require(self.owned_usage()+ledger_length+280<=self.budget,
                     'logical byte budget rejects source ledger/seal; retain spool')
        durable_json(ledger_path, ledger)
        seal.configure(self.lib, ledger)
        base.require(self.lib.finish(0) == 0, 'C independent-source seal failed')
        base.require(self.lib.close_files() == 0, 'POSIX close failed')
        entry = dict(segment=ledger['segment'], ledger=ledger_path.name,
                     ledger_sha256=digest(ledger_path), spool=self.spool.name,
                     spool_sha256=digest(self.spool), seal=self.sidecar.name,
                     seal_sha256=digest(self.sidecar), records=len(ledger['records']))
        rows, receipt = scan_owned(self.lib,self.root,entry)
        entry['closure'] = receipt
        self.closed.append(entry); self.active = None
        self.events.append(dict(event='sealed_and_new_reader_verified',segment=entry['segment'],records=len(rows)))
        # A packet end can extend beyond the current arrival/trigger clock.
        # Only an observed next packet's PTS is a valid rolling watermark.
        if arrived_source_time is not None:self.evict(arrived_source_time)
        self.peak = max(self.peak, self.owned_usage()); self.checkpoint()

    def evict(self, frontier):
        if self.pinned or frontier < 60:
            return
        metadata = [(entry,json.loads((self.root/entry['ledger']).read_text())['records']) for entry in self.closed]
        rows = [row for entry, group in metadata for row in group]
        keys = [row for row in rows if row['kind']==1 and row['key'] and position(row)<=frontier-60]
        if not keys:
            return
        key = keys[-1]
        audio = [row for row in rows if row['kind']==2 and position(row)<=position(key)<end(row)]
        base.require(len(audio)==1,'cannot establish whole AAC preceding rolling IDR')
        cutoff = min(position(key),position(audio[0]))
        for entry, group in metadata:
            if max(end(row) for row in group) > cutoff:
                break
            # Bind exact owned bytes before removal; checkpoint intent first.
            for field in ('ledger','spool','seal'):
                base.require(digest(self.root/entry[field])==entry[field+'_sha256'],'eviction identity changed')
            self.manifest['eviction_pending'] = entry; self.checkpoint()
            for field in ('spool','seal','ledger'):
                (self.root/entry[field]).unlink()
            sync_directory(self.root)
            self.closed.remove(entry)
            self.events.append(dict(event='evicted_owned_closed_segment',segment=entry['segment'],cutoff=compact.g.rational(cutoff)))
            self.manifest.pop('eviction_pending'); self.checkpoint()

    def trigger(self, source, at):
        router = self.router
        if source=='voice':
            result = router.on_camera_event(CameraEvent(CameraEventType.START_RECORDING,int(at*1_000_000)))
        else:
            result = router.on_shutter(int(at*1_000_000))
        if result.decision is Decision.DUPLICATE:
            self.events.append(dict(event='duplicate_START_ignored',source=source,at=compact.g.rational(at)))
            self.checkpoint();return result
        base.require(result.decision is Decision.ACCEPTED,'typed START rejected')
        self.pinned = True
        self.manifest['trigger'] = dict(source=source,at=compact.g.rational(at),decision=result.decision.value,
                                       binding='host typed event, not spoken recognition or physical GPIO')
        self.manifest['state'] = 'recording_pinned'
        self.events.append(dict(event='trigger_pin',source=source,at=compact.g.rational(at)))
        self.checkpoint()
        return result


def ingest(args):
    args.output.mkdir(parents=True, exist_ok=False)
    library, command = compile_library(args.output)
    source_report = {}
    packets, configuration = base.load_segments(args.input,source_report)
    folder = args.output/'spool'; folder.mkdir()
    owner = NativePacketRing(folder,library,configuration,source_report['inputs'],args.budget)
    count = 0
    try:
        for packet in packets:
            t = Fraction(packet['pts'],window.RATES[packet['stream']])
            if not owner.pinned and t >= args.start:
                owner.trigger(args.trigger,args.start)
                owner.trigger('shutter' if args.trigger=='voice' else 'voice',args.start)
            if t >= args.stop:
                continue
            owner.append(packet,int(t)+1)
            # Export is a different process and never receives these buffers.
            packet.pop('data'); count+=1
        base.require(owner.pinned,'trigger did not occur')
        owner.finish_segment()
        owner.manifest.update(state='sealed_for_recovery',start=compact.g.rational(args.start),stop=compact.g.rational(args.stop),
                              pretrigger=compact.g.rational(Fraction(60)),consumed_packets=count,
                              source_buffers_released_before_export=True,writer_stopped_by_serialized_host_loop=True)
        owner.checkpoint()
        report=dict(status='pass_archived_native_packets_to_C_spool_ring',device_access=False,
                    command=command,ring_manifest=str(folder/'ring.json'),ring_manifest_sha256=digest(folder/'ring.json'),
                    evicted_segments=[e['segment'] for e in owner.events if e['event']=='evicted_owned_closed_segment'],
                    retained_segments=len(owner.closed),consumed_packets=count,peak_owned_bytes=owner.peak,
                    final_owned_bytes=owner.owned_usage(),
                    limits=['Archive inputs decoded before host ingest; no real encoder producer, DMA lease, callback or throughput proof',
                            'Serialized host owner plus POSIX fsync; not physical SD power loss',
                            'Ring retains whole packet/GOP predecessor beyond60s; output and recovery copies are separate storage'])
    except Exception as error:
        owner.manifest.update(state='frozen_retained',error=str(error))
        try:owner.checkpoint()
        except Exception:pass  # Existing durable manifest and files remain; never exceed budget to report failure.
        raise
    finally:
        owner.lib.close_files()
    durable_json(args.output/'ingest.json',report)
    return report


def export_retained(args):
    args.output.mkdir(parents=True,exist_ok=False)
    report=dict(status='running',device_access=False,script_sha256=digest(__file__),published=False,
                input_scope='Only C spool/seal/accepted-source ledgers until candidate exists; original MP4 only subsequent oracle',
                source_used_as_mux_input=False,reader_pid=os.getpid(),inputs=[])
    try:
        manifest_path=args.input/'ring.json'
        record=json.loads(manifest_path.read_text())
        # Record the complete retained-file inventory before any recovery gate.
        # If the manifest or one of its files is missing/corrupt, the audit must
        # still expose that custody failure instead of reporting an empty (and
        # therefore vacuously unchanged) input set.
        for entry in record.get('closed', []):
            for field in ('ledger', 'spool', 'seal'):
                report['inputs'].append(dict(path=str(args.input/entry[field]),
                                             sha256=entry[field + '_sha256']))
        base.require(record['state']=='sealed_for_recovery' and record['pinned'] and not record.get('eviction_pending'),
                     'ring is not a complete pinned closed set')
        base.require(record['writer_pid']!=os.getpid(),'recovery must use new process')
        report['ring_manifest_sha256']=digest(manifest_path);report['writer_pid']=record['writer_pid']
        library=Path(record['library']);base.require(digest(library)==record['library_sha256'],'C reader library changed')
        lib=load_library(library);all_packets=[];report['C_readers']=[]
        for entry in record['closed']:
            rows,receipt=scan_owned(lib,args.input,entry)
            all_packets.extend(rows);report['C_readers'].append(receipt)
        all_packets.sort(key=lambda p:(Fraction(p['dts'],window.RATES[p['stream']]),p['stream']))
        selected,origin=window.select_window(all_packets,base.fraction(record['start']),base.fraction(record['stop']),Fraction(60),report)
        configuration=tuple(decode_bytes(x) for x in record['configuration_hex'])
        cfg=b''.join(len(x).to_bytes(4,'little')+x for x in configuration)
        base.require(n.sha(cfg)==record['configuration_sha256'],'codec configuration identity changed')
        geometry=compact.native_geometry(configuration,selected,report)
        compact.export(selected,configuration,origin,geometry,args.output,report,args.fail_close)
        pending=args.output/'session.pending.mp4'
        if args.interrupt_after_mux:
            report.update(status='interrupted_after_native_close_retained',error='injected process exit before publication')
            durable_json(args.output/'audit.json',report)
            os._exit(73)
        compact.validate(pending,selected,origin,args.output,report,args.reader.resolve(),
                         (ROOT/'.tools/ffmpeg8-host/ffprobe').resolve(),(ROOT/'.tools/ffmpeg8-host/ffmpeg').resolve())
        with pending.open('rb') as file:os.fsync(file.fileno())
        publish_candidate(pending,args.output/'clip.mp4')
        report.update(status='pass_C_spool_ring_original_ARM_export',published=True)
    except Exception as error:
        report.update(status='rejected_retained_for_recovery',error=str(error),traceback=traceback.format_exc())
        if (args.output/'clip.mp4').exists():
            report.update(status='publication_uncertain_final_retained',publication_uncertain=True,
                          final_path_present=True,published=False)
    report['retained_input_checks']=retained_hashes(report['inputs'])
    # An empty inventory cannot establish custody.  Keep rejection audits
    # conservative even when validation failed before the manifest exposed any
    # retained files.
    report['retained_inputs_unchanged']=bool(report['retained_input_checks']) and all(
        row['matches'] for row in report['retained_input_checks'])
    durable_json(args.output/'audit.json',report)
    return report


def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('action',choices=('ingest','export'))
    p.add_argument('--input',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--start',type=Fraction,default=Fraction(63));p.add_argument('--stop',type=Fraction,default=Fraction(64))
    p.add_argument('--trigger',choices=('voice','shutter'),default='voice');p.add_argument('--budget',type=int,default=400*1024*1024)
    p.add_argument('--reader',type=Path);p.add_argument('--interrupt-after-mux',action='store_true');p.add_argument('--fail-close',action='store_true')
    args=p.parse_args()
    base.require(args.stop>args.start>=60 and args.budget>0,'invalid window/budget')
    if args.action=='export':base.require(args.reader is not None,'AVFoundation control reader required')
    result=ingest(args) if args.action=='ingest' else export_retained(args)
    print(json.dumps({key:result.get(key) for key in ('status','published','error','evicted_segments','retained_segments')}),flush=True)
    return 2 if result.get('published') is False else 0


if __name__=='__main__':raise SystemExit(main())
