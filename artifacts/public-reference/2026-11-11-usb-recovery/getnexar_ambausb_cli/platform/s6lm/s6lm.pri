s6lm_bld.files   = $${PWD}/bld/s6lm_bld_nand.elf
s6lm_bld.files  += $${PWD}/bld/s6lm_bld_emmc.elf
s6lm_bld.files  += $${PWD}/bld/s6lm_bld_stack.elf
s6lm_bld.files  += $${PWD}/bld/h32_bld.bin
s6lm_bld.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s6lm/bld
INSTALLS        += s6lm_bld

s6lm_ads.files   = $${PWD}/ads/s6lm_ddr4_588MHz.ads
s6lm_ads.files  += $${PWD}/ads/s6lm_ddr4_792MHz.ads
s6lm_ads.files  += $${PWD}/ads/s6lm_lpddr4_792MHz.ads
s6lm_ads.files  += $${PWD}/ads/s6lm_lpddr4_540MHz.ads
s6lm_ads.files  += $${PWD}/ads/h32_lpddr4_396MHz.ads
s6lm_ads.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s6lm/ads
INSTALLS        += s6lm_ads

s6lm_boards.files   = $${PWD}/boards/S6Lm_DDR4_NAND_588MHz.board
s6lm_boards.files  += $${PWD}/boards/S6Lm_DDR4_EMMC_588MHz.board
s6lm_boards.files  += $${PWD}/boards/S6Lm_DDR4_STACK_588MHz.board
s6lm_boards.files  += $${PWD}/boards/S6Lm_DDR4_NAND_792MHz.board
s6lm_boards.files  += $${PWD}/boards/S6Lm_DDR4_EMMC_792MHz.board
s6lm_boards.files  += $${PWD}/boards/S6Lm_DDR4_STACK_792MHz.board
s6lm_boards.files  += $${PWD}/boards/S6Lm_LPDDR4_NAND_792MHz.board
s6lm_boards.files  += $${PWD}/boards/S6Lm_LPDDR4_EMMC_792MHz.board
s6lm_boards.files  += $${PWD}/boards/S6Lm_LPDDR4_NAND_540MHz.board
s6lm_boards.files  += $${PWD}/boards/S6Lm_LPDDR4_EMMC_540MHz.board
s6lm_boards.files  += $${PWD}/boards/RTOS_H32_LPDDR4_396MHz.board
s6lm_boards.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s6lm/boards
INSTALLS           += s6lm_boards

s6lm_conf.files = $${PWD}/chip.conf
s6lm_conf.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s6lm/
INSTALLS  += s6lm_conf
