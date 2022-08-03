#!/bin/sh

DEFAULT_IFS=$IFS   # Here, we define a local variable that we will use in this script 
IFS=$'\n'          # Modifying the variable that was saved just before on which we will be acting in the rest of the script

# This command imports the data in the qiime2 environment from the directory given in the "--input-path" and outputs a file which name is given in the "--ouput-path". It converts all the sequences from the "fastq.gz" format and trasnforms them into a "qza" format usable by qiime2.
qiime2_2022.2.sif tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path reads --input-format CasavaOneEightSingleLanePerSampleDirFmt --output-path plaque1.qza

# Here, we will be doing a loop in the "metedata.tsv" file. Go see what it contains to be sure to understand. This loop goes through the "metadata.tsv" file and takes out one line each time
for i in $(tail -n+2 metadata.tsv); do 
    IFS=$DEFAULT_IFS          # Here, we re-define the variable that was changed before.
    #In the folowing line, we define three environmental variables "SINGULARITY_CACHEDIR", "MPLCONFIGDIR" and "NUMBA_CACHE_DIR" that give a directory that allows the qiime2 software to write on the cluster.
    # Then, we export these variables in a sbatch job, allowing us to not stay in front of the computer during all the analysis, but to launch it and leave it working in the cluster's background.
    # Finaly, we give the name of the script to launch and the variable ${i} is passed on to the script as a variable.
    SINGULARITY_CACHEDIR=/lustre/${USER}/.singularity MPLCONFIGDIR=/lustre/${USER}/ NUMBA_CACHE_DIR=/lustre/${USER} sbatch --export=PATH,SINGULARITY_CACHEDIR,MPLCONFIGDIR,NUMBA_CACHE_DIR ./script_metabarcoding_publi.sh ${i}
done
