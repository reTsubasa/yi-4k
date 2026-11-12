"""Transfer Python source with per-chunk acknowledgements over camera Telnet.

Avoids long PTY input bursts and canonical line limits. A unique temporary
Linux file is exclusively created, hash checked, executed, and removed only
when its content matches the acknowledged/attempted source prefix.
"""
import base64
import hashlib
import json
from pathlib import Path
import uuid


def run_python(camera, source, evidence_dir, timeout=25):
    evidence_dir=Path(evidence_dir)
    data=source.encode('utf-8')
    remote='/tmp/yi4k-py-'+uuid.uuid4().hex+'.py'
    digest=lambda value:hashlib.sha256(value).hexdigest()
    receipt={'path':remote,'bytes':len(data),'sha256':digest(data),'chunks':[],
             'created':False,'verified':False,'removed':False}
    candidates=[digest(b'')]
    try:
        raw=camera.command('python -c "import os; fd=os.open(\''+remote+\
                           "',os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600); os.close(fd); print('YI_PY_CREATED')\"",timeout=8)
        assert 'YI_PY_CREATED' in raw.splitlines(),'Temporary source creation not acknowledged'
        receipt['created']=True
        for offset in range(0,len(data),384):
            chunk=data[offset:offset+384]
            end=offset+len(chunk)
            payload=base64.b64encode(chunk).decode()
            candidates=[digest(data[:offset]),digest(data[:end])]
            command=("python -c \"import base64; f=open('"+remote+"','ab'); f.write(base64.b64decode('"+
                     payload+"')); n=f.tell(); f.close(); print('YI_PY_CHUNK '+str(n))\"")
            assert len(command)<900
            raw=camera.command(command,timeout=8)
            assert ('YI_PY_CHUNK '+str(end)) in raw.splitlines(),'Chunk acknowledgement missing'
            receipt['chunks'].append(end)
        command=("python -c \"import hashlib; assert hashlib.sha256(open('"+remote+
                 "','rb').read()).hexdigest()=='"+receipt['sha256']+"'; print('YI_PY_READY')\"")
        raw=camera.command(command,timeout=8)
        assert 'YI_PY_READY' in raw.splitlines(),'Source SHA-256 mismatch'
        receipt['verified']=True
        return camera.command('python -B -u '+remote,timeout=timeout)
    except BaseException as error:
        receipt['error']=repr(error)
        (evidence_dir/'transport-partial-output.txt').write_bytes(bytes(camera.buffer))
        raise
    finally:
        if receipt['created']:
            try:
                command=("python -c \"import os,stat,hashlib; p='"+remote+
                         "'; assert stat.S_ISREG(os.lstat(p).st_mode); assert hashlib.sha256(open(p,'rb').read()).hexdigest() in "+
                         repr(candidates)+"; os.unlink(p); print('YI_PY_REMOVED')\"")
                raw=camera.command(command,timeout=8)
                receipt['removed']='YI_PY_REMOVED' in raw.splitlines()
            except Exception as error:
                receipt['cleanup_error']=repr(error)
        (evidence_dir/'transport.json').write_text(json.dumps(receipt,indent=2)+'\n')
