#!/usr/bin/env python3
"""Summarize read-only /proc process, FD, RPMsg and mount evidence."""
import argparse, json, re
from pathlib import Path

PIDS={102:'ipcbind',104:'util_svc',108:'AmbaNetFifoDaemon',110:'AmbaEventNotifyDaemon',156:'remoteapi_disc_daemon',266:'remoteapi_cmd_daemon',271:'remoteapi_data_daemon',275:'remoteapi_syssvc_daemon',288:'XCServer',959:'AmbaRTSPServer'}

def parse_maps(path):
    out={p:{'name':name,'maps':[],'shared_device_mappings':[],'libraries':[],'anon':[]} for p,name in PIDS.items()}
    cur=None
    for line in path.read_text(errors='replace').splitlines():
        m=re.search(r'PID=(\d+)',line)
        if m:
            cur=int(m.group(1)); continue
        if cur not in out: continue
        m=re.match(r'([0-9a-f]+)-([0-9a-f]+)\s+(\S+)\s+([0-9a-f]+)\s+\S+\s+\d+\s*(.*)',line)
        if not m: continue
        lo,hi=int(m.group(1),16),int(m.group(2),16); perms=m.group(3); off=int(m.group(4),16); pathpart=m.group(5).strip()
        rec={'start':hex(lo),'end':hex(hi),'bytes':hi-lo,'perms':perms,'file_offset':hex(off),'path':pathpart or None}
        out[cur]['maps'].append(rec)
        if '/dev/amba_' in pathpart: out[cur]['shared_device_mappings'].append(rec)
        elif pathpart.startswith('/'): out[cur]['libraries'].append(rec)
        elif not pathpart: out[cur]['anon'].append(rec)
    for x in out.values():
        x['map_count']=len(x['maps']); x['mapped_bytes']=sum(r['bytes'] for r in x['maps']); x['shared_device_bytes']=sum(r['bytes'] for r in x['shared_device_mappings'])
        x['library_paths']=sorted({r['path'] for r in x['libraries'] if r['path']})
    return out

def parse_cmd(path):
    out={}; cur=None
    for line in path.read_text(errors='replace').splitlines():
        m=re.match(r'PID=(\d+)',line)
        if m: cur=int(m.group(1)); continue
        if cur in PIDS and line.strip() and not line.startswith('~ #') and not line.startswith('__YI_CAPTURE_'):
            out[cur]=line.strip()
    return out

def parse_fds(path):
    out={}; cur=None
    for line in path.read_text(errors='replace').splitlines():
        m=re.match(r'====PID=(\d+)',line)
        if m: cur=int(m.group(1)); out[cur]=[]; continue
        if cur in PIDS:
            m=re.search(r'\s(\d+)\s+->\s+(.+)$',line)
            if m: out[cur].append({'fd':int(m.group(1)),'target':m.group(2).strip()})
    return out

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('directory',type=Path); ap.add_argument('--output',type=Path,required=True); a=ap.parse_args()
    d=a.directory
    maps=parse_maps(d/'proc_maps.txt'); cmds=parse_cmd(d/'proc_cmdlines.txt'); fds=parse_fds(d/'proc_fds.txt')
    for pid,x in maps.items(): x['cmdline']=cmds.get(pid); x['fds']=fds.get(pid,[]); x['socket_fd_count']=sum(v['target'].startswith('socket:') for v in x['fds'])
    rpmsg=[]; cur=None
    for line in (d/'rpmsg_sysfs.txt').read_text(errors='replace').splitlines():
        m=re.match(r'==== (/sys/bus/rpmsg/devices/rpmsg\d+)',line)
        if m: cur={'sysfs':m.group(1)}; rpmsg.append(cur); continue
        if cur is not None:
            if line.startswith('/sys/devices/'): cur['resolved_path']=line.strip()
            elif line.startswith('--'): cur['field']=line[2:]
            elif line.startswith('cat:'): cur.pop('field',None)
            elif cur.get('field') and line.strip() and not line.startswith('~ #'): cur[cur.pop('field')]=line.strip()
    mount=(d/'open_ports.txt').read_text(errors='replace')
    summary={'scope':'read-only /proc process command lines, maps, FDs, RPMsg sysfs and mountinfo','pids':maps,'rpmsg_endpoints':rpmsg,'mountinfo_lines':[l for l in mount.splitlines() if ' - ' in l], 'limitations':['PIDs and mappings are a single runtime snapshot; process restart can change them.','/proc fd socket inode numbers do not identify RPC program IDs by themselves.','Shared /dev/amba_heapmem mapping proves Linux processes map the device; it does not expose ownership or safe write protocol.']}
    a.output.parent.mkdir(parents=True,exist_ok=True); a.output.write_text(json.dumps(summary,ensure_ascii=False,indent=2)+'\n'); print(json.dumps({'pids':len(maps),'rpmsg':len(rpmsg)}))
if __name__=='__main__': main()
