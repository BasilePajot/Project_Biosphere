#!/bin/sh
#SBATCH --job-name=biosphere
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=96:00:00

# This first line is used to take the name of the first taxa from the list you want to get and use it as a variable.
first=$(head -n 3 ../../All_orders_to_get.tsv | tail -n 1)

# Then, you launch the script called concat_script.R with the variable that was made before
Rscript ./concat_script.R $first --save
