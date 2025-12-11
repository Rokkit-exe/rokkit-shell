#!/bin/bash
boot_dev=$(lsblk -no NAME,MOUNTPOINT | grep " /boot" | head -n1 | awk '{print $1}')
lsblk -dno MODEL "$(lsblk -no PKNAME /dev/$boot_dev 2>/dev/null | head -n1)" 2>/dev/null | xargs || echo "N/A"
