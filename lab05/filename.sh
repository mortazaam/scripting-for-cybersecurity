#!/bin/bash
read -p "Enter a filename: " FNAME
echo "You entered: $FNAME"
echo "Extension: ${FNAME##*.}"
echo "Name without path: ${FNAME##*/}"
echo "Length: ${#FNAME}"
