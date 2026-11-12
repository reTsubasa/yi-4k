cv2_bld.files      = $${PWD}/bld/cv2_bld_linux_nand.elf
cv2_bld.files     += $${PWD}/bld/cv2_bld_linux_emmc.elf
cv2_bld.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv2/bld
INSTALLS           += cv2_bld

cv2_ads.files      = $${PWD}/ads/cv2_lpddr4_420MHz.ads
cv2_ads.files     += $${PWD}/ads/cv2_lpddr4_420MHz_rtos.ads
cv2_ads.files     += $${PWD}/ads/cv2_lpddr4_408MHz.ads
cv2_ads.files     += $${PWD}/ads/cv2_lpddr4_396MHz.ads
cv2_ads.files     += $${PWD}/ads/cv2_dk_lpddr4_408MHz.ads
cv2_ads.path       = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv2/ads
INSTALLS           += cv2_ads

cv2_boards.files   = $${PWD}/boards/LINUX_CV2_LPDDR4_NAND.board
cv2_boards.files  += $${PWD}/boards/LINUX_CV2_LPDDR4_EMMC.board
cv2_boards.files  += $${PWD}/boards/RTOS_CV2_LPDDR4_NAND.board
cv2_boards.files  += $${PWD}/boards/RTOS_CV2_LPDDR4_NAND_408MHz.board
cv2_boards.files  += $${PWD}/boards/RTOS_CV2_LPDDR4_EMMC.board
cv2_boards.files  += $${PWD}/boards/RTOS_CV2_LPDDR4_EMMC_408MHz.board
cv2_boards.files  += $${PWD}/boards/RTOS_CV2_LPDDR4_NAND_SC5.board
cv2_boards.files  += $${PWD}/boards/RTOS_CV2_LPDDR4_NAND_DK.board
cv2_boards.path    = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv2/boards
INSTALLS           += cv2_boards

cv2_conf.files     = $${PWD}/chip.conf
cv2_conf.path      = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv2
INSTALLS           += cv2_conf
