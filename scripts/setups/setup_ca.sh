#!/bin/bash

python3 ca/pki.py init
python3 ca/pki.py ca create --common-name "$TRUZZTPORT_DOMAIN" --organization-name "$TRUZZTPORT_CA_ORGANIZATION_NAME" --country-name "$TRUZZTPORT_CA_COUNTRY_NAME" --unit-name "$TRUZZTPORT_CA_UNIT_NAME" --hash sha512
