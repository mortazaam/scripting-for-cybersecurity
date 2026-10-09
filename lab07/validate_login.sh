#!/bin/bash
LOG="case/logs/auth.log"
read -p "Enter a username: " USERNAME
if [ -z "$USERNAME" ]; then
    echo "Error: no username entered" >&2
    exit 1
fi
if grep -q "^$USERNAME," intel/users.csv; then
    SOURCE="CURRENT"
    RECORD=$(grep "^$USERNAME," intel/users.csv)
    ROLE=$(echo "$RECORD" | cut -d',' -f2)
    STATUS=$(echo "$RECORD" | cut -d',' -f3)
    echo "$USERNAME: CURRENT account (role: $ROLE, status: $STATUS)"
elif grep -qx "$USERNAME" case/backups/users.old; then
    SOURCE="LEGACY"
    echo "$USERNAME: LEGACY account (old backup list only)"
else
    SOURCE="UNKNOWN"
    echo "$USERNAME: UNKNOWN account"
fi
FAILS=$(grep -c "Failed password for $USERNAME " "$LOG")
ACCEPTS=$(grep -c "Accepted password for $USERNAME " "$LOG")
echo "Failed logins  : $FAILS"
echo "Accepted logins: $ACCEPTS"
if [ "$FAILS" -eq 0 ]; then
    echo "Risk: NONE"
elif [ "$FAILS" -lt 5 ]; then
    echo "Risk: LOW"
elif [ "$FAILS" -lt 15 ]; then
    echo "Risk: MEDIUM"
else
    echo "Risk: HIGH"
fi
if [ "$SOURCE" = "CURRENT" ] && [ "$STATUS" = "disabled" ] && [ "$ACCEPTS" -gt 0 ]; then
    echo "WARNING: disabled account has successful logins"
fi
if [ "$SOURCE" != "CURRENT" ] && [ "$FAILS" -gt 0 ]; then
    echo "WARNING: attacker guessing account names that do not exist"
fi
if [ "$SOURCE" = "CURRENT" ] && [ "$ACCEPTS" -gt 0 ] && grep -q "^$USERNAME:" case/evidence/passwords.txt; then
    echo "WARNING: plaintext password on disk AND successful logins"
fi
if [ "$SOURCE" = "CURRENT" ]; then
    exit 0
elif [ "$SOURCE" = "LEGACY" ]; then
    exit 2
else
    exit 3
fi
