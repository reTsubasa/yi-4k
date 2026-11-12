import os, stat, subprocess, tempfile, signal, hashlib, json, base64
def deadline(signum, frame):
    raise RuntimeError('Log capture deadline')
signal.signal(signal.SIGALRM, deadline)
signal.alarm(25)
path = tempfile.mkdtemp(prefix='yi4k-rtos-logs-', dir='/tmp')
mounted = False
try:
    rc = subprocess.call(['mount','-t','ambafs','-o','ro','b:',path])
    assert rc == 0, 'b: mount failed'
    mounted = True
    print('YI_RTOS_LOG_MOUNT ' + path)
    for name in ('RtosActive.log', 'RtosOlder.log', 'RtosOldest.log'):
        source = path + '/' + name
        if not os.path.exists(source):
            print('YI_RTOS_LOG_MISSING ' + name)
            continue
        before = os.stat(source)
        assert stat.S_ISREG(before.st_mode), 'Not a regular file'
        assert 0 <= before.st_size <= 8388608, 'Log exceeds 8 MiB limit'
        digest = hashlib.sha256()
        copied = 0
        with open(source, 'rb') as file:
            while copied < before.st_size:
                data = file.read(min(32768, before.st_size - copied))
                assert data, 'File truncated during capture'
                digest.update(data)
                copied += len(data)
                print('YI_RTOS_LOG_DATA ' + name + ' ' + base64.b64encode(data))
        after = os.stat(source)
        print('YI_RTOS_LOG_META ' + json.dumps({'name':name, 'source':'b:/'+name,
            'bytes':copied, 'size_before':before.st_size, 'size_after':after.st_size,
            'mtime_before':before.st_mtime, 'mtime_after':after.st_mtime,
            'sha256':digest.hexdigest()}))
finally:
    signal.alarm(0)
    if mounted:
        rc = subprocess.call(['umount',path])
        print('YI_RTOS_LOG_UNMOUNT ' + str(rc))
        if rc == 0:
            os.rmdir(path)
    else:
        os.rmdir(path)
print('YI_RTOS_LOG_DONE')
