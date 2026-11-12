s2_bld.files  = $${PWD}/bld/bld_nand.bin
s2_bld.files += $${PWD}/bld/bld_emmc.bin
s2_bld.files += $${PWD}/bld/ambhal.bin
s2_bld.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s2/bld
INSTALLS     += s2_bld

s2_ads.files = $${PWD}/ads/s2_ddr3.ads
s2_ads.path  = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s2/ads
INSTALLS    += s2_ads

s2_boards.files  = $${PWD}/boards/S2_DDR3_NAND.board
s2_boards.files += $${PWD}/boards/S2_DDR3_EMMC.board
s2_boards.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s2/boards
INSTALLS       += s2_boards

s2_conf.files += $${PWD}/chip.conf
s2_conf.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s2
INSTALLS += s2_conf
