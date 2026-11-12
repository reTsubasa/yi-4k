s2l_bld.files  = $${PWD}/bld/s2l_bld_nand.elf
s2l_bld.files += $${PWD}/bld/s2l_bld_emmc.elf
s2l_bld.files += $${PWD}/bld/s2l_bld_spinor.elf
s2l_bld.files += $${PWD}/bld/s2l_bld_spinor_spansion.elf
s2l_bld.files += $${PWD}/bld/s2lm_bld_nand.elf
s2l_bld.files += $${PWD}/bld/s2lm_bld_emmc.elf
s2l_bld.files += $${PWD}/bld/s2lm_bld_spinor.elf
s2l_bld.files += $${PWD}/bld/s2lm_bld_spinor_spansion.elf
s2l_bld.files += $${PWD}/bld/a12_bld_emmc.bin
s2l_bld.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s2l/bld
INSTALLS      += s2l_bld

s2l_ads.files  = $${PWD}/ads/s2lm_ddr3.ads
s2l_ads.files += $${PWD}/ads/s2l_ddr3.ads
s2l_ads.files += $${PWD}/ads/a12_ddr3.ads
s2l_ads.files += $${PWD}/ads/a12_lpddr3.ads
s2l_ads.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s2l/ads
INSTALLS      += s2l_ads

s2l_boards.files  = $${PWD}/boards/S2L_DDR3_NAND.board
s2l_boards.files += $${PWD}/boards/S2L_DDR3_EMMC.board
s2l_boards.files += $${PWD}/boards/S2L_DDR3_SPINOR.board
s2l_boards.files += $${PWD}/boards/S2L_DDR3_SPINOR_SPANSION.board
s2l_boards.files += $${PWD}/boards/S2Lm_DDR3_NAND.board
s2l_boards.files += $${PWD}/boards/S2Lm_DDR3_EMMC.board
s2l_boards.files += $${PWD}/boards/S2Lm_DDR3_SPINOR.board
s2l_boards.files += $${PWD}/boards/S2Lm_DDR3_SPINOR_SPANSION.board
s2l_boards.files += $${PWD}/boards/A12_DDR3_NAND.board
s2l_boards.files += $${PWD}/boards/A12_LPDDR3_EMMC.board
s2l_boards.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s2l/boards
INSTALLS         += s2l_boards

s2l_conf.files = $${PWD}/chip.conf
s2l_conf.path  = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s2l
INSTALLS      += s2l_conf
