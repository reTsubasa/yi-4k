import os, subprocess, tempfile, json
path = tempfile.mkdtemp(prefix='yi4k-rtos-logs-', dir='/tmp')
print('YI_LOG_MOUNT_PATH ' + path)
result = subprocess.call(['mount','-t','ambafs','-o','ro','b:',path])
print('YI_LOG_MOUNT_RC ' + str(result))
if result == 0:
    print('YI_LOG_FILES ' + json.dumps([{'name':n,'bytes':os.stat(path+'/'+n).st_size} for n in os.listdir(path)]))
    print('YI_LOG_MOUNT_CONFIRMED')
else:
    os.rmdir(path)
