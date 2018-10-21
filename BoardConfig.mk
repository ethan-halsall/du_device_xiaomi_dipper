#
# Copyright (C) 2018 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from sdm845-common
-include device/xiaomi/sdm845-common/BoardConfigCommon.mk

DEVICE_PATH := device/xiaomi/dipper

# Assert
TARGET_OTA_ASSERT_DEVICE := dipper

# Kernel
TARGET_KERNEL_CONFIG := sphinx_defconfig

# NFC
TARGET_USES_NQ_NFC := true

# Face Unlock
TARGET_FACE_UNLOCK_CAMERA_ID := 5

# Inherit from the proprietary version
-include vendor/xiaomi/dipper/BoardConfigVendor.mk

# Sepolicy
BOARD_PLAT_PRIVATE_SEPOLICY_DIR += $(DEVICE_PATH)/sepolicy/private

# Vendor init
TARGET_INIT_VENDOR_LIB := libinit_dipper
TARGET_RECOVERY_DEVICE_MODULES := libinit_dipper
