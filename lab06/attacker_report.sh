#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <logfile>" >&2
    exit 1
fi

LOGFILE=$1

if [ ! -f "$LOGFILE" ]; then
    echo "Error: file '$LOGFILE' not found" >&2
    exit 2
fi

FAILED=$(grep -c "Failed password" "$LOGFILE")
echo "Failed password events: $FAILED"
echo ""

TOP_IP=$(grep "Failed password" "$LOGFILE" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
echo "Top attacker: $TOP_IP"
echo ""

echo "Top 3 source IPs:"
grep "Failed password" "$LOGFILE" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' | sort | uniq -c | sort -nr | head -n 3
echo ""

echo "Top 3 targeted usernames:"
grep "Failed password" "$LOGFILE" | awk '{for(i=1;i<=NF;i++) if($i=="for") print $(i+1)}' | sort | uniq -c | sort -nr | head -n 3

exit 0
