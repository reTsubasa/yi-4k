s3_bld.files  = $${PWD}/bld/s3_bld_nand.bin
s3_bld.files += $${PWD}/bld/s3_bld_emmc.bin
s3_bld.files += $${PWD}/bld/s3_bld_spinor.bin
s3_bld.files += $${PWD}/bld/h1_bld_nand.bin
s3_bld.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s3/bld
INSTALLS     += s3_bld

s3_ads.files  = $${PWD}/ads/s3_ddr3.ads
s3_ads.files += $${PWD}/ads/s3_lpddr3_micron_EDF8132A3MAJDFD.ads
s3_ads.files += $${PWD}/ads/s3_lpddr3_hynix_H9CCNNN8GTMLAR.ads
s3_ads.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s3/ads
INSTALLS     += s3_ads

s3_boards.files  = $${PWD}/boards/S3_DDR3_NAND.board
s3_boards.files += $${PWD}/boards/S3_DDR3_EMMC.board
s3_boards.files += $${PWD}/boards/S3_DDR3_SPINOR.board
s3_boards.files += $${PWD}/boards/S3_LPDDR3-Hynix-H9CCNNN8GTMLAR_NAND.board
s3_boards.files += $${PWD}/boards/S3_LPDDR3-Hynix-H9CCNNN8GTMLAR_EMMC.board
s3_boards.files += $${PWD}/boards/S3_LPDDR3-Hynix-H9CCNNN8GTMLAR_SPINOR.board
s3_boards.files += $${PWD}/boards/S3_LPDDR3-Micron-EDF8132A3MAJDFD_NAND.board
s3_boards.files += $${PWD}/boards/S3_LPDDR3-Micron-EDF8132A3MAJDFD_EMMC.board
s3_boards.files += $${PWD}/boards/S3_LPDDR3-Micron-EDF8132A3MAJDFD_SPINOR.board
s3_boards.files += $${PWD}/boards/H1_DDR3_NAND.board
s3_boards.files += $${PWD}/boards/H1_LPDDR3-Micron-EDF8132A3MAJDFD_NAND.board
s3_boards.files += $${PWD}/boards/H1_LPDDR3-Hynix-H9CCNNN8GTMLAR_NAND.board

s3_boards.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s3/boards
INSTALLS        += s3_boards

s3_conf.files  = $${PWD}/chip.conf
s3_conf.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s3
INSTALLS      += s3_conf
