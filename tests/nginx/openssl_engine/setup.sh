#!/bin/bash

# SPDX-FileCopyrightText: 2026 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

chmod +x pd
dos2unix pd

CERT_FOLDER=../certificates
IFX_CERT_PATH=${CERT_FOLDER}/infineon_CA_root.pem
set -e

echo "=================================================="
echo "SSL/TLS Nginx Server with Trust M with PKCS11 Engine"
echo "=================================================="

# Use with Caution
# check if the oldest nginx process is really the nginx we want to kill for start our own
STOP_EXISTING=0
if [ $STOP_EXISTING -eq 1 ]
then
    NGINX_PID=$(pgrep -o nginx || true)
    if [ -n "$NGINX_PID" ]
    then
        echo "Stop current running nginx"
        echo
        echo "=================================================="
        sudo kill -9 $NGINX_PID
    fi
fi

echo "Retrieve the public cert from Trust M"
echo "=================================================="
./pd --slot 0 --label Cert --read-object --type cert --output-file temp_server_cert.der

# convert to pem and combine to form leaf(device) -> intermediate
openssl x509 -in temp_server_cert.der -outform PEM -out TrustM_cert.pem
mv TrustM_cert.pem ${CERT_FOLDER}/
cat ${CERT_FOLDER}/TrustM_cert.pem ${CERT_FOLDER}/infineon_CA_300.pem > ${CERT_FOLDER}/Nginx_server_cert.pem

echo "Write the public key to Trust M"
echo "=================================================="
openssl x509 -in temp_server_cert.der -pubkey -nocert -out temp_server_pub.pem
./pd --slot 0 --label PubKey --write-object temp_server_pub.pem --type pubkey 


# Copy the config file into nginx folder
sed -i '31s/Token1/Token0/' default
sudo cp default /etc/nginx/sites-enabled/default
sudo cp ${CERT_FOLDER}/Nginx_server_cert.pem /etc/nginx/Nginx_server_cert.pem
sudo cp nginx.conf /etc/nginx/nginx.conf

# Set up root certificate to verify this TLS connect
sudo cp ${IFX_CERT_PATH} ${CERT_FOLDER}/Ngix_CA_cert.pem

# Start nginx
echo "=================================================="
echo "Start nginx server"
sudo env OPENSSL_CONF="$PWD/openssl_pkcs11.cnf" nginx -g "daemon off; master_process off;" &
