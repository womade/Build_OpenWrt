#!/bin/bash

shopt -s extglob

SHELL_FOLDER=$(dirname $(readlink -f "$0"))

kernel_v="$(cat include/kernel-version.mk | grep LINUX_KERNEL_HASH-4.* | cut -f 2 -d - | cut -f 1 -d ' ')"
echo "KERNEL=${kernel_v}" >> $GITHUB_ENV || true
sed -i "s?targets/%S/.*'?targets/%S/$kernel_v'?" include/feeds.mk

rm -rf target/linux/ipq807x package/network/wifi-ax
svn co https://github.com/Telecominfraproject/wlan-ap/trunk/feeds/ipq807x target/linux/ipq807x
svn co https://github.com/Telecominfraproject/wlan-ap/trunk/feeds/wifi-ax package/network/wifi-ax

rm -rf devices/common/patches/{glinet,imagebuilder.patch,iptables.patch,kernel-defaults.patch}


