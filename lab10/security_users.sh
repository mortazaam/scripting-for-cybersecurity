#!/bin/bash

FIRST_LINE=1

while IFS=',' read -r USERNAME ROLE STATUS DEPT; do
    if [ "$FIRST_LINE" -eq 1 ]; then
        FIRST_LINE=0
        continue
    fi
   DEPT=${DEPT%$'\r'} 
    if [ "$DEPT" = "Security" ]; then
        echo "Security team: $USERNAME"
    fi
done < intel/users.csv
