#!/bin/bash
#
# Shell Script to stop 
# Author: truzzt GmbH
# Copyright 2023

set -e

if [ $# -eq 0 ]; then
  echo "Please specify env"
  exit
fi

echo STARTING $1 ...

source scripts/load_environment.sh $1

if [ "$TRUZZTPORT_ENV_SLUG" = "local" ]; then
   docker compose -f docker/docker-compose.yml -f docker/docker-compose.local.yml down
else
    docker compose -f docker/docker-compose.yml -f docker/docker-compose.traefik.yml down
fi
