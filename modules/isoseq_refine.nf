#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// Refine BAM with Isoseq inside conda environment
process refine_bam {
    conda 'PacBio_LR'
    
    input:
    tuple path(bam), path(primers)

    output:

    script:
    template 'isoseq_refine.sh'

}
