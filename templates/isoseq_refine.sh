#!/bin/bash


set -euo pipefail

# Extract the basename and append the new suffix
base=$(basename $bam)
output_filename="${base%.*}_refined.bam"

echo "Input Bam: $bam"
echo "Primer Set: $primers"
echo "Output Filename: $output_filename"


echo "Running IsoSeq Refine"
isoseq refine \
    ${bam} \
    ${primers} \
    ${output_filename} \

echo "DONE"