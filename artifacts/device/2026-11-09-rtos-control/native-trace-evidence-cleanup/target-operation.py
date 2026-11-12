import os,stat,hashlib,json,subprocess
owned={'/tmp/SD0/yi4k_trace_f1f114115096_before.bin': 'aa2bcf7aa5faf010db040a26151face499dac7247035f09fd40063bb854c1968', '/tmp/SD0/yi4k_trace_f1f114115096_active.bin': '2e07d75dab5f58b5fe8af273179b4783e84c9f21cd5fedd5b751aaa414359c4e', '/tmp/SD0/yi4k_trace_f1f114115096_after.bin': 'aa2bcf7aa5faf010db040a26151face499dac7247035f09fd40063bb854c1968', '/tmp/SD0/yi4k_trace_f1f114115096_code.bin': '5e64b91b57eaf124341a5f84484d853cfe5e97bae40e8d7c8bf60c7ed4c6969d', '/tmp/SD0/yi4k_trace_f1f114115096_record.json': '7104a391a52e3dc2bd058fd0bad3b277186181607301754344b050a238aa2c19', '/tmp/SD0/yi4k_trace_f1f114115096_attempt': 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', '/tmp/yi4k_trace_f1f114115096_begin': 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', '/tmp/yi4k_trace_f1f114115096_done': 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'}
absent=['/tmp/SD0/autoexec.ash', '/tmp/SD0/yi4k_trace_f1f114115096.py', '/tmp/SD0/save_log_enable.script']
assert all(not os.path.lexists(p) for p in absent)
for path,expected in owned.items():
 assert stat.S_ISREG(os.lstat(path).st_mode)
 assert hashlib.sha256(open(path,'rb').read()).hexdigest()==expected
for path in owned:os.unlink(path)
subprocess.check_call(['sync'])
assert all(not os.path.lexists(p) for p in list(owned)+absent)
print('YI_EVIDENCE_CLEANED '+str(len(owned)))
