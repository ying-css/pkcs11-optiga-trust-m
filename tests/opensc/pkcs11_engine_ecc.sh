#!/bin/bash

# SPDX-FileCopyrightText: 2024 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

chmod +x pd
dos2unix pd
#~ rm *.log

set -e
declare -i ErrorCount=0

clear

echo "libp11 commands example:"
echo "=================================================="

#~ echo "======>List slots with tokens"	
#~ ./pd --list-token-slots

#~ echo "======>List supported mechanisms"
#~ ./pd --list-mechanisms --slot 1

#~ echo "======>Show objects"
#~ ./pd --list-objects --slot 1

#echo "======>Generate ECC key pair"	
#./pd --slot 1 --keypairgen --key-type EC:secp256r1
#./pd --slot 1 --label PubKey --read-object --type data --output-file Token1PubKey.der
#openssl ec -pubin -inform DER -in Token1PubKey.der -out Token1PubKey.pem
#~ xxd Token1PubKey.pem

#echo "======>Hash data"	
#echo "01234567890123456789012345678901234567890123456789" > test.txt	
#./pd --hash  --hash-algorithm SHA256 --input-file test.txt --output-file test.sha
#xxd test.sha 

echo "======>Read out the Public Key"
OPENSSL_CONF=openssl_pkcs11.cnf openssl pkey -engine pkcs11 -in "pkcs11:token=Token1" -pubin -pubout -text -inform engine

echo "======>Generate CSR"
OPENSSL_CONF=openssl_pkcs11.cnf openssl req -new -engine pkcs11 -key "pkcs11:token=Token1" -keyform engine -out new_device.csr -subj "/CN=TrustM"

echo "======>Sign with private key"	
OPENSSL_CONF=openssl_pkcs11.cnf openssl dgst -engine pkcs11 -sign "pkcs11:token=Token1" -keyform engine -out signature.bin -sha256 test.txt

echo "======>Verify signature"	
OPENSSL_CONF=openssl_pkcs11.cnf openssl dgst -engine pkcs11 -verify "pkcs11:token=Token1" -keyform engine -signature signature.bin -sha256 test.txt


if [ $ErrorCount -ne 0 ]; then 
 echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
 echo Verification errors: $ErrorCount
 echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
 (exit 1)
fi
echo ==== Finished - OK ====
