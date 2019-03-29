#!/bin/bash

qemu-system-mips -M malta -m 256 -hda hda.img -kernel vmlinux-4.9.0-8-4kc-malta -initrd initrd.img-4.9.0-8-4kc-malta -append "root=/dev/sda1 console=ttyS0 nokaslr" -nographic -device e1000-82545em,netdev=user.0 -netdev user,id=user.0,hostfwd=tcp::5555-:22

