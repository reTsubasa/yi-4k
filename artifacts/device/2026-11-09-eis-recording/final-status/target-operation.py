import os,json,glob
paths=['/tmp/SD0/autoexec.ash', '/tmp/SD0/yi4k_rec_7f7a3fa2fbd5.py', '/tmp/SD0/save_log_enable.script', '/tmp/SD0/yi4k_rec_7f7a3fa2fbd5_before.bin', '/tmp/SD0/yi4k_rec_7f7a3fa2fbd5_active.bin', '/tmp/SD0/yi4k_rec_7f7a3fa2fbd5_after.bin', '/tmp/SD0/yi4k_rec_7f7a3fa2fbd5_fingerprint.bin', '/tmp/SD0/yi4k_rec_7f7a3fa2fbd5_gate.json', '/tmp/SD0/yi4k_rec_7f7a3fa2fbd5_record.json', '/tmp/SD0/yi4k_rec_7f7a3fa2fbd5_attempt.flag', '/tmp/yi4k_rec_7f7a3fa2fbd5_begin', '/tmp/yi4k_rec_7f7a3fa2fbd5_done', '/tmp/yi4k_rec_7f7a3fa2fbd5_bad', '/tmp/yi4k_rec_7f7a3fa2fbd5_good', '/tmp/SD0/yi4k_rec_7f7a3fa2fbd5_ready', '/tmp/SD0/yi4k_rec_7f7a3fa2fbd5_missing']
assert all(not os.path.lexists(p) for p in paths)
mounts=[l for l in open('/proc/mounts') if 'yi4k-rtos-logs-' in l]
dirs=glob.glob('/tmp/yi4k-rtos-logs-*')
transports=[p for p in glob.glob('/tmp/yi4k-py-*.py') if p!=os.path.abspath(__file__)]
assert not mounts and not dirs and not transports
print('YI_FINAL '+json.dumps({'all_probe_paths_absent':True,'paths_checked':len(paths),'temporary_log_mounts':len(mounts),'temporary_log_directories':len(dirs),'other_transport_files':len(transports),'uptime':open('/proc/uptime').read().split()[0]}))
