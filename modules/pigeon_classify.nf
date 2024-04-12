#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// Cluster the BAM with Isoseq inside conda environment
process CLASSIFY_GFF {
    conda '/home/lwallac2/.conda/envs/PacBio_LR'
    
    tag "Classify ${gff} with PIGEON"

    input:
    path gff
    path abundance
    path gtf
    path fasta

    output:
    path("*.collapsed.sorted.gff")

    script:
    template 'pigeon_classify.sh'

}