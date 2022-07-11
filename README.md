# Project_Biosphere

This project gives an overview of the analysis of environmental DNA extracted on wheat leaves. 

  This code is used after the DNA as sequenced and may be applied to any type of sequencing material. It builds a database to blast the sequences that have been sequenced using the BOLD systems database. 

  This projet is separated in two parts. First the sequence analysis part that takes as an input the data comming out of the sequencer. It works on the sequences to construct a biom table in which we can find the number of variants there is in the sequencing data depending on the sequence (or how many replicates of the sequence we have in the sequncing dataset). This is the first output that is names "feature-table.biom" in the created files. These files can be exported to tsv to visualise them on your computer.
  To launch the analysis, use the launcher in the "analysis_run/codes" directory. It lauches the metabarcoding_publish script that uses qiime2 software to do the analysis. The files in the "necessary_files_analysis" are necessary to realise the analysis. They give information that will be used in the code to analyse the sequencing data. The launcher and metabarcoding script were not writen by me, but by Jean-François MARTIN and Johannes TAVOILLOT in CBGP, Montpellier. I only ran them to analyse the sequencing data.


  The other part of the project is the building of the blasting database. To do that, use the "blasting_data/construction" repository. Inside you will find the "launcher.sh" file that will launch the database construction. It uses the Global_database_constitution.R script that downloads sequences and metadata from BOLD Systems (https://www.boldsystems.org/) for several taxa in the "All_orders_to_get.tsv" file. Some orders do not have any data and are listed in the "Orders_without_sequences.tsv" file. But this list is not exhaustive. For each taxa, it will build a csv file containing the sequence and the taxonomy of the sample. All this data will be concatenated thanks to the "concatenation" directory. It allows to make one big csv file with all the sequences collected previously. Then the data is sorted thanks to the "sorting" directory and finaly, a fasta file is created.
    Then, we make a classifier that will blast the data for us thanks to qiime2. This code is inspired from the qiime2 tutorial "Training feature classifiers with q2-feature-classifier" from the qiime2 website (https://docs.qiime2.org/2022.2/tutorials/feature-classifier/). This allow us to recognise the sequences in the biom table and compare it to the ones from the database to tell us which sequence blasts with which taxa. 
    In the end, we end up with a table giving us the number of variants of a taxa and how many times it has matched in the sequencing data set. 

  
  Finaly, this project contains both Rscripts and Linux scripts. It has been coded to go on a cluster and be used accordingly. The memory requirements may be too important for some computers. 
