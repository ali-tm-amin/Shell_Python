#!/bin/bash

# default value to use if none specified
PERCENT=30

# test for command line argument is present
if [[ $# -le 0 ]]
then
    printf "No disks are running with more usage than= %d\n" $PERCENT
# test if the argument is an integer
# If it is, use that as percent, if not use default
else
    if [[ $1 =~ ^-?[0-9]+([0-9]+)?$ ]]
    then
        PERCENT=$1
    fi
fi

let "PERCENT += 0"
printf "Threshold = %d\n" $PERCENT

df -Ph | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5,$1 }' | while read data;
do
    used=$(echo $data | awk '{print $1}' | sed s/%//g)
    p=$(echo $data | awk '{print $2}')
    if [ $used -ge $PERCENT ]
    then
        echo "WARNING: The partition \"$p\" has used $used% of total available space - Date: $(date)"
    fi
done
