t ipc rpc clnt exec1 'touch /tmp/yi4k_trace_f1f114115096_begin'
savebin c:\yi4k_trace_f1f114115096_code.bin 0xA0394BA0 l 8
savebin c:\yi4k_trace_f1f114115096_before.bin 0xA0757AF8 l 74
t imgproc -eis 100 22 50
t imgproc -eis 100 14 1
t imgproc -eis 100 15 1
t imgproc -eis 100 20 1
savebin c:\yi4k_trace_f1f114115096_active.bin 0xA0757AF8 l 74
t ipc rpc clnt exec1 'python -B /tmp/SD0/yi4k_trace_f1f114115096.py'
t imgproc -eis 100 20 0
t imgproc -eis 100 15 0
t imgproc -eis 100 14 0
t imgproc -eis 100 22 0
savebin c:\yi4k_trace_f1f114115096_after.bin 0xA0757AF8 l 74
t ipc rpc clnt exec1 'touch /tmp/yi4k_trace_f1f114115096_done'

