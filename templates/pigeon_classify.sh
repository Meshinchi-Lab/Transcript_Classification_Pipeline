#!/bin/bash

set -euo pipefail

# CHECKS
echo "Classifying $gff"

# Run the collapse command
echo "Running Pigeon Classify"
pigeon classify \
    ${gff} \
    ${gtf} \
    ${fasta} \
    --fl ${abundance} \

echo "$gff classification has been completed"