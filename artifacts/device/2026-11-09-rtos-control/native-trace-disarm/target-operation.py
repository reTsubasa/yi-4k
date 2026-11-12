import os,stat,hashlib,json,base64,subprocess
probe = json.loads(base64.b64decode((
    'eyJpZGVudGlmaWVyIjogImYxZjExNDExNTA5NiIsICJwYXRocyI6IHsic2NyaXB0IjogIi90bXAvU0QwL2F1dG9leGVjLmFzaCIsICJ3b3JrZXIiOiAiL3RtcC9TRDAv'
    'eWk0a190cmFjZV9mMWYxMTQxMTUwOTYucHkiLCAibG9nX21hcmtlciI6ICIvdG1wL1NEMC9zYXZlX2xvZ19lbmFibGUuc2NyaXB0IiwgImJlZm9yZSI6ICIvdG1wL1NE'
    'MC95aTRrX3RyYWNlX2YxZjExNDExNTA5Nl9iZWZvcmUuYmluIiwgImFjdGl2ZSI6ICIvdG1wL1NEMC95aTRrX3RyYWNlX2YxZjExNDExNTA5Nl9hY3RpdmUuYmluIiwg'
    'ImFmdGVyIjogIi90bXAvU0QwL3lpNGtfdHJhY2VfZjFmMTE0MTE1MDk2X2FmdGVyLmJpbiIsICJmaW5nZXJwcmludCI6ICIvdG1wL1NEMC95aTRrX3RyYWNlX2YxZjEx'
    'NDExNTA5Nl9jb2RlLmJpbiIsICJyZWNvcmQiOiAiL3RtcC9TRDAveWk0a190cmFjZV9mMWYxMTQxMTUwOTZfcmVjb3JkLmpzb24iLCAiYXR0ZW1wdCI6ICIvdG1wL1NE'
    'MC95aTRrX3RyYWNlX2YxZjExNDExNTA5Nl9hdHRlbXB0IiwgImJlZ2luIjogIi90bXAveWk0a190cmFjZV9mMWYxMTQxMTUwOTZfYmVnaW4iLCAiZG9uZSI6ICIvdG1w'
    'L3lpNGtfdHJhY2VfZjFmMTE0MTE1MDk2X2RvbmUifSwgImZpZWxkcyI6IHsiMTQiOiAxLCAiMTUiOiAxLCAiMjAiOiAxLCAiMjIiOiA1MH0sICJwYXlsb2FkX3NoYTI1'
    'NiI6IHsic2NyaXB0IjogImU2ZTgzNTllYmM0Nzg3YTZiZGEzN2I1NzFkMjZlMDQzMzg4ODQ3ZjIwMWY4MTNjYTUxZDFhNTYzZDc3YTE5YmMiLCAid29ya2VyIjogIjJh'
    'NmM4OTVmYzM5NjllZTcyMTFhZjAyYzM5ZDFiZTlhNmFhYmEzMmJkYzlhODQzNjJhMjFmN2FlNWFhYmJhZjEiLCAibG9nX21hcmtlciI6ICJlM2IwYzQ0Mjk4ZmMxYzE0'
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
