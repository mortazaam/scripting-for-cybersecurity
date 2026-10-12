#!/bin/bash
if [ $# -ne 2 ]; then
    echo "Usage: $0 <logfile> <ip>" >&2
    exit 1
fi
LOGFILE=$1
IP=$2
if [ ! -f "$LOGFILE" ]; then
    echo "Error: '$LOGFILE' not found" >&2
    exit 2
fi
if grep -qwF "$IP" "$LOGFILE"; then
    echo "FOUND: $IP appears $(grep -cwF "$IP" "$LOGFILE") time(s)"
    exit 0
else
    echo "NOT FOUND: $IP"
    exit 3
fi
