#!/bin/bash
if test -e config/init_off.txt
then
   echo "Init-Script bereits ausgeführt. Wenn Sie es nochmal ausführen wollen, löschen Sie zuerst unter config die init.off.txt Datei."
exit
fi


python3 ca/pki.py init
python3 ca/pki.py ca create --common-name dataspace --organization-name test --country-name DE --unit-name test --hash sha512
python3 ca/pki.py subca create --CA dataspace --common-name dataspaceSubCa --organization-name test --country-name DE --unit-name test --hash sha384

mkdir -p data/daps/clients
echo "---" > data/daps/clients.yml

cp config/.env_default  config/.env
echo "Bitte geben Sie eine IP ein."
read IP
echo "BROKER_CORE_COMPONENT_URI=http://$IP:13001" >> config/.env
echo "BROKER_CORE_COMPONENT_CATALOGURI=http://$IP:13001/catalog" >> config/.env
echo "IP=$IP" >> config/.env

echo "---" > config/daps/omejdn.yml
echo "plugins:" >> config/daps/omejdn.yml
echo "  user_db:" >> config/daps/omejdn.yml
echo "    yaml:" >> config/daps/omejdn.yml
echo "      location: config/daps/users.yml" >> config/daps/omejdn.yml
echo "  claim_mapper:" >> config/daps/omejdn.yml
echo "    attribute:" >> config/daps/omejdn.yml
echo "      skip_access_token: false" >> config/daps/omejdn.yml
echo "      skip_id_token: true" >> config/daps/omejdn.yml
echo "  api:" >> config/daps/omejdn.yml
echo "    admin_v1:" >> config/daps/omejdn.yml 
echo "    user_selfservice_v1:" >> config/daps/omejdn.yml
echo "      allow_deletion: false" >> config/daps/omejdn.yml
echo "      allow_password_change: true" >> config/daps/omejdn.yml
echo "      editable_attributes: []" >> config/daps/omejdn.yml
echo "user_backend_default: yaml" >> config/daps/omejdn.yml
echo "environment: production" >> config/daps/omejdn.yml
echo "issuer: http://$IP:13000/auth" >> config/daps/omejdn.yml
echo "front_url: http://$IP:13000/auth" >> config/daps/omejdn.yml
echo "bind_to: 0.0.0.0:4567" >> config/daps/omejdn.yml
echo "openid: true" >> config/daps/omejdn.yml
echo "default_audience: idsc:IDS_CONNECTORS_ALL" >> config/daps/omejdn.yml
echo "accept_audience: idsc:IDS_CONNECTORS_ALL" >> config/daps/omejdn.yml
echo "access_token:" >> config/daps/omejdn.yml
echo "  expiration: 3600" >> config/daps/omejdn.yml
echo "  algorithm: RS256" >> config/daps/omejdn.yml
echo "id_token:" >> config/daps/omejdn.yml
echo "  expiration: 3600" >> config/daps/omejdn.yml
echo "  algorithm: RS256" >> config/daps/omejdn.yml

# Create clients for broker and DAPS
./scripts/create_client.sh broker.local
./scripts/create_client.sh daps.local

# Transform certificates from .crt and .key to .p12
BROKER_P12=data/cert/broker.local.p12 
openssl pkcs12 -export -in data/cert/broker.local.crt -inkey data/cert/broker.local.key -out $BROKER_P12 -password pass:password
openssl pkcs12 -export -in data/cert/daps.local.crt -inkey data/cert/daps.local.key -out data/cert/daps.local.p12 -password pass:password
# keytool -importkeystore -srckeystore data/cert/broker.local.p12 -srcstoretype pkcs12 -destkeystore data/cert/broker.local.jks -deststoretype jks -deststorepass password -srcstorepass password -noprompt 2>/dev/null

# Extracting the SKI:AKI for the Broker
SKI="$(grep -A1 "Subject Key Identifier"  "$BROKER_P12" | tail -n 1 | tr -d ' ')"
AKI="$(grep -A1 "Authority Key Identifier"  "$BROKER_P12" | tail -n 1 | tr -d ' ')"
echo "SKI_AKI=$SKI:$AKI" >> config/.env

# Lockfile for accidential override of config
touch config/init_off.txt
