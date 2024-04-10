#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// Refine BAM with Isoseq inside conda environment
process REFINE_BAM {
    conda '/home/lwallac2/.conda/envs/PacBio_LR'
    
    input:
    path bam
    path primers

    output:
    path("*.refined.bam")

    script:
    template 'isoseq_refine.sh'

}
