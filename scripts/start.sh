#!/bin/bash
#
# Shell Script to start 
# Author: truzzt GmbH
# Copyright 2023

source scripts/load_environment.sh
docker compose -f docker/docker-compose.yml up -d
