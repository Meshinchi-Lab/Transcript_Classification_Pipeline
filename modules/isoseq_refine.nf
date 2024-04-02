#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// Refine BAM with Isoseq inside conda environment
process refine_bam {
    conda 'PacBio_LR'
    
    input:
    tuple val(bam_filename) from bam_channel
    path primer_fasta from params.primer_fasta
    path output_directory from params.output_directory

    output:
    file("${bam_filename}_refined.bam")

    publishDir "${output_directory}/refined_bam", mode: 'copy'

    script:
    template 'isoseq_refine.sh'

}
