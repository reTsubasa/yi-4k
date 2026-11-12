cv5_ust.files      = $${PWD}/ust/cv5_lpddr5_540MHz.ust
cv5_ust.files     += $${PWD}/ust/cv5_lpddr4_540MHz.ust
cv5_ust.files     += $${PWD}/ust/cv52_ddrc0_lpddr5_540MHz.ust
cv5_ust.files     += $${PWD}/ust/cv52_ddrc0_lpddr4_540MHz.ust
cv5_ust.files     += $${PWD}/ust/cv52_ddrc1_lpddr5_540MHz.ust
cv5_ust.files     += $${PWD}/ust/cv52_ddrc1_lpddr4_540MHz.ust
cv5_ust.files     += $${PWD}/ust/cv5_single_rank_lpddr5_540MHz.ust
cv5_ust.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv5/ust
INSTALLS          += cv5_ust

cv5_bld.files      = $${PWD}/bld/cv5_bld_linux.elf
cv5_bld.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv5/bld
INSTALLS          += cv5_bld

cv5_boards.files   = $${PWD}/boards/LINUX_CV5_LPDDR5_540MHz.board
cv5_boards.files  += $${PWD}/boards/LINUX_CV5_LPDDR4_540MHz.board
cv5_boards.files  += $${PWD}/boards/LINUX_CV52_DDRC0_LPDDR5_540MHz.board
cv5_boards.files  += $${PWD}/boards/LINUX_CV52_DDRC0_LPDDR4_540MHz.board
cv5_boards.files  += $${PWD}/boards/LINUX_CV52_DDRC1_LPDDR5_540MHz.board
cv5_boards.files  += $${PWD}/boards/LINUX_CV52_DDRC1_LPDDR4_540MHz.board
cv5_boards.files  += $${PWD}/boards/LINUX_CV5_SINGLE_RANK_LPDDR5_540MHz.board
cv5_boards.files  += $${PWD}/boards/RTOS_CV5_LPDDR5_540MHz.board
cv5_boards.files  += $${PWD}/boards/RTOS_CV5DK_LPDDR5_540MHz.board
cv5_boards.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv5/boards
INSTALLS          += cv5_boards

cv5_conf.files     = $${PWD}/chip.conf
cv5_conf.path      = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv5
INSTALLS          += cv5_conf
