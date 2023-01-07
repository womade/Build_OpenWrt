#!/bin/bash

rm -rf target/linux package/kernel package/boot package/firmware/linux-firmware include/{kernel-*,netfilter.mk}
latest="$(curl -sfL https://github.com/openwrt/openwrt/commits/master/include | grep -o 'href=".*>kernel: bump 5.15' | head -1 | cut -d / -f 5 | cut -d '"' -f 1)"
latest=""
mkdir new; cp -rf .git new/.git
cd new
[ "$latest" ] && git reset --hard $latest || git reset --hard origin/master
git checkout HEAD^
[ "$(echo $(git log -1 --pretty=short) | grep "kernel: bump 5.15")" ] && git checkout $latest

cp -rf --parents target/linux package/kernel package/boot package/firmware/linux-firmware include/{kernel-*,netfilter.mk} ../
cd -

svn export --force https://github.com/openwrt/packages/trunk/kernel feeds/packages/kernel
svn export --force  https://github.com/openwrt/packages/trunk/net/xtables-addons feeds/packages/net/xtables-addons

svn co https://github.com/coolsnowwolf/lede/trunk/target/linux/generic/hack-5.15 target/linux/generic/hack-5.15
svn co https://github.com/coolsnowwolf/lede/trunk/target/linux/generic/backport-5.15 target/linux/generic/backport-5.15
find target/linux/generic/backport-5.15 -name "[0-9][0-9][0-9]-[a-z][a-z]*" -exec rm -f {} \;
rm -rf target/linux/generic/backport-5.15/802-v6.1-nvmem*

sed -i "s/tty\(0\|1\)::askfirst/tty\1::respawn/g" target/linux/*/base-files/etc/inittab

echo "
CONFIG_TESTING_KERNEL=y
CONFIG_PACKAGE_kmod-ipt-coova=n
CONFIG_PACKAGE_kmod-pf-ring=n
" >> devices/common/.config
