#!/bin/bash
#
# Shell Script to start 
# Author: truzzt GmbH
# Copyright 2023

source scripts/load_environment.sh

# Extract SKI and AKI from client certificate
BROKER_SKI="$(openssl x509 -in "data/cert/broker.dev.truzzt.com.crt" -noout -text | awk '/Subject Key Identifier/ {getline; print}' | tr -d ' ')"
BROKER_AKI="$(openssl x509 -in "data/cert/broker.dev.truzzt.com.crt" -noout -text | awk '/Authority Key Identifier/ {getline; print}' | tr -d ' ')"

CONNECTOR_SKI="$(openssl x509 -in "data/cert/connector.dev.truzzt.com.crt" -noout -text | awk '/Subject Key Identifier/ {getline; print}' | tr -d ' ')"
CONNECTOR_AKI="$(openssl x509 -in "data/cert/connector.dev.truzzt.com.crt" -noout -text | awk '/Authority Key Identifier/ {getline; print}' | tr -d ' ')"

export TRUZZTPORT_BROKER_SKI_AKI=$BROKER_SKI:$BROKER_AKI
export TRUZZTPORT_CONNECTOR_SKI_AKI=$CONNECTOR_SKI:$CONNECTOR_AKI

docker compose -f docker/docker-compose.yml -f docker/docker-compose.traefik.yml up -d
