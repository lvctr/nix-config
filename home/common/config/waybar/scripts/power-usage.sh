#!/bin/sh

power_file=$(printf '%s\n' /sys/class/hwmon/hwmon*/power1_input | head -n1)

if [ -r "$power_file" ]; then
    echo "$(( $(cat "$power_file") / 1000000 )) W"
else
    echo "0 W"
fi