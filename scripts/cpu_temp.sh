#!/bin/bash

# for zone in /sys/class/thermal/thermal_zone*/; do 
#   type=$(cat "$zone/type" 2>/dev/null)
#   if [[ "$type" == *"pkg"* ]] || [[ "$type" == *"x86"* ]] || [[ "$type" == *"cpu"* ]]; then 
#     cat "$zone/temp" 2>/dev/null | awk '{printf "%.0f\n", $1/1000; exit}'
#   fi 
# done | head -n

# Try package temp first, fallback to thermal_zone0
cat /sys/class/hwmon/hwmon*/temp1_input 2>/dev/null | head -n1 | awk '{printf "%.0f", $1/1000}' || cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{printf "%.0f", $1/1000}' || echo "N/A"
