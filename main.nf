#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// Create message for process logs
log.info """\
        PACBIO TRANSCRIPT CLASSIFICATION PIPELINE
        =========================================
        Bam_Directory: ${params.bam_directory}
        Output_Directory: ${params.output_directory}
        """ 
        .stripIndent()

// Function which prints help message text
def helpMessage() {
    log.info"""

Usage:

nextflow run FredHutch/workflow-template-nextflow <ARGUMENTS> OR 

sbatch run_main.sh <ARGUMENTS>

Required Arguments:

  Input Data:
  --bam_directory                   A directory containing the BAM files to be refined. All files ending 
                                    in '.bam' in this location will be processed. 

  Reference Data:
  --primer_fasta                    Location of the fasta file containing the primer sequences used in 
                                    the sequencing run.
  
  --classification_reference_gtf    Location of the GTF file containing the reference transcriptome
                                    for classification.
  
  --classification_reference_fasta  Location of the fasta file containing the reference transcriptome

  --alignment_reference_fasta       Location of the fasta file containing the reference genome for alignment

Output Data:

  --output_directory                The directory where the output files will be written. 

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

// Channel definition

// Initial input BAM channel
bam_pattern = "${params.bam_directory}*bam" 

bam_ch = Channel
    .fromPath(bam_pattern)
    .ifEmpty { error "No files found matching the pattern ${bam_pattern}" }

// Channels for collapse process
// Set up a channel for the abundance files
abundance_ch = Channel
    .empty()
        
// Set up a channel for the GFF files
gff_ch = Channel
    .empty()

// Main workflow
workflow {

    // Refine the BAM files
    REFINE_BAM(bam_ch, file(params.primer_fasta))

    // Cluster the refined BAM files
    CLUSTER_BAM(REFINE_BAM.out)

    // Align the clustered BAM files
    ALIGN_BAM(CLUSTER_BAM.out, file(params.alignment_reference_fasta))

    // Collapse the aligned BAM files
    COLLAPSE_BAM(ALIGN_BAM.out)
    abundance = COLLAPSE_BAM.out[0]
    gff = COLLAPSE_BAM.out[1]

    // CHECK
    abundance.view()
    gff.view()

    // Prepare the collapsed BAM files for classification
    PREPARE_GFF(gff)

    // Classify the prepared GFF files
    CLASSIFY_GFF(PREPARE_GFF.out, abundance, file(params.classification_reference_gtf), file(params.classification_reference_fasta))
}