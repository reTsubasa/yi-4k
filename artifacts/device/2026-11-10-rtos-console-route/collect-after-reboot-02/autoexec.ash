t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
savebin c:\yi4k_diag_5c12b7b27033_fingerprint.bin 0xA0394BA0 l 8
t ipc rpc clnt exec1 'python -B /tmp/SD0/yi4k_diag_5c12b7b27033.py claim'
if cd c:\yi4k_diag_5c12b7b27033_ready; then savebin c:\yi4k_diag_5c12b7b27033_pool1.bin 0xA0FD7114 l 48; fi
if cd c:\yi4k_diag_5c12b7b27033_ready; then savebin c:\yi4k_diag_5c12b7b27033_va1.bin 0xA14307B8 l 220; fi
if cd c:\yi4k_diag_5c12b7b27033_ready; then ps mem > c:\yi4k_diag_5c12b7b27033_mem.txt; fi
if cd c:\yi4k_diag_5c12b7b27033_ready; then ps tsk > c:\yi4k_diag_5c12b7b27033_tsk1.txt; fi
if cd c:\yi4k_diag_5c12b7b27033_ready; then t app mem; fi
if cd c:\yi4k_diag_5c12b7b27033_ready; then t ipc rpc clnt exec1 'sleep 3'; fi
if cd c:\yi4k_diag_5c12b7b27033_ready; then savebin c:\yi4k_diag_5c12b7b27033_pool2.bin 0xA0FD7114 l 48; fi
if cd c:\yi4k_diag_5c12b7b27033_ready; then savebin c:\yi4k_diag_5c12b7b27033_va2.bin 0xA14307B8 l 220; fi
if cd c:\yi4k_diag_5c12b7b27033_ready; then ps tsk > c:\yi4k_diag_5c12b7b27033_tsk2.txt; fi
if cd c:\yi4k_diag_5c12b7b27033_ready; then t ipc rpc clnt exec1 'python -B /tmp/SD0/yi4k_diag_5c12b7b27033.py done'; fi
cd c:\

