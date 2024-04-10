#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// Creeate message for process logs
log.info """\
        PACBIO TRANSCRIPT CLASSIFICATION PIPELINE
        =========================================
        """ 
        .stripIndent()
// All of the default parameters are being set in `nextflow.config`

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

Optional Arguments:

""".stripIndent()
}

// Import sub-workflows
include { REFINE_BAM } from './modules/isoseq_refine'
include { CLUSTER_BAM } from './modules/isoseq_cluster'
include { ALIGN_BAM } from './modules/pbmm2_align'
include { COLLAPSE_BAM } from './modules/isoseq_collapse'
include { PREPARE_GFF } from './modules/pigeon_prepare'
include { CLASSIFY_GFF } from './modules/pigeon_classify'

// Main workflow
workflow {

    // CHECK
    println(params.bam_directory)

    // Define the pattern which will be used to find the BAM files
    bam_pattern = "${params.bam_directory}*bam" 

    // Set up a channel from the bam files found with that pattern
    bam_ch = Channel
        .fromPath(bam_pattern)
        .ifEmpty { error "No files found matching the pattern ${bam_pattern}" }

    // CHECK
    // bam_ch.view()

    // Refine the BAM files
    REFINE_BAM(bam_ch, file(params.primer_fasta))

    // Cluster the refined BAM files
    CLUSTER_BAM(REFINE_BAM.out)

    // Align the clustered BAM files
    ALIGN_BAM(CLUSTER_BAM.out, file(params.alignment_reference_fasta))

    // Collapse the aligned BAM files
    COLLAPSE_BAM(ALIGN_BAM.out)

    // Prepare the collapsed BAM files for classification
    PREPARE_GFF(COLLAPSE_BAM.out)

    // Classify the prepared GFF files
    CLASSIFY_GFF(PREPARE_GFF.out, path(abundance), file(params.classification_reference_gtf), file(params.classification_reference_fasta))
}