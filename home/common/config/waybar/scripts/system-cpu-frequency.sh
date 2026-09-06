#!/bin/sh

c=0
t=0

awk '/MHz/ {print $4}' < /proc/cpuinfo | while read -r i; do
    t=$(echo "$t + $i" | bc)
    c=$((c + 1))
    echo "$t $c" > /tmp/system-cpu-frequency.$$ 
done

if [ -f /tmp/system-cpu-frequency.$$ ]; then
    read -r t c < /tmp/system-cpu-frequency.$$
    rm -f /tmp/system-cpu-frequency.$$
fi

if [ -n "$c" ] && [ "$c" -gt 0 ] 2>/dev/null; then
    echo "scale=2; $t / $c / 1000" | bc | awk '{printf " %.2f GHz\n", $0}'
else
    echo " 0.00 GHz"
fi