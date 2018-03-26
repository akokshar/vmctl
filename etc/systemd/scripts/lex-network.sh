#!/usr/bin/bash

set -x

DNSMASQ_IF=dnsmasq0
DNSMASQ_ADDR=172.17.0.3/32

QEMU_BR=qemu0
QEMU_ADDR=172.17.0.1/24

case $1 in
	start)
		# create and configure interface for dnsmasq
		#/usr/sbin/ip tuntap add dev ${DNSMASQ_IF} mode tap
		#/usr/sbin/ip addr add dev ${DNSMASQ_IF} ${DNSMASQ_ADDR}
		#/usr/sbin/ip link set dev ${DNSMASQ_IF} up

		#create bridge for qemu
		/usr/sbin/ip link add dev ${QEMU_BR} type bridge
		/usr/sbin/ip addr add dev ${QEMU_BR} ${QEMU_ADDR}
		/usr/sbin/ip link set dev ${QEMU_BR} up
		;;
	stop)
		# do not need to clean up anything
		# since service is not supposed to be stopped.
		;;
esac

