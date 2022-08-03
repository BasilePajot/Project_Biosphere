#!/bin/sh
#SBATCH --job-name=biosphere
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=96:00:00
#SBATCH --mem=50G
#SBATCH --output=/lustre/%u/project_biosphere/blasting_data/database/blasting_database/logs/output-%j.out             # OUTPUT FILE
#SBATCH --error=/lustre/%u/project_biosphere/blasting_data/database/blasting_database/err/output-%j.err              # ERROR FILE


# Use the classifier
qiime2_2022.2.sif feature-classifier classify-sklearn --i-classifier Classifier.qza --i-reads /lustre/pajotb/project_biosphere/analyse_runs/code_results/run_11-07-2022/20220711_HCO_sequences.qza --o-classification HCO_taxonomy.qza

qiime2_2022.2.sif metadata tabulate --m-input-file HCO_taxonomy.qza --o-visualization HCO_taxonomy.qzv

# Then export your taxonomy
qiime2_2022.2.sif tools export --input-path HCO_taxonomy.qza --output-path HCO_taxonomy

#Add the metadata to the biom table
singularity exec /nfs/work/biomics/shared_softwares/qiime2/qiime2_2020.2.sif bash -c "HDF5_USE_FILE_LOCKING=FALSE biom add-metadata --input-fp /lustre/pajotb/project_biosphere/analyse_runs/code_results/run_11-07-2022/20220711_HCO_table.biom/feature-table.biom --observation-metadata-fp HCO_taxonomy.qza --output-fp HCO_biom-with-taxonomy.biom"

#Export the biom table to text
singularity exec /nfs/work/biomics/shared_softwares/qiime2/qiime2_2020.2.sif bash -c "HDF5_USE_FILE_LOCKING=FALSE biom convert --input-fp HCO_biom-with-taxonomy.biom --output-fp HCO_biom-with-taxonomy.tsv --to-tsv --output-observation-metadata --header-key taxonomy"

echo 'done'
