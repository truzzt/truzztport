#!/bin/bash
#
# Shell Script to setup broker
# Author: truzzt GmbH
# Copyright 2023

# Set environment variables
common_name_subca="$TRUZZTPORT_ENV_SLUG.$TRUZZTPORT_CA_COMMON_NAME"
common_name="$TRUZZTPORT_CA_COMMON_NAME"
organization_name="$TRUZZTPORT_CA_ORGANIZATION_NAME"
country_name="$TRUZZTPORT_CA_COUNTRY_NAME"
unit_name="$TRUZZTPORT_CA_UNIT_NAME"

# Generate client certificate
python3 ca/pki.py cert create --subCA "$common_name_subca" --common-name "broker.$common_name_subca" --algo rsa --bits 2048 --hash sha256 --country-name "$country_name" --organization-name "$organization_name" --unit-name "$unit_name" --server --client --san-name "daps.$common_name_subca" --san-ip 127.0.0.1

# Export client certificate as PKCS12 format
openssl pkcs12 -export -in "$PWD/data/cert/broker.$common_name_subca.crt" -inkey "$PWD/data/cert/broker.$common_name_subca.key" -out "$PWD/data/cert/broker.$common_name_subca.p12" -password pass:password

# Import PKCS12 keystore to JKS format
keytool -importkeystore -srckeystore "$PWD/data/cert/broker.$common_name_subca.p12" -srcstoretype pkcs12 -destkeystore "$PWD/data/$TRUZZTPORT_ENV_SLUG/broker/keystore.jks" -deststoretype jks -deststorepass password -srcstorepass password -noprompt 2>/dev/null

