#!/bin/bash
#
# Shell Script to setup broker
# Author: truzzt GmbH
# Copyright 2023

# Define the webfinger contents
vault_contents=$(cat <<EOL
#
#  Copyright (c) 2020, 2021 Microsoft Corporation
#
#  This program and the accompanying materials are made available under the
#  terms of the Apache License, Version 2.0 which is available at
#  https://www.apache.org/licenses/LICENSE-2.0
#
#  SPDX-License-Identifier: Apache-2.0
#
#  Contributors:
#       Microsoft Corporation - initial API and implementation
#
#

company1assets-key1=key1
EOL
)

echo "$vault_contents" > $PWD/data/$TRUZZTPORT_ENV_SLUG/broker/vault.properties


# Generate client certificate
source scripts/setups/setup_client.sh "$TRUZZTPORT_BROKER_DOMAIN" "$TRUZZTPORT_CA_COUNTRY_NAME" "$TRUZZTPORT_CA_ORGANIZATION_NAME" "$TRUZZTPORT_CA_UNIT_NAME"
cp $PWD/data/cert/${TRUZZTPORT_BROKER_DOMAIN}.jks $PWD/data/$TRUZZTPORT_ENV_SLUG/broker/keystore.jks

BROKER_SKI="$(openssl x509 -in "data/cert/$TRUZZTPORT_BROKER_DOMAIN.crt" -noout -text | awk '/Subject Key Identifier/ {getline; print}' | tr -d ' ')"
BROKER_AKI="$(openssl x509 -in "data/cert/$TRUZZTPORT_BROKER_DOMAIN.crt" -noout -text | awk '/Authority Key Identifier/ {getline; print}' | tr -d ' ')"

export TRUZZTPORT_BROKER_SKI_AKI=$BROKER_SKI:$BROKER_AKI
