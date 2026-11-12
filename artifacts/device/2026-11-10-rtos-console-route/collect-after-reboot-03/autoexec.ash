t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
t ipc rpc clnt exec1 'sleep 3'
savebin c:\yi4k_diag_e30da2b76aa5_fingerprint.bin 0xA0394BA0 l 8
t ipc rpc clnt exec1 'python -B /tmp/SD0/yi4k_diag_e30da2b76aa5.py claim'
cd c:\yi4k_diag_e30da2b76aa5_ready
if $?; then savebin c:\yi4k_diag_e30da2b76aa5_pool1.bin 0xA0FD7114 l 48; fi
cd c:\yi4k_diag_e30da2b76aa5_ready
if $?; then savebin c:\yi4k_diag_e30da2b76aa5_va1.bin 0xA14307B8 l 220; fi
cd c:\yi4k_diag_e30da2b76aa5_ready
if $?; then ps mem > c:\yi4k_diag_e30da2b76aa5_mem.txt; fi
cd c:\yi4k_diag_e30da2b76aa5_ready
if $?; then ps tsk > c:\yi4k_diag_e30da2b76aa5_tsk1.txt; fi
cd c:\yi4k_diag_e30da2b76aa5_ready
if $?; then t app mem; fi
cd c:\yi4k_diag_e30da2b76aa5_ready
if $?; then t ipc rpc clnt exec1 'sleep 3'; fi
cd c:\yi4k_diag_e30da2b76aa5_ready
if $?; then savebin c:\yi4k_diag_e30da2b76aa5_pool2.bin 0xA0FD7114 l 48; fi
cd c:\yi4k_diag_e30da2b76aa5_ready
if $?; then savebin c:\yi4k_diag_e30da2b76aa5_va2.bin 0xA14307B8 l 220; fi
cd c:\yi4k_diag_e30da2b76aa5_ready
if $?; then ps tsk > c:\yi4k_diag_e30da2b76aa5_tsk2.txt; fi
cd c:\yi4k_diag_e30da2b76aa5_ready
if $?; then t ipc rpc clnt exec1 'python -B /tmp/SD0/yi4k_diag_e30da2b76aa5.py done'; fi
cd c:\

