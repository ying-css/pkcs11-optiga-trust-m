#!/bin/bash

# SPDX-FileCopyrightText: 2026 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

curl -v --resolve InfineonIoTNode:443:127.0.0.1 https://InfineonIoTNode --cacert ../certificates/Nginx_CA_cert.pem