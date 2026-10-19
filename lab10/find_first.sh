#!/bin/bash

LOG="case/nested/archive/old.log"
FOUND=""

while IFS= read -r INDICATOR; do
    if grep -qwF "$INDICATOR" "$LOG"; then
        FOUND="$INDICATOR"
        break
    fi
done < intel/iocs.txt

if [ -n "$FOUND" ]; then
    echo "First match in $LOG: $FOUND"
else
    echo "No indicators matched $LOG"
fi
