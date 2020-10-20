# MySQL Workbench in snap

[![Available on Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-white.svg)](https://snapcraft.io/mysql-workbench-community)

A wrapper for deb package `mysql-workbench-community` from original mysql repository `repo.mysql.com`.

Official packages from [mysql](https://dev.mysql.com/downloads/workbench/) tend to take a long time to come out on 
newly released operating systems or they don't even exist.

Wrapping this package in snap makes it possible to use a new or different distribution regardless of the releases from
mysql team.

### Connections
If you use connections, Workbench use Password Manager and ssh to work properly.

So it is necessary to give this permission explicitly.
```sh
snap connect mysql-workbench-community:password-manager-service 
snap connect mysql-workbench-community:ssh-keys
snap connect mysql-workbench-community:cups-control
```
