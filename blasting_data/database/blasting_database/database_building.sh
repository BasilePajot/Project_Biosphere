#!/bin/sh
#SBATCH --job-name=biosphere
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=96:00:00
#SBATCH --mem=50G


# from https://docs.qiime2.org/2021.11/tutorials/feature-classifier/

# The files are already in the working environment so there is no need to import them.
#wget \
  #-O "fasta_file.fasta" \
  #"/lustre/pajotb/project_biosphere/blasting_data/database/fasta_file/test_fasta_file.fasta"
#wget \
  #-O "text_file.txt" \
  #"/lustre/pajotb/project_biosphere/blasting_data/database/fasta_file/test_text_file.txt"
#wget \
  #-O "rep-seqs.qza" \
  #"https://data.qiime2.org/2021.11/tutorials/training-feature-classifiers/rep-seqs.qza"

##################### Isis_references.fas == sequences      
##################### test_sequences == testing sequences to test the classifier
##################### 

# Transforming the fasta file into a qza file

qiime2_2021.11.sif tools import --type 'FeatureData[Sequence]' --input-path ../fasta_file/final_fasta_file.fasta --output-path fasta_sequences.qza

# Transforming the fasta file used to train the classifier into a qza file

qiime2_2021.11.sif tools import --type 'FeatureData[Sequence]' --input-path ../fasta_file/training_fasta_file.fasta --output-path training_fasta_file.qza

# Transforming the text file containing the taxonomy of each sequence in the fasta file into a qza file so it can be used in the following steps

qiime2_2021.11.sif tools import --type 'FeatureData[Taxonomy]' --input-format HeaderlessTSVTaxonomyFormat --input-path ../fasta_file/text_file.txt --output-path taxonomy.qza

# extract reference reads (this part is not executed because all the seqeunces are filtered beforehand and are exactly 658 bp)

#qiime2_2021.11.sif feature-classifier extract-reads \
#  --i-sequences 85_otus.qza \
#  --p-f-primer GTGCCAGCMGCCGCGGTAA \
#  --p-r-primer GGACTACHVGGGTWTCTAAT \
#  --p-trunc-len 120 \
#  --p-min-length 100 \
#  --p-max-length 400 \
#  --o-reads ref-seqs.qza


# train the classifier (this takes a lot of time [start-time = 14h12; finish time = ])
qiime2_2021.11.sif feature-classifier fit-classifier-naive-bayes --i-reference-reads fasta_sequences.qza --i-reference-taxonomy taxonomy.qza --o-classifier Classifier.qza --verbose

  # test the classifier
qiime2_2021.11.sif feature-classifier classify-sklearn --i-classifier Classifier.qza --i-reads training_fasta_file.qza --o-classification test_taxonomy.qza

qiime2_2021.11.sif metadata tabulate --m-input-file test_taxonomy.qza --o-visualization test_taxonomy.qzv
# SO FAR SO GOOD


# Export feature table to a qza. Im going to assume your feature table is called feature-table.qza
qiime2_2021.11.sif tools export \
 --input-path ../../../analyse_runs/code_results/demo_biosph_1_pb_reads_leaves2021/HCO/plaque1_HCO_table.biom/feature-table.biom \
 --output-path feature-table/feature-table.qza

# Then export your taxonomy
qiime2_2021.11.sif tools export \
 --input-path taxonomy.qza \
 --output-path taxonomy
#Open the taxonomy and change the header. When you open it, you’ll see the header looks like this:
#Feature ID	Taxon	Confidence 
#where the spaces are tabs. You need to change it to this:
#otu-id	taxonomy	Confidence

#Add the metadata to the biom table
biom add-metadata \
 --input-fp feature-table/feature-table.biom \
 --observation-metadata-fp taxonomy/taxonomy.qza \
 --output-fp biom-with-taxonomy.biom

#Export the biom table to text
biom convert \
 --input-fp biom-with-taxonomy.biom \
 --output-fp biom-with-taxonomy.tsv \
 --to-tsv \
 --output-observation-metadata \
 --header-key taxonomy
