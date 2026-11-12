cv3_ust.files      = $${PWD}/ust/cv3_lpddr5_540MHz.ust
cv3_ust.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv3/ust
INSTALLS          += cv3_ust

cv3_bld.files      = $${PWD}/bld/cv3_bld_linux.elf
cv3_bld.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv3/bld
INSTALLS          += cv3_bld

cv3_boards.files   = $${PWD}/boards/LINUX_CV3_LPDDR5_540MHz.board
cv3_boards.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv3/boards
INSTALLS          += cv3_boards

cv3_conf.files     = $${PWD}/chip.conf
cv3_conf.path      = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv3
INSTALLS          += cv3_conf
