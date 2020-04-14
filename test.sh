#!/bin/bash
set -euo pipefail
# Simple script to rebuild and run

# Unistall old snap
sudo snap remove mysql-workbench-community

# Clean up old builds
rm -f mysql-workbench*.snap

# clean all cache
snapcraft clean --use-lxd

# Build new image
snapcraft --use-lxd --debug

# Install new image
sudo snap install --devmode mysql-workbench*.snap

# Run new snap
snap run mysql-workbench-community
