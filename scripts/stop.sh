#!/bin/bash
#
# Shell Script to stop 
# Author: truzzt GmbH
# Copyright 2023

source scripts/load_environment.sh

if [ "$TRUZZTPORT_ENV_SLUG" = "local" ]; then
   docker compose -f docker/docker-compose.yml -f docker/docker-compose.local.yml down
else
    docker compose -f docker/docker-compose.yml -f docker/docker-compose.traefik.yml down
fi
