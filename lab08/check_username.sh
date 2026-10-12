#!/bin/bash
LOGFILE=$1
USERNAME=$2
if [ ! -f "$LOGFILE" ]; then
    echo "Error: '$LOGFILE' not found" >&2
    exit 2
fi
if ! grep -q "for $USERNAME " "$LOGFILE"; then
    echo "$USERNAME: no activity found"
    exit 3
fi
FAILS=$(grep -c "Failed password for $USERNAME " "$LOGFILE")
ACCEPTS=$(grep -c "Accepted password for $USERNAME " "$LOGFILE")
if [ "$FAILS" -gt 5 ]; then
    echo "$USERNAME: $FAILS failed, $ACCEPTS accepted — HIGH RISK"
elif [ "$FAILS" -gt 0 ]; then
    echo "$USERNAME: $FAILS failed, $ACCEPTS accepted — investigate"
else
    echo "$USERNAME: $ACCEPTS successful login(s) only"
fi
exit 0
