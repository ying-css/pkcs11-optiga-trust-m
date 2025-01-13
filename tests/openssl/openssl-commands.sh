#!/bin/bash

# SPDX-FileCopyrightText: 2024 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT


export PKCS11_PROVIDER_MODULE=liboptigatrust-i2c-linux-pkcs11.so

set -e

clear
echo "Worked OpenSSL command examples:"
echo "=================================================="
echo "======>"	

pkcs11-tool --module $PKCS11_PROVIDER_MODULE --list-objects --slot 0
#~ openssl pkey -in pkcs11:id=%e0f1 -pubin -pubout -text
openssl dgst -engine pkcs11 -sign "pkcs11:token=Token1;id=%e0f1;object=PrvKey;type=private" -keyform engine -out signa-ture.bin -sha384 test.txt

echo ==== Finished - OK ====
