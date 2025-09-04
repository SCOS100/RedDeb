#!/bin/sh
set -e
echo "RedDeb Build Script"
if [ "$(uname -m)" != "aarch64" ]; then echo "Please build on device. (Check \"Building/Why On Device?\" for more info)"; fi
if [ "$(whoami)" != "root" ]; then echo "Please run as root."; exit 1; fi
if [ ! -e ./README.md ]; then echo "Please only run this script inside the project folder."; exit 1; fi
echo

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
		DEVICE_NAME="$(read_info DeviceInfo Codename)"
		DEVICE_ARCH="$(read_info DeviceInfo Arch)"
	fi
done

if [ ! -e /dev/loop37 ]; then
	echo "Wrong /dev configuration (Read \"Building/Setting up the build environment\")"
	exit 1
fi

echo "Please insert an exFat formatted SD-Card with at least 9GB of storage available and press any key to continue..."
read -n1 -s
mount -t devtmpfs none mnt/dev
fsck.exfat mnt/dev/mmcblk0p1
mount -t exfat -o rw mnt/dev/mmcblk0p1 mnt/sdcard || wrong_sdcard
if [ ! -e mnt/sdcard/reddeb.img ]; then
	echo "Creating and mounting disk..."
	dd if=/dev/zero of=mnt/sdcard/reddeb.img bs=1024MB count=8 status=progress
	mkfs.ext4 mnt/sdcard/reddeb.img
	mount mnt/sdcard/reddeb.img mnt/rootfs

	ALPINE_RELEASE="$(curl -s https://mirror.csclub.uwaterloo.ca/alpine/edge/releases/aarch64/ | grep "2025" | grep "minirootfs" | sed '/alpha/d' | sed '/sha/d' | head -n1 | cut -d\" -f2 | cut -d- -f3)"
	echo "Building Alpine..."
	distrobuilder build-dir res/alpine.yaml mnt/rootfs -o image.serial=$ALPINE_RELEASE -o image.architecture=$DEVICE_ARCH -o image.release=edge
	cp -r $DEVICE_PATH/kernel/* mnt/rootfs
	echo
	chroot mnt/rootfs usr/bin/env - /usr/sbin/adduser reddeb
	echo "reddeb ALL=(ALL:ALL) ALL" >>mnt/rootfs/etc/sudoers
	cp -r devices/additions/* mnt/rootfs
	chroot mnt/rootfs usr/bin/env - /sbin/rc-update add adbd default
	echo
	sync mnt/rootfs/*
	umount mnt/rootfs
else
	echo "Disk image already exists, skipping..."
fi

cp $DEVICE_PATH/installer.zip mnt/sdcard
sync mnt/sdcard/*
umount mnt/sdcard
umount mnt/dev

echo "Done."