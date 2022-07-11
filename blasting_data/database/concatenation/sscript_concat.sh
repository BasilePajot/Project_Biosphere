#!/bin/sh
#SBATCH --job-name=biosphere
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=96:00:00


#order=$1

rm database_test.csv 

#touch database_test.csv


first=$(head -n 3 ../../All_orders_to_get.tsv | tail -n 1)
Rscript ./concat_script.R $first --save


#for i in $(seq 1 100000); do ll database/Orders/ | grep Order | wc -l; sleep 150; done
