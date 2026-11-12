cv22_bld.files      = $${PWD}/bld/cv22_bld_linux_nand.elf
cv22_bld.files     += $${PWD}/bld/cv22_bld_linux_emmc.elf
cv22_bld.files     += $${PWD}/bld/cv22_bld_linux_stack.elf
cv22_bld.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv22/bld
INSTALLS           += cv22_bld

cv22_ads.files      = $${PWD}/ads/cv22_lpddr4_408MHz.ads
cv22_ads.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv22/ads
INSTALLS           += cv22_ads

cv22_boards.files   = $${PWD}/boards/LINUX_CV22_LPDDR4_NAND.board
cv22_boards.files  += $${PWD}/boards/LINUX_CV22_LPDDR4_EMMC.board
cv22_boards.files  += $${PWD}/boards/LINUX_CV22_LPDDR4_STACK.board
cv22_boards.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv22/boards
INSTALLS           += cv22_boards

cv22_conf.files     = $${PWD}/chip.conf
cv22_conf.path      = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv22
INSTALLS           += cv22_conf
