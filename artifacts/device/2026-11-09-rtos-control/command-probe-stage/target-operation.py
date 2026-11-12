import os,stat,hashlib,json,binascii,subprocess
probe = {'identifier': '0df64432c397', 'begin': '/tmp/yi4k_probe_0df64432c397_begin', 'done': '/tmp/yi4k_probe_0df64432c397_done', 'output': '/tmp/SD0/yi4k_probe_0df64432c397.bin', 'script': "t ipc rpc clnt exec1 'touch /tmp/yi4k_probe_0df64432c397_begin'\nsavebin c:\\yi4k_probe_0df64432c397.bin 0xA0394BA0 l 8\nt ipc rpc clnt exec1 'touch /tmp/yi4k_probe_0df64432c397_done'\n\n", 'script_sha256': '13d3a42a695bc9a71e0e0ce8da3f3788006f54ceffd195c57a8a01d5f134c53a'}
path = '/tmp/SD0/autoexec.ash'
expected_code = '0300a0e11eff2fe1'
for name in (probe['begin'],probe['done'],probe['output'],path):
    assert not os.path.lexists(name), 'Refuse existing probe path: '+name
fd=os.open(path,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0600)
with os.fdopen(fd,'wb') as file:
    file.write(probe['script'])
assert hashlib.sha256(open(path,'rb').read()).hexdigest()==probe['script_sha256']
subprocess.check_call(['sync'])
print('YI_COMMAND_PROBE '+json.dumps({'created_exclusively':True,'script_sha256':probe['script_sha256']}))
