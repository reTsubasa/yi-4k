paths=['/tmp/SD0/autoexec.ash', '/tmp/SD0/yi4k_sharepv_bf1a02b30203_rpc.py', '/tmp/SD0/yi4k_sharepv_bf1a02b30203_rpc_result.json', '/tmp/yi4k_sharepv_bf1a02b30203_begin', '/tmp/yi4k_sharepv_bf1a02b30203_init_after', '/tmp/yi4k_sharepv_bf1a02b30203_enable_after', '/tmp/yi4k_sharepv_bf1a02b30203_disable_after', '/tmp/yi4k_sharepv_bf1a02b30203_done']
temporary=['/tmp/yi4k-py-b843bc0a228c488e9c5bc5fc644e9080.py', '/tmp/yi4k-py-b6675e26daf54e2aa5090c342fa1dede.py', '/tmp/yi4k-py-336917e9ac944acfa28237ba4b9a8f6c.py', '/tmp/yi4k-py-5f58395438894c05a4deaab5475aea59.py']
import os,json
out={'uptime':open('/proc/uptime').read().split()[0],
 'probe_paths_absent':all(not os.path.lexists(p) for p in paths),
 'previous_transport_paths_absent':all(not os.path.lexists(p) for p in temporary),
 'temporary_log_mounts':[line.strip() for line in open('/proc/mounts') if 'yi4k-rtos-logs-' in line]}
assert out['probe_paths_absent'] and out['previous_transport_paths_absent']
assert not out['temporary_log_mounts']
print('YI_RECOVERY_FINAL '+json.dumps(out,sort_keys=True))
