#!/bin/bash

# Check if the .env file exists
if [ -f data/.$1.env ]; then
  # Load the environment variables from .env file
  while read -r line || [[ -n "$line" ]]; do
    export "$line"
  done < data/.$1.env

  echo "Environment variables from .env loaded and exported successfully."
else
  echo "No data/.$1.env file found."
fi
