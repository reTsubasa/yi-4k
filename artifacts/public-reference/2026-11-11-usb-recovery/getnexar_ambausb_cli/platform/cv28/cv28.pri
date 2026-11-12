cv28_bld.files      = $${PWD}/bld/cv28_bld_linux_nand.elf
cv28_bld.files     += $${PWD}/bld/cv28_bld_linux_emmc.elf
cv28_bld.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv28/bld
INSTALLS           += cv28_bld

cv28_ads.files      = $${PWD}/ads/cv28_lpddr4_540MHz.ads
cv28_ads.files     += $${PWD}/ads/cv28_ddr4_540MHz.ads
cv28_ads.files     += $${PWD}/ads/cv28_ddr4_540MHz_16Gb.ads
cv28_ads.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv28/ads
INSTALLS           += cv28_ads

cv28_boards.files   = $${PWD}/boards/LINUX_CV28_LPDDR4_NAND_540MHz.board
cv28_boards.files  += $${PWD}/boards/LINUX_CV28_LPDDR4_EMMC_540MHz.board
cv28_boards.files  += $${PWD}/boards/LINUX_CV28_DDR4_NAND_540MHz.board
cv28_boards.files  += $${PWD}/boards/LINUX_CV28_DDR4_EMMC_540MHz.board
cv28_boards.files  += $${PWD}/boards/LINUX_CV28_DDR4_EMMC_540MHz_16Gb.board
cv28_boards.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv28/boards
INSTALLS           += cv28_boards

cv28_conf.files     = $${PWD}/chip.conf
cv28_conf.path      = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv28
INSTALLS           += cv28_conf
