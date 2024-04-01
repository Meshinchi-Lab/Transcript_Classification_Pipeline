#!/bin/bash

# Run the workflow on the test data, and write the output to output/
nextflow \
    run \
    main.nf \
    --bam_folder /fh/scratch/delete90/meshinchi_s/lwallac2/KF_BAM_Operations/Unaligned_RNAseq/ \
    --primer_fasta /fh//fh/fast/meshinchi_s/workingDir/scripts/lwallac2/Python/PacBio_LR_Initial_Investigation/IsoSeq_Primers_12_Barcodes_v1_barcodeset.fasta \
    --output_folder /fh/scratch/delete90/meshinchi_s/lwallac2/NF_Transcript_Classification/ \
    -with-report \
    -resume