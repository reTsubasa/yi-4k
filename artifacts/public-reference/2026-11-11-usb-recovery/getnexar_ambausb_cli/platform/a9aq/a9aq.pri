a9aq_bld.files = $${PWD}/bld/a9aq_bld_nand.bin
a9aq_bld.path  = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/a9aq/bld
INSTALLS      += a9aq_bld

a9aq_ads.files  = $${PWD}/ads/a9aq_ddr3_600MHz.ads
a9aq_ads.files += $${PWD}/ads/a9aqb_ddr3_216MHz.ads
a9aq_ads.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/a9aq/ads
INSTALLS       += a9aq_ads

a9aq_boards.files  = $${PWD}/boards/A9AQ_DDR3_NAND.board
a9aq_boards.files += $${PWD}/boards/A9AQB_DDR3_NAND.board
a9aq_boards.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/a9aq/boards
INSTALLS          += a9aq_boards

a9aq_conf.files   = $${PWD}/chip.conf
a9aq_conf.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/a9aq
INSTALLS         += a9aq_conf
