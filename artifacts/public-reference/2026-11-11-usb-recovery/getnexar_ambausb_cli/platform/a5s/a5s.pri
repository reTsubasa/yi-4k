a5s_bld.files  = $${PWD}/bld/bld.bin
a5s_bld.files += $${PWD}/bld/bld_a5s.bin
a5s_bld.files += $${PWD}/bld/ambhal.bin
a5s_bld.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/a5s/bld
INSTALLS      += a5s_bld

a5s_ads.files  = $${PWD}/ads/a5s_ddr2.ads
a5s_ads.files += $${PWD}/ads/a5s_ddr3.ads
a5s_ads.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/a5s/ads
INSTALLS      += a5s_ads

a5s_boards.files  = $${PWD}/boards/A5s_DDR2_NAND.board
a5s_boards.files += $${PWD}/boards/A5s_DDR3_NAND.board
a5s_boards.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/a5s/boards
INSTALLS         += a5s_boards

a5s_conf.files = $${PWD}/chip.conf
a5s_conf.path  = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/a5s
INSTALLS      += a5s_conf
