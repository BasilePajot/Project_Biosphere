#!/bin/sh
#SBATCH --job-name=biosphere
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=96:00:00
#SBATCH --array=1-925%10
#SBATCH --mail-user=basile.pajot@supagro.fr
#SBATCH --mail-type=end

ORDER_FILES=$1
module load R.4.0.2

echo ------ $i --------------
Rscript Global_database_simulation.R ${SLURM_ARRAY_TASK_ID} --save
