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
                  echo SET $key=${!key}
              fi
          done < "$env_file"
      else
          echo "Could not find $env_file."
      fi
  }

  # Function to set domain variables
  set_domain_variable() {
    local variable_name=$1
    local subdomain_variable_name=$2
    local port_variable_name=$3
    local prefix_variable_name=$4
    
    if [ -n "$2" ] && [ -n "${!subdomain_variable_name}" ]; then
        local subdomain="${!subdomain_variable_name}."
    fi
    
    if [ -n "$3" ] && [ -n "${!port_variable_name}" ]; then
        local port=":${!port_variable_name}"
    fi
    
    if [ -n "$4" ] && [ -n "${!prefix_variable_name}" ]; then
        local prefix="${!prefix_variable_name}"
    fi

    if [ "$TRUZZTPORT_ENV_SLUG" = "local" ]; then
        export "$variable_name"="${TRUZZTPORT_DOMAIN}${port}${prefix}"
    else
        export "$variable_name"="${subdomain}${env_slug}${TRUZZTPORT_DOMAIN}${port}${prefix}"
    fi

    if [ "TRUZZTPORT_ENV_SLUG" = "local" ]; then
        echo SET "$variable_name"="${TRUZZTPORT_DOMAIN}${port}${prefix}"
    else
        echo SET "$variable_name"="${subdomain}${env_slug}${TRUZZTPORT_DOMAIN}${port}${prefix}"
    fi
  }

  # Specify the path to your .env file
  env_file=".env"

  # Call the function to read the .env file
  read_env_file "$env_file"

  # Array of domain variables and their associated variables
  domain_variables=(
    "TRUZZTPORT_DAPS_DOMAIN TRUZZTPORT_DAPS_SUBDOMAIN TRUZZTPORT_DAPS_PORT"
    "TRUZZTPORT_BROKER_DOMAIN TRUZZTPORT_BROKER_SUBDOMAIN TRUZZTPORT_BROKER_IDS_PORT"
    "TRUZZTPORT_BROKER_IDS_DOMAIN TRUZZTPORT_BROKER_SUBDOMAIN TRUZZTPORT_BROKER_IDS_PORT TRUZZTPORT_BROKER_IDS_PREFIX"
    "TRUZZTPORT_BROKER_MANAGEMENT_DOMAIN TRUZZTPORT_BROKER_SUBDOMAIN TRUZZTPORT_BROKER_MANAGEMENT_PORT TRUZZTPORT_BROKER_MANAGEMENT_PREFIX"
    "TRUZZTPORT_BROKER_DATA_DOMAIN TRUZZTPORT_BROKER_SUBDOMAIN TRUZZTPORT_BROKER_DATA_PORT TRUZZTPORT_BROKER_DATA_PREFIX"
    "TRUZZTPORT_BROKER_API_DOMAIN TRUZZTPORT_BROKER_SUBDOMAIN TRUZZTPORT_BROKER_API_PORT TRUZZTPORT_BROKER_API_PREFIX"
    "TRUZZTPORT_CONNECTOR_DOMAIN TRUZZTPORT_CONNECTOR_SUBDOMAIN TRUZZTPORT_CONNECTOR_IDS_PORT"
    "TRUZZTPORT_CONNECTOR_IDS_DOMAIN TRUZZTPORT_CONNECTOR_SUBDOMAIN TRUZZTPORT_CONNECTOR_IDS_PORT TRUZZTPORT_CONNECTOR_IDS_PREFIX"
    "TRUZZTPORT_CONNECTOR_MANAGEMENT_DOMAIN TRUZZTPORT_CONNECTOR_SUBDOMAIN TRUZZTPORT_CONNECTOR_MANAGEMENT_PORT TRUZZTPORT_CONNECTOR_MANAGEMENT_PREFIX"
    "TRUZZTPORT_CONNECTOR_DATA_DOMAIN TRUZZTPORT_CONNECTOR_SUBDOMAIN TRUZZTPORT_CONNECTOR_DATA_PORT TRUZZTPORT_CONNECTOR_DATA_PREFIX"
    "TRUZZTPORT_CONNECTOR_API_DOMAIN TRUZZTPORT_CONNECTOR_SUBDOMAIN TRUZZTPORT_CONNECTOR_API_PORT TRUZZTPORT_CONNECTOR_API_PREFIX"
    "TRUZZTPORT_CLEARING_DOMAIN TRUZZTPORT_CLEARING_SUBDOMAIN TRUZZTPORT_CLEARING_PORT"
    "TRUZZTPORT_CA_SUBCA"
  )

  # Set domain variables
  env_slug="${TRUZZTPORT_ENV_SLUG}."
  for entry in "${domain_variables[@]}"; do
      set_domain_variable $entry
  done

