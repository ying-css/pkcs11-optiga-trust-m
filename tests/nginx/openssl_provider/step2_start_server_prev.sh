#!/bin/bash

# SPDX-FileCopyrightText: 2026 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

CERT_FOLDER=../certificates
IFX_CERT_PATH=${CERT_FOLDER}/infineon_CA_root.pem
set -e

echo "=================================================="
echo "Start Nginx Server with PKCS11 provider"
echo "=================================================="


# Copy the config file into nginx folder
sed -i '31s/Token1/Token0/' default
sudo mkdir -p /etc/nginx/sites-enabled
sudo cp default /etc/nginx/sites-enabled/default
sudo cp ${CERT_FOLDER}/Nginx_server_cert.pem /etc/nginx/Nginx_server_cert.pem
sudo cp nginx.conf /etc/nginx/nginx.conf

# Start nginx
echo "Start nginx server"
sudo env OPENSSL_CONF="$PWD/openssl_pkcs11.cnf" nginx -g "daemon off; master_process off;" &
