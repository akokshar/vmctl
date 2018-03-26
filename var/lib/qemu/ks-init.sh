#!/bin/bash

if [ -z $1 ]; then
    echo "usage $0 <image-file>"
    exit 1
fi

/usr/local/bin/vmctl-ifup qemu0 ks
qemu-system-x86_64 \
	-enable-kvm  \
	-m 4096 \
	-net nic,model=virtio \
	-net tap,ifname=ks,script=no,downscript=no \
	-drive file=$1,format=raw,if=virtio,aio=native,cache.direct=on \
	-cdrom /home/lex/Downloads/ubuntu-16.04.3-desktop-amd64.iso \
	-boot once=d \
	-vga qxl \
	-device virtio-serial-pci \
	-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
	-chardev spicevmc,id=spicechannel0,name=vdagent \
	-spice unix,addr=/tmp/test-spice.sock,disable-ticketing \
	-monitor unix:/tmp/test-monitor.sock,server,nowait

#	-serial unix:/tmp/test-serial.sock,server,nowait \
#	-nographic
#	-drive file=$1,format=qcow2,if=virtio,aio=native,cache.direct=on,l2-cache-size=2M \
#	-cdrom Fedora-Workstation-netinst-x86_64-27_Beta-1.5.iso \
#	-fda ks.flp \
#	-vga qxl \
#	-device virtio-serial-pci \

/usr/local/bin/vmctl-ifdown qemu0 ks
