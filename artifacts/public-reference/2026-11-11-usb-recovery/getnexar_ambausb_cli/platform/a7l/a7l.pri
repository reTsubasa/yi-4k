a7l_bld.files  = $${PWD}/bld/bld.bin
a7l_bld.files += $${PWD}/bld/ambhal.bin
a7l_bld.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/a7l/bld
INSTALLS      += a7l_bld

a7l_ads.files  = $${PWD}/ads/a7l_ddr3.ads
a7l_ads.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/a7l/ads
INSTALLS      += a7l_ads

a7l_boards.files  = $${PWD}/boards/A7L_DDR3_NAND.board
a7l_boards.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/a7l/boards
INSTALLS         += a7l_boards

a7l_conf.files = $${PWD}/chip.conf
a7l_conf.path  = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/a7l
INSTALLS      += a7l_conf
