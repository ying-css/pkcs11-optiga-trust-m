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

# Set up root certificate to verify the TLS connection
sudo cp ${IFX_CERT_PATH} ${CERT_FOLDER}/Nginx_CA_cert.pem

echo "Setup the pre-provisioned certificate and private key in successful"
echo "=================================================="