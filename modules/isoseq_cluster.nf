#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// Cluster the BAM with Isoseq inside conda environment
process CLUSTER_BAM {
    conda '/home/lwallac2/.conda/envs/PacBio_LR'
    
    input:
    path bam

    output:
    path("*.clustered.bam")

    script:
    template 'isoseq_cluster.sh'

}