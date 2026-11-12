cv25_bld.files      = $${PWD}/bld/cv25_bld_linux_nand.elf
cv25_bld.files     += $${PWD}/bld/cv25_bld_linux_emmc.elf
cv25_bld.files     += $${PWD}/bld/cv25_bld_linux_stack.elf
cv25_bld.files     += $${PWD}/bld/cv25_bld_rtos_nand.elf
cv25_bld.files     += $${PWD}/bld/cv25_bld_rtos_emmc.elf
cv25_bld.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv25/bld
INSTALLS           += cv25_bld

cv25_ads.files      = $${PWD}/ads/cv25_ddr4_792MHz.ads
cv25_ads.files     += $${PWD}/ads/cv25_lpddr4_540MHz.ads
cv25_ads.files     += $${PWD}/ads/cv25bub_lpddr4_840MHz.ads
cv25_ads.files     += $${PWD}/ads/cv25m_ddr4_792MHz.ads
cv25_ads.files     += $${PWD}/ads/cv25m_lpddr4_540MHz.ads
cv25_ads.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv25/ads
INSTALLS           += cv25_ads

cv25_boards.files   = $${PWD}/boards/LINUX_CV25M_DDR4_NAND_792MHz.board
cv25_boards.files  += $${PWD}/boards/LINUX_CV25M_DDR4_EMMC_792MHz.board
cv25_boards.files  += $${PWD}/boards/LINUX_CV25M_LPDDR4_NAND_540MHz.board
cv25_boards.files  += $${PWD}/boards/LINUX_CV25M_LPDDR4_EMMC_540MHz.board
cv25_boards.files  += $${PWD}/boards/LINUX_CV25_DDR4_NAND_792MHz.board
cv25_boards.files  += $${PWD}/boards/LINUX_CV25_DDR4_EMMC_792MHz.board
cv25_boards.files  += $${PWD}/boards/LINUX_CV25_LPDDR4_NAND_540MHz.board
cv25_boards.files  += $${PWD}/boards/LINUX_CV25_LPDDR4_EMMC_540MHz.board
cv25_boards.files  += $${PWD}/boards/LINUX_CV25_LPDDR4_STACK_540MHz.board
cv25_boards.files  += $${PWD}/boards/RTOS_CV25_LPDDR4_NAND_840MHz.board
cv25_boards.files  += $${PWD}/boards/RTOS_CV25_LPDDR4_EMMC_840MHz.board
cv25_boards.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv25/boards
INSTALLS           += cv25_boards

cv25_conf.files     = $${PWD}/chip.conf
cv25_conf.path      = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv25
INSTALLS           += cv25_conf
