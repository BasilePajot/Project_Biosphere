#!/bin/sh
#SBATCH --job-name=qiime2
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=99:00:00
#SBATCH --mail-user=basile.pajot@supagro.fr
#SBATCH --mail-type=end

project="$1"
marker="$2"
truncf="$3"
truncr="$4"
# size="$5"
# min=$(expr ${size} - 1)
# max=$(expr ${size} + 1)
# rm -r reads 
# mkdir reads
# cp raw_data/*.fastq.gz reads/

# qiime2_2021.11.sif tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path ./reads --input-format CasavaOneEightSingleLanePerSampleDirFmt --output-path ${project}.qza

qiime2_2021.11.sif cutadapt trim-paired --p-front-f file:forward_${marker}.fas --p-front-r file:reverse_${marker}.fas --p-error-rate 0.05 --p-times 1 --p-match-adapter-wildcards TRUE --verbose --p-minimum-length 100 --p-discard-untrimmed TRUE --i-demultiplexed-sequences ${project}.qza --o-trimmed-sequences ${project}_${marker}_trimmed.qza

qiime2_2021.11.sif dada2 denoise-paired --i-demultiplexed-seqs  ${project}_${marker}_trimmed.qza --p-trunc-len-f ${truncf} --p-trunc-len-r ${truncr} --p-chimera-method 'consensus' --p-n-reads-learn 10000 --p-hashed-feature-ids TRUE --o-table  ${project}_${marker}_table.qza --o-representative-sequences  ${project}_${marker}_sequences.qza --o-denoising-stats  ${project}_${marker}_denoising-stats.qza --verbose

qiime2_2021.11.sif tools export --input-path  ${project}_${marker}_denoising-stats.qza --output-path  ${project}_${marker}_dada2_output

qiime2_2021.11.sif tools export --input-path ${project}_${marker}_table.qza --output-path ${project}_${marker}_table.biom
