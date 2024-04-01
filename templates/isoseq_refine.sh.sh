#!/bin/bash


set -euo pipefail


echo "Input Bam: $bam"
echo "Primer Set: $primers"
echo "Output Filename: $output_filename"


echo "Running IsoSeq Refine"
isoseq refine \
    ${bam} \
    ${primers} \
    ${output_filename} \

echo "DONE"