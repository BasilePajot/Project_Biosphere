#!/bin/sh
#SBATCH --job-name=qiime2
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=99:00:00
#SBATCH --mail-user=basile.pajot@supagro.fr
#SBATCH --mail-type=end

# Here, we define some variables that are given in the launcher and passed on.
project="$1"
marker="$2"
truncf="$3"
truncr="$4"
size="$5"
min="$6"
max="$7"
# The next variables are commented because they are not used in this file, but it may be interesting to use them according to the work you want to do
# min=$(expr ${size} - 1)
# max=$(expr ${size} + 1)

# The first command is used to cut off the primers of the extracted sequences. It takes into account the forward and reverse sequences of the primers and cuts them off the sequence. It also makes a first filter on the primer-less sequences. If they are too short (<100bp), they will not be kept for the rest of the analysis. It also takes into account a small error rate that allows the fact that in the sequencing process, the primers might have changed (or at least on one base), so that it can still recognize them.... 
qiime2_2022.2.sif cutadapt trim-paired --p-front-f file:forward_${marker}.fas --p-front-r file:reverse_${marker}.fas --p-error-rate 0.05 --p-times 1 --p-match-adapter-wildcards TRUE --verbose --p-minimum-length 100 --p-discard-untrimmed TRUE --i-demultiplexed-sequences ${project}.qza --o-trimmed-sequences ${project}_${marker}_trimmed.qza

# The following line is used to denoise the first one
qiime2_2022.2.sif dada2 denoise-paired --i-demultiplexed-seqs  ${project}_${marker}_trimmed.qza --p-trunc-len-f ${truncf} --p-trunc-len-r ${truncr} --p-chimera-method 'consensus' --p-n-reads-learn 1000000 --p-hashed-feature-ids TRUE --o-table  ${project}_${marker}_table.qza --o-representative-sequences  ${project}_${marker}_sequences.qza --o-denoising-stats  ${project}_${marker}_denoising-stats.qza --verbose

# This line is used to filter the sequences according to their length. It takes the sequences from the file in "--i-data" and ouputs a file which name is given in "--o-filtered-data". This line is commented here because it is not used in this analysis, but it may be useful to use this line if you need to filter some data.
# qiime2_2022.2.sif feature-table filter-seqs --i-data ${project}_${marker}_sequences.qza --m-metadata-file ${project}_${marker}_sequences.qza --p-where "length(sequence) > ${min} AND length(sequence) < ${max}" --o-filtered-data ${project}_${marker}_filtered_sequences.qza --verbose

# This line is used to filter the sequences in the feature table according to their length. It takes the sequences from the file in "--i-data" and ouputs a file which name is given in "--o-filtered-data". This line is commented here because it is not used in this analysis, but it may be useful to use this line if you need to filter some data.
# qiime2_2022.2.sif feature-table filter-features --i-table ${project}_${marker}_table.qza --m-metadata-file ${project}_${marker}_sequences.qza --p-where "length(sequence) > ${min} AND length(sequence) < ${max}" --o-filtered-table ${project}_${marker}_filtered_table.qza --verbose

# This line is used to export the results of the denoising stats that are put in the directory given in the "--output-path". This directory is automatically created when this line is reached
qiime2_2022.2.sif tools export --input-path  ${project}_${marker}_denoising-stats.qza --output-path  ${project}_${marker}_dada2_output

# This line is used to export the results of the calculated feature table. It is put in a "biom" format which is a universal format to present the feature tables.
qiime2_2022.2.sif tools export --input-path ${project}_${marker}_table.qza --output-path ${project}_${marker}_table.biom

# This last line is used to convert the file from the biom format to the tsv format to be readable by other softwares and usable in the folowing steps of the analysis.
singularity exec /nfs/work/biomics/shared_softwares/qiime2/qiime2_2020.2.sif bash -c "HDF5_USE_FILE_LOCKING=FALSE biom convert -i ${project}_${marker}_table.biom/feature-table.biom --to-tsv -o ${project}_${marker}_table.tsv"
