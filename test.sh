#!/bin/bash
set -euo pipefail
# Simple script to rebuild and run

# Unistall old snap
sudo snap remove mysql-workbench

# Clean up old builds
rm mysql-workbench*.snap

# Build new image
snapcraft --use-lxd --debug

# Install new image
sudo snap install --devmode mysql-workbench*.snap

# Run new snap
mysql-workbench
