#!/bin/bash

PORT22=0
PORT80=0
PORT443=0

while read -r ACTION SRC ARROW DST; do
    if [ "$ACTION" != "BLOCK" ]; then
        continue
    fi
    PORT=${DST##*:}
    echo "BLOCK $SRC -> port $PORT"
    if [ "$PORT" = "22" ]; then
        PORT22=$((PORT22 + 1))
    elif [ "$PORT" = "80" ]; then
        PORT80=$((PORT80 + 1))
    elif [ "$PORT" = "443" ]; then
        PORT443=$((PORT443 + 1))
    fi
done < case/logs/firewall.log

echo ""
echo "Blocked on port 22  (SSH)  : $PORT22"
echo "Blocked on port 80  (HTTP) : $PORT80"
echo "Blocked on port 443 (HTTPS): $PORT443"
