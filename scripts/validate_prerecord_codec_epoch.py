#!/usr/bin/env python3
"""Offline codec binding/cache tests plus original ARM MP4/parser integration.

No device access. Configuration is extracted from an archived MP4 avcC/ASC,
not from a live encoder; file IO/RTOS allocator are explicit memory models.
"""
from __future__ import annotations
import argparse
import ctypes as ct
import hashlib
import io
import json
import platform
from pathlib import Path
import shutil
import struct
import subprocess
import tempfile
from elftools.elf.elffile import ELFFile
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM
from unicorn.arm_const import *
import audit_prerecord_owned_mux_writer as stock
import audit_prerecord_native_mp4 as native

ROOT=Path(__file__).resolve().parents[1]
DEFAULT=ROOT/'artifacts/device/2026-11-11-prerecord-codec-epoch'
SOURCE_FILES=[ROOT/'sdk/yi4k_1107_codec_epoch.c',ROOT/'sdk/offline/yi4k_codec_epoch_test.c']
HEADER=ROOT/'sdk/yi4k_1107_codec_epoch.h'
CASES=['valid_binding','missing_identity','missing_config_digest','sps_over_limit','pps_over_limit',
       'truncated_sps','pps_references_wrong_sps','invalid_emulation_prevention','asc_rate_mismatch',
       'asc_channel_mismatch','non_lc_aot','wrong_aac_frame_size','reserved_nonzero','exact_parameter_limits',
       'slice_before_config','slice_only_inject','inband_same_no_duplicate','ordinary_slice_no_injection',
       'partial_parameter_pair','duplicate_sps','fresh_non_idr','slice_wrong_pps','changed_sps','changed_pps',
       'trailing_empty_prefix','three_byte_prefix','forbidden_zero_bit','no_vcl','one_byte_short_output',
       'video_eos_blocks_video_not_audio','invalid_eos_not_committed','audio_eos_blocks_audio',
       'audio_over_limit','video_over_limit','source_output_alias','wrong_frame_identity',
       'exact_video_max','exact_audio_max','over_nal_count','truncated_slice','malformed_unescaped_rbsp',
       'exact_output_capacity','rebind_existing_epoch_rejected','identity_aliases_epoch_rejected',
       'identity_aliases_input_rejected','written_aliases_output_rejected','exact_nal_count',
       'asc_extension_flags_rejected','idr_with_p_slice_type_rejected']

class Config(ct.Structure):
    _fields_=[('identity',ct.c_uint8*32),('config_digest',ct.c_uint8*32),
              ('sps_size',ct.c_uint32),('pps_size',ct.c_uint32),('sample_rate',ct.c_uint32),
              ('channels',ct.c_uint32),('samples_per_aac',ct.c_uint32),
              ('sps',ct.c_uint8*64),('pps',ct.c_uint8*64),('asc',ct.c_uint8*2),('reserved',ct.c_uint8*2)]
class Epoch(ct.Structure):
    _fields_=[('magic',ct.c_uint32),('video_end',ct.c_uint32),('audio_end',ct.c_uint32),
              ('sps_id',ct.c_uint32),('pps_id',ct.c_uint32),('config',Config)]

def sha(data):return hashlib.sha256(data).hexdigest()
HARNESS_PATHS={name:ROOT/'scripts'/name for name in ('audit_prerecord_native_mp4.py','audit_prerecord_owned_mux_writer.py')}
IMPORTED_HARNESS_HASHES={name:sha(path.read_bytes()) for name,path in HARNESS_PATHS.items()}
def run(command):
    try:return subprocess.check_output(list(map(str,command)),stderr=subprocess.PIPE)
    except subprocess.CalledProcessError as error:raise RuntimeError(error.stderr.decode(errors='replace')) from error
def extradata(text):
    return b''.join(bytes.fromhex(line.split(':',1)[1].split('  ')[0].strip())
                    for line in text.splitlines() if ':' in line)
def avcc_parameters(blob):
    assert blob[0]==1 and blob[4]&3==3
    nsps=blob[5]&31;assert nsps==1
    size=int.from_bytes(blob[6:8],'big');sps=blob[8:8+size];pos=8+size
    assert blob[pos]==1;pos+=1;size=int.from_bytes(blob[pos:pos+2],'big');pos+=2
    pps=blob[pos:pos+size];assert pos+size==len(blob)
    return sps,pps
def load_sections(uc,elf):
    uc.mem_map(0x10030000,0x300000)
    for section in elf.iter_sections():
        if section['sh_flags']&2 and section['sh_size']:
            address,size=section['sh_addr'],section['sh_size']
            assert 0x10030000<=address<address+size<=0x10330000
            uc.mem_write(address,section.data() if section['sh_type']!='SHT_NOBITS' else bytes(size))

class CodecMachine(native.NativeMachine):
    def hook(self,uc,address,size,user):
        if 0x10030000<=address<0x10330000:return
        super().hook(uc,address,size,user)

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output-dir',type=Path,default=DEFAULT)
    output=parser.parse_args().output_dir.resolve();output.mkdir(parents=True,exist_ok=False)
    clang=shutil.which('clang');linkers=sorted(Path('/Users/hyc/Library/Android/sdk/ndk').glob('*/toolchains/llvm/prebuilt/*/bin/ld.lld'))
    linker=shutil.which('ld.lld') or str(linkers[-1]);assert clang and linker
    common=['-std=c11','-O2','-Wall','-Wextra','-Werror','-fno-builtin','-I'+str(ROOT/'sdk')]
    flags=['--target=armv7-none-eabi','-mcpu=cortex-a9','-marm','-mfloat-abi=soft','-mfpu=none',
           '-ffreestanding','-fno-stack-protector','-fno-pic','-fno-unwind-tables','-fno-asynchronous-unwind-tables',*common]
    commands=[];rows=[];integrations=[]
    def command(args):
        run(args);commands.append(list(map(str,args)))
    with tempfile.TemporaryDirectory(prefix='yi4k-codec-epoch-') as temporary:
        temp=Path(temporary);library_path=temp/'codec.dylib'
        host_arch=['-arch',platform.machine()] if platform.system()=='Darwin' else []
        command([clang,*host_arch,'-shared','-fPIC',*common,*SOURCE_FILES,'-o',library_path])
        objects=[]
        for source in SOURCE_FILES:
            obj=temp/(source.name+'.o');command([clang,*flags,'-c',source,'-o',obj]);objects.append(obj)
        script=temp/'codec.ld';script.write_text((ROOT/'sdk/offline/yi4k_payload_copy_emulation.ld').read_text().replace('ENTRY(yi4k_1107_copy_payload)','ENTRY(yi4k_codec_epoch_test)'))
        target=temp/'codec.elf';command([linker,'-T',script,*objects,'-o',target])
        elf_bytes=target.read_bytes();elf=ELFFile(io.BytesIO(elf_bytes));symbols=list(elf.get_section_by_name('.symtab').iter_symbols())
        assert not any(s.name and s['st_shndx']=='SHN_UNDEF' for s in symbols)
        assert not any(s['sh_type'] in ('SHT_REL','SHT_RELA') and s['sh_size'] for s in elf.iter_sections())
        functions={s.name:dict(address=s['st_value'],bytes=s['st_size']) for s in symbols if s['st_info']['type']=='STT_FUNC'}
        globals_={s.name:s['st_value'] for s in symbols if s['st_info']['type']=='STT_OBJECT'}
        library=ct.CDLL(str(library_path));test=library.yi4k_codec_epoch_test
        test.argtypes=[ct.c_uint32];test.restype=ct.c_int32
        report=(ct.c_uint32*8).in_dll(library,'yi4k_codec_epoch_test_report')
        for index,name in enumerate(CASES):
            status=test(index);assert status==0,(name,'host',status)
            host_report=list(report)
            uc=Uc(UC_ARCH_ARM,UC_MODE_ARM);load_sections(uc,elf);uc.mem_map(0x23000000,0x10000)
            uc.reg_write(UC_ARM_REG_CPSR,0x13)
            saved={r:0x31450000+i*0x1234 for i,r in enumerate((UC_ARM_REG_R4,UC_ARM_REG_R5,UC_ARM_REG_R6,UC_ARM_REG_R7,UC_ARM_REG_R8,UC_ARM_REG_R9,UC_ARM_REG_R10,UC_ARM_REG_R11))}
            for r,value in saved.items():uc.reg_write(r,value)
            uc.reg_write(UC_ARM_REG_R0,index);uc.reg_write(UC_ARM_REG_SP,0x23008000);uc.reg_write(UC_ARM_REG_LR,0x1032FF00)
            uc.emu_start(functions['yi4k_codec_epoch_test']['address'],0x1032FF00,count=100000000)
            assert uc.reg_read(UC_ARM_REG_PC)==0x1032FF00 and uc.reg_read(UC_ARM_REG_R0)==0,(name,'ARM',uc.reg_read(UC_ARM_REG_R0))
            assert uc.reg_read(UC_ARM_REG_SP)==0x23008000 and all(uc.reg_read(r)==v for r,v in saved.items())
            arm_report=list(struct.unpack('<8I',uc.mem_read(globals_['yi4k_codec_epoch_test_report'],32)))
            assert arm_report==host_report
            rows.append(dict(name=name,host_passed=True,compiled_arm_passed=True,reports_equal=True,abi_preserved=True,report=host_report))
        (output/'compiled-codec-offline-tests.elf').write_bytes(elf_bytes)

        video,nals,audio,source=stock.load_archived_samples()
        streams=json.loads(run([stock.FFPROBE,'-v','error','-show_streams','-show_data','-of','json',stock.SAMPLE_MP4]))['streams']
        vs=next(s for s in streams if s['codec_type']=='video');aus=next(s for s in streams if s['codec_type']=='audio')
        avcc=extradata(vs['extradata']);asc=extradata(aus['extradata']);sps,pps=avcc_parameters(avcc)
        assert [sps,pps]==nals[:2] and len(sps)<=64 and len(pps)<=64 and asc[2:]==bytes(len(asc)-2)
        digest=hashlib.sha256(b'avcC'+struct.pack('>I',len(avcc))+avcc+b'ASC'+struct.pack('>I',len(asc))+asc).digest()
        identity=hashlib.sha256(b'archived-source-codec-binding-v1'+bytes.fromhex(source['sha256'])+digest).digest()
        config=Config();config.identity[:]=identity;config.config_digest[:]=digest
        config.sps_size=len(sps);config.pps_size=len(pps);config.sps[:len(sps)]=sps;config.pps[:len(pps)]=pps
        config.sample_rate=int(aus['sample_rate']);config.channels=aus['channels'];config.samples_per_aac=1024;config.asc[:]=asc[:2]
        assert (config.sample_rate,config.channels)==(48000,2) # exact archived fixture/native setup scope
        (output/'bound-config.bin').write_bytes(bytes(config))
        provenance=dict(source=source,identity_hex=identity.hex(),config_digest_hex=digest.hex(),avcc_hex=avcc.hex(),asc_hex=asc.hex(),sps_hex=sps.hex(),pps_hex=pps.hex(),
                        binding_derivation='SHA256(archived-source-codec-binding-v1 || source SHA256 bytes || config_digest); config_digest=SHA256(avcC || BE32(length) || exact avcC || ASC || BE32(length) || exact ASC)',
                        sample_rate_origin='explicit archived mp4a/ASC; never inferred from raw AAC',live_encoder_binding_proven=False)
        (output/'configuration-provenance.json').write_text(json.dumps(provenance,indent=2)+'\n')
        epoch=Epoch();library.yi4k_1107_codec_init.argtypes=[ct.POINTER(Epoch),ct.POINTER(Config)]
        assert library.yi4k_1107_codec_init(ct.byref(epoch),ct.byref(config))==0
        library.yi4k_1107_codec_video.argtypes=[ct.POINTER(Epoch),ct.c_void_p,ct.c_uint32,ct.c_uint32,ct.c_void_p,ct.c_uint32,ct.c_void_p,ct.c_uint32,ct.POINTER(ct.c_uint32)]
        library.yi4k_1107_codec_audio.argtypes=[ct.POINTER(Epoch),ct.c_void_p,ct.c_uint32,ct.c_void_p,ct.c_uint32,ct.c_void_p,ct.c_uint32,ct.POINTER(ct.c_uint32)]
        image=stock.life.arm.IMAGE.read_bytes();assert sha(image)==stock.life.arm.DIGEST
        control=stock.WriterMachine(image);track=control.movie(video=True,audio=False)
        slice_only=b'\0\0\0\1'+nals[-1];ptr=control.payload(slice_only,32);control.descriptor(slice_only,ptr,1,0)
        status=control.call(0xA042D0F8,stock.MOVIE,track,stock.PARAMS,stock.INDEX,stock.STREAM,60000,0xFFFFFFFF,0xFFFFFFFF)
        assert status==0 and control.get(stock.PARAMS+0xB8,2)==0 and control.get(stock.PARAMS+0xBA,2)==0
        control_result=dict(original_process_status=status,sps_length=0,pps_length=0,media_bytes=len(control.output),meaning='raw slice-only return success does not initialize codec parameters')
        source_decoded=run([stock.FFMPEG,'-v','error','-xerror','-i',stock.SAMPLE_MP4,'-map','0:v:0','-frames:v','1','-pix_fmt','yuv420p','-f','rawvideo','pipe:1'])
        for name,input_video in [('slice_only_injected',slice_only),('same_inband_preserved',video)]:
            inp=ct.create_string_buffer(input_video);host_output=ct.create_string_buffer(stock.CAPACITY);written=ct.c_uint32()
            assert library.yi4k_1107_codec_video(ct.byref(epoch),config.identity,1,0,inp,len(input_video),host_output,len(host_output),ct.byref(written))==0
            adapted=host_output.raw[:written.value];assert adapted==video
            m=CodecMachine(image);load_sections(m.uc,elf);m.uc.mem_map(0x21000000,0x10000)
            config_addr,epoch_addr,size_addr=0x21000000,0x21001000,0x21002000
            m.uc.mem_write(config_addr,bytes(config));m.uc.mem_write(epoch_addr,bytes(ct.sizeof(Epoch)))
            track,mem=m.setup_index(audio=True)
            assert m.call(0xA0435A18,native.FORMAT,mem,stock.INDEX,128,0,1,0xA0435630)==0
            assert m.call(functions['yi4k_1107_codec_init']['address'],epoch_addr,config_addr)==0
            m.uc.mem_write(stock.ORIGINAL,input_video)
            assert m.call(functions['yi4k_1107_codec_video']['address'],epoch_addr,config_addr,1,0,stock.ORIGINAL,len(input_video),stock.OWNED+32,stock.CAPACITY-32,size_addr)==0
            count=m.get(size_addr);assert count==len(adapted) and bytes(m.uc.mem_read(stock.OWNED+32,count))==adapted
            m.uc.mem_write(stock.ORIGINAL,b'\xEE'*len(input_video))
            m.descriptor(adapted,stock.OWNED+32,1,0)
            assert m.call(0xA042D0F8,stock.MOVIE,track,stock.PARAMS,stock.INDEX,stock.STREAM,60000,0xFFFFFFFF,0xFFFFFFFF)==0
            assert m.get(stock.PARAMS+0xB8,2)==len(sps) and m.get(stock.PARAMS+0xBA,2)==len(pps)
            assert bytes(m.uc.mem_read(stock.PARAMS,len(sps)))==sps and bytes(m.uc.mem_read(stock.PARAMS+0x40,len(pps)))==pps
            m.uc.mem_write(stock.ORIGINAL,audio)
            assert m.call(functions['yi4k_1107_codec_audio']['address'],epoch_addr,config_addr,0,stock.ORIGINAL,len(audio),stock.OWNED+32,stock.CAPACITY-32,size_addr)==0
            assert m.get(size_addr)==len(audio) and bytes(m.uc.mem_read(stock.OWNED+32,len(audio)))==audio
            m.uc.mem_write(stock.ORIGINAL,b'\xEE'*len(audio));m.descriptor(audio,stock.OWNED+32,8,0)
            assert m.call(0xA043173C,stock.MOVIE,track+0x90,stock.INDEX,stock.STREAM,0,60000,0xFFFFFFFF,0xFFFFFFFF)==0
            close=m.call(0xA0436004,native.FORMAT,mem,stock.INDEX,128,0,0xA0433AF0,0xA0433C1C,native.MOOV,0);assert close==0
            path=output/(name+'.mp4');path.write_bytes(m.output)
            probe=json.loads(run([stock.FFPROBE,'-v','error','-show_streams','-show_packets','-show_data','-of','json',path]))
            decoded=run([stock.FFMPEG,'-v','error','-xerror','-err_detect','explode','-i',path,'-map','0:v:0','-map','0:a:0','-f','null','-'])
            frame=run([stock.FFMPEG,'-v','error','-xerror','-i',path,'-map','0:v:0','-frames:v','1','-pix_fmt','yuv420p','-f','rawvideo','pipe:1'])
            assert frame==source_decoded
            out_audio=next(s for s in probe['streams'] if s['codec_type']=='audio');assert extradata(out_audio['extradata'])==asc
            out_video=next(s for s in probe['streams'] if s['codec_type']=='video');assert avcc_parameters(extradata(out_video['extradata']))==(sps,pps)
            (output/(name+'-probe.json')).write_text(json.dumps(probe,indent=2)+'\n')
            integrations.append(dict(name=name,host_arm_adapted_bytes_equal=True,input_nal_types=[n[0]&31 for n in stock.nals(input_video)],output_nal_types=[n[0]&31 for n in stock.nals(adapted)],
                adapted_sha256=sha(adapted),original_process_video_sps_bytes=len(sps),original_process_video_pps_bytes=len(pps),native_close_status=close,
                mp4_path=str(path),mp4_bytes=len(m.output),mp4_sha256=sha(m.output),source_and_output_first_decoded_frame_equal=True,decoded_frame_sha256=sha(frame),full_av_decode_passed=True,
                native_index_call_count=len(m.native_calls),native_entries=sorted(set(c['entry'] for c in m.native_calls)),modeled_file_writes=len(m.writes)))
        result=dict(scope='offline new C binding/cache plus original ARM parser/index/open/close/serializer with explicit RAM file and OS models',
            host_cases=len(rows),compiled_arm_cases=len(rows),results=rows,original_arm_complete_mp4_cases=integrations,slice_only_without_adapter_control=control_result,
            image_sha256=stock.life.arm.DIGEST,configuration_provenance=provenance,build_commands=commands,
            source_sha256={str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in [*SOURCE_FILES,HEADER]},
            validation_script_sha256=sha(Path(__file__).read_bytes()),native_harness_sha256=IMPORTED_HARNESS_HASHES['audit_prerecord_native_mp4.py'],
            original_writer_harness_sha256=IMPORTED_HARNESS_HASHES['audit_prerecord_owned_mux_writer.py'],
            imported_harness_hashes=IMPORTED_HARNESS_HASHES,imported_harness_files_unchanged_at_completion={name:sha(path.read_bytes())==IMPORTED_HARNESS_HASHES[name] for name,path in HARNESS_PATHS.items()},
            arm_elf_sha256=sha(elf_bytes),functions=functions,
            limitations=['No camera, live encoder configuration binding, hook, FIFO adapter integration, hardware epoch, cache lease or minute spool.',
                'Identity/digest provenance must be supplied by caller; this test binds exact archived MP4 avcC/ASC/source, not a real producer session.',
                'C validates framing and initial IDs only, not complete codec syntax; actual original parser and decoder validate the archived positive fixture.',
                'Native index and MP4 path execute original ARM; file seek/write and OS allocator are explicit memory models, not SD filesystem.',
                'SPS/PPS each64, one pair, four-byte prefixes, <=64NALs/AU, AAC-LC mono/stereo fixed1024 are intentionally narrow adapter limits.',
                'No raw AAC sample-rate inference and no arbitrary codec change/rebind; caller must abort/close/quiesce and create fresh binding.'],
            device_access=False,camera_prerecord_implemented=False)
        (output/'validation.json').write_text(json.dumps(result,indent=2)+'\n')
        print(json.dumps(dict(output=str(output),host_cases=len(rows),compiled_arm_cases=len(rows),native_mp4_cases=len(integrations))))

if __name__=='__main__':main()
