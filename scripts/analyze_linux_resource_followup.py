#!/usr/bin/env python3
import argparse,json,re
from pathlib import Path
PIDS={102:'ipcbind',104:'util_svc',108:'AmbaNetFifoDaemon',110:'AmbaEventNotifyDaemon',156:'remoteapi_disc_daemon',266:'remoteapi_cmd_daemon',271:'remoteapi_data_daemon',275:'remoteapi_syssvc_daemon',288:'XCServer',959:'AmbaRTSPServer'}
def sample(path):
 txt=path.read_text(errors='replace'); label=re.search(r'LABEL=(\w+)',txt).group(1); out={}
 for pid,name in PIDS.items():
  m=re.search(rf'PID={pid}\n([^\n]+)\n((?:[^\n]*\n)*?)(?=PID=|~ # echo|$)',txt)
  if not m: continue
  stat=m.group(1); status=m.group(2)
  sm=re.match(r'\s*\d+\s+\((.*)\)\s+([A-Z])\s+(.*)',stat)
  if not sm: continue
  fields=sm.group(3).split(); utime=int(fields[10]);stime=int(fields[11]); rss=re.search(r'^VmRSS:\s+(\d+) kB',status,re.M); vmpeak=re.search(r'^VmPeak:\s+(\d+) kB',status,re.M)
  out[pid]={'name':name,'state':sm.group(2),'utime_ticks':utime,'stime_ticks':stime,'rss_kb':int(rss.group(1)) if rss else None,'vmpeak_kb':int(vmpeak.group(1)) if vmpeak else None}
 return label,out
ap=argparse.ArgumentParser();ap.add_argument('directory',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();d=a.directory
l0,s0=sample(d/'t0.txt');l5,s5=sample(d/'t5.txt');out=[]
for p in sorted(set(s0)&set(s5)):
 x=s0[p];y=s5[p];out.append({'pid':p,'name':x['name'],'state_t0':x['state'],'state_t5':y['state'],'rss_kb_t0':x['rss_kb'],'rss_kb_t5':y['rss_kb'],'cpu_ticks_delta_5s':(y['utime_ticks']+y['stime_ticks'])-(x['utime_ticks']+x['stime_ticks']),'user_ticks_delta_5s':y['utime_ticks']-x['utime_ticks'],'system_ticks_delta_5s':y['stime_ticks']-x['stime_ticks']})
raw=(d/'t0.txt').read_text(errors='replace'); start=re.search(r'\nLABEL=\w+\n',raw); text=raw[start.end():].split('PID=',1)[0] if start else raw; mem={k:int(v) for k,v in re.findall(r'^([A-Za-z()]+):\s+(\d+)',text,re.M)}
res={'scope':'two read-only /proc resource samples separated by 5 seconds','samples':[l0,l5],'meminfo_t0_kb':mem,'processes':out,'limitations':['Linux clock tick frequency was not independently read here; CPU deltas are raw scheduler ticks.','The interval is idle/preview state, not an active high-motion recording.','RSS and heap mappings do not reveal RTOS ownership or cache policy.']}
a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(res,ensure_ascii=False,indent=2)+'\n');print(json.dumps({'processes':len(out),'memfree_kb':mem.get('MemFree'),'cached_kb':mem.get('Cached')}))
