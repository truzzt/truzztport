#!/bin/bash

python3 ca/pki.py init
python3 ca/pki.py ca create --common-name dataspace --organization-name test --country-name DE --unit-name test --hash sha512
python3 ca/pki.py subca create --CA dataspace --common-name dataspaceSubCa --organization-name test --country-name DE --unit-name test --hash sha384

mkdir -p data/daps/clients
echo "---" > data/daps/clients.yml

./scripts/create_client.sh broker.local
./scripts/create_client.sh daps.local
openssl pkcs12 -export -in data/cert/broker.local.crt -inkey data/cert/broker.local.key -out data/cert/broker.local.p12  -password pass:password
openssl pkcs12 -export -in data/cert/daps.local.crt -inkey data/cert/daps.local.key -out data/cert/daps.local.p12  -password pass:password
keytool -importkeystore -srckeystore data/cert/broker.local.p12 -srcstoretype pkcs12 -destkeystore data/cert/broker.local.jks -deststoretype jks -deststorepass password -srcstorepass password -noprompt 2>/dev/null

