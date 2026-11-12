import os, stat, json
path = '/tmp/SD0/save_log_enable.script'
st = os.lstat(path)
assert stat.S_ISREG(st.st_mode) and st.st_size == 0, 'Refuse removal of modified marker'
os.unlink(path)
assert not os.path.lexists(path)
print('YI_LOG_MARKER_REMOVED')
