#!/bin/bash

COUNT=0
TOTAL_LINES=0

while IFS= read -r -d '' LOGFILE; do
    COUNT=$((COUNT + 1))
    LINECOUNT=$(wc -l < "$LOGFILE")
    TOTAL_LINES=$((TOTAL_LINES + LINECOUNT))
done < <(find case -type f -name "*.log" -print0)

echo "Logs found: $COUNT"
echo "Total lines across all logs: $TOTAL_LINES"
