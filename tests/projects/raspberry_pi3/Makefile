# Copyright (c) 2018 Infineon Technologies AG
# SPDX-FileCopyrightText: 2024 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

#Include build congiguration, compiler to be used, file name/directory definitions
-include Config.mk

.PHONY: all $(sample_libusb) $(sample_i2c)

all: $(wolfssl) $(sample_libusb) $(sample_i2c)

#Make application note

#Include build congiguration, compiler to be used, file name/directory definitions
-include ../../Config.mk

#Source code root directory from the directory of this make file
ROOT_DIR = ../../
#~ PKCS11_INCLUDE_DIR = ../../../optiga-trust-m/examples/utilities
PKCS11_INCLUDE_DIR = ../../../examples/utilities

#Bin directory..
BIN_DIR = ./lib/

#Header file dependencies
INCLUDES = -I$(PKCS11_INCLUDE_DIR)/include -I$(ROOT_DIR)cunit_framework/include

#Compiler flags
CFLAGS = $(INCLUDES) -g -Wall -c -DWOLFSSL_RPI3_OPTIGA
LDFLAGS	= -L/usr/local/lib
LDLIBS  = -lrt -lm -lpthread -lssl -lcrypto -lcunit

#Binary output file name
TrustM_Sample_USB_Name = OPTIGA_Trust_M_PKCS11_Test_usbdongle
TrustM_Sample_i2c_Name = OPTIGA_Trust_M_PKCS11_Test_i2c

#Actual source code file to be built
SRC = \
$(ROOT_DIR)cunit_framework/c_unit_helper.c \
$(ROOT_DIR)test/test_holder_pkcs11.c \
$(ROOT_DIR)test/st_C_test_utility.c \
$(ROOT_DIR)test/st_C_Initialize_Finalize.c \
$(ROOT_DIR)test/st_C_GenerateRandom.c \
$(ROOT_DIR)test/st_C_GenerateKeyPair.c \
$(ROOT_DIR)test/st_C_Sign.c \
$(ROOT_DIR)test/st_C_Verify.c \
$(ROOT_DIR)test/st_C_Encrypt_Decrypt.c \
$(ROOT_DIR)test/st_C_Digest.c \
$(ROOT_DIR)test/st_C_GetTokenInfo.c \
$(ROOT_DIR)test/st_C_GetMechanismInfo.c \
$(ROOT_DIR)test/st_C_GetAttributeValue.c \
$(ROOT_DIR)test/st_C_FindObjects.c \
$(ROOT_DIR)main/main.c \

#Make Platform Crypto layer
$(wolfssl):
	$(MAKE) --directory=$@

COBJS = $(SRC:.c=.o)

$(COBJS) : %.o : %.c
	$(CC) $(CFLAGS) $<
	mv *.o $(BIN_DIR)
	
all: $(COBJS) sample_libusb sample_i2c

sample_libusb:
	$(CC) -o "$(BIN_DIR)/$(TrustM_Sample_USB_Name)" "$(BIN_DIR)/"*.o -L$(BIN_DIR) $(LDLIBS) -loptigatrust-libusb-linux-pkcs11
	
sample_i2c:
	$(CC) -o "$(BIN_DIR)/$(TrustM_Sample_i2c_Name)" "$(BIN_DIR)/"*.o -L$(BIN_DIR) $(LDLIBS) -loptigatrust-i2c-linux-pkcs11



clean:
	$(CLEAN) "$(BIN_DIR)/"*.o
	$(CLEAN) "$(BIN_DIR)/"OPTIGA_Trust_M_PKCS11_Test_libusb
	$(CLEAN) "$(BIN_DIR)/"OPTIGA_Trust_M_PKCS11_Test_i2c
