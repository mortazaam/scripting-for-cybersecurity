#!/usr/bin/env bash

set -euo pipefail

name="$(whoami)"
host="$(hostname)"
directory="$(pwd)"
shell="${SHELL}"
python="$(which python3)"
environment_count="$(env | wc -l)"
python_count="$(find /usr/bin -maxdepth 1 -type f -printf '%f\n' | grep -c 'python' || true)"

{
    echo "Linux CLI Revision Report"
    echo "User: ${name}"
    echo "Host: ${host}"
    echo "Directory: ${directory}"
    echo "Shell: ${shell}"
    echo "Python: ${python}"
    echo "Environment variables: ${environment_count}"
    echo "Python-related filenames: ${python_count}"
} > revision-report.txt

cat revision-report.txt