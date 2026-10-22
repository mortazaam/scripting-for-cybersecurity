#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <logfile> <ip_or_username>" >&2
    exit 1
fi

LOGFILE=$1
TERM_ARG=$2

if [ ! -e "$LOGFILE" ]; then
    echo "Error: '$LOGFILE' does not exist" >&2
    exit 2
fi

if [ ! -f "$LOGFILE" ]; then
    echo "Error: '$LOGFILE' is not a regular file" >&2
    exit 3
fi

if [ ! -r "$LOGFILE" ]; then
    echo "Error: '$LOGFILE' is not readable" >&2
    exit 4
fi

if [ -z "$TERM_ARG" ]; then
    echo "Error: search term is empty" >&2
    exit 5
fi

if echo "$TERM_ARG" | grep -Eq '^[0-9]+(\.[0-9]+){3}$'; then
    echo "=== IP address: $TERM_ARG ==="
    COUNT=$(grep -cwF "$TERM_ARG" "$LOGFILE" || true)
    FAILED=$(grep "Failed password" "$LOGFILE" | grep -cwF "$TERM_ARG" || true)
    echo "Appearances in $LOGFILE : $COUNT"
    echo "Failed password events  : $FAILED"

    if [ "$FAILED" -eq 0 ]; then
        echo "Risk: NONE (no failed attempts)"
    elif [ "$FAILED" -lt 5 ]; then
        echo "Risk: LOW ($FAILED failed attempts)"
    elif [ "$FAILED" -lt 15 ]; then
        echo "Risk: MEDIUM ($FAILED failed attempts)"
    else
        echo "Risk: HIGH ($FAILED failed attempts)"
    fi

    echo "Firewall:"
    if grep -qwF "$TERM_ARG" case/logs/firewall.log; then
        grep -wF "$TERM_ARG" case/logs/firewall.log | sed 's/^/  /'
    else
        echo "  no firewall entries for this address"
    fi

    if grep -qxF "$TERM_ARG" intel/iocs.txt; then
        echo "IOC list: LISTED"
    else
        echo "IOC list: NOT listed"
    fi
else
    echo "=== Username: $TERM_ARG ==="
    COUNT=$(grep -c "for $TERM_ARG " "$LOGFILE" || true)
    FAILED=$(grep -c "Failed password for $TERM_ARG " "$LOGFILE" || true)
    ACCEPTED=$(grep -c "Accepted password for $TERM_ARG " "$LOGFILE" || true)
    echo "Failed logins   : $FAILED"
    echo "Accepted logins : $ACCEPTED"

    if grep -q "^$TERM_ARG," intel/users.csv; then
        echo "Account: CURRENT (listed in intel/users.csv)"
    elif grep -qx "$TERM_ARG" case/backups/users.old; then
        echo "Account: LEGACY (only in the old backup list)"
    else
        echo "Account: UNKNOWN (in neither list)"
    fi
fi

if [ "$COUNT" -gt 0 ]; then
    exit 0
else
    echo "NOT FOUND: $TERM_ARG does not appear in $LOGFILE"
    exit 6
fi
