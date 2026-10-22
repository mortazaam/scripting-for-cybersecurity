#!/bin/bash
read -p "Username: " USERNAME
read -s -p "Password: " PASSWORD
echo ""
echo "Credentials captured for $USERNAME (password length: ${#PASSWORD})"
