#!/bin/sh
#SBATCH --job-name=biosphere
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=96:00:00
#SBATCH --mem=50G

# This line just launches the Rscript
Rscript sorting_script.R
