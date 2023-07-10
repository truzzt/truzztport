#!/bin/bash
#
# Shell Script to setup directory structure
# Author: truzzt GmbH
# Copyright 2023

# Function to create preset directory structure recursively
create_preset_directory_structure() {
    local root_path="$1"
    
    # Define the preset directory structure
    local directories=(
        "data/$TRUZZTPORT_ENV_SLUG/daps/config"
        "data/$TRUZZTPORT_ENV_SLUG/daps/keys"
        "data/$TRUZZTPORT_ENV_SLUG/daps/keys/omejdn"
        "data/$TRUZZTPORT_ENV_SLUG/daps/keys/clients"
        "data/$TRUZZTPORT_ENV_SLUG/broker"
        "data/$TRUZZTPORT_ENV_SLUG/mongo"
        "data/$TRUZZTPORT_ENV_SLUG/postgres"
        "data/$TRUZZTPORT_ENV_SLUG/proxy"
        "data/$TRUZZTPORT_ENV_SLUG/clearing"
        "data/$TRUZZTPORT_ENV_SLUG/clearing/keys"
        "data/$TRUZZTPORT_ENV_SLUG/connector"
    )

    # Create directories
    for directory in "${directories[@]}"; do
        local directory_path="$root_path/$directory"
        mkdir -p "$directory_path"
    done
}

# Call the function to create the preset directory structure
create_preset_directory_structure $PWD
