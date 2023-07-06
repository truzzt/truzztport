#!/bin/bash
#
# Shell Script to load environment
# Author: truzzt GmbH
# Copyright 2023

# Function to read .env file and export variables
read_env_file() {
    local env_file="$1"

    # Check if .env file exists
    if [ -f "$env_file" ]; then
        # Read each line in .env file
        while IFS='=' read -r key value; do
            # Remove leading/trailing whitespace from key and value
            key="${key// /}"
            value="${value// /}"

            # Skip empty lines and comments
            if [[ -n "$key" && ! "$key" =~ ^# ]]; then
                export "$key"="$value"
                echo "Loaded environment variable: $key"
            fi
        done < "$env_file"

        echo "Environment variables loaded from $env_file."
    else
        echo "Could not find $env_file."
    fi
}

# Specify the path to your .env file
env_file=".env"

# Call the function to read the .env file
read_env_file "$env_file"
