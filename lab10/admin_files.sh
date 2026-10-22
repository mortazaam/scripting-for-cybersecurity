#!/bin/bash

TERM="admin"

while IFS= read -r -d '' FILE; do
    echo "$FILE mentions $TERM ($(grep -c "$TERM" "$FILE") line(s))"
done < <(grep -rlZ "$TERM" case)
