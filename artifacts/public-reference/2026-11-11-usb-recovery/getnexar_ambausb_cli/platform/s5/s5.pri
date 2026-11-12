s5_bld.files   = $${PWD}/bld/s5_bld_nand.elf
s5_bld.files  += $${PWD}/bld/s5_bld_emmc.elf
s5_bld.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s5/bld
INSTALLS      += s5_bld

s5_ads.files   = $${PWD}/ads/s5_lpddr3.ads
s5_ads.files  += $${PWD}/ads/s5_ddr3.ads
s5_ads.files  += $${PWD}/ads/s5_16Gb_lpddr3_336MHz.ads
s5_ads.files  += $${PWD}/ads/s5_16Gb_ddr3_336MHz.ads
s5_ads.files  += $${PWD}/ads/s5_8Gb_ddr3_336MHz.ads
s5_ads.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s5/ads
INSTALLS      += s5_ads

s5_boards.files   = $${PWD}/boards/S5_LPDDR3_NAND_16Gb.board
s5_boards.files  += $${PWD}/boards/S5_LPDDR3_EMMC_16Gb.board
s5_boards.files  += $${PWD}/boards/S5_DDR3_NAND_16Gb.board
s5_boards.files  += $${PWD}/boards/S5_DDR3_EMMC_16Gb.board
s5_boards.files  += $${PWD}/boards/S5_DDR3_NAND_8Gb.board
s5_boards.files  += $${PWD}/boards/S5_DDR3_EMMC_8Gb.board
s5_boards.files  += $${PWD}/boards/H2_LPDDR3_NAND.board
s5_boards.files  += $${PWD}/boards/H2_LPDDR3_EMMC.board
s5_boards.files  += $${PWD}/boards/H2_DDR3_NAND.board
s5_boards.files  += $${PWD}/boards/H2_DDR3_EMMC.board
s5_boards.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s5/boards
INSTALLS         += s5_boards

s5_conf.files = $${PWD}/chip.conf
s5_conf.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s5/
INSTALLS  += s5_conf
