#!/usr/bin/env python3
"""Group printed EIS events by completed native mode-initialization blocks.

Uses source line ordering, not inferred timestamp/PTS alignment. Geometry is
retained literally; a mode is not automatically labelled recording by size.
"""
import argparse
import collections
import json
from pathlib import Path

from analyze_native_eis_trace import analyze as gyro_analyze
from analyze_rtos_log import analyze as mode_analyze


def analyze(path):
    gyro=gyro_analyze(path)
    modes=mode_analyze(path)
    blocks=modes['mode_init_blocks']
    phases=[]
    assigned=set()
    for index,block in enumerate(blocks):
        first=block['end_line']+1
        last=blocks[index+1]['start_line']-1 if index+1<len(blocks) else None
        events=[row for row in gyro['events'] if row['line']>=first and (last is None or row['line']<=last)]
        assigned.update(row['line'] for row in events)
        ticks=[row['log_tick'] for row in events]
        gyro_ticks=[row['log_tick'] for row in events if row['kind']=='gyro']
        deltas=collections.Counter(b-a for a,b in zip(gyro_ticks,gyro_ticks[1:]))
        phases.append(dict(mode_index=index,sensor_geometry=block.get('sensor_geometry'),
                           init_tick=block['end_tick'],first_source_line=first,last_source_line=last,
                           mode_fields=block['fields'],printed_event_counts=dict(collections.Counter(e['kind'] for e in events)),
                           observed_log_tick_range=[min(ticks),max(ticks)] if ticks else [],
                           gyro_log_tick_delta_histogram={str(k):v for k,v in sorted(deltas.items())},
                           exposure_values_raw=sorted({e['exposure_time_raw'] for e in events if e['kind']=='exposure'}),
                           arm_update_values_hex=sorted({hex(e['arm_sys_time_raw']) for e in events if e['kind']=='frame_update'})))
    return dict(source=gyro['source'],sha256=gyro['sha256'],bytes=gyro['bytes'],
                total_printed_event_counts=gyro['counts'],phases=phases,
                unassigned_or_during_mode_init_events=sum(e['line'] not in assigned for e in gyro['events']),
                bounded_error_string_counts=modes['bounded_error_counts'],
                limitations=gyro['limitations']+[
                    'Phase assignment follows file line ordering between completed mode initializations.',
                    'No camera-video PTS alignment is inferred.',
                    'Internal geometry alone does not establish recording; correlate with actual API and video.',
                    'A printed frame_update event is not proof of one uniquely identified video frame.',
                    'Error-string counts only cover retained bytes and enabled print branches.'])


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('log',type=Path)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    result=analyze(args.log)
    args.output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps(dict(total=result['total_printed_event_counts'],
                          phases=[dict(index=p['mode_index'],geometry=p['sensor_geometry'],counts=p['printed_event_counts']) for p in result['phases']]),ensure_ascii=False))


if __name__=='__main__':main()
