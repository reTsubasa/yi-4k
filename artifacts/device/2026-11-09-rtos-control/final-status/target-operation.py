import os,json
paths=['/tmp/SD0/autoexec.ash', '/tmp/SD0/yi4k_trace_f1f114115096.py', '/tmp/SD0/save_log_enable.script', '/tmp/SD0/yi4k_trace_f1f114115096_before.bin', '/tmp/SD0/yi4k_trace_f1f114115096_active.bin', '/tmp/SD0/yi4k_trace_f1f114115096_after.bin', '/tmp/SD0/yi4k_trace_f1f114115096_code.bin', '/tmp/SD0/yi4k_trace_f1f114115096_record.json', '/tmp/SD0/yi4k_trace_f1f114115096_attempt', '/tmp/yi4k_trace_f1f114115096_begin', '/tmp/yi4k_trace_f1f114115096_done']
assert all(not os.path.lexists(p) for p in paths)
mounts=[l for l in open('/proc/mounts') if 'yi4k-rtos-logs-' in l]
assert not mounts
print('YI_FINAL '+json.dumps({'all_11_probe_paths_absent':True,'temporary_log_mounts':len(mounts),'uptime':open('/proc/uptime').read().split()[0]}))
