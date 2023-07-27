#!/bin/bash
#
# Shell Script to start 
# Author: truzzt GmbH
# Copyright 2023

set -e

if [ $# -eq 0 ]; then
  echo "Please specify env"
  exit
fi

echo STARTING $1 ...

source scripts/load_environment.sh $1

# Extract SKI and AKI from client certificate
BROKER_SKI="$(openssl x509 -in "data/cert/$TRUZZTPORT_BROKER_DOMAIN.crt" -noout -text | awk '/Subject Key Identifier/ {getline; print}' | tr -d ' ')"
BROKER_AKI="$(openssl x509 -in "data/cert/$TRUZZTPORT_BROKER_DOMAIN.crt" -noout -text | awk '/Authority Key Identifier/ {getline; print}' | tr -d ' ')"

CONNECTOR_SKI="$(openssl x509 -in "data/cert/$TRUZZTPORT_CONNECTOR_DOMAIN.crt" -noout -text | awk '/Subject Key Identifier/ {getline; print}' | tr -d ' ')"
CONNECTOR_AKI="$(openssl x509 -in "data/cert/$TRUZZTPORT_CONNECTOR_DOMAIN.crt" -noout -text | awk '/Authority Key Identifier/ {getline; print}' | tr -d ' ')"

export TRUZZTPORT_BROKER_SKI_AKI=$BROKER_SKI:$BROKER_AKI
export TRUZZTPORT_CONNECTOR_SKI_AKI=$CONNECTOR_SKI:$CONNECTOR_AKI


if [ "$TRUZZTPORT_ENV_SLUG" = "local" ]; then
  docker compose -f docker/docker-compose.yml -f docker/docker-compose.local.yml up -d
else
  docker compose -f docker/docker-compose.yml -f docker/docker-compose.traefik.yml up -d
fi
