#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// All of the default parameters are being set in `nextflow.config`

// Import sub-workflows
include { refine_bam } from './modules/isoseq_refine'

// Function which prints help message text
def helpMessage() {
    log.info"""
Usage:

nextflow run FredHutch/workflow-template-nextflow <ARGUMENTS>

Required Arguments:

  Input Data:
  --bam_directory           A directory containing the BAM files to be refined. 

  Reference Data:
  --primer_fasta            Location of the fasta file containing the primer sequences used in 
                             the sequencing run.

  Output Location:
  --output_folder       Folder for output files

Optional Arguments:

""".stripIndent()
}


// Main workflow
workflow {

    // Define the pattern which will be used to find the BAM files
    bam_pattern = "${params.bam_directory}/*bam" 

    // Set up a channel from the bam files found with that pattern
    bam_channel = Channel
        .fromPath(bam_pattern)
        .ifEmpty { error "No files found matching the pattern ${bam_pattern}" }
        .map{
            println("Reading BAM file: ${it.name}")
            [it.baseName, it]
        }

    // Refine the BAM files
    refine_bam(
        bam_ch
    )

}