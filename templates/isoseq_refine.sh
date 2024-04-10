#!/bin/bash

set -euo pipefail

# CHECKS
if [[ -v CONDA_DEFAULT_ENV ]]; then
    echo "Current Conda environment: \$CONDA_DEFAULT_ENV"
else
    echo "No Conda environment activated"
fi
echo " Refine Input Bam: $bam"
echo "Primer Set: $primers"

echo "Running IsoSeq Refine"
isoseq refine \
    ${bam} \
    ${primers} \
    ${bam}.refined.bam \

echo "Refinement complete for $bam"