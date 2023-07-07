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
source scripts/setups/setup_client.sh "broker.$common_name_subca" "$country_name" "$organization_name" "$unit_name"
cp $PWD/data/cert/${client_name}.jks $PWD/data/$TRUZZTPORT_ENV_SLUG/broker/keystore.jks
