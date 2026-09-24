<!--
SPDX-FileCopyrightText: 2024 Infineon Technologies AG

SPDX-License-Identifier: MIT
-->

# This folder is for showcasing the Nginx server with Optiga Trust M certificate as server certificate.





# Requirement
Set the nginx environmental variable to use the current config file

```console
sudo systemctl edit nginx
```

Add this line into the file and save

```console
OPENSSL_CONF=/home/css/Desktop/pkcs11-optiga-trust-m/tests/nginx/openssl_pkcs11.cnf
```
Then restart the service by
```console
sudo systemctl daemon-reload
```
