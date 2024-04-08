#!/bin/bash

set -euo pipefail

# CHECKS
echo "Cluster Input Bam: $bam"

# Run the cluster command
echo "Running IsoSeq Cluster"
isoseq cluster2 \
    ${bam} \
    ${bam}.clustered.bam \

echo "DONE"