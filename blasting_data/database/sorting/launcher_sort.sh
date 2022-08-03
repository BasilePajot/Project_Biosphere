#!/bin/sh
#SBATCH --job-name=biosphere
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=96:00:00
#SBATCH --mail-user=basile.pajot@supagro.fr
#SBATCH --mail-type=end

# This line of command is used to define several environmental variables that are passed on through the sbatch command. It also launches the file called "sort_script.sh"
SINGULARITY_CACHEDIR=/lustre/${USER}/.singularity MPLCONFIGDIR=/lustre/${USER}/ NUMBA_CACHE_DIR=/lustre/${USER} sbatch --export=PATH,SINGULARITY_CACHEDIR,MPLCONFIGDIR,NUMBA_CACHE_DIR /lustre/pajotb/blasting_data/database/sorting/script_sort.sh
