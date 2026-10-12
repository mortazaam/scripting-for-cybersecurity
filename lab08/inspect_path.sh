#!/bin/bash
TARGET=$1
if [ ! -e "$TARGET" ]; then
    echo "$TARGET does not exist"
    exit 2
elif [ -d "$TARGET" ]; then
    echo "$TARGET is a directory"
elif [ -f "$TARGET" ]; then
    echo "$TARGET is a regular file"
    if [ -s "$TARGET" ]; then
        echo "  not empty ($(wc -c < "$TARGET") bytes)"
    else
        echo "  but it is empty"
    fi
else
    echo "$TARGET exists but is neither"
fi
