#!/bin/bash

# SPDX-FileCopyrightText: 2026 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT


# Copy the original config into nginx folder
sudo mkdir -p /etc/nginx/sites-enabled
sudo cp default_org /etc/nginx/sites-enabled/default
sudo cp nginx_org.conf /etc/nginx/nginx.conf