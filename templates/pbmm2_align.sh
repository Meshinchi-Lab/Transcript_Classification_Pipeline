#!/bin/bash

set -euo pipefail

# CHECKS

echo "Alignment Input Bam: $bam"
ehco "Using Reference Fasta: $reference_fasta"

# Run the alignment command
pbmm2 align \
    --preset ISOSEQ \
    --sort ${bam} \
    ${reference_fasta} \ 
    ${bam}.aligned.bam \

echo "Alignment complete for $bam"