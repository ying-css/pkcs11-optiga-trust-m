<!--
SPDX-FileCopyrightText: 2026 Infineon Technologies AG
SPDX-License-Identifier: MIT
-->
# Installing Nginx 1.29+ for OpenSSL Provider Support

## Overview
As of writing this guide, the default Nginx package available on Raspberry Pi OS (Trixie) is version 1.27, which does not support the OpenSSL Provider used in this repository. To work around this, you need to self-install Nginx 1.29 or higher.

This guide follows the steps for Debian packages outlined in the [official Nginx documentation](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#debian-packages).

## Steps

First, install the required prerequisites:
```shell
sudo apt update && \
sudo apt install curl \
                 gnupg2 \
                 ca-certificates \
                 lsb-release \
                 debian-archive-keyring
```

Next, import the Nginx signing key:
```shell
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
     | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
```

Then, verify that the downloaded key matches the official fingerprint listed on the [Nginx documentation page](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#debian-packages):

> **Note:** On some newer Raspberry Pi images, the `~/.gnupg` folder may not exist yet, which can cause the command below to fail. If this happens, run `mkdir -p ~/.gnupg` first.

```shell
gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
```

Set up the apt repository to fetch packages from the stable branch:
```shell
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
```

Set the priority of the Nginx package to ensure it takes precedence over the default distribution package:
```shell
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
   | sudo tee /etc/apt/preferences.d/99nginx
```

Install the Nginx package:
```shell
sudo apt update && \
sudo apt install nginx
```

## Troubleshooting
- After installing the Nginx package, systemd may automatically start the service and bind it to port 80. To release the port, stop and disable the systemd-managed Nginx service with:
  ```shell
  sudo systemctl stop nginx
  sudo systemctl disable nginx
  ```