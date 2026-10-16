#!/bin/bash
for IP in $(awk '{print $1}' case/logs/access.log | sort -u); do
    COUNT=$(grep -cwF "$IP" case/logs/access.log)
    if grep -qxF "$IP" intel/iocs.txt; then
        echo "$IP ($COUNT requests): in IOC list"
    else
        echo "$IP ($COUNT requests): NOT in IOC list"
    fi
done
