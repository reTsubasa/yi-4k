t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
savebin c:\yi4k_diag_0fc5406a4c7f_fingerprint.bin 0xA0394BA0 l 8
t ipc rpc clnt exec1 'python -B /tmp/SD0/yi4k_diag_0fc5406a4c7f.py claim'
if cd c:\yi4k_diag_0fc5406a4c7f_ready; then savebin c:\yi4k_diag_0fc5406a4c7f_pool1.bin 0xA0FD7114 l 48; fi
if cd c:\yi4k_diag_0fc5406a4c7f_ready; then savebin c:\yi4k_diag_0fc5406a4c7f_va1.bin 0xA14307B8 l 220; fi
if cd c:\yi4k_diag_0fc5406a4c7f_ready; then ps mem > c:\yi4k_diag_0fc5406a4c7f_mem.txt; fi
if cd c:\yi4k_diag_0fc5406a4c7f_ready; then ps tsk > c:\yi4k_diag_0fc5406a4c7f_tsk1.txt; fi
if cd c:\yi4k_diag_0fc5406a4c7f_ready; then t app mem; fi
if cd c:\yi4k_diag_0fc5406a4c7f_ready; then t ipc rpc clnt exec1 'sleep 3'; fi
if cd c:\yi4k_diag_0fc5406a4c7f_ready; then savebin c:\yi4k_diag_0fc5406a4c7f_pool2.bin 0xA0FD7114 l 48; fi
if cd c:\yi4k_diag_0fc5406a4c7f_ready; then savebin c:\yi4k_diag_0fc5406a4c7f_va2.bin 0xA14307B8 l 220; fi
if cd c:\yi4k_diag_0fc5406a4c7f_ready; then ps tsk > c:\yi4k_diag_0fc5406a4c7f_tsk2.txt; fi
if cd c:\yi4k_diag_0fc5406a4c7f_ready; then t ipc rpc clnt exec1 'python -B /tmp/SD0/yi4k_diag_0fc5406a4c7f.py done'; fi
cd c:\

