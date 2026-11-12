cv72_ust.files      = $${PWD}/ust/cv72_lpddr5_540MHz.ust
cv72_ust.files     += $${PWD}/ust/cv72_lpddr4_540MHz.ust
cv72_ust.files     += $${PWD}/ust/cv72_lpddr4_540MHz_single_rank.ust
cv72_ust.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv72/ust
INSTALLS           += cv72_ust

cv72_bld.files      = $${PWD}/bld/cv72_bld_linux.elf
cv72_bld.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv72/bld
INSTALLS           += cv72_bld

cv72_boards.files   = $${PWD}/boards/LINUX_CV72_LPDDR4_540MHz.board
cv72_boards.files  += $${PWD}/boards/LINUX_CV72_LPDDR5_540MHz.board
cv72_boards.files  += $${PWD}/boards/LINUX_CV72_LPDDR4_540MHz_SINGLE_RANK.board
cv72_boards.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv72/boards
INSTALLS           += cv72_boards

cv72_conf.files     = $${PWD}/chip.conf
cv72_conf.path      = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv72
INSTALLS           += cv72_conf
