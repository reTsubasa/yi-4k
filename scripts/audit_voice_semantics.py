#!/usr/bin/env python3
"""Offline stock ARM voice score-to-command and action-gate audit.

Synthetic scores/status only: DSP/NN, queue IO, settings and device calls do not
run. Unknown executed function bodies fail closed. No camera connection.
"""
import hashlib
import json
import struct
from pathlib import Path
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_ARM, UC_HOOK_CODE
from unicorn.arm_const import *

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT/'artifacts/device/2026-11-09-linux/rtos-analysis'
OUT = ROOT/'artifacts/device/2026-11-10-voice-semantics'
BASE = 0xA0100000
EXPECTED = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'
REGS = (UC_ARM_REG_R0,UC_ARM_REG_R1,UC_ARM_REG_R2,UC_ARM_REG_R3)


def main():
    raw=(SOURCE/'rtos-window.bin').read_bytes()
    assert hashlib.sha256(raw).hexdigest()==EXPECTED
    word=lambda a:struct.unpack_from('<I',raw,a-BASE)[0]
    cstr=lambda a:raw[a-BASE:].split(b'\0',1)[0].decode('ascii')
    flt=lambda bits:struct.unpack('<f',struct.pack('<I',bits))[0]
    md=Cs(CS_ARCH_ARM,CS_MODE_ARM)
    table=(word(0xA04C9F24)+0xA04C9F10)&0xFFFFFFFF
    mapping=[word(table+i*4) for i in range(5)]
    assert table==0xA07E3C14 and mapping==[1002,1001,1004,1003,1005]
    names=[cstr(word(0xA056E2C8+i*4)) for i in range(5)]
    image_functions=json.loads((SOURCE/'full/functions.json').read_text())
    functions={int(f['entry'],16):f for f in image_functions}
    ranges={a:[tuple(int(x,16) for x in s.split('-')) for s in f['body_ranges']]
            for a,f in functions.items()}
    uc=Uc(UC_ARCH_ARM,UC_MODE_ARM)
    uc.mem_map(0xA0000000,0x02000000);uc.mem_write(BASE,raw)
    uc.mem_map(0x70000000,0x800000)
    put=lambda a,v:uc.mem_write(a,struct.pack('<I',v&0xFFFFFFFF))
    get=lambda a:struct.unpack('<I',uc.mem_read(a,4))[0]
    byte=lambda a,v:uc.mem_write(a,bytes([v]))
    floatput=lambda a,v:uc.mem_write(a,struct.pack('<f',v))
    ctx=0x70200000;scores=0x70001000;context=0x70002000;end=0x70008000
    state={}

    def ret(v):
        lr=uc.reg_read(UC_ARM_REG_LR)
        uc.reg_write(UC_ARM_REG_R0,v&0xFFFFFFFF)
        uc.reg_write(UC_ARM_REG_CPSR,(uc.reg_read(UC_ARM_REG_CPSR)&~32)|((lr&1)<<5))
        uc.reg_write(UC_ARM_REG_PC,lr&~1)

    neutral={0xA04CA1CC,0xA04F7DE0,0xA04F2014,0xA04F2018,0xA02A819C,
        0xA04CB1C4,0xA04CAC18,0xA04CB3AC,0xA04CBB00,0xA048E3F8,
        0xA01EDD38,0xA03BC320,0xA04CCFF8}
    def hook(machine,address,size,user):
        a=[machine.reg_read(r) for r in REGS];v=None
        if address==0xA04C9F28 and not state.get('real_gate'):
            v=state.get('gate',1)
        elif address==0xA04F2020:
            for i,p in enumerate((scores,scores+len(state['scores'])*4,scores+len(state['scores'])*4)):
                put(a[0]+i*4,p)
            v=0
        elif address in (0xA02A8104,0xA01CBB24):
            v=state['heap'];state['heap']+=(a[0]+15)&~15
        elif address==0xA04F8DEC:
            machine.mem_write(a[0],bytes([a[1]&255])*a[2]);v=a[0]
        elif address==0xA029C680:
            machine.mem_write(a[0],bytes(machine.mem_read(a[1],a[2])));v=a[0]
        elif address==0xA04CAF98 and not state.get('real_reset'):
            state['reset_requests'].append(a[0]);v=0
        elif address==0xA04CA540 and state.get('stub_classifier'):
            state['classification_requests'].append(a[:3]);v=state['classified']
        elif address==0xA04CAC94:
            v=0
        elif address==0xA011F260 and not state.get('real_ready'):
            v=state.get('ready',1)
        elif address==0xA011EFC4:
            v=state.get('busy_helper',0)
        elif address==0xA0197928:
            state['start_stop_flags'].append(a[0]);v=0
        elif address==0xA01E5E98:
            state['queued_descriptors'].append([get(a[0]+i*4) for i in range(11)]);v=0
        elif address==0xA02A70EC:
            state['logs'].append(cstr(a[0]));v=0
        elif address==0xA03BC4E8:
            state['idle_signals']+=1;v=0
        elif address==0xA03BC4AC:
            state['waits']+=1
            # Stop the infinite task through its ordinary error return after
            # exactly one audio/recognition iteration, never via injected code.
            v=1 if state['waits']>2 else 0
        elif address==0xA01EDE60:
            v=0
        elif address==0xA01B18A0:
            v=0x780
        elif address==0xA03BC4FC:
            put(a[1],state.get('event_flags',0));v=0
        elif address==0xA04CB57C and state.get('stub_engine'):
            state['engine_calls']+=1;v=state['engine_result']
        elif address==0xA01881F4:
            put(a[0],context);v=0
        elif address==0xA01E6510:
            state['events'].append(a[:3]);v=0
        elif address in neutral:
            v=0
        if v is not None:ret(v)
        else:assert any(lo<=address<=hi for lo,hi in state['real_ranges']),hex(address)
    uc.hook_add(UC_HOOK_CODE,hook)

    def run(entry,args=(),real=(),**opts):
        state.clear();state.update(scores=[],heap=0x70010000,reset_requests=[],
            classification_requests=[],start_stop_flags=[],queued_descriptors=[],logs=[],
            idle_signals=0,waits=0,engine_calls=0,events=[])
        state.update(opts)
        state['real_ranges']=[s for f in (entry,*real) for s in ranges[f]]
        for reg,v in zip(REGS,list(args)+[0]*(4-len(args))):uc.reg_write(reg,v)
        uc.reg_write(UC_ARM_REG_CPSR,0x10)
        uc.reg_write(UC_ARM_REG_C1_C0_2,0xF00000)
        uc.reg_write(UC_ARM_REG_FPEXC,0x40000000)
        uc.reg_write(UC_ARM_REG_SP,0x707FF000);uc.reg_write(UC_ARM_REG_LR,end)
        uc.emu_start(entry,end,count=200000)
        assert uc.reg_read(UC_ARM_REG_PC)==end
        assert uc.reg_read(UC_ARM_REG_SP)==0x707FF000
        value=uc.reg_read(UC_ARM_REG_R0)
        return dict(result=value if value<0x80000000 else value-0x100000000,
            **{k:v for k,v in state.items() if k not in ('real_ranges','heap')})

    classification=[]
    for language,threshold in [('en',flt(0x3F733333)),('zh',flt(0x3F7EB852))]:
        for index in range(10):
            values=[0.0]*10;values[index]=1.0
            uc.mem_write(scores,struct.pack('<10f',*values));floatput(ctx+0x6DBC,threshold)
            result=run(0xA04CA540,(ctx,0x70003000,200,13),scores=values)
            expected=mapping[index]-1000 if index<5 else 0
            assert result['result']==expected
            classification.append(dict(language=language,winner=index,threshold=threshold,**result))
        for value in (threshold-0.0001,threshold,threshold+0.0001):
            values=[0.0]*10;values[3]=value
            uc.mem_write(scores,struct.pack('<10f',*values));floatput(ctx+0x6DBC,threshold)
            result=run(0xA04CA540,(ctx,0x70003000,200,13),scores=values)
            assert result['result']==(3 if value>threshold else 0)
            classification.append(dict(language=language,winner=3,threshold=threshold,**result))
    # Tie policy: strict '<' argmax keeps the first equal score, including if
    # that causes an accepted semantic class to win over a later reject class.
    values=[1.0,1.0]+[0.0]*8
    uc.mem_write(scores,struct.pack('<10f',*values));floatput(ctx+0x6DBC,.95)
    tied=run(0xA04CA540,(ctx,0x70003000,200,13),scores=values)
    assert tied['result']==2
    values=[0.0]*10;values[3]=.96;values[7]=1.0
    uc.mem_write(scores,struct.pack('<10f',*values))
    dominant_reject=run(0xA04CA540,(ctx,0x70003000,200,13),scores=values)
    assert dominant_reject['result']==0
    gate_reject=run(0xA04CA540,(ctx,0x70003000,200,13),scores=values,gate=0)
    assert gate_reject['result']==0

    gate_cases=[]
    for language,threshold in [('en',flt(0x3F19999A)),('zh',.5)]:
        patterns=[('1110', [1.,1.,1.,0.]+[0.]*9,1),
            ('all_high',[1.]*13,0),('all_low',[0.]*13,0),
            ('short_run',[1.,1.,0.]+[0.]*10,0),
            ('last_tested',[0.]*8+[1.,1.,1.,0.,0.],1),
            ('last_untested',[0.]*9+[1.,1.,1.,0.],0),
            ('equal_threshold',[threshold]*3+[0.]*10,0)]
        for label,values,expected in patterns:
            uc.mem_write(scores,struct.pack('<13f',*values))
            put(ctx+0x36A8,scores);put(ctx+0x36C8,13);floatput(ctx+0x36DC,threshold)
            result=run(0xA04C9F28,(ctx,),real_gate=True,scores=values)
            assert result['result']==expected,(label,result['result'])
            gate_cases.append(dict(language=language,label=label,threshold=threshold,**result))

    # Engine framing/reset behavior uses synthetic existing feature counts;
    # no DSP, model inference or fake claim of time-based duplicate suppression.
    got=0xA0821700
    target=lambda literal:word(got+word(literal))
    first_vec=target(0xA04CBA68);second_vec=target(0xA04CBA6C)
    feature=target(0xA04CBA7C);timer=target(0xA04CBA78)
    engine_cases=[]
    for frames,classified in [(0,3),(120,3),(121,0),(121,3),(121,4),(350,3),(351,3),(121,-1)]:
        for vec,p in ((first_vec,0x70003000),(second_vec,0x70004000)):
            put(vec,p);put(vec+4,p+3200);put(vec+8,p+3200)
        put(target(0xA04CBA70),1);put(target(0xA04CBA80),ctx)
        floatput(timer,0);put(feature+4,frames);put(feature+0x18,0)
        result=run(0xA04CB57C,(0x70005000,0,1600),real=(0xA04CB568,),
                   stub_classifier=True,classified=classified)
        expected=0 if frames<=120 else classified if classified<0 else classified+1000
        assert result['result']==expected,(frames,classified,result)
        assert bool(result['reset_requests'])==(frames>120 and classified!=0)
        if frames>120:assert get(feature)==min(frames,350)
        engine_cases.append(dict(frames=frames,**result))

    # Real VC_Init reset and its ordinary buffer/counter initialization, with
    # synthetic allocation and DSP coefficient initialization stubbed.
    cfg=target(0xA04CB194);dsp=target(0xA04CB1A8)
    put(cfg,0);floatput(cfg+4,150.0);put(cfg+8,5)
    put(target(0xA04CB1AC),ctx);put(dsp+0x54,0x70030000)
    put(feature+4,200);floatput(timer,7.0)
    reset=run(0xA04CAF98,(cfg,),real=(0xA04CABE0,0xA04CAB18,0xA04CD2B8),real_reset=True)
    assert reset['result']==0 and get(feature+4)==0 and get(timer)==0x40E00000
    assert get(feature)==0 and get(feature+0x18)==0 and get(feature+0x14)==0xFFFFFFFF
    reset['feature_words_after']=[get(feature+i*4) for i in range(7)]
    reset['timer_bits_after']=get(timer)

    readiness=[]
    for status,blocked,busy in [(0,0,0),(1,0,0),(5,0,0),(0,4,0),(0,0,1),(5,0,1)]:
        byte(0xA0FB334C,status);put(0xA1055D08,blocked)
        r=run(0xA011F260,(),real_ready=True,busy_helper=busy)
        assert r['result']==int(status in (0,5) and not blocked and not busy)
        readiness.append(dict(status=status,blocked=blocked,**r))

    semantic_events=[]
    # These image globals are both startup placeholders (0xffffffff); runtime
    # app registration assigns distinct IDs. Supply distinct synthetic IDs so
    # both branches can be tested without claiming captured live identity.
    assert word(0xA069B01C)==word(0xA069B034)==0xFFFFFFFF
    app_rec,app_other=1,2
    put(0xA069B01C,app_rec);put(0xA069B034,app_other)
    for result_code,skip,rtmp,app in [(n,0,0,app_rec) for n in range(1000,1007)]+[
            (1003,4,0,app_rec),(1003,0,1,app_rec),(1003,0,0,0),(1003,0,0,app_other)]:
        put(context,app);put(0xA12596B0,0);byte(0xA1055D84,rtmp)
        result=run(0xA01B18E0,(),stub_engine=True,engine_result=result_code,event_flags=skip)
        expected=[[0xF0010336+result_code-1001,0,0]] if 1001<=result_code<=1005 and not skip and not rtmp and app in (app_rec,app_other) else []
        assert result['events']==expected
        semantic_events.append(dict(recognition=result_code,skip=skip,rtmp=rtmp,app=hex(app),**result))

    action_cases=[]
    for app,ready,capable,mode,recording in [(app_rec,1,4,4,0),(app_rec,0,4,4,1),
            (app_rec,1,0,4,0),(app_rec,1,4,0,0),(app_other,1,4,0,0),(0,1,4,4,0)]:
        put(context,app);put(context+20,capable);byte(0xA1055CFA,mode);byte(0xA0FB334C,recording)
        result=run(0xA01B22E0,(context,),ready=ready)
        accepted=app in (app_rec,app_other) and capable==4 and (ready or app==app_other)
        assert result['result']==(0 if accepted else -1),(hex(app),ready,capable,mode,recording,result)
        if accepted:
            assert result['queued_descriptors'][-1][0]==0xF001033B
            assert result['queued_descriptors'][-1][3]==0xF0010338
            assert result['start_stop_flags']==[1]
        else:assert not result['queued_descriptors']
        action_cases.append(dict(command='START',app=hex(app),capable=capable,mode=mode,recording=recording,**result))
    for app,mode,recording in [(app_rec,4,1),(app_rec,4,0),(app_rec,0,1),(app_other,4,1)]:
        put(context,app);byte(0xA1055CFA,mode);byte(0xA0FB334C,recording)
        result=run(0xA01B25E4,(context,))
        accepted=app==app_rec and mode==4 and recording==1
        assert result['result']==(0 if accepted else -1)
        if accepted:
            assert result['queued_descriptors'][0][0]==0xF001033B
            assert result['queued_descriptors'][0][3]==0xF0010339
            assert result['start_stop_flags']==[0]
        action_cases.append(dict(command='STOP',app=hex(app),mode=mode,recording=recording,**result))

    selected=[0xA04CA540,0xA04C9F28,0xA04CAF98,0xA04CB568,0xA04CB57C,
        0xA04CD2B8,0xA01B18E0,0xA01B22E0,0xA01B25E4,0xA01B168C,0xA01B1790,
        0xA01B11F8,0xA01B2C30,0xA01C7748,0xA01B2FF8,0xA011F260]
    fingerprints=[]
    for entry in selected:
        chunks=[raw[lo-BASE:hi-BASE+1] for lo,hi in ranges[entry]]
        fingerprints.append(dict(entry=hex(entry),ranges=functions[entry]['body_ranges'],
            sha256=hashlib.sha256(b''.join(chunks)).hexdigest()))
    windows={}
    for label,lo,hi in [('argmax_map',0xA04C9E74,0xA04C9F18),
        ('engine_reset',0xA04CB710,0xA04CB750),('start_event',0xA01B1BD8,0xA01B1BFC),
        ('button_gate',0xA019F66C,0xA019F6C4),('button_to_app',0xA01A0958,0xA01A098C)]:
        windows[label]=[dict(address=hex(i.address),bytes=bytes(i.bytes).hex(),op=i.mnemonic+' '+i.op_str)
                       for i in md.disasm(raw[lo-BASE:hi-BASE],lo)]
    report=dict(image_sha256=EXPECTED,mapping_table=hex(table),class_to_public_code=mapping,
        command_names=names,language_suffixes=[cstr(word(0xA056E3F4+i*4)) for i in range(2)],
        synthetic_classification=classification,tie_case=tied,dominant_reject_case=dominant_reject,
        stage1_reject_short_circuit=gate_reject,synthetic_stage1_gate=gate_cases,
        synthetic_engine_framing=engine_cases,synthetic_task_events=semantic_events,
        synthetic_real_reset=reset,synthetic_real_readiness=readiness,
        synthetic_action_gates=action_cases,function_fingerprints=fingerprints,instructions=windows,
        limitations=['Injected score/status fixtures; no real audio or classifier inference.',
            'Runtime app-ID globals replace 0xffffffff image placeholders with distinct synthetic 1/2 IDs.',
            'Engine reset edges captured separately; real reset verified with synthetic allocation and DSP initializer stubbed.',
            'Task processes exactly one synthetic buffer then exits through its ordinary event-wait error return.',
            'Sampling names and English logs label command semantics, not a complete acoustic phrase dictionary.',
            'No device access, preference write, RTOS queue send, real record or runtime patch.'],
        device_access=False,device_write=False,exact_acoustic_phrases_verified=False)
    OUT.mkdir(parents=True,exist_ok=True)
    (OUT/'audit.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(f'PASS: {len(classification)} class/threshold, {len(gate_cases)} stage1, '
          f'{len(engine_cases)} engine, {len(semantic_events)} task-event, '
          f'{len(action_cases)} action-gate, {len(readiness)} ready, real reset; no device access')


if __name__=='__main__':main()
