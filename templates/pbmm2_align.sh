#!/bin/bash

set -euo pipefail

# CHECKS

echo "Alignment Input Bam: $bam"

# Run the alignment command
pbmm2 align \
    --preset ISOSEQ \
    --sort ${bam} \
    ${bam}.pbmm2.aligned.bam \

echo "Alignment complete for $bam"