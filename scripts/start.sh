#!/bin/bash
#
# Shell Script to start 
# Author: truzzt GmbH
# Copyright 2023

source scripts/load_environment.sh

# Extract SKI and AKI from client certificate
SKI="$(openssl x509 -in "data/cert/broker.dev.truzzt.com.crt" -noout -text | awk '/Subject Key Identifier/ {getline; print}' | tr -d ' ')"
AKI="$(openssl x509 -in "data/cert/broker.dev.truzzt.com.crt" -noout -text | awk '/Authority Key Identifier/ {getline; print}' | tr -d ' ')"

export SKI_AKI=$SKI:$AKI

docker compose -f docker/docker-compose.yml -f docker/docker-compose.traefik.yml up -d
