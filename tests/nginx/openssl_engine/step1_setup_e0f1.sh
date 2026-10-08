#!/bin/bash

# SPDX-FileCopyrightText: 2026 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

chmod +x pd
dos2unix pd

CERT_FOLDER=../certificates
IFX_CERT_PATH=${CERT_FOLDER}/OPTIGA_Trust_M_Infineon_Test_CA.pem
IFX_CERT_KEY=${CERT_FOLDER}/OPTIGA_Trust_M_Infineon_Test_CA_Key.pem

set -e

echo "=================================================="
if [ -e $IFX_CERT_KEY ]
then
	echo "TEST CA certificate and key already exists"
else
	if [ ! -d certificates ]
	then
	mkdir certificates
	fi
	echo "Generate Test CA Key"
	openssl ecparam -out $IFX_CERT_KEY -name P-384 -genkey
	echo "Generate Test CA Certificate"
	openssl req -new -x509 -days 3650 -key $IFX_CERT_KEY -subj "/CN=Infineon OPTIGA(TM) Trust M Test CA/O=Infineon Technologies AG/OU=OPTIGA(TM)/C=DE" -out $IFX_CERT_PATH
fi
echo "=================================================="
echo "Generate Trust M private key"
echo "=================================================="
# generate keypair
./pd --slot 1 --keypairgen --key-type EC:secp256r1
./pd --slot 1 --label PubKey --read-object --type data --output-file Slot1PubKey.der &>/dev/null

echo "Generate Trust M certificate to use for TLS"
echo "=================================================="
# generate certificate
openssl pkey -in Slot1PubKey.der -pubin -inform der -outform pem -out Slot1PubKey.pem
openssl x509 -new -force_pubkey Slot1PubKey.pem -subj /CN=InfineonIoTNode/OU=InfineonTest -CAcreateserial -CA $IFX_CERT_PATH -CAkey $IFX_CERT_KEY -out Slot1Cert.pem
openssl x509 -outform der -in Slot1Cert.pem -out Slot1Cert.der
./pd --slot 1 --label Cert --write-object Slot1Cert.der --type cert 
# combine to certificate leaf(device) and intermediate
cp Slot1Cert.pem ${CERT_FOLDER}/
cat ${CERT_FOLDER}/Slot1Cert.pem > ${CERT_FOLDER}/Nginx_server_cert.pem

# Set up root certificate to verify the TLS connection
sudo cp ${IFX_CERT_PATH} ${CERT_FOLDER}/Nginx_CA_cert.pem

echo "Setup the certificate and private key in e0e1 and e0f1 successful"
echo "=================================================="