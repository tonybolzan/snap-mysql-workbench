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

function echo_red() {
    echo -e "\033[0;31m${1}\033[0m"
}

function echo_green() {
    echo -e "\033[0;32m${1}\033[0m"
}

if [ "$VERSION_LOCAL" != "$VERSION_ONLINE" ]; then
    echo >&2 "Version to be installed and local version don't match"
    echo_green >&2 " - Online: ${VERSION_ONLINE}"
    echo_red   >&2 " - Local:  ${VERSION_LOCAL}"
    exit 1
fi

echo_green "CleanUP installed versions"
sudo snap remove mysql-workbench-community

echo_green "CleanUP old builds"
rm -f mysql-workbench*.snap

echo_green "CleanUP cache"
snapcraft clean

echo_green "Building Version: ${VERSION_LOCAL}"
snapcraft

echo_green "Install Version: ${VERSION_LOCAL}"
sudo snap install --dangerous mysql-workbench*.snap
echo_green "Connect"
sudo snap connect mysql-workbench-community:password-manager-service
sudo snap connect mysql-workbench-community:ssh-keys
sudo snap connect mysql-workbench-community:cups-control
sudo snap connect mysql-workbench-community:removable-media

echo_green "Run Version: ${VERSION_LOCAL}"
snap run mysql-workbench-community --log-to-stderr

# Deploy
# sudo snap remove mysql-workbench-community
# snapcraft upload --release=edge mysql-workbench*.snap
# sudo snap install mysql-workbench-community --edge
