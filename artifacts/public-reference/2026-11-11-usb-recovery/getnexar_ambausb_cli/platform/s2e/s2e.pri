s2e_bld.files  = $${PWD}/bld/s2e_bld_nand.bin
s2e_bld.files += $${PWD}/bld/s2e_bld_emmc.bin
s2e_bld.files += $${PWD}/bld/a9s_bld_nand.bin
s2e_bld.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s2e/bld
INSTALLS       += s2e_bld

s2e_ads.files  = $${PWD}/ads/s2e_ddr3.ads
s2e_ads.files += $${PWD}/ads/s2e_lpddr3_micron_EDF8132A3MAJDFD.ads
s2e_ads.files += $${PWD}/ads/s2e_lpddr3_micron_MT29UZ4B8DZZHGPB.ads
s2e_ads.files += $${PWD}/ads/s2e_lpddr3_hynix_H9CCNNN8GTMLAR.ads
s2e_ads.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s2e/ads
INSTALLS       += s2e_ads

s2e_boards.files  = $${PWD}/boards/S2E_DDR3_NAND.board
s2e_boards.files += $${PWD}/boards/S2E_DDR3_EMMC.board

s2e_boards.files += $${PWD}/boards/S2E_LPDDR3-Micron-EDF8132A3MAJDFD_NAND.board
s2e_boards.files += $${PWD}/boards/S2E_LPDDR3-Micron-EDF8132A3MAJDFD_EMMC.board

s2e_boards.files += $${PWD}/boards/S2E_LPDDR3-Hynix-H9CCNNN8GTMLAR_NAND.board
s2e_boards.files += $${PWD}/boards/S2E_LPDDR3-Hynix-H9CCNNN8GTMLAR_EMMC.board

s2e_boards.files += $${PWD}/boards/S2E_LPDDR3-Micron-MT29UZ4B8DZZHGPB_NAND.board
s2e_boards.files += $${PWD}/boards/S2E_LPDDR3-Micron-MT29UZ4B8DZZHGPB_EMMC.board

s2e_boards.files += $${PWD}/boards/A9s_DDR3_NAND.board
s2e_boards.files += $${PWD}/boards/A9s_LPDDR3-Hynix-H9CCNNN8GTMLAR_NAND.board
s2e_boards.files += $${PWD}/boards/A9s_LPDDR3-Micron-EDF8132A3MAJDFD_NAND.board
s2e_boards.files += $${PWD}/boards/A9s_LPDDR3-Micron-MT29UZ4B8DZZHGPB_NAND.board

s2e_boards.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s2e/boards
INSTALLS       += s2e_boards

s2e_conf.files += $${PWD}/chip.conf
s2e_conf.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/s2e
INSTALLS       += s2e_conf
