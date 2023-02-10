#!/bin/bash

shopt -s extglob

SHELL_FOLDER=$(dirname $(readlink -f "$0"))

rm -rf package/feeds
./scripts/feeds install -a -p gl_feed_mtk -f
./scripts/feeds install -a -p gl_feed_common -f
./scripts/feeds install -a -p gl_feed_21_02 -f
./scripts/feeds install -a -p womade -f
./scripts/feeds install -a

rm -rf package/feeds/womade/{firewall,rtl*,base-files,netifd}

rm -rf devices/common/patches/{imagebuilder.patch,fix.patch,iptables.patch,targets.patch,kernel-defaults.patch,disable_flock.patch}

sed -i "s/BOARD:=mediatek$/BOARD:=mediatek_gl/" target/linux/mediatek/Makefile

mv -f target/linux/mediatek target/linux/mediatek_gl

rm -rf toolchain/musl

svn co https://github.com/openwrt/openwrt/branches/openwrt-22.03/toolchain/musl toolchain/musl


sed -i "/gl_feed_mtk/d" feeds.conf
sed -i "/gl_feed_common/d" feeds.conf
sed -i "/gl_feed_21_02/d" feeds.conf


