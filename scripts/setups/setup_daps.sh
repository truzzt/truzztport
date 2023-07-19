#!/bin/bash
#
# Shell Script to setup daps
# Author: truzzt GmbH
# Copyright 2023

# Define the omejdn contents
omejdn_contents=$(cat <<EOL
plugins:
  user_db:
    yaml:
      location: config/users.yml
  claim_mapper:
    attribute:
      skip_access_token: false
      skip_id_token: true
  api:
    admin_v1: 
    user_selfservice_v1:
      allow_deletion: false
      allow_password_change: true
      editable_attributes: []
user_backend_default: yaml
environment: production
issuer: $TRUZZTPORT_DAPS_DOMAIN
front_url: $TRUZZTPORT_DAPS_DOMAIN
bind_to: 0.0.0.0:4567
openid: true
default_audience: idsc:IDS_CONNECTORS_ALL
accept_audience: idsc:IDS_CONNECTORS_ALL
access_token:
  expiration: 3600
  algorithm: RS256
id_token:
  expiration: 3600
  algorithm: RS256
EOL
)

# Define the omejdn-plugins contents
omejdn_plugins_contents=$(cat <<EOL
plugins:
  token_user_attributes:
    skip_id_token: true
EOL
)

# Define the scope_description contents
scope_description_contents=$(cat <<EOL
---
omejdn:read: Read access to the Omejdn server API
omejdn:write: Write access to the Omejdn server API
omejdn:admin: Access to the Omejdn server admin API
profile: 'Standard profile claims (e.g.: Name, picture, website, gender, birthdate,
  location)'
email: Email-Address
address: Address
phone: Phone-number
EOL
)

# Define the scope_mapping contents
scope_mapping_contents=$(cat <<EOL
---
idsc:IDS_CONNECTOR_ATTRIBUTES_ALL:
- securityProfile
- referringConnector
- "@type"
- "@context"
- transportCertsSha256
EOL
)

# Define the users contents
users_contents=$(cat <<EOL
---
- username: admin
  attributes:
  - key: omejdn
    value: admin
  password: "\$2a\$12\$3NVyFBT4Biqhd9D5IokNFuL78NH8pvR/Ir48Ci6FlA8yKuLZuzqFa"
  backend: yaml
EOL
)

# Define the webfinger contents
webfinger_contents=$(cat <<EOL
--- {}
EOL
)

# Create the files
echo "$omejdn_contents" > $PWD/data/$TRUZZTPORT_ENV_SLUG/daps/config/omejdn.yml
echo "$omejdn_plugins_contents" > $PWD/data/$TRUZZTPORT_ENV_SLUG/daps/config/omejdn-plugins.yml
echo "$scope_description_contents" > $PWD/data/$TRUZZTPORT_ENV_SLUG/daps/config/scope_description.yml
echo "$scope_mapping_contents" > $PWD/data/$TRUZZTPORT_ENV_SLUG/daps/config/scope_mapping.yml
echo "$users_contents" > $PWD/data/$TRUZZTPORT_ENV_SLUG/daps/config/users.yml
echo "$webfinger_contents" > $PWD/data/$TRUZZTPORT_ENV_SLUG/daps/config/webfinger.yml

python3 ca/pki.py cert create --subCA "$TRUZZTPORT_CA_SUBCA" --common-name "$TRUZZTPORT_DAPS_DOMAIN" --algo rsa --bits 2048 --hash sha256 --country-name "$TRUZZTPORT_CA_COUNTRY_NAME" --organization-name "$TRUZZTPORT_CA_ORGANIZATION_NAME" --unit-name "$TRUZZTPORT_CA_UNIT_NAME" --server --client --san-name "$TRUZZTPORT_DAPS_DOMAIN" --san-ip 127.0.0.1
openssl x509 -inform "PEM" -outform "DER" -in "data/cert/$TRUZZTPORT_DAPS_DOMAIN.crt" -out "data/cert/$TRUZZTPORT_DAPS_DOMAIN.der"
cp "$PWD/data/cert/$TRUZZTPORT_DAPS_DOMAIN.key" "$PWD/data/$TRUZZTPORT_ENV_SLUG/daps/keys/omejdn/omejdn.key"
cp "$PWD/data/cert/$TRUZZTPORT_DAPS_DOMAIN.crt" "$PWD/data/$TRUZZTPORT_ENV_SLUG/broker/daps.crt"
cp "$PWD/data/cert/$TRUZZTPORT_DAPS_DOMAIN.der" "$PWD/data/$TRUZZTPORT_ENV_SLUG/clearing/daps.der"
