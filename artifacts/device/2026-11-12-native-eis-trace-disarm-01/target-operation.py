import os,stat,hashlib,json,base64,subprocess
probe = json.loads(base64.b64decode((
    'eyJpZGVudGlmaWVyIjogIjBkZTY5MzA2Y2M5YSIsICJwYXRocyI6IHsic2NyaXB0IjogIi90bXAvU0QwL2F1dG9leGVjLmFzaCIsICJ3b3JrZXIiOiAiL3RtcC9TRDAv'
    'eWk0a190cmFjZV8wZGU2OTMwNmNjOWEucHkiLCAibG9nX21hcmtlciI6ICIvdG1wL1NEMC9zYXZlX2xvZ19lbmFibGUuc2NyaXB0IiwgImJlZm9yZSI6ICIvdG1wL1NE'
    'MC95aTRrX3RyYWNlXzBkZTY5MzA2Y2M5YV9iZWZvcmUuYmluIiwgImFjdGl2ZSI6ICIvdG1wL1NEMC95aTRrX3RyYWNlXzBkZTY5MzA2Y2M5YV9hY3RpdmUuYmluIiwg'
    'ImFmdGVyIjogIi90bXAvU0QwL3lpNGtfdHJhY2VfMGRlNjkzMDZjYzlhX2FmdGVyLmJpbiIsICJmaW5nZXJwcmludCI6ICIvdG1wL1NEMC95aTRrX3RyYWNlXzBkZTY5'
    'MzA2Y2M5YV9jb2RlLmJpbiIsICJyZWNvcmQiOiAiL3RtcC9TRDAveWk0a190cmFjZV8wZGU2OTMwNmNjOWFfcmVjb3JkLmpzb24iLCAiYXR0ZW1wdCI6ICIvdG1wL1NE'
    'MC95aTRrX3RyYWNlXzBkZTY5MzA2Y2M5YV9hdHRlbXB0IiwgImJlZ2luIjogIi90bXAveWk0a190cmFjZV8wZGU2OTMwNmNjOWFfYmVnaW4iLCAiZG9uZSI6ICIvdG1w'
    'L3lpNGtfdHJhY2VfMGRlNjkzMDZjYzlhX2RvbmUifSwgImZpZWxkcyI6IHsiMTQiOiAxLCAiMTUiOiAxLCAiMjAiOiAxLCAiMjIiOiA1MH0sICJwYXlsb2FkX3NoYTI1'
    'NiI6IHsic2NyaXB0IjogIjZjZWRhMjY5NWY1ZTU2YmE1YmIxYjI0NmMzYmQxY2NjNzgzODk0MTNiZGQ0NjlkZWRlMjVmNGVmZmMwY2MwNmUiLCAid29ya2VyIjogImNi'
    'ZGVlYWNiZmUyYTdkNzBhZjE0YmIzNjE4YzgwYWFhMGIwMmUxYWMwMDgzNzNjZWQ2YTg4ZDAxNjMzMDZiMGIiLCAibG9nX21hcmtlciI6ICJlM2IwYzQ0Mjk4ZmMxYzE0'
    'OWFmYmY0Yzg5OTZmYjkyNDI3YWU0MWU0NjQ5YjkzNGNhNDk1OTkxYjc4NTJiODU1In19'
)))
keys=('script','worker','log_marker')
for key in keys:
    path=probe['paths'][key]
    st=os.lstat(path)
    assert stat.S_ISREG(st.st_mode), 'Modified configuration type: '+key
    assert hashlib.sha256(open(path,'rb').read()).hexdigest()==probe['payload_sha256'][key], 'Modified configuration: '+key
for key in keys:os.unlink(probe['paths'][key])
subprocess.check_call(['sync'])
assert all(not os.path.lexists(probe['paths'][key]) for key in keys)
print('YI_TRACE_RESULT '+json.dumps({'owned_configuration_removed':True,'runtime_flags_verified':False,'evidence_retained':True}))
