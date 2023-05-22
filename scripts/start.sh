#!/bin/bash

docker compose -f docker/docker-compose.yml --env-file config/.env up -d
