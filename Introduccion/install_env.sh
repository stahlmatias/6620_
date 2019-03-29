#!/bin/bash

command -v wget >/dev/null 2>&1 || { echo >&2 "It is required wget but it's not installed. Installing..."; sudo apt-get install wget; }

command -v qemu-system-mips >/dev/null 2>&1 || { echo >&2 "Installing qemu-system-mips..."; sudo apt-get install qemu-system-mips; }

echo "Downloading Debian-MIPS..."
wget http://ftp.debian.org/debian/dists/stable/main/installer-mips/current/images/malta/netboot/initrd.gz

wget http://ftp.debian.org/debian/dists/stable/main/installer-mips/current/images/malta/netboot/vmlinux-4.9.0-8-4kc-malta

echo "Creating QEMU image file..."
qemu-img create -f qcow2 hda.img 2G

echo "Installing Debian-MIPS..."
qemu-system-mips -M malta -m 256 -hda hda.img -kernel vmlinux-4.9.0-8-4kc-malta -initrd initrd.gz -append "console=ttyS0 nokaslr" -nographic

echo "Copying over Kernel initrd.img file..."
sudo modprobe nbd max_part=63
sudo qemu-nbd -c /dev/nbd0 hda.img
sudo mount /dev/nbd0p1 /mnt
cp -r /mnt/boot/initrd.img-4.9.0-8-4kc-malta .
sudo umount /mnt
sudo qemu-nbd -d /dev/nbd0

echo "Done..."
