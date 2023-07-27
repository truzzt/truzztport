#!/bin/bash
#
# Shell Script to initialize 
# Author: truzzt GmbH
# Copyright 2023

if [ $# -eq 1 ]; then

  # Check if the .env file exists
  ENV_FILE=".env"

  # Check the value of the OSTYPE variable
  if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i "" "s/^TRUZZTPORT_ENV_SLUG=.*/TRUZZTPORT_ENV_SLUG=$1/" $ENV_FILE
  elif [[ "$OSTYPE" == "linux-gnu" ]]; then
      sed -i "s/^TRUZZTPORT_ENV_SLUG=.*/TRUZZTPORT_ENV_SLUG=$1/" $ENV_FILE
  else
    echo "Unsupported operating system"
  fi


fi

source scripts/load_environment.sh
source scripts/setups/setup_directories.sh
source scripts/setups/setup_subca.sh
source scripts/setups/setup_daps.sh
source scripts/setups/setup_broker.sh
source scripts/setups/setup_clearing.sh
source scripts/setups/setup_connector.sh

# Get all exported variables with the "TRUZZTPORT" prefix from the environment
env | grep -E '^TRUZZTPORT_[a-zA-Z_][a-zA-Z0-9_]*=' | sed 's/^TRUZZTPORT_//' >> "data/.$TRUZZTPORT_ENV_SLUG.env"
