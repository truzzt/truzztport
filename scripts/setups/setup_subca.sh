#!/bin/bash
#
# Shell Script to setup subca
# Author: truzzt GmbH
# Copyright 2023

# Environment variables for the flags
common_name="$TRUZZTPORT_CA_COMMON_NAME"
common_name_subca="$TRUZZTPORT_ENV_SLUG.$TRUZZTPORT_CA_COMMON_NAME"
organization_name="$TRUZZTPORT_CA_ORGANIZATION_NAME"
country_name="$TRUZZTPORT_CA_COUNTRY_NAME"
unit_name="$TRUZZTPORT_CA_UNIT_NAME"

python3 ca/pki.py subca create --CA "$common_name" --common-name "$common_name_subca" --organization-name "$organization_name" --country-name "$country_name" --unit-name "$unit_name" --hash sha512
