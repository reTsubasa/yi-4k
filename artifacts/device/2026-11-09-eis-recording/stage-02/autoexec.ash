t ipc rpc clnt exec1 'touch /tmp/yi4k_rec_7f7a3fa2fbd5_begin'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
savebin c:\yi4k_rec_7f7a3fa2fbd5_fingerprint.bin 0xA0394BA0 l 8
savebin c:\yi4k_rec_7f7a3fa2fbd5_before.bin 0xA0757AF8 l 74
t ipc rpc clnt exec1 'python -B /tmp/SD0/yi4k_rec_7f7a3fa2fbd5.py prepare'
cd c:\yi4k_rec_7f7a3fa2fbd5_missing
if $?; then t ipc rpc clnt exec1 'touch /tmp/yi4k_rec_7f7a3fa2fbd5_bad'; fi
cd c:\yi4k_rec_7f7a3fa2fbd5_ready
if $?; then t ipc rpc clnt exec1 'touch /tmp/yi4k_rec_7f7a3fa2fbd5_good'; fi
cd c:\yi4k_rec_7f7a3fa2fbd5_ready
if $?; then t imgproc -eis 100 22 50; fi
cd c:\yi4k_rec_7f7a3fa2fbd5_ready
if $?; then t imgproc -eis 100 14 1; fi
cd c:\yi4k_rec_7f7a3fa2fbd5_ready
if $?; then t imgproc -eis 100 15 1; fi
cd c:\yi4k_rec_7f7a3fa2fbd5_ready
if $?; then t imgproc -eis 100 20 1; fi
cd c:\yi4k_rec_7f7a3fa2fbd5_ready
if $?; then savebin c:\yi4k_rec_7f7a3fa2fbd5_active.bin 0xA0757AF8 l 74; fi
cd c:\yi4k_rec_7f7a3fa2fbd5_ready
if $?; then t ipc rpc clnt exec1 'python -B /tmp/SD0/yi4k_rec_7f7a3fa2fbd5.py record'; fi
cd c:\yi4k_rec_7f7a3fa2fbd5_ready
if $?; then t imgproc -eis 100 20 0; fi
cd c:\yi4k_rec_7f7a3fa2fbd5_ready
if $?; then t imgproc -eis 100 15 0; fi
cd c:\yi4k_rec_7f7a3fa2fbd5_ready
if $?; then t imgproc -eis 100 14 0; fi
cd c:\yi4k_rec_7f7a3fa2fbd5_ready
if $?; then t imgproc -eis 100 22 0; fi
savebin c:\yi4k_rec_7f7a3fa2fbd5_after.bin 0xA0757AF8 l 74
cd c:\
t ipc rpc clnt exec1 'touch /tmp/yi4k_rec_7f7a3fa2fbd5_done'

