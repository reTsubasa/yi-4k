cv2fs_bld.files     = $${PWD}/bld/cv2fs_bld_linux_nand.elf
cv2fs_bld.files    += $${PWD}/bld/cv2fs_bld_rtos_emmc.elf
cv2fs_bld.path      = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv2fs/bld
INSTALLS           += cv2fs_bld

cv2fs_ads.files     = $${PWD}/ads/cv2fs_boot.ads
cv2fs_ads.files    += $${PWD}/ads/cv2fs_lpddr4_816MHz.ads
cv2fs_ads.path      = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv2fs/ads
INSTALLS           += cv2fs_ads

cv2fs_boards.files  = $${PWD}/boards/LINUX_CV2FS_LPDDR4_NAND.board
cv2fs_boards.files += $${PWD}/boards/RTOS_CV2FS_LPDDR4_EMMC.board
cv2fs_boards.files += $${PWD}/boards/LINUX_CV2XFS_LPDDR4_NAND.board
cv2fs_boards.files += $${PWD}/boards/RTOS_CV2XFS_LPDDR4_EMMC.board
cv2fs_boards.path   = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv2fs/boards
INSTALLS           += cv2fs_boards

cv2fs_conf.files    = $${PWD}/chip.conf
cv2fs_conf.path     = $${DATA_DIR}/$${APP_NAME}-$${APP_VERSION}/platform/cv2fs
INSTALLS           += cv2fs_conf
