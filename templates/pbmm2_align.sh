#!/bin/bash

set -euo pipefail

# CHECKS

echo "Alignment Input Bam: $bam"
echo "Using Reference Fasta: $alignment_reference_fasta"

# Run the alignment command
pbmm2 align \
    --preset ISOSEQ \
    --sort ${bam} \
    ${alignment_reference_fasta} \
    ${bam}.aligned.bam \

echo "Alignment complete for $bam"