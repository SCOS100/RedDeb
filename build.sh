#!/bin/sh
set -e
if [ "$(uname -m)" != "aarch64" ]; then echo "Please build on device. (Check \"Building/Why On Device?\" for more info)"; fi
if [ "$(whoami)" != "root" ]; then echo "Please run as root."; exit 1; fi
if [ ! -e ./README.md ]; then echo "Please only run this script inside the project folder."; exit 1; fi

read_info() {
	awk -v section="[$1]" '$0 == section { in_section=1; next } in_section && NF == 0 { exit } in_section { print }' $SOC_PATH/$DEVICE/info | grep "^$2" | cut -d= -f2
}

wrong_sdcard() {
	echo "Your SD-Card is wrong, yay! It's supposed to be exFat, but it's something else."
	echo "I cannot proceed automatically, but the wiki does a better job explaining it than I do in this shell script."
	echo
	echo "Please read \"Installing/Preparing the SD-Card\" for more details."
	exit 1
}

SOC_ID="$(cat /sys/devices/soc0/soc_id)"
SOC_FAMILY="$(cat /sys/devices/soc0/family)"
SOC_PATH=devices/$SOC_FAMILY/$SOC_ID

if [ ! -e $SOC_PATH ]; then echo "Sorry! This SOC is not available for RedDeb at this time."; exit 1; fi
echo "Detected a $SOC_FAMILY device of ID $SOC_ID."
while [ -z "$DEVICE_PATH" ]; do
	echo "Devices available for this SOC are: $(ls --color=none ./$SOC_PATH)"
	echo
	echo -n "Please choose one and press enter: "
	read DEVICE
	while [ ! -e $SOC_PATH/$DEVICE/info ]; do
		echo "Device Invalid!"
		echo -n "Please choose one and press enter: "
		read DEVICE
	done
	echo
	echo -n "Name: "; read_info "DeviceInfo" "MarketName"
	echo -n "SOC: "; read_info "DeviceInfo" "SOCName"
	echo -n "Arch: "; read_info "DeviceInfo" "Arch"
	echo -n "Type: "; read_info "RedDeb" "Type"
	echo -n "Is this the correct device? (y/n): "
	read -n2 choice
	echo
	if [ "$choice" = "y" ]; then
		DEVICE_PATH=$SOC_PATH/$DEVICE
		DEVICE_ARCH="$(read_info "DeviceInfo" "Arch")"
	fi
done

## Setup Disk ##
echo "Creating and mounting disk..."
truncate --size=8GB tmp/reddeb.img
mkfs.ext4 tmp/reddeb.img
mount tmp/reddeb.img mnt/rootfs
## End Setup Disk ##

## Build System ##
ALPINE_RELEASE="$(curl -s https://mirror.csclub.uwaterloo.ca/alpine/edge/releases/aarch64/ | grep "2025" | grep "minirootfs" | sed '/alpha/d' | sed '/sha/d' | head -n1 | cut -d\" -f2 | cut -d- -f3)"
echo "Building Alpine..."
distrobuilder build-dir res/alpine.yaml mnt/rootfs -o image.serial=$ALPINE_RELEASE -o image.architecture=$DEVICE_ARCH -o image.release=edge

cp -r $DEVICE_PATH/kernel/* mnt/rootfs

echo

chroot mnt/rootfs usr/bin/env - /usr/sbin/adduser reddeb

cp -r devices/additions/* mnt/rootfs

chroot mnt/rootfs usr/bin/env - /sbin/rc-update add adbd default
## End Build System ##

## Copy Files ##
sync mnt/rootfs/*
umount mnt/rootfs

echo "Please insert an exFat formatted SD-Card with at least 9GB of storage available and press any key to continue..."
read -n1 -s

mount -t devtmpfs none mnt/dev
fsck.exfat mnt/dev/mmcblk0p1
mount -t exfat -o rw mnt/dev/mmcblk0p1 mnt/sdcard || wrong_sdcard

cp tmp/reddeb.img mnt/sdcard
## End Copy Files ##

umount mnt/sdcard
umount mnt/dev

echo "The main build finished successfully!"