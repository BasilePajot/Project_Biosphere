#!/bin/sh
DEFAULT_IFS=$IFS
IFS=$'\n'
#data=${1}

for i in $(tail -n+2 metadata.tsv); do
    SINGULARITY_CACHEDIR=/lustre/${USER}/.singularity MPLCONFIGDIR=/lustre/${USER}/ NUMBA_CACHE_DIR=/lustre/${USER} sbatch --export=PATH,SINGULARITY_CACHEDIR,MPLCONFIGDIR,NUMBA_CACHE_DIR ./database_using.sh ${i} #${data}
    IFS=$DEFAULT_IFS 

done
