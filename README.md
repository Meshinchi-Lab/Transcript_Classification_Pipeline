# Transcript_Classification_Pipeline
An end to end transcript classification pipeline for PacBio long read RNAseq data using [PIGEON](https://github.com/PacificBiosciences/pigeon)

### Purpose
The purpose of this pipeline is to classify transcripts which have been generated via PacBio long read sequencing. 

### Outline 
This pipeline is designed to run on the Fred Hutch HPC, Gizmo. It follows the reccomended workflow outlined in the Iso-Seq.how documentation [here](https://isoseq.how/classification/pigeon.html).

STEPS
Starting with HiFi reads which have been proccessed by ccs to consensus bams. 

1. Refine
   The refine command removes PolyA tails and performs rapid concatemer identification and removal.

2. Cluster
   Clustering of transcripts identifies similar transcripts and groups them together. The output is a file with full-length non-concatemer reads clustered together with prediction accuracy >0.99.
   
3. Align
   Reads are mapped to a reference using PBMM2 and sorted. 
   
4. Collapse
   Redundant transcripts are collapsed into unique isoforms on the basis of (exonic) structure
   
5. Prepare
   The preparation step sorts and indexes the reference genome annotation files as well as the input transcript GFF which will be classified in the following step.
   
6. Classify
   Finally, isoforms are categorized by exon structure.

   [Classification Categories](https://isoseq.how/classification/categories) 

### TODO

1. Update to run using conda environment yaml such that anyone could build the environment from scratch and does not need access to my home directory. 

### Installation

### Usage

