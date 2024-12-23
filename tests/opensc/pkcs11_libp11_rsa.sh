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

echo "Worked pkcs11 engine command examples:"
echo "=================================================="

#~ echo "======>List slots with tokens"	
#~ ./pd --list-token-slots

#~ echo "======>List supported mechanisms"
#~ ./pd --list-mechanisms --slot 4

#~ echo "======>Show objects"
#~ ./pd --list-objects --slot 4

#~ echo "======>Generate RSA key pair"	
#~ ./pd --slot 4 --keypairgen --key-type RSA:2048
#~ ./pd --slot 4 --label PubKey --read-object --type data --output-file Slot4PubKey.der
#~ xxd Slot4PubKey.der

echo "======>Read out the Public Key for Token4"	
OPENSSL_CONF=openssl_pkcs11.cnf openssl pkey -engine pkcs11 -in "pkcs11:token=Token4" -pubin -pubout -text -inform engine


if [ $ErrorCount -ne 0 ]; then 
 echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
 echo Verification errors: $ErrorCount
 echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
 (exit 1)
fi
echo ==== Finished - OK ====
