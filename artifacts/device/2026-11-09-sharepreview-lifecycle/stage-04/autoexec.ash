t ipc rpc clnt exec1 'touch /tmp/yi4k_sharepv_6ab59d77355b_begin'
t app test sharepv init
t ipc rpc clnt exec1 'touch /tmp/yi4k_sharepv_6ab59d77355b_init_after'
t ipc rpc clnt exec1 'python /tmp/SD0/yi4k_sharepv_6ab59d77355b_rpc.py init'
t app test sharepv en
t ipc rpc clnt exec1 'touch /tmp/yi4k_sharepv_6ab59d77355b_enable_after'
t ipc rpc clnt exec1 'python /tmp/SD0/yi4k_sharepv_6ab59d77355b_rpc.py enable'
t app test sharepv dis
t ipc rpc clnt exec1 'touch /tmp/yi4k_sharepv_6ab59d77355b_disable_after'
t ipc rpc clnt exec1 'python /tmp/SD0/yi4k_sharepv_6ab59d77355b_rpc.py disable'
t ipc rpc clnt exec1 'touch /tmp/yi4k_sharepv_6ab59d77355b_done'
