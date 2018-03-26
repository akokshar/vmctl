#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_DIR=$(dirname ${SCRIPT})
DROP_IN_DIR=${SCRIPT%.*}.d

WAKEALARM=/sys/devices/pnp0/00:02/rtc/rtc0/wakealarm
DELAY=+4hours

function run_drop_ins() {
	if [ ! -d $DROP_IN_DIR ]; then
		return
	fi

	for s in $(ls $DROP_IN_DIR); do
		if [ -x ${DROP_IN_DIR}/${s} ]; then
			${DROP_IN_DIR}/$s $1
		fi
	done
}

case $1 in
	pause)
		echo Suspending ... 
		run_drop_ins "pause"
		ALARMTIME=$(date +%s -d${DELAY})
		echo ${ALARMTIME} > ${WAKEALARM}
		echo Alarm at ${DELAY}
		;;
	resume)
		ALARMTIME=$(cat ${WAKEALARM})
		NOW=$(date +%s)
		# wakealarm is cleared after alarming.
		# if empty, then it is passed so triggering hibernation.
		# FIXME: drop_ins will not execute on resuming from hibernation
		if [ -z ${ALARMTIME} ] || [ ${NOW} -ge ${ALARMTIME} ]; then
			echo "Yay! Hibernating..."
			systemctl hibernate
		else
			echo "Normal wakeup."
			run_drop_ins "resume"

			# FIXME:
			# if hibernated with display powered off, not switching it on after 
			# wakeup. 
			echo 0 | tee /sys/class/backlight/intel_backlight/bl_power
		fi
		echo 0 > ${WAKEALARM}
		echo Alarm is reset to zero.
		;;
esac
