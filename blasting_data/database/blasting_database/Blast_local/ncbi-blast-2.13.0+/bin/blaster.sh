#!/bin/sh
#SBATCH --job-name=biosphere
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=96:00:00
#SBATCH --cpus-per-task=25

# In this script, we have two command lines. The first one is used to make a database using the fasta files and the second one in the two loops is to make a blasting procedure. As the two lines are in the same script, it would be easy to uncomment all the lines to run them. But it will not work. It is recommended to first run the first line without the second loop, then run the second line to do the blasting procedure. 

for FILENAME in  arthemis bold bold_and_arthemis; do      # Here, we make a list of all the database we want to make using the different fasta files. 
    # ./makeblastdb -in ./fasta_file_${FILENAME}_blast_local.fasta -out ${FILENAME} -dbtype 'nucl' -hash_index  # To make the database   # This line is used to make the databse using the fasta files
    for MARKER in HCO HEX LEP; do  #This loop is used to realise the blasting procedure on all three markers
      ./blastn -query ./${MARKER}_sequences.fasta -task blastn -db ${FILENAME} -out ${MARKER}_${FILENAME}.csv -evalue 10 -word_size 4 -num_threads 150 -max_target_seqs 1 -outfmt 6 -perc_identity 80   # This line does the blasting procedure on the different parkers for the selected databases.
    done
done
