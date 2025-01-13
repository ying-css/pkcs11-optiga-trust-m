#!/bin/bash

# SPDX-FileCopyrightText: 2024 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

#~ PROVIDER="/lib/liboptigatrust-i2c-linux-pkcs11.so" 
#~ export PKCS11_PROVIDER_MODULE=/usr/lib/aarch64-linux-gnu/ossl-modules/pkcs11.so
export PKCS11_PROVIDER_DEBUG=file:/tmp/debug.log,level:1
chmod +x pd
dos2unix pd

rm *.log

set -e
declare -i ErrorCount=0

clear

#~ echo "Worked OpenSC pkcs11-tool command examples:"
#~ echo "=================================================="

#~ echo "======>List slots with tokens"	
#~ ./pd --list-token-slots

#~ echo "======>List supported mechanisms"
#~ ./pd --list-mechanisms --slot 1

#~ echo "======>Show objects"
#~ ./pd --list-objects --slot 1

#~ echo "======>Generate ECC key pair"	
#~ ./pd --slot 1 --keypairgen --key-type EC:secp256r1
#~ ./pd --slot 1 --label PubKey --read-object --type data --output-file Slot1PubKey.der
#~ openssl ec -pubin -inform DER -in Slot1PubKey.der -out Token1PubKey.pem
#~ xxd Token1PubKey.pem

#~ echo "======>Hash data"	
#~ echo "01234567890123456789012345678901234567890123456789" > test.txt	
#~ ./pd --hash  --hash-algorithm SHA256 --input-file test.txt --output-file test.sha
#~ xxd test.sha 

#~ export PKCS11_PROVIDER_MODULE=/lib/liboptigatrust-i2c-linux-pkcs11.so
#~ openssl pkey -in pkcs11:id=e0e8 -pubin -pubout -text 

#~ echo "======>Generate random on chip"	
#~ ./pd --generate-random 8 --output-file rand8.bin
#~ xxd rand8.bin

 
OPENSSL_CONF=openssl_pkcs11a.cnf openssl dgst -sign "pkcs11:token=Token1"  -out signature.bin  test.txt

#~ export PKCS11_PROVIDER_MODULE=/usr/lib/aarch64-linux-gnu/ossl-modules/pkcs11.so
#~ openssl dgst -provider pkcs11 -sign "pkcs11:token=Token1"  -out signature.bin  test.txt




#~ OPENSSL_CONF=openssl_pkcs11.cnf openssl dgst -engine pkcs11 -keyform engine -sign "pkcs11:token=Token1"  -out signature.bin -sha256 test.txt

#~ # ******pkeyutl not working due to Get Attribute error
#~ OPENSSL_CONF=openssl_pkcs11.cnf openssl pkeyutl -engine pkcs11 -keyform engine -inkey "pkcs11:token=Token1"  -sign -rawin -in test.txt -digest sha256  -out signature.bin 

#~ export PKCS11_PROVIDER_MODULE=/lib/liboptigatrust-i2c-linux-pkcs11.so
#~ openssl pkeyutl -inkey "pkcs11:token=Token1;id=e0f1;object=PrvKey;type=private"  -sign -rawin -in test.txt -out signature.bin



#~ pkcs11-tool --module liboptigatrust-i2c-linux-pkcs11.so -v --slot 1 --sign --mechanism ECDSA --input-file test.sha --output-file signature.bin
#~ xxd signature.bin

#~ openssl pkeyutl -inkey "pkcs11:token=Token1;id=e0f1;object=PrvKey;type=private"  -sign -rawin -in test.txt -out signature.bin -config openssl_pkcs11a.cnf


#~ echo "======>printout signature.sig"	
#~ xxd signature.bin

#~ echo "======>ECDSA signature"	
#~ ./pd --slot 1 --sign --mechanism ECDSA --input-file test.sha --output-file Slot1prvkey.sig
#~ echo "======>printout Slot1prvkey.sig"	
#~ xxd Slot1prvkey.sig

#~ echo "======>Verify ECDSA signature"
#~ openssl dgst -verify Token1PubKey.pem -signature signature.bin -sha256 test.txt

if [ $ErrorCount -ne 0 ]; then 
 echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
 echo Verification errors: $ErrorCount
 echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
 (exit 1)
fi
echo ==== Finished - OK ====
#~ handle SIG34 nostop noprint pass noignore
