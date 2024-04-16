#!/bin/bash

set -euo pipefail

# CHECKS
echo "Preparing Input GFF $gff"

# Run the collapse command
echo "Running Pigeon Prepare"
pigeon prepare \
    ${gff} \

echo "$gff prepared for classification"