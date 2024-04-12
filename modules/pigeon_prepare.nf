#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// Cluster the BAM with Isoseq inside conda environment
process PREPARE_GFF {
    conda '/home/lwallac2/.conda/envs/PacBio_LR'

    tag "Prepare ${gff} for Pigeon"
    
    input:
    path gff

    output:
    path("*.collapsed.sorted.gff")

    script:
    template 'pigeon_prepare.sh'

}