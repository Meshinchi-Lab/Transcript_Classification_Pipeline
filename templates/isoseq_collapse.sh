#!/bin/bash

set -euo pipefail

# CHECKS
echo "Collapsing Input Bam: $bam"

# Run the collapse command
echo "Running IsoSeq Collapse"
isoseq collapse \
    ${bam} \
    ${bam}.collapsed.gff \

echo "Clustering complete for $bam"