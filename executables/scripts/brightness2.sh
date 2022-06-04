#!/bin/bash

base=/sys/class/backlight/intel_backlight
cur=$(<$base/brightness)
max=$(<$base/max_brightness)
min=0
step=10

case $1 in
	up|increase|+) cur=$(($cur + $step)) ;;
	down|decrease|-) cur=$(($cur - $step)) ;;
	check) ;;
	*) echo "USAGE: $0 [ up | down | check ]"; exit 1 ;;
esac

[[ $cur -gt $max ]] && echo "Backlight at maximum" && exit 1
[[ $cur -lt $min ]] && echo "Backlight at minimum" && exit 1

echo $cur | sudo tee $base/brightness
