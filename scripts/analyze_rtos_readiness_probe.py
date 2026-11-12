#!/usr/bin/env python3
"""Parse hash-verified native RTOS snapshots, never read live camera memory."""
import argparse
import base64
import hashlib
import json
from pathlib import Path
import re
import struct


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('receipt',type=Path)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    session=json.loads(args.receipt.read_text())
    assert session['action']=='collect' and 'error' not in session
    result=session['result']
    def get(key):
        row=result[key]
        assert row['present'] and 'base64' in row, 'Missing '+key
        data=base64.b64decode(row['base64'],validate=True)
        assert len(data)==row['bytes'] and hashlib.sha256(data).hexdigest()==row['sha256']
        return data
    assert get('fingerprint').hex()=='0300a0e11eff2fe1'
    claim=json.loads(get('claim'))
    done=json.loads(get('done'))
    assert claim['phase']=='claim' and done['phase']=='done'
    pools=[]
    for key in ('pool1','pool2'):
        data=get(key)
        assert len(data)==48
        words=struct.unpack('<12I',data)
        assert words[0]==0x42595445, 'Invalid BYTE pool magic'
        pools.append({'source':key,'address':'0xa0fd7114','magic':hex(words[0]),
                      'available_bytes':words[2],'fragment_count':words[3],
                      'region_start':hex(words[6]),'region_size_bytes':words[7],
                      'minimum_image_and_reader_request_bytes':2310336,
                      'headroom_over_minimum_bytes':words[2]-2310336,
                      'guarantees_contiguous_allocation':False})
    tasks=[]
    for key in ('va1','va2'):
        data=get(key)
        assert len(data)==220 and data[0]==1, 'VideoAnal not initialized'
        words=struct.unpack('<55I',data)
        # Snapshot starts at initialized byte, four bytes before VA task TCB.
        assert words[1]==0x54485244, 'Invalid THRD task magic'
        tasks.append({'source':key,'initialized_byte':data[0],
                      'task_control_block':'0xa14307bc','magic':hex(words[1]),
                      'scheduling_count':words[2],'state_raw':words[13],
                      'priority_raw':words[45],'preemption_threshold_raw':words[46],
                      'wait_object_raw':hex(words[29]),
                      'stack_saved_sp_raw':hex(words[3]),
                      'stack_start_raw':hex(words[4]),'stack_end_raw':hex(words[5])})
    texts={key:get(key).decode('utf-8','replace') for key in ('mem','tsk1','tsk2')}
    assert 'Available' in texts['mem'] and 'Byte pool' in texts['mem']
    va_rows={key:[line.strip() for line in text.splitlines() if re.search(r'VA[ _]frame[ _]hdlr',line)]
             for key,text in texts.items() if key.startswith('tsk')}
    assert all(len(rows)==1 for rows in va_rows.values()), 'VideoAnal task row missing or ambiguous'
    assert all('SCHED' in texts[key] for key in va_rows)
    ps_tasks={}
    for key in ('tsk1','tsk2'):
        parsed={}
        for line in texts[key].splitlines():
            fields=line.split(None,13)
            if len(fields)!=14 or not fields[0].isdigit():continue
            parsed[fields[13]]={'id':int(fields[0]),'priority':int(fields[1]),
                                'sched':int(fields[3]),'state':fields[4]}
        ps_tasks[key]=parsed
    names=['VA frame hdlr','AmbaImageMainEisTask','AmbaImageMainEisAlgo2Task']
    progress={}
    for name in names:
        first,second=(ps_tasks[key][name] for key in ('tsk1','tsk2'))
        progress[name]={'first':first,'second':second,
                        'scheduling_delta_mod32':(second['sched']-first['sched'])&0xffffffff}
    for index,key in enumerate(('tsk1','tsk2')):
        assert ps_tasks[key]['VA frame hdlr']['sched']==tasks[index]['scheduling_count']
    byte_rows=[]
    byte_section=texts['mem'].split('Block pool',1)[0]
    for line in byte_section.splitlines():
        match=re.fullmatch(r'\s*(\d+)\s+(\d+)\s+(\d+)\s*(.*?)\s*',line)
        if match:byte_rows.append({'id':int(match[1]),'available_bytes':int(match[2]),
                                  'fragment_count':int(match[3]),'name':match[4]})
    assert byte_rows and byte_rows[0]['available_bytes']==pools[0]['available_bytes']
    report={'identifier':session['probe']['identifier'],
            'firmware_fingerprint_verified':True,'persistent_done_verified':True,
            'linux_boot_id_at_claim':claim['boot_id'],
            'linux_uptime_at_claim':claim['uptime'],'linux_uptime_at_done':done['uptime'],
            'pools':pools,'videoanal_snapshots':tasks,'videoanal_ps_rows':va_rows,
            'byte_pool_ps_rows':byte_rows,'selected_task_progress':progress,
            'scheduling_count_delta_mod32':(tasks[1]['scheduling_count']-tasks[0]['scheduling_count'])&0xffffffff,
            'limitations':['Snapshots are sequential and not atomic across tasks.',
                           'Available bytes do not establish maximum contiguous allocation.',
                           'Task existence/state/scheduling are not proof that frame callbacks deliver images.',
                           'ps output is emitted through a file callback; t app mem uses the separate global logger.',
                           'No SharePreview initialization or EIS algorithm change was performed.']}
    args.output.write_text(json.dumps(report,indent=2,ensure_ascii=False)+'\n')
    print(json.dumps(report,indent=2,ensure_ascii=False))


if __name__=='__main__':main()
