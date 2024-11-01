#!/bin/bash

# Check if directory exists and remove it if it does
if [ -d "./generated_tcl_parameter" ]; then
    echo "Removing existing ./generated_tcl_parameter directory..."
    rm -rf ./generated_tcl_parameter
fi

# Print a message and create the directory
echo "Creating a new ./generated_tcl_parameter directory..."
mkdir ./generated_tcl_parameter

# Check if the directory was successfully created
if [ $? -eq 0 ]; then
    echo "Directory created successfully."
else
    echo "Failed to create directory." >&2
    exit 1
fi

