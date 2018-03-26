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
	-boot c \
	-device virtio-serial-pci,id=virtio-serial0 \
	-chardev socket,id=guestagent0,path=/tmp/test-agent.sock,server,nowait \
	-device virtserialport,chardev=guestagent0,name=org.qemu.guest_agent.0 \
	-monitor unix:/tmp/test-monitor.sock,server,nowait \
	-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
	-chardev spicevmc,id=spicechannel0,name=vdagent \
	-spice unix,addr=/tmp/test-spice.sock,disable-ticketing \
	-nographic 
	#-serial unix:/tmp/test-serial.sock,server,nowait \
	#-vga qxl \

#	-device virtio-serial-pci \
#	-cdrom /home/lex/Downloads/Fedora-Server-dvd-x86_64-26-1.5.iso \
	#-fda ks.flp \
	#-cdrom rhel-server-7.4-x86_64-dvd.iso \

/usr/local/bin/vmctl-ifdown qemu0 ks
