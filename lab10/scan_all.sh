#!/bin/bash

IOC_FILE="intel/iocs.txt"
TOTAL_MATCHES=0

while IFS= read -r -d '' LOGFILE; do
    LINECOUNT=$(wc -l < "$LOGFILE")
    FAILED=$(grep -c "Failed password" "$LOGFILE" || true)
    MATCHES=0
    STOPPED=0

    while IFS= read -r INDICATOR; do
        [ -z "$INDICATOR" ] && continue
        if grep -qwF "$INDICATOR" "$LOGFILE"; then
            MATCHES=$((MATCHES + 1))
            if [ "$MATCHES" -eq 3 ]; then
                STOPPED=1
                break
            fi
        fi
    done < "$IOC_FILE"

    echo "=== $LOGFILE ==="
    echo "  lines         : $LINECOUNT"
    echo "  failed logins : $FAILED"
    echo "  IOC matches   : $MATCHES"
    if [ "$STOPPED" -eq 1 ]; then
        echo "  note          : stopped early after 3 matches"
    fi
    echo ""

    TOTAL_MATCHES=$((TOTAL_MATCHES + MATCHES))
done < <(find case -type f -name "*.log" -print0)

echo "TOTAL IOC matches across all logs: $TOTAL_MATCHES"

if [ "$TOTAL_MATCHES" -eq 0 ]; then
    exit 0
else
    exit 1
fi
