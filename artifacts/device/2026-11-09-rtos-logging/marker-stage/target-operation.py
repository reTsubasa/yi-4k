import os, stat, json
path = '/tmp/SD0/save_log_enable.script'
fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0600)
os.close(fd)
st = os.lstat(path)
assert stat.S_ISREG(st.st_mode) and st.st_size == 0
print('YI_LOG_MARKER_CREATED ' + json.dumps({'size': st.st_size, 'inode': st.st_ino, 'mtime': st.st_mtime}))
