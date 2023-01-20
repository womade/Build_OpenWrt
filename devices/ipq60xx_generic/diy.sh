#!/bin/bash
shopt -s extglob

rm -rf package/system/opkg && mv -f feeds/womade/opkg package/system/
rm -rf package/feeds/womade/{firewall,rtl*,nft-fullcone,fullconenat} package/kernel/mt76 toolchain/musl

rm -rf target/imagebuilder
svn co https://github.com/openwrt/openwrt/branches/openwrt-22.03/target/imagebuilder target/imagebuilder

rm -rf toolchain/musl
svn co https://github.com/openwrt/openwrt/branches/openwrt-22.03/toolchain/musl toolchain/musl

svn co https://github.com/coolsnowwolf/openwrt-gl-ax1800/trunk/package/network/services/fullconenat feeds/womade/fullconenat

rm -rf devices/common/patches/{targets.patch,kernel-defaults.patch,fix.patch,iptables.patch,disable_flock.patch}


