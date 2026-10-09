<!--
SPDX-FileCopyrightText: 2026 Infineon Technologies AG
SPDX-License-Identifier: MIT
-->
# Nginx with Optiga Trust M as Server Certificate (via PKCS#11)

## Overview
This example demonstrates how to configure an **Nginx** web server to use the **Infineon Optiga Trust M** secure element as the source of its server certificate and private key, instead of storing them as plain files on disk.

Private key operations (such as signing during the TLS handshake) are performed securely inside the Optiga Trust M chip. This is achieved by integrating Nginx with OpenSSL's **PKCS#11 engine** or **PKCS#11 provider**, which acts as a bridge between OpenSSL and the hardware secure element.

## Prerequisites
Before running this example, make sure that:
- The Optiga Trust M module is properly connected and provisioned with a valid certificate and corresponding private key.
- OpenSSL and the PKCS#11 engine/provider package (e.g., `libp11`) are installed and correctly configured on your system.
- Nginx is installed and accessible from your system's `PATH`. You can install it with `sudo apt install -y nginx`.
- You have the necessary permissions to start and stop services, and to bind to port `443` (this may require `sudo`, depending on your system configuration).
- If you plan to use the PKCS#11 provider, ensure you are running Nginx 1.29 or later. See this [guide](nginx_install.md) instead for installation instructions.

## Setup
Navigate to either the [engine folder](openssl_engine) or the [provider folder](openssl_provider), depending on which PKCS#11 interface you intend to use.

Then, choose the private key/certificate pair you want to use:
- If pre-provisioned inside the Trust M, use the `*_prov.sh` script.
- If using a self-generated certificate/private key pair stored in the Trust M, use the `*_e0f1.sh` script.

First, run this script to stop any existing Nginx server that may be holding onto the Trust M:
```shell
./step0_stop_nginx.sh
```
> **Note:** This example assumes Nginx is only used for Trust M. If that is not the case, make sure to stop the specific Nginx master process that is holding the Trust M.

Next, run the script to extract the certificate and public key for the TLS connection:
```shell
./step1_setup_prov.sh
```

Then, start the Nginx server using this script:
```shell
./step2_start_server_prov.sh
```

## Testing the Server
Once the server is running, you can verify that it is correctly serving the Trust M-backed TLS certificate by performing an HTTPS request with `curl`, using the provided script:
```shell
./step3_curl_test.sh
```
If everything is configured correctly, you should see a successful TLS handshake in the verbose output, followed by the HTTP response from the server.

You can also use the following command to inspect the certificate served by Nginx and verify that it matches the expected certificate:
```shell
openssl s_client \
  -connect 127.0.0.1:443 \
  -showcerts \
  -CAfile ../certificates/Nginx_CA_cert.pem
```

## Troubleshooting
- After running the setup script, the Trust M remains occupied by the Nginx server until the server is stopped. To release the Trust M for other tasks, make sure to stop the Nginx service. You can do this by running `pgrep nginx` to find the process ID, then `sudo kill {id}`, or by simply using the `step0_stop_nginx.sh` script.