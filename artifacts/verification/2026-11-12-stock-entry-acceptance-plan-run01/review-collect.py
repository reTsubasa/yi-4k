import os,stat,json,hashlib,base64
spec=json.loads(base64.b64decode('eyJzY2hlbWEiOiAic3RvY2stZW50cnktYWNjZXB0YW5jZS1wbGFuL3YxIiwgImlkZW50aWZpZXIiOiAiNTM0NWE1ZWM3YzUyIiwgInBhdGhzIjogeyJzY3JpcHQiOiAiL3RtcC9TRDAvYXV0b2V4ZWMuYXNoIiwgImNsYWltIjogIi90bXAvU0QwL3lpNGtfZW50cnlfNTM0NWE1ZWM3YzUyX2NsYWltLmpzb24iLCAidGFza3MiOiAiL3RtcC9TRDAveWk0a19lbnRyeV81MzQ1YTVlYzdjNTJfdGFza3MudHh0IiwgImZpbmdlcnByaW50IjogIi90bXAvU0QwL3lpNGtfZW50cnlfNTM0NWE1ZWM3YzUyX2NvZGUuYmluIn0sICJzY3JpcHRfYmFzZTY0IjogImNITWdkSE5ySUQ0Z1l6cGNlV2swYTE5bGJuUnllVjgxTXpRMVlUVmxZemRqTlRKZmRHRnphM011ZEhoMENuTmhkbVZpYVc0Z1l6cGNlV2swYTE5bGJuUnllVjgxTXpRMVlUVmxZemRqTlRKZlkyOWtaUzVpYVc0Z01IaEJNRE01TkVKQk1DQnNJRGdLIiwgInNjcmlwdF9zaGEyNTYiOiAiZWNjMTI3ZjE3Y2YxZmQ5ZDE4ODExMjg1N2RhNGUzMzJlYjNlM2YyMGY5ZTliMjM0NWNiZDhhOTgyNzYzOGRkNCIsICJjbGFpbV9iYXNlNjQiOiAiZXdvZ0lDSnBaR1Z1ZEdsbWFXVnlJam9nSWpVek5EVmhOV1ZqTjJNMU1pSXNDaUFnSW1sdFlXZGxYM05vWVRJMU5pSTZJQ0psWldVME5HTTJZelV6TURFNE0yVmpaVEZsTXpnM01tTmlNMlU0T1RVNE9URTVZVGxoWVRReE9EazFNemc1T1dSaVpXRTRZams0T0RrNU9EY3pPREZqSWl3S0lDQWliM2R1WlhKemFHbHdJam9nSW1WNFkyeDFjMmwyWlNCdVlXMWxjM0JoWTJVZ1kyeGhhVzBnYjI1c2VUc2dibTkwSUdFZ2NuVnVkR2x0WlNCdmJtTmxJSFJ2YTJWdUlpd0tJQ0FpY0dGMGFITWlPaUI3Q2lBZ0lDQWlZMnhoYVcwaU9pQWlMM1J0Y0M5VFJEQXZlV2swYTE5bGJuUnllVjgxTXpRMVlUVmxZemRqTlRKZlkyeGhhVzB1YW5OdmJpSXNDaUFnSUNBaVptbHVaMlZ5Y0hKcGJuUWlPaUFpTDNSdGNDOVRSREF2ZVdrMGExOWxiblJ5ZVY4MU16UTFZVFZsWXpkak5USmZZMjlrWlM1aWFXNGlMQW9nSUNBZ0luTmpjbWx3ZENJNklDSXZkRzF3TDFORU1DOWhkWFJ2WlhobFl5NWhjMmdpTEFvZ0lDQWdJblJoYzJ0eklqb2dJaTkwYlhBdlUwUXdMM2xwTkd0ZlpXNTBjbmxmTlRNME5XRTFaV00zWXpVeVgzUmhjMnR6TG5SNGRDSUtJQ0I5TEFvZ0lDSnpZMmhsYldFaU9pQWljM1J2WTJzdFpXNTBjbmt0YzNSaFoyVXRZMnhoYVcwdmRqRWlMQW9nSUNKelkzSnBjSFJmYzJoaE1qVTJJam9nSW1Wall6RXlOMll4TjJObU1XWmtPV1F4T0RneE1USTROVGRrWVRSbE16TXlaV0l6WlRObU1qQm1PV1U1WWpJek5EVmpZbVE0WVRrNE1qYzJNemhrWkRRaUNuMEsiLCAiY2xhaW1fc2hhMjU2IjogIjViNmU4MTY3ZWM5ODMwZTc0MjFkZWY1YTY0OWMzOTdmMTJmZjA4N2YyZTRjYmY3YjlhNjJmZjVjNzQxNjE5YzQiLCAiZXhwZWN0ZWRfY29kZV9oZXgiOiAiMDMwMGEwZTExZWZmMmZlMSIsICJib290X2lkX3BhdGgiOiAiL3Byb2Mvc3lzL2tlcm5lbC9yYW5kb20vYm9vdF9pZCIsICJ1cHRpbWVfcGF0aCI6ICIvcHJvYy91cHRpbWUiLCAibWF4X2ZpbGVfYnl0ZXMiOiA2NTUzNn0='))
paths=spec['paths']
def digest(data): return hashlib.sha256(data).hexdigest()
def snapshot():
 result={}
 for key,path in sorted(paths.items()):
  if not os.path.lexists(path): result[key]={'present':False};continue
  st=os.lstat(path)
  assert stat.S_ISREG(st.st_mode) and st.st_size<=spec['max_file_bytes'], 'Unexpected type/size: '+key
  with open(path,'rb') as f: data=f.read(spec['max_file_bytes']+1)
  assert len(data)==st.st_size, 'File changed during read: '+key
  result[key]={'present':True,'bytes':len(data),'sha256':digest(data),'base64':base64.b64encode(data).decode('ascii')}
 return result
def validate_owned(result):
 for key in ('claim','script'):
  if result[key]['present']:
   assert result[key]['sha256']==spec[key+'_sha256'], 'Ownership mismatch: '+key
def emit(value): print('YI_STOCK_ENTRY '+json.dumps(value,sort_keys=True))
result=snapshot();validate_owned(result)
assert result['claim']['present'], 'Ownership claim missing'
emit({'action':'collect','boot_id':open(spec['boot_id_path']).read().strip(),'uptime':open(spec['uptime_path']).read().strip(),'snapshot':result,'removed_files':False})
