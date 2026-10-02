#!/bin/bash

read -p "Enter a username to look up: " TARGET_USER
echo "Searching the account list for: $TARGET_USER"
MATCH=$(grep "$TARGET_USER" intel/users.csv)
echo "Full record : $MATCH"
echo "Role        : $(echo "$MATCH" | cut -d',' -f2)"
echo "Status      : $(echo "$MATCH" | cut -d',' -f3)"
