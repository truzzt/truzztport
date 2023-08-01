#!/bin/bash
#
# Shell Script to setup a client
# Author: truzzt GmbH
# Copyright 2023

set -e  # Enable error handling

source scripts/load_environment.sh

# Set environment variables
client_name="$1"
country_name="$2"
organization_name="$3"
unit_name="$4"

# Generate client certificate
python3 ca/pki.py cert create --subCA "$TRUZZTPORT_CA_SUBCA" --common-name "$client_name" --algo rsa --bits 2048 --hash sha256 --country-name "$country_name" --organization-name "$organization_name" --unit-name "$unit_name" --server --client --san-name "$client_name"

# Export client certificate as PKCS12 format
CLIENT_CERT="data/cert/${client_name}.crt"
openssl pkcs12 -export -in "$CLIENT_CERT" -inkey "data/cert/${client_name}.key" -out "data/cert/${client_name}.p12" -password pass:password

# Import PKCS12 keystore to JKS format
keytool -importkeystore -srckeystore "$PWD/data/cert/${client_name}.p12" -srcstoretype pkcs12 -destkeystore "$PWD/data/cert/${client_name}.jks" -deststoretype jks -deststorepass password -srcstorepass password -noprompt 2>/dev/null

# Extract SKI and AKI from client certificate
SKI="$(openssl x509 -in "data/cert/${client_name}.crt" -noout -text | awk '/Subject Key Identifier/ {getline; print}' | tr -d ' ')"
AKI="$(openssl x509 -in "data/cert/${client_name}.crt" -noout -text | awk '/Authority Key Identifier/ {getline; print}' | tr -d ' ')"

# Generate CLIENT_ID using SKI and AKI
CLIENT_ID="$SKI:$AKI"

# Calculate CLIENT_CERT_SHA
CLIENT_CERT_SHA="$(openssl x509 -in "data/cert/${client_name}.crt" -noout -sha256 -fingerprint | awk -F '=' '{print $NF}' | tr '[:upper:]' '[:lower:]' | tr -d :)"

# Append client details to clients.yml
cat >> "data/$TRUZZTPORT_ENV_SLUG/daps/config/clients.yml" <<EOF
- client_id: $CLIENT_ID
  client_name: $client_name
  grant_types: client_credentials
  token_endpoint_auth_method: private_key_jwt
  scope: idsc:IDS_CONNECTOR_ATTRIBUTES_ALL
  attributes:
    - key: idsc
      value: IDS_CONNECTOR_ATTRIBUTES_ALL
    - key: securityProfile
      value: idsc:BASE_SECURITY_PROFILE
    - key: referringConnector
      value: https://$client_name
    - key: "@type"
      value: ids:DatPayload
    - key: "@context"
      value: https://w3id.org/idsa/contexts/context.jsonld
    - key: transportCertsSha256
      value: $CLIENT_CERT_SHA
EOF

cp "data/cert/${client_name}.crt" "data/$TRUZZTPORT_ENV_SLUG/daps/keys/clients/${CLIENT_ID}.cert"
