#!/bin/bash
# 获取CPU使用率

while true
do
    cpu=$(top -l 1 -n 0 | sed -n '4p'| awk '{print $3, $5}')
    cpu=${cpu//%/}
    cpu=${cpu// /+}
    total=$(echo "$cpu" | bc)
    printf "%.0f%%" $total > ~/.cpu.txt
    sleep 1
done

