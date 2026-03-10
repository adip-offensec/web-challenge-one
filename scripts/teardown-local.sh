#!/bin/bash

# Tokha Attack Path Lab - Local Teardown Script
# Removes the lab files and flag (use with caution)

set -e

echo "=== Tokha Attack Path Lab Teardown ==="
echo "This script will remove the lab web files and flag."
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Confirm deletion
read -p "Are you sure you want to remove the lab? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Teardown cancelled."
    exit 0
fi

echo "[1/3] Removing lab web files..."
LAB_DIR="/var/www/html/bambi"
if [ -d "$LAB_DIR" ]; then
    rm -rf "$LAB_DIR"
    echo "Removed: $LAB_DIR"
else
    echo "Lab directory not found: $LAB_DIR"
fi

echo "[2/3] Removing flag file..."
FLAG_FILE="/home/ctf/local.txt"
if [ -f "$FLAG_FILE" ]; then
    rm -f "$FLAG_FILE"
    echo "Removed: $FLAG_FILE"
else
    echo "Flag file not found: $FLAG_FILE"
fi

echo "[3/3] Removing wordlist..."
WORDLIST_FILE="/home/ctf/wordlist.txt"
if [ -f "$WORDLIST_FILE" ]; then
    rm -f "$WORDLIST_FILE"
    echo "Removed: $WORDLIST_FILE"
else
    echo "Wordlist not found: $WORDLIST_FILE"
fi

echo ""
echo "=== Teardown Complete ==="
echo "Lab files removed. Apache service remains running."
echo "To completely remove Apache/PHP: apt remove apache2 php libapache2-mod-php"