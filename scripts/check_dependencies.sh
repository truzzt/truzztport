#!/bin/bash
#
# Shell Script to Check Dependencies
# Author: truzzt GmbH
# Copyright 2023

# Function to check if a command is available
check_command() {
    if command -v "$1" &> /dev/null; then
        echo "$2 check passed"
    else
        echo "Please install $2"
    fi
}

# Function to check if a Python module is available
check_python() {
    if python3 -c "import $1" &> /dev/null; then
        echo "$2 check passed"
    else
        echo "Please install $2"
    fi
}

# Check if Python 3 is installed
check_command "python3" "Python3"

# Check if PyOpenSSL module is installed
check_python "OpenSSL" "PyOpenSSL"

# Check if OpenSSL command is available
check_command "openssl" "OpenSSL"

# Check if Docker command is available
check_command "docker" "Docker"

# Check if Keytool command is available
check_command "keytool" "Keytool"
