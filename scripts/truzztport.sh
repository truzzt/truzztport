#!/bin/bash
#
# Shell Script to start 
# Author: truzzt GmbH
# Copyright 2023

set -e

# Check if the script is called with one or two arguments
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $0 init|add|start|stop|debug|clean"
  exit 1
fi

# Set the COMMAND variable based on the input
case "$1" in
  init)
    source scripts/check_dependencies.sh
    source scripts/load_environment.sh
    source scripts/setups/setup_ca.sh
    exit 0
    ;;
  add)
    ENV_FILE=".env"

    # Check the value of the OSTYPE variable
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i "" "s/^TRUZZTPORT_ENV_SLUG=.*/TRUZZTPORT_ENV_SLUG=$2/" $ENV_FILE
    elif [[ "$OSTYPE" == "linux-gnu" ]]; then
        sed -i "s/^TRUZZTPORT_ENV_SLUG=.*/TRUZZTPORT_ENV_SLUG=$2/" $ENV_FILE
    else
      echo "Unsupported operating system"
    fi

    source scripts/load_environment.sh
    source scripts/setups/setup_directories.sh
    source scripts/setups/setup_subca.sh
    source scripts/setups/setup_daps.sh
    source scripts/setups/setup_broker.sh
    source scripts/setups/setup_clearing.sh
    source scripts/setups/setup_connector.sh

    # Get all exported variables with the "TRUZZTPORT" prefix from the environment
    env | grep -E '^TRUZZTPORT_[a-zA-Z_][a-zA-Z0-9_]*=' | sed 's/^//' >> "data/.$TRUZZTPORT_ENV_SLUG.env"
    exit 0
    ;;
  start)
    COMMAND="up -d"
    ;;
  stop)
    COMMAND="down"
    ;;
  debug)
    COMMAND="up"
    ;;
  clean)
    sudo rm -rf ./data
    exit 0
    ;;
  *)
    echo "Invalid action. Use init|add|start|stop|debug|clean"
    exit 1
    ;;
esac

ACTION="$1"
ENV_NAME="$2"

# Check if the environment name is provided
if [ -z "$ENV_NAME" ]; then
  echo "No environment name provided."
  exit 1
fi

# Define the path to your docker-compose.yml file
DOCKER_COMPOSE_FILE="docker/docker-compose.yml"

source scripts/load_env.sh $ENV_NAME

# Determine the compose file based on the environment
COMPOSE_FILE="-f docker/docker-compose.yml"
if [ "$TRUZZTPORT_ENV_SLUG" = "local" ]; then
  COMPOSE_FILE+=" -f docker/docker-compose.local.yml"
else
  COMPOSE_FILE+=" -f docker/docker-compose.traefik.yml"
fi

# Determine if enables the debug ports
if [ "$ACTION" = "debug" ]; then
  COMPOSE_FILE+=" -f docker/docker-compose.debug.yml"
fi

# Perform the specified action
docker compose -p truzztport $COMPOSE_FILE $COMMAND 
