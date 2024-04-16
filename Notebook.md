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

Error - "Another git process seems to be running in this repository, e.g.
an editor opened by 'git commit'. Please make sure all processes
are terminated then try again. If it still fails, a git process
may have crashed in this repository earlier:
remove the file manually to continue."
Fix - Manually delete the index.lock file by running

```rm -f .git/index.lock```

### Required inputs

The inputs for this workflow are as follows - 
1. Unaligned but CCS processed, BAM(s). Can be given as a manifest argument which points to a file hosting the filenames or as a filename argument. 
2. References which will be used in the workflow; Should default to PacBio reference files and GRCh38 if the user does not provide them. 

### Creating a docker container to run the process

We are going to wait to do this because the simplest path forward is to use a conda environment that I have setup on the cluster already. This conda environment is PacBio_LR which has all of the PacBio tools necessary already installed. 

### Pipeline Creation Notes

4.4.24

I ran into an error that took some time troubleshooting. The shell script which serves as the template for the nextflow process was causing nextflow to throw a ton of errors. This was because of how nextflow interprets bash commands from a template script. It does not allow for the full suite of bash commands and there needs to be a lot of escaping of variables passed to get things to work. 

Today, I am hoping to get through the alignment process. Currently, I am at the point of having the refinement run on the bam files but we are seeing an error with the output filename. I think this will be fixed by making sure that the output names match between the shell and the nf scripts for the isoseq_refine process. I am noticing that when I run the sbatch from a gizmo node it recognizes the conda environment that I am trying to utilize, but otherwise it does not. 

The command is reaching the isoseq command it looks like and then exiting without 

After troubleshooting with Sam Minot I have a couple notes;
1. I should be spending more time with the documentation when I encounter a problem. 
2. Conda is a totally appropriate way to run this pipeline, however I should create a conda.yaml so that the environment can be created on the cluster for anyone in the lab that wants to run the pipeline and not just myself. For now, I could point to the full path where the environment is hosted. 
    First, needed to enable conda in the configuration file. 
    Second, I found where the conda environment was created and can reference with the full path. 
    Finally, created a conda_env.yml file that tells conda how to create the environment. 
3. Inputs and outputs. There are two main directives, PATH() and FILE(). Basically, path will give the location and file with pass the whole file as input directly. There is a little more nuance than that but this is a useful way to think about it. Defining an explicit output directory, makes the output from a process

OK, have incorporated template scripts for clustering and alignment. I should just do the whole thing and to troubleshoot I can run on a smaller amount of files as neccessary. 

Now, need to do the same for the next couple of processes!
    - collapse
    - prepare
    - classify
Add a template script for each, add a module.nf script for each and then add to the main.nf script. 

Also, need to figure out how to have the collapsing step / preparation step pass the abundance file to the classification step.

Need to add some files to the run_main.sh and the config file as well as move the reference pigeon classification data from PacBio to a more appropriate location. Moved the reference data to here - /Volumes/fh/fast/meshinchi_s/workingDir/scripts/Reference_Data/PacBio_References

Now I just need to figure out how to emit the data to a desired location. Anh suggests doing some like; 

process COLLAPSE_BAM() {
  input: 
  output:
    file "*.bam" into for_classify_gff
    val x into for_prepare_gff
}

// Cluster the BAM with Isoseq inside conda environment
process COLLAPSE_BAM {
    conda '/home/lwallac2/.conda/envs/PacBio_LR'
    
    input:
    path bam

    output:
    path("*.abundance.txt") into abundance_ch
    path("*.collapsed.gff") into gff_ch 

    script:
    template 'isoseq_collapse.sh'

}

So I need to pass the abundance_ch to classify process and the gff_ch into the prepare step. 

OK, that's updated apporoximately how I think it should be. What shut down our last run? We should additionally create a sample directory to run in along with a sample BAM file which we have trimmed down for faster running. 
    Sorting the error;
        Here is the error that appears in the report...
        Workflow execution completed unsuccessfully!
The exit status of the task that caused the workflow execution to fail was: 139.

The full error message was:

Error executing process > 'cluster_bam (40)'

Caused by:
  Process `cluster_bam (40)` terminated with an error exit status (139)

Command executed [/fh/fast/meshinchi_s/workingDir/scripts/lwallac2/Workflows/Transcript_Classification_Pipeline/Transcript_Classification_Pipeline/templates/isoseq_cluster.sh]:

  #!/bin/bash
  
  set -euo pipefail
  
  # CHECKS
  echo "Cluster Input Bam: PAUWHF.refined.bam"
  
  # Run the cluster command
  echo "Running IsoSeq Cluster"
  isoseq cluster2     PAUWHF.refined.bam     PAUWHF.refined.bam.clustered.bam 
  echo "Clustering complete for bam"

Command exit status:
  139

Command output:
  Cluster Input Bam: PAUWHF.refined.bam
  Running IsoSeq Cluster

Command error:
  | 20240409 21:26:25.299 | INFO | Effective commandline : cluster2 PAUWHF.refined.bam PAUWHF.refined.bam.clustered.bam
  | 20240409 21:26:25.299 | INFO | Version               : 4.0.0 (commit v4.0.0)
  | 20240409 21:26:25.299 | INFO | Options 
  | 20240409 21:26:25.299 | INFO | - CPU threads         : 48
  | 20240409 21:26:25.299 | INFO | - Sorting threads     : 48
  | 20240409 21:26:25.299 | INFO | - Kmer size           : 17
  | 20240409 21:26:25.299 | INFO | - Merge rounds        : 2
  | 20240409 21:26:25.299 | INFO | - 5' overhang         : 100
  | 20240409 21:26:25.299 | INFO | - 3' overhang         : 30
  | 20240409 21:26:25.299 | INFO | - 5' errors           : 5
  | 20240409 21:26:25.299 | INFO | - 3' errors           : 10
  | 20240409 21:26:25.299 | INFO | - 5' non-match window : 10
  | 20240409 21:26:25.299 | INFO | - 3' non-match window : 10
  | 20240409 21:26:25.299 | INFO | - Max gaps            : 5
  | 20240409 21:26:25.299 | INFO | - Gap window          : 20
  | 20240409 21:26:25.299 | INFO | - Max consensus cov   : 50
  | 20240409 21:26:25.299 | INFO | - Deduplicate         : True
  | 20240409 21:26:25.299 | INFO | - Break clusters      : True
  | 20240409 21:26:25.299 | INFO | - Break consensus     : True
  | 20240409 21:26:25.299 | INFO | - Output singletons   : False
  | 20240409 21:26:25.299 | INFO | - POA intermediate    : False
  | 20240409 21:26:25.299 | INFO | - POA final           : True
  | 20240409 21:26:25.299 | INFO | - Use QVs for POA     : False
  | 20240409 21:26:25.299 | INFO | Temp file name        : /loc/scratch/40389952/tmp.7724.bam
  | 20240409 21:26:25.382 | INFO | Get offsets
  | 20240409 21:30:22.188 | INFO | Get offsets           : 3m 56s 
  | 20240409 21:30:22.188 | INFO | Consolidate offsets
  | 20240409 21:30:22.280 | INFO | Consolidate offsets   : 91ms 777us 
  | 20240409 21:30:22.280 | INFO | Sorting
  | 20240409 21:30:22.483 | INFO | Sorting               : 203ms 602us 
  | 20240409 21:30:22.588 | INFO | Write sorted
  | 20240409 22:10:05.890 | INFO | Write sorted          : 39m 43s 
  | 20240409 22:10:06.478 | INFO | Dedup
  | 20240409 22:12:26.514 | INFO | Dedup                 : 2m 20s 
  | 20240409 22:12:26.588 | INFO | Clustering
  | 20240409 22:25:17.034 | INFO | Clustering            : 12m 50s 
  | 20240409 22:25:17.722 | INFO | Merge clusters
  | 20240409 22:25:22.136 | INFO | Clustering            : 4s 413ms 
  | 20240409 22:25:22.147 | INFO | Break coarse clusters
  | 20240409 23:26:01.981 | INFO | Break coarse clusters : 1h 834ms 
  | 20240409 23:26:02.028 | INFO | Break again
  | 20240409 23:53:52.121 | INFO | Break again           : 27m 50s 
  | 20240409 23:53:52.168 | INFO | Consensus
  .command.sh: line 10:  7724 Segmentation fault      (core dumped) isoseq cluster2 PAUWHF.refined.bam PAUWHF

    It is some sort of memory error. Do I simply need to ask for more memory or is this a little more nuanced of a question?

    lwallac2@rhino01:~$ cat   /fh/scratch/delete90/meshinchi_s/lwallac2/Nextflow/2b/d517bc679d2c047b848e87be9d2486/.command.sh
#!/bin/bash

set -euo pipefail

# CHECKS
echo "Cluster Input Bam: PAUWHF.refined.bam"

# Run the cluster command
echo "Running IsoSeq Cluster"
isoseq cluster2     PAUWHF.refined.bam     PAUWHF.refined.bam.clustered.bam
echo "Clustering complete for bam"
lwallac2@rhino01:~$

So this command looks good. Maybe there is something more tricky going on with the memory?

OK, after messing with the input output channels it looks like I was able to get it running again but I really don't want to have it running on all these files and hogging the cluster, let's see if I can get it to run on a smaller set.
Making a testDir and testBAM;
    Let's make a testDir in a nearby location with only a couple files. /fh/scratch/delete90/meshinchi_s/lwallac2/KF_BAM_Operations/testDir. This directory contains two files.

executor >  slurm (2)
[34/849316] process > REFINE_BAM (2)  [100%] 2 of 2, cached: 2 ✔
[54/133187] process > CLUSTER_BAM (1) [ 50%] 1 of 2, cached: 1
[58/497da6] process > ALIGN_BAM (1)   [  0%] 0 of 1
[-        ] process > COLLAPSE_BAM    -
[-        ] process > PREPARE_GFF     -
[-        ] process > CLASSIFY_GFF    -
ERROR ~ Error executing process > 'ALIGN_BAM (1)'

Caused by:
  Process `ALIGN_BAM (1)` terminated with an error exit status (1)

Command executed [/fh/fast/meshinchi_s/workingDir/scripts/lwallac2/Workflows/Transcript_Classification_Pipeline/Transcript_Classification_Pipeline/templates/pbmm2_align.sh]:

  #!/bin/bash
  
  set -euo pipefail
  
  # CHECKS
  
  echo "Alignment Input Bam: PAUMGZ.refined.bam.clustered.bam"
  echo "Using Reference Fasta: human_GRCh38_no_alt_analysis_set.fasta"
  
  # Run the alignment command
  pbmm2 align     --preset ISOSEQ     --sort PAUMGZ.refined.bam.clustered.bam     human_GRCh38_no_alt_analysis_set.fasta 
      PAUMGZ.refined.bam.clustered.bam.aligned.bam 
  echo "Alignment complete for PAUMGZ.refined.bam.clustered.bam"

Command exit status:
  1

Command output:
  Alignment Input Bam: PAUMGZ.refined.bam.clustered.bam
  Using Reference Fasta: human_GRCh38_no_alt_analysis_set.fasta

Command error:
  >|> 20240412 19:01:22.205 -|- FATAL -|- DetermineInputTypeApprox -|- 0x148fd1496f00|| -|- pbmm2 align ERROR: Input data file does not exist: human_GRCh38_no_alt_analysis_set.fasta

Work dir:
  /fh/scratch/delete90/meshinchi_s/lwallac2/Nextflow/58/497da6c3abdd4073e402d3afc2005e

The above error is telling me that the file is not found, however, when I go to the working directory for that process I am finding the file where expected. 

So it might be an issue with the way I am passing the path or how the file is staged. I think I am referencing it properly, but it still isn't finding it. Even if I update the script to say path().

The symbolic link was broken, so while the item was pointing to the appropriate file and it looked like it was in the working dir, it was really an empty symbolic link and needed to be updated. I had the right path in the configuration file but not in the run_main.sh batch script and this was ruining the call and didn't allow for the file to be found. 

I forgot i was working on the wiki pages on github and loaded an image that I didn't ask git to ignore. This caused a merge issue when I had no idea about what work I had actually done, oops! But this is now resolved and recent commits have been pushed! Nextflow is running as hoped and I just want to make a couple updates before leaving for the day to the logging and adding checkIfExists prior to running it. 































## Notes on Nextflow

### Fundamentals

    Channel inputs are not considered in order. That is, if a channel is used as input to a process, all the inputs from the process are likely to be run simultaneously and will not be run one at a time. Therefore, trying to organize a process by the input order is usually not a functional method.

    .command files within the working directory can tell us a lot about the run. 
        .command.begin will tell you that the process has began.
    
    .command.sh will give you the actual command that was run. 

    If we want to change the number of cpus that a process has, we can specify like, 
        process MY_PROCESS{
            cpus X
            input:
            output:
            script:
        }
    
    A channel factory is created like 
        read_pairs_ch = Channel.fromFilePairs(params.reads)
        Above will create a list with file pairs from the directory in params.reads. 
        You can also use the .set { read_pairs_ch } operator to create the variable. There is no difference between using .set{} or = , just syntax. I personally like the = operator. 

    Using checkIfExists is a good check to make sure that the input files are making it into our downstream process. 

    A tag directive can be addded to a process to provide a more readable execution log, 
        process MY_PROCESS{
            tag "MY_PROCESS on $sample_id" 
        }
    
    A publishDir directive can be added to a process to publish the results from a process to a results folder. 
        publishDir params.outidr, mode: 'copy' - will copy the outputs from the process to the specified output directory. In our case, we'll want to save the final results from the classification process. I just need to check and see if this will write out all files resultant from the process or just those specified by output: 
    
    The .mix() channel operator can  be used to combine multiple channels to a single line. 

    If you want to generate a graph of the process which your nextflow script is running you can use the argument -with-dag, which will generate a Directed Acrylic Graph and show the workflow of the pipeline. However, you need to have GraphViz installed on the system.

    We can run a pipeline directly from github. We aren't really concerned about this now, but might be useful in the future. 

    We ran into an error, I did not have pigeon loaded into the environment haha. So I've loaded it and we should be back up! Let's resume the run. 

The pigeon prepare command was not found and this was because, I think due to other dependencies, the newer version would not load which is needed to run the _prepare_ command. Using conda update -c bioconda pbpigeon worked but needed to update a large amount of dependencies. 

Let's try once more. 


### Groovy Basics

print values with println("")

single line comments are made with // and multiline comments like
*/
    A comment
    that is across
    multiple lines
*/

lists = [item, item, etc], groovy is 0 based (like python) so list[1] will yield the second element. 

### Channels

There are two types of channels;

Queue Channels are FIFO -
    From poducer to consumer,
    First in, first out
    The are consumed when they are used as input
    Channel.fromPath()

Value channels are also known as singleton channels,
    They can be consumed multiple times,
    Ex: ch1 = Channel.of(1, 2, 3)

fromPath() is another common channel factory to bring in a list of files,
    Ex, Channel
            .fromPath('path/to/files*.csv')

### Processes

Conditional scripts 

### NF-CORE Linting

A code linter is something that checks over code using a series of tests that check for rules or formatting of code and either flag or fix the code. 

### Best Practices

Best practice is to name processes in all uppercase so that they can be distinguished from functions.

### MISC

I need one output file from the collapse process to be used in the final step, classification but there is a process between.