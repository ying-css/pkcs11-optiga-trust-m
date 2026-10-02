<!--
SPDX-FileCopyrightText: 2024 Infineon Technologies AG

SPDX-License-Identifier: MIT
-->

# Info

This folder is for showcasing the Nginx server with Optiga Trust M certificate as server certificate, using OpenSSL PKCS#11 engine

# Command
Run this following command to set up the nginx server to use Trust M certificate and private keys through PKCS#11
```console
./setup.sh
```

Perform HTTP GET request to the nginx server through this command
```console
curl -v --resolve InfineonIoTNode:443:127.0.0.1 https://InfineonIoTNode --cacert ../certificates/infineon_CA_root.pem 
```