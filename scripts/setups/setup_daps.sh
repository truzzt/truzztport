#!/bin/bash
#
# Shell Script to setup daps
# Author: truzzt GmbH
# Copyright 2023

# Environment variables for the flags
common_name_subca="$TRUZZTPORT_ENV_SLUG.$TRUZZTPORT_CA_COMMON_NAME"
common_name="$TRUZZTPORT_CA_COMMON_NAME"
organization_name="$TRUZZTPORT_CA_ORGANIZATION_NAME"
country_name="$TRUZZTPORT_CA_COUNTRY_NAME"
unit_name="$TRUZZTPORT_CA_UNIT_NAME"

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
issuer: $TRUZZTPORT_DAPS_ISSUER
front_url: $TRUZZTPORT_DAPS_ISSUER
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

python3 ca/pki.py cert create --subCA "$common_name_subca" --common-name "daps.$common_name_subca" --algo rsa --bits 2048 --hash sha256 --country-name "$country_name" --organization-name "$organization_name" --unit-name "$unit_name" --server --client --san-name "daps.$common_name_subca" --san-ip 127.0.0.1
cp "$PWD/data/cert/daps.$common_name_subca.key" "$PWD/data/$TRUZZTPORT_ENV_SLUG/daps/keys/omejdn/omejdn.key"
cp "$PWD/data/cert/daps.$common_name_subca.crt" "$PWD/data/$TRUZZTPORT_ENV_SLUG/broker/daps.crt"