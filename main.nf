#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// All of the default parameters are being set in `nextflow.config`

// Import sub-workflows
include { validate_manifest } from './modules/manifest'



// Function which prints help message text
def helpMessage() {
    log.info"""
Usage:

nextflow run FredHutch/workflow-template-nextflow <ARGUMENTS>

Required Arguments:

  Input Data:
  --bam_folder        Folder containing PacBio BAM ccs processed files,
                        identified with ".bam".

  Reference Data:
  --genome_fasta        Reference genome to use for alignment, in FASTA format

  Output Location:
  --output_folder       Folder for output files

Optional Arguments:
  --min_qvalue          Minimum quality score used to trim data (default: ${params.min_qvalue})
  --min_align_score     Minimum alignment score (default: ${params.min_align_score})
    """.stripIndent()
}


// Main workflow
workflow {


    // Define the pattern which will be used to find the FASTQ files
    bam_pattern = "${params.bam_folder}/*bam" 

    // Set up a channel from the bam files found with that pattern
    bam_ch = Channel
        .fromPath(bam_pattern)
        .ifEmpty { error "No files found matching the pattern ${bam_pattern}" }
        .map{
            [it.baseName, it]
        }

    // Perform quality trimming on the input 
    refine_wf(
        bam_ch
    )
    // output:
    //   bam:
    //     

    // Align the quality-trimmed reads to the reference genome
    align_wf(
        quality_wf.out.reads,
        file(params.genome_fasta)
    )
    // output:
    //   bam:
    //     tuple val(specimen), path(bam)

}