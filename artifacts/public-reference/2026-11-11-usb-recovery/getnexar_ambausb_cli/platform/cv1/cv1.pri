cv1_bld.files      = $${PWD}/bld/cv1_bld_rtos.bin
cv1_bld.files     += $${PWD}/bld/cv1_bld_linux_nand.elf
cv1_bld.files     += $${PWD}/bld/cv1_bld_linux_emmc.elf
cv1_bld.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv1/bld
INSTALLS          += cv1_bld

cv1_ads.files      = $${PWD}/ads/cv1_lpddr4_1200MHz.ads
cv1_ads.files     += $${PWD}/ads/cv1_lpddr4_1416MHz.ads
cv1_ads.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv1/ads
INSTALLS          += cv1_ads

cv1_boards.files   = $${PWD}/boards/RTOS_CV1_LPDDR4_NAND.board
cv1_boards.files  += $${PWD}/boards/RTOS_CV1_LPDDR4_NAND_SC3.board
cv1_boards.files  += $${PWD}/boards/RTOS_CV1_LPDDR4_EMMC.board
cv1_boards.files  += $${PWD}/boards/LINUX_CV1_LPDDR4_NAND.board
cv1_boards.files  += $${PWD}/boards/LINUX_CV1_LPDDR4_EMMC.board
cv1_boards.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv1/boards
INSTALLS          += cv1_boards

cv1_conf.files     = $${PWD}/chip.conf
cv1_conf.path      = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv1
INSTALLS          += cv1_conf
