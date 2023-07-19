#!/bin/bash
#
# Shell Script to stop 
# Author: truzzt GmbH
# Copyright 2023

source scripts/load_environment.sh
docker compose -f docker/docker-compose.yml -f docker/docker-compose.traefik.yml down
