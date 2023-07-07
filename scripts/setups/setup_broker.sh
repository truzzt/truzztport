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
source scripts/setups/setup_client.sh "broker.$common_name_subca" "$country_name" "$organization_name" "$unit_name"
cp $PWD/data/cert/${client_name}.jks $PWD/data/$TRUZZTPORT_ENV_SLUG/broker/keystore.jks
