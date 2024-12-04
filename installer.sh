#!/bin/bash

# Variables
DEBIAN_MIRROR="http://deb.debian.org/debian"
DEBIAN_RELEASE="bullseye"
DEBIAN_ARCH="amd64"
TARGET_DIR="/home/container/debian_bullseye"
TARGET_FS_DIR="$TARGET_DIR/rootfs"

# Dependencies
echo "Installing dependencies..."
apt-get update && apt-get install -y debootstrap proot wget curl

# Create a directory for the Debian environment
echo "Creating directory for Debian Bullseye installation..."
mkdir -p $TARGET_FS_DIR

# Use debootstrap to install Debian Bullseye in the directory
echo "Installing Debian Bullseye..."
debootstrap --arch=$DEBIAN_ARCH $DEBIAN_RELEASE $TARGET_FS_DIR $DEBIAN_MIRROR

# Mount necessary filesystems (proc, sys, dev)
echo "Mounting necessary filesystems..."
mount -t proc /proc $TARGET_FS_DIR/proc
mount -t sysfs /sys $TARGET_FS_DIR/sys
mount -o bind /dev $TARGET_FS_DIR/dev
mount -o bind /dev/pts $TARGET_FS_DIR/dev/pts
mount -o bind /run $TARGET_FS_DIR/run

# Enter the Debian environment with proot
echo "Entering Debian 11 Bullseye environment using proot..."
proot -S $TARGET_FS_DIR /bin/bash

# Clean up - unmount everything after exiting the proot environment
echo "Unmounting filesystems..."
umount $TARGET_FS_DIR/proc
umount $TARGET_FS_DIR/sys
umount $TARGET_FS_DIR/dev/pts
umount $TARGET_FS_DIR/dev
umount $TARGET_FS_DIR/run

echo "Debian 11 Bullseye setup is complete. Exited the proot environment."

