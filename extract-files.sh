#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/bin/hw/android.hardware.biometrics.fingerprint@2.1-fpcservice)
            sed -i 's|/firmware/image|/vendor/f/image|' "${2}"
            "${PATCHELF}" --replace-needed "libhidlbase.so" "libhidlbase-v32.so"
            ;;

        vendor/lib/hw/camera.msm8937.so)
            "${PATCHELF}" --set-soname "camera.msm8937.so" "${2}"
            ;;

        vendor/lib/com.fingerprints.extension@1.0_vendor.so)
            "${PATCHELF}" --remove-needed "android.hidl.base@1.0.so" "${2}"
            ;;

        vendor/lib/libactuator_dw9767_truly.so)
            "${PATCHELF}" --set-soname "libactuator_dw9767_truly.so" "${2}"
            ;;

        vendor/lib/libDepthBokehEffect.so)
            "${PATCHELF}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
            ;;

        vendor/lib/libDepthBokehEffect2.so)
            "${PATCHELF}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
            ;;

        vendor/lib/libmmcamera2_pproc_modules.so)
            sed -i "s/ro.product.manufacturer/ro.product.nopefacturer/" "${2}"
            sed -i 's|msm8953_mot_deen_camera.xml|msm8937_mot_camera_conf.xml|g' "${2}"
            ;;

        vendor/lib/libmmcamera_ppeiscore.so)
            sed -i "s/libgui/libwui/" "${2}"
            "${PATCHELF}" --add-needed "libppeiscore_shim.so" "${2}"
            ;;

        vendor/lib/libmmcamera_hdr_gb_lib.so)
            "${PATCHELF}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
            ;;

        vendor/lib/liboptizoom.so)
            "${PATCHELF}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
            ;;

        vendor/lib/libseemore.so)
            "${PATCHELF}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
            ;;

        vendor/lib/libtrueportrait.so)
            "${PATCHELF}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
            ;;

        vendor/lib/libubifocus.so)
            "${PATCHELF}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
            ;;

        vendor/etc/init/android.hardware.biometrics.fingerprint@2.1-service.rc)
            sed -i "s/system input/system uhid input/" "${2}"
            sed -i "s/class late_start/class hal/" "${2}"
            ;;
    esac
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export BOARD_COMMON=msm8937-common
export DEVICE=cedric
export VENDOR=motorola

"./../../${VENDOR}/${BOARD_COMMON}/extract-files.sh" "$@"
