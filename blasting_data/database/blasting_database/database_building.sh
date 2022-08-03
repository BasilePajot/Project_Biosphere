#!/bin/sh
#SBATCH --job-name=biosphere
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=96:00:00
#SBATCH --mem=100G
#SBATCH --output=/lustre/%u/project_biosphere/blasting_data/database/blasting_database/logs/output-%j.out           # OUTPUT FILE
#SBATCH --error=/lustre/%u/project_biosphere/blasting_data/database/blasting_database/err/output-%j.err             # ERROR FILE

data=${1}
# Transforming the fasta file into a qza file

qiime2_2022.2.sif tools import --type 'FeatureData[Sequence]' --input-path ../fasta_file/${data}_fasta_file.fasta --output-path ${data}_fasta_sequences.qza

# Transforming the fasta file used to train the classifier into a qza file

# qiime2_2022.2.sif tools import --type 'FeatureData[Sequence]' --input-path ../fasta_file/training_fasta_file.fasta --output-path training_fasta_file.qza

# Transforming the text file containing the taxonomy of each sequence in the fasta file into a qza file so it can be used in the following steps

qiime2_2022.2.sif tools import --type 'FeatureData[Taxonomy]' --input-format HeaderlessTSVTaxonomyFormat --input-path ../fasta_file/${data}_text_file.txt --output-path ${data}_taxonomy.qza

# Train the classifier (this takes a lot of time)
qiime2_2022.2.sif feature-classifier fit-classifier-naive-bayes --i-reference-reads ${data}_fasta_sequences.qza --i-reference-taxonomy ${data}_taxonomy.qza --o-classifier ${data}_Classifier.qza --verbose

echo 'done'
