#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// Refine BAM with Isoseq 
process refine_bam {
    container "${params.container__refine_bam}"
    publishDir "${params.output_folder}/alignments/${specimen}/", mode: 'copy', overwrite: true
    
    input:
    tuple path(bam), path(primers), val(output_filename)

    output:
    tuple val(specimen), path("aligned.bam"), emit: bam

    script:
    template 'isoseq_refine.sh'

}
