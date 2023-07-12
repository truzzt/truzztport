#!/bin/bash
#
# Shell Script to setup subca
# Author: truzzt GmbH
# Copyright 2023

python3 ca/pki.py subca create --CA "$TRUZZTPORT_DOMAIN" --common-name "$TRUZZTPORT_CA_SUBCA" --organization-name "$TRUZZTPORT_CA_ORGANIZATION_NAME" --country-name "$TRUZZTPORT_CA_COUNTRY_NAME" --unit-name "$TRUZZTPORT_CA_UNIT_NAME" --hash sha512
