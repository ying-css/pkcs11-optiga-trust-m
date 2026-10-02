#!/bin/bash

# SPDX-FileCopyrightText: 2026 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

chmod +x pd
dos2unix pd

CERT_FOLDER=../certificates
set -e

echo "=================================================="
echo "SSL/TLS Nginx Server with Trust M"
echo "=================================================="

# Use with Caution
# check if the oldest nginx process is really the nginx we want to kill for start our own
KILL_EXISTING=0
if [ $KILL_EXISTING -eq 1 ]
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
openssl x509 -in temp_server_cert.der -outform PEM -out server_cert_TrustM.pem
mv server_cert_TrustM.pem ${CERT_FOLDER}/
cat ${CERT_FOLDER}/server_cert_TrustM.pem ${CERT_FOLDER}/infineon_CA_300.pem > ${CERT_FOLDER}/TrustM_chaincert.pem

echo "Write the public key to Trust M"
echo "=================================================="
openssl x509 -in temp_server_cert.der -pubkey -nocert -out temp_server_pub.pem
./pd --slot 0 --label PubKey --write-object temp_server_pub.pem --type pubkey 


# Copy the config file into nginx folder
sudo cp default /etc/nginx/sites-enabled/default
sudo cp ${CERT_FOLDER}/TrustM_chaincert.pem /etc/nginx/TrustM_chaincert.pem
sudo cp nginx.conf /etc/nginx/nginx.conf

# Start nginx
echo "=================================================="
echo "Start nginx server"
sudo env OPENSSL_CONF="$PWD/openssl_pkcs11.cnf" nginx -g "daemon off; master_process off;" &
