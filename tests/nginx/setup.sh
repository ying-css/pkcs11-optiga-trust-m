#!/bin/bash

# SPDX-FileCopyrightText: 2026 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

chmod +x pd
dos2unix pd

set -e

echo "SSL/TLS Nginx Server with Trust M"
echo "=================================================="


echo "=================================================="
echo "Retrieve the public cert from Trust M"
echo "=================================================="
./pd --slot 1 --label Cert --read-object --type cert --output-file temp_server_cert.der

openssl x509 -in temp_server_cert.der -outform PEM -out server_cert_TrustM.pem
mv server_cert_TrustM.pem certificates/
sudo cp default /etc/nginx/sites-enabled/default
sudo cp certificates/server_cert_TrustM.pem /etc/nginx/server_cert_TrustM.pem
sudo cp nginx.conf /etc/nginx/nginx.conf
sudo service nginx restart
