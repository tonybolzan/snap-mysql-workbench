#!/bin/bash
set -euo pipefail
# Simple script to rebuild and run

# sudo snap install snapcraft --classic
# sudo snap install lxd
# lxd init --auto
# snapcraft login

# Latest version from mysql
VERSION_ONLINE=$(curl -sS "http://repo.mysql.com/apt/ubuntu/dists/jammy/mysql-tools/binary-amd64/Packages" | grep -PA2 '^Package: mysql-workbench-community$'| grep -Po '^Version: \K(\d+\.\d+\.\d+)')

VERSION_LOCAL=$(grep 'version' snapcraft.yaml |awk '{print $2}')

if [ "$VERSION_LOCAL" != "$VERSION_ONLINE" ]; then
    echo >&2 "Version to be installed and local version don't match"
    echo >&2 " - Online: $VERSION_ONLINE"
    echo >&2 " - Local:  $VERSION_LOCAL"
    exit 1
fi

echo "Building Version:  $VERSION_LOCAL"

# Unistall old snap
sudo snap remove mysql-workbench-community

# Clean up old builds
rm -f mysql-workbench*.snap

# clean all cache
snapcraft clean

# Build new image
snapcraft --debug

# Install new image
sudo snap install --dangerous mysql-workbench*.snap
sudo snap connect mysql-workbench-community:password-manager-service
sudo snap connect mysql-workbench-community:ssh-keys
sudo snap connect mysql-workbench-community:cups-control
sudo snap connect mysql-workbench-community:removable-media

# Run new snap
snap run mysql-workbench-community --log-to-stderr

# Deploy
# sudo snap remove mysql-workbench-community
# snapcraft upload --release=edge mysql-workbench*.snap
# sudo snap install mysql-workbench-community --edge
