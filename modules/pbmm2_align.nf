#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// Cluster the BAM with Isoseq inside conda environment
process ALIGN_BAM {
    conda '/home/lwallac2/.conda/envs/PacBio_LR'
    
    input:
    path bam
    path reference_fasta

    output:
    path("*.aligned.bam")

    script:
    template 'pbmm2_align.sh'

}