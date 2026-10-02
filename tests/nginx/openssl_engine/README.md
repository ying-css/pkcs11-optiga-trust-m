<!--
SPDX-FileCopyrightText: 2024 Infineon Technologies AG
SPDX-License-Identifier: MIT
-->

# Nginx with Optiga Trust M as Server Certificate (via PKCS#11)

## Overview

This example demonstrates how to configure an **Nginx** web server to use the **Infineon Optiga Trust M** secure element as the source of its server certificate and private key, instead of storing them as plain files on disk.

The private key operations (such as signing during the TLS handshake) are performed securely inside the Optiga Trust M chip. This is achieved by integrating Nginx with OpenSSL's **PKCS#11 engine**, which acts as a bridge between OpenSSL and the hardware secure element.

## Prerequisites

Before running this example, make sure that:
- The Optiga Trust M module is properly connected and provisioned with a valid certificate and corresponding private key.
- OpenSSL and the PKCS#11 engine (e.g. `libp11`) are installed and correctly configured on your system.
- Nginx is installed and accessible from your system's `PATH`.
- You have the necessary permissions to start and stop services, and to bind to port `443` (may require `sudo` depending on your system configuration).

## Setup

To configure and start the Nginx server using the Trust M certificate and private key through PKCS#11, run the following script:

```console
./setup.sh
```

This script will:
1. Configure Nginx to use the PKCS#11 engine for the server's private key operations.
2. Set up the Trust M certificate as the server certificate.
3. Start (or restart) the Nginx server with the new configuration.

> **Note:** If this is the only Nginx instance running on your system, you can set `STOP_EXISTING=1` inside `setup.sh`. This ensures any previously running Nginx process is terminated before starting a new one, making the script idempotent and safe to re-run multiple times.

## Testing the Server

Once the server is running, you can verify that it is correctly serving the Trust M-backed TLS certificate by performing an HTTPS request using `curl`:

```console
curl -v --resolve InfineonIoTNode:443:127.0.0.1 https://InfineonIoTNode --cacert ../certificates/infineon_CA_root.pem
```

If everything is configured correctly, you should see a successful TLS handshake in the verbose output, followed by the HTTP response from the server.

## Troubleshooting

- After running the `setup.sh` script, the Trust M is occupied by the nginx server till the server stops. So to release the Trust M for other tasks, please remember to stop the nginx service through the `kill` command.