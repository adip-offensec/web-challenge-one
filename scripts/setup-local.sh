#!/bin/bash

# Tokha Attack Path Lab - Local Setup Script
# This script sets up the lab environment on a local Apache/PHP server

set -e

echo "=== Tokha Attack Path Lab Setup ==="
echo "This script will install Apache/PHP, deploy the lab web application,"
echo "and create the flag file at /home/ctf/local.txt"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Install Apache and PHP
echo "[1/5] Installing Apache and PHP..."
apt update
apt install -y apache2 php libapache2-mod-php

# Create lab directory
echo "[2/5] Creating lab directory structure..."
LAB_DIR="/var/www/html/bambi"
mkdir -p "$LAB_DIR"
mkdir -p "$LAB_DIR/developer"
mkdir -p "$LAB_DIR/admin"

# Copy web files
echo "[3/5] Copying web application files..."
cp -r ../bambi/* "$LAB_DIR/"

# Set permissions
echo "[4/5] Setting file permissions..."
chown -R www-data:www-data "$LAB_DIR"
chmod -R 755 "$LAB_DIR"

# Create flag file
echo "[5/5] Creating flag file..."
FLAG_DIR="/home/ctf"
mkdir -p "$FLAG_DIR"
echo "BAMBI{you_found_the_local_flag}" > "$FLAG_DIR/local.txt"
chown www-data:www-data "$FLAG_DIR/local.txt"
chmod 600 "$FLAG_DIR/local.txt"

# Copy wordlist for reference
cp ../resources/wordlist.txt "$FLAG_DIR/wordlist.txt"
chmod 644 "$FLAG_DIR/wordlist.txt"

echo ""
echo "=== Setup Complete ==="
echo "Lab deployed to: $LAB_DIR"
echo "Flag file: $FLAG_DIR/local.txt"
echo "Wordlist: $FLAG_DIR/wordlist.txt"
echo ""
echo "Access the lab at: http://localhost/bambi/"
echo "Apache service status: systemctl status apache2"
echo ""
echo "To start Apache if not running: systemctl start apache2"
echo "To enable Apache on boot: systemctl enable apache2"