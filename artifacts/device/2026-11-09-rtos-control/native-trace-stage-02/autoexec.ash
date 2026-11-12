t ipc rpc clnt exec1 'touch /tmp/yi4k_trace_217af7548a88_begin'
savebin c:\yi4k_trace_217af7548a88_code.bin 0xA0394BA0 l 8
savebin c:\yi4k_trace_217af7548a88_before.bin 0xA0757AF8 l 74
t imgproc -eis 100 22 50
t imgproc -eis 100 14 1
t imgproc -eis 100 15 1
t imgproc -eis 100 20 1
savebin c:\yi4k_trace_217af7548a88_active.bin 0xA0757AF8 l 74
t ipc rpc clnt exec1 'python -B /tmp/SD0/yi4k_trace_217af7548a88.py'
t imgproc -eis 100 20 0
t imgproc -eis 100 15 0
t imgproc -eis 100 14 0
t imgproc -eis 100 22 0
savebin c:\yi4k_trace_217af7548a88_after.bin 0xA0757AF8 l 74
t ipc rpc clnt exec1 'touch /tmp/yi4k_trace_217af7548a88_done'

