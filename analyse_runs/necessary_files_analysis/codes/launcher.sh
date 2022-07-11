#!/bin/sh
# SINGULARITY_CACHEDIR=/lustre/${USER}/.singularity
# MPLCONFIGDIR=/lustre/${USER}/ 
# NUMBA_CACHE_DIR=/lustre/${USER}
DEFAULT_IFS=$IFS
IFS=$'\n'
qiime2_2021.11.sif tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path reads --input-format CasavaOneEightSingleLanePerSampleDirFmt --output-path plaque1.qza

for i in $(tail -n+2 metadata.tsv)
do 
    IFS=$DEFAULT_IFS 
SINGULARITY_CACHEDIR=/lustre/${USER}/.singularity MPLCONFIGDIR=/lustre/${USER}/ NUMBA_CACHE_DIR=/lustre/${USER} sbatch --export=PATH,SINGULARITY_CACHEDIR,MPLCONFIGDIR,NUMBA_CACHE_DIR ./script_metabarcoding_publi.sh ${i}
done
