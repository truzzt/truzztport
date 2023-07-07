#!/bin/bash

# Environment variables for the flags
common_name="$TRUZZTPORT_CA_COMMON_NAME"
organization_name="$TRUZZTPORT_CA_ORGANIZATION_NAME"
country_name="$TRUZZTPORT_CA_COUNTRY_NAME"
unit_name="$TRUZZTPORT_CA_UNIT_NAME"

python3 ca/pki.py init
python3 ca/pki.py ca create --common-name "$common_name" --organization-name "$organization_name" --country-name "$country_name" --unit-name "$unit_name" --hash sha512
