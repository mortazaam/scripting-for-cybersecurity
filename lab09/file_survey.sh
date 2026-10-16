#!/bin/bash

SURVEYED=0
FLAGGED=0
TOTAL_IOC=0

for FILE in case/evidence/* case/scripts/* case/logs/*; do
    [ -f "$FILE" ] || continue
    SURVEYED=$((SURVEYED + 1))

    TYPE=$(file -b "$FILE")
    echo "=== $FILE"
    echo "  size   : $(wc -c < "$FILE") bytes"
    echo "  type   : $TYPE"

    if [[ "$TYPE" == *text* ]]; then
        echo "  lines  : $(wc -l < "$FILE")"
    fi

    echo "  sha256 : $(sha256sum "$FILE" | awk '{print $1}')"

    if [[ "$FILE" == *.png ]]; then
        EXPECT="PNG"
    elif [[ "$FILE" == *.zip ]]; then
        EXPECT="Zip"
    elif [[ "$FILE" == *.txt || "$FILE" == *.md || "$FILE" == *.log ]]; then
        EXPECT="text"
    elif [[ "$FILE" == *.sh ]]; then
        EXPECT="shell script"
    elif [[ "$FILE" == *.py ]]; then
        EXPECT="Python"
    else
        EXPECT=""
    fi

    if [ -n "$EXPECT" ] && [[ "$TYPE" != *"$EXPECT"* ]]; then
        echo "  !! FLAG: expected $EXPECT"
        FLAGGED=$((FLAGGED + 1))
    fi

    if [[ "$FILE" == *.log ]]; then
        HITS=0
        for IND in $(cat intel/iocs.txt); do
            if grep -qwF "$IND" "$FILE"; then
                HITS=$((HITS + 1))
            fi
        done
        echo "  IOCs   : $HITS indicator(s) present"
        TOTAL_IOC=$((TOTAL_IOC + HITS))
    fi
done

echo ""
echo "Files surveyed : $SURVEYED"
echo "Files flagged  : $FLAGGED"
echo "Total IOC hits : $TOTAL_IOC"
