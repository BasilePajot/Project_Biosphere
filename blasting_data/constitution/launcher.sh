#!/bin/sh
#SBATCH --job-name=biosphere
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=96:00:00
#SBATCH --mail-user=basile.pajot@supagro.fr  # Please change this mail when you use it :)
#SBATCH --mail-type=end

# Commands used for debugging
#rm slurm* database/Order_* orders.tsv

# Commands to make it run
Rscript Global_database_simulation.R
