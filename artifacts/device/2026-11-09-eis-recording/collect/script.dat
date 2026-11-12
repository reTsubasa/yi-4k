t ipc rpc clnt exec1 'touch /tmp/yi4k_rec_19310d5edeeb_begin'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
savebin c:\yi4k_rec_19310d5edeeb_fingerprint.bin 0xA0394BA0 l 8
savebin c:\yi4k_rec_19310d5edeeb_before.bin 0xA0757AF8 l 74
t ipc rpc clnt exec1 'python -B /tmp/SD0/yi4k_rec_19310d5edeeb.py prepare'
if cd c:\yi4k_rec_19310d5edeeb_missing; then t ipc rpc clnt exec1 'touch /tmp/yi4k_rec_19310d5edeeb_bad'; fi
if cd c:\yi4k_rec_19310d5edeeb_ready; then t imgproc -eis 100 22 50; fi
if cd c:\yi4k_rec_19310d5edeeb_ready; then t imgproc -eis 100 14 1; fi
if cd c:\yi4k_rec_19310d5edeeb_ready; then t imgproc -eis 100 15 1; fi
if cd c:\yi4k_rec_19310d5edeeb_ready; then t imgproc -eis 100 20 1; fi
if cd c:\yi4k_rec_19310d5edeeb_ready; then savebin c:\yi4k_rec_19310d5edeeb_active.bin 0xA0757AF8 l 74; fi
if cd c:\yi4k_rec_19310d5edeeb_ready; then t ipc rpc clnt exec1 'python -B /tmp/SD0/yi4k_rec_19310d5edeeb.py record'; fi
if cd c:\yi4k_rec_19310d5edeeb_ready; then t imgproc -eis 100 20 0; fi
if cd c:\yi4k_rec_19310d5edeeb_ready; then t imgproc -eis 100 15 0; fi
if cd c:\yi4k_rec_19310d5edeeb_ready; then t imgproc -eis 100 14 0; fi
if cd c:\yi4k_rec_19310d5edeeb_ready; then t imgproc -eis 100 22 0; fi
savebin c:\yi4k_rec_19310d5edeeb_after.bin 0xA0757AF8 l 74
cd c:\
t ipc rpc clnt exec1 'touch /tmp/yi4k_rec_19310d5edeeb_done'

