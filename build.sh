#!/bin/bash
set -euo pipefail
# Simple script to rebuild and run

# sudo snap install snapcraft --classic
# sudo snap install lxd
# sudo usermod -a -G lxd ${USER}
# lxd init

# Latest version from mysql
VERSION_ONLINE=$(curl -sS "http://repo.mysql.com/apt/ubuntu/dists/bionic/mysql-tools/binary-amd64/Packages" | grep -PA2 '^Package: mysql-workbench-community$'| grep -Po '^Version: \K(\d+\.\d+\.\d+)')

VERSION_LOCAL=$(grep 'version' snapcraft.yaml |awk '{print $2}')

if [ "$VERSION_LOCAL" != "$VERSION_ONLINE" ]; then
    echo >&2 "Version to be installed and local version don't match"
    echo >&2 " - Online: $VERSION_ONLINE"
    echo >&2 " - Local:  $VERSION_LOCAL"
    exit 1
fi

# Unistall old snap
sudo snap remove mysql-workbench-community

# Clean up old builds
rm -f mysql-workbench*.snap

# clean all cache
snapcraft clean --use-lxd

# Build new image
snapcraft --use-lxd --debug

# Install new image
sudo snap install --dangerous mysql-workbench*.snap

# Run new snap
snap run mysql-workbench-community --log-to-stderr

# Deploy
# sudo snap remove mysql-workbench-community
# snapcraft push --release=beta mysql-workbench*.snap
# sudo snap install mysql-workbench-community