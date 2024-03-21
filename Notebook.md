# Transcript Classification Pipeline
### Logan Wallace
### Date: 2024-03-24

## Background

PacBio long read sequencing has been performed on over 30 patients. While we do not currently have normal samples for comparison, we will be recieving many more in the future and a workflow will be critical for efficient processing of this transcriptomic data.

## Purpose

To perform transcript classification on 'raw' PacBio isoseq data to identify novel isoforms and or differential isoform usage which is relevant to pediatric AML. 

## Work

Created repo _https://github.com/Meshinchi-Lab/Transcript_Classification_Pipeline_

A workflow can be seen in the README.md file in that repository.

I will be trying to follow the NextFlow repo structure from Sam Minot's example [here](https://github.com/FredHutch/workflow-template-nextflow)

The essential components of the workflow repository are:

main.nf: Contains the primary workflow code which pulls in all additional code from the repository
modules/: Contains all of the sub-workflows which are used to organize large chunks of analysis
templates/: Contains all of the code which is executed in each individual step of the workflow

### Error when trying to push to github

Returned this error when trying to run git status
_fatal: not a git repository (or any parent up to mount point /Volumes/fh/fast) Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set)._



### Required inputs

The inputs for this workflow are as follows - 
1. Unaligned but CCS processed, BAM(s). Can be given as a manifest argument which points to a file hosting the filenames or as a filename argument. 
2. References which will be used in the workflow; Should default to PacBio reference files and GRCh38 if the user does not provide them. 