#!/bin/bash
#SBATCH --job-name=Transcript_Classification_Pipeline
#SBATCH --output=./slurmout/Transcript_Classification_Pipeline-%j.out

# Module Loading
ml nextflow/23.04.0

# Run the workflow on the test data, and write the output to output/
nextflow \
    run \
    main.nf \
    --bam_directory /fh/scratch/delete90/meshinchi_s/lwallac2/KF_BAM_Operations/Unaligned_RNAseq/ \
    --primer_fasta /fh/fast/meshinchi_s/workingDir/scripts/lwallac2/Python/PacBio_LR_Initial_Investigation/IsoSeq_Primers_12_Barcodes_v1_barcodeset.fasta \
    --alignment_reference_fasta /fh/fast/meshinchi_s/workingDir/scripts/Reference_Data/PacBio_References/human_GRCh38_no_alt_analysis_set.fasta \
    --classification_reference_gtf /fh/fast/meshinchi_s/workingDir/scripts/Reference_Data/PacBio_References/gencode.v39.annotation.sorted.gtf \
    --classification_reference_fasta /fh/fast/meshinchi_s/workingDir/scripts/Reference_Data/PacBio_References/human_GRCh38_no_alt_analysis_set.fasta \
    --output_directory /fh/scratch/delete90/meshinchi_s/lwallac2/NF_Transcript_Classification/ \
    -with-report \
    -resume