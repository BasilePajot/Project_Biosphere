#!/bin/sh
#SBATCH --job-name=biosphere
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=96:00:00
#SBATCH --mail-user=basile.pajot@supagro.fr
#SBATCH --mail-type=end

SINGULARITY_CACHEDIR=/lustre/${USER}/.singularity MPLCONFIGDIR=/lustre/${USER}/ NUMBA_CACHE_DIR=/lustre/${USER} sbatch --export=PATH,SINGULARITY_CACHEDIR,MPLCONFIGDIR,NUMBA_CACHE_DIR /lustre/pajotb/blasting_data/database/concatenation/script_concat.sh
