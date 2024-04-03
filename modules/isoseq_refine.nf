#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// Refine BAM with Isoseq inside conda environment
process refine_bam {
    conda 'PacBio_LR'
    
    input:
    file bam
    path primers
    path output_directory

    output:
    file("${bam.baseName}_refined.bam")

    //publishDir "${output_directory}/refined_bam", mode: 'copy'

    script:
    """
    /fh/fast/meshinchi_s/workingDir/scripts/lwallac2/Workflows/Transcript_Classification_Pipeline/Transcript_Classification_Pipeline/templates/isoseq_refine.sh ${bam}
    """

}
