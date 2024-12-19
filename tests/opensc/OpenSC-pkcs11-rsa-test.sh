#!/bin/bash

# SPDX-FileCopyrightText: 2024 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

chmod +x pd
dos2unix pd

set -e
declare -i ErrorCount=0

#~ rm *.log

clear

echo "Worked OpenSC pkcs11-tool command examples:"
echo "=================================================="
echo "======>Show PKCS#11 module/library info"	
#./pd --show-info

echo "======>List available slots"	
#./pd --list-slots

echo "======>List slots with tokens"	
./pd --list-token-slots

echo "======>List supported mechanisms"
./pd --list-mechanisms --slot 4 

echo "======>Generate RSA key pair"	
./pd --slot 4 --keypairgen --key-type RSA:2048
./pd --slot 4 --label PubKey --read-object --type data --output-file Slot4PubKey.der
xxd Slot4PubKey.der

echo "======>Hash data"	
echo "01234567890123456789012345678901234567890123456789" > data.in	
./pd --hash  --hash-algorithm SHA256 --input-file data.in --output-file data.sha
xxd data.sha 
 
echo "======>RSA sign"	
./pd --slot 4 --sign --mechanism RSA-PKCS --input-file data.sha --output-file Slot4prvkey.sig

echo "======>Verifgy RSA signature (by ID)"
./pd --slot 4 --verify --mechanism RSA-PKCS --input-file data.sha --signature-file Slot4prvkey.sig
 

if [ $ErrorCount -ne 0 ]; then 
 echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
 echo Verification errors: $ErrorCount
 echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
 (exit 1)
fi
echo ==== Finished - OK ====
