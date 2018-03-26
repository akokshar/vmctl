#!/bin/bash

function send_command() {
	command=$1
	vm_name=$2
	
	/etc/qemu/qemu-vm-ctl.sh $command $vm_name
}

function for_each_vm() {
	func=$1
	command=$2
	for f in $(ls /run/qemu-vm-*.pid); do
		# remove longest sring with regex /*-
		# get filename without extention
		vm_name=$(basename ${f##/*-} .pid)
		$func $command $vm_name
	done
}

case $1 in
	pause)
		for_each_vm send_command "pause"
		;;
	resume)
		for_each_vm send_command "resume"
		;;
esac

