#!/bin/sh
#SBATCH --job-name=biosphere
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=96:00:00

# This script needs an argument which is the name of the file you want to use the script on. 
# In this example, it is "../sorting/Final_database.csv" but it must be adaptated if you change your file organisation

# This script can be used in several ways. By commenting the lines you want, you can make your own fasta files to use

FILE_NAME=$1

# Making a function that takes as an argument the number of the embranchment (1=Phylum, 2=Class, 3=Order, 4=Family, 5=Genus, 6=Species) and adds the proper level of embranchment to the TAXA variable
taxaname () {  # This function is designed to split the columns of your database using a separator (here ";") and making a separate file with the split up part
    tail -n+2 $FILE_NAME | cut -d";" -f $1 | cut -d'"' -f2 | sed 's/^\ *//g' > construction_$1_${FILENAME}.txt # for BOLD only
    # tail -n+2 $FILE_NAME | cut -d";" -f $1 | sed 's/^\ *//g' > construction_$1_${FILENAME}.txt   # for ARTHEMIS only
    # tail -n+2 $FILE_NAME | cut -d";" -f $1 | cut -d'"' -f2 | sed 's/^\ *//g' > construction_$1_${FILENAME}.txt   # for the merged file of bold and arthemis
}

# Here, we use the function defined earlier in a loop of length number of columns of your database to extract the columns in separate files
for i in $(seq 13); do           # 13 for BOLD and 17 for ARTHEMIS and 8 for the combination of both
    taxaname $i
    echo $i
done

# 1. If you want to use the qiime2 feature classifier method, uncomment the next parts. It will make a text file containing the taxonomy of your database, a fasta file containing the sequences of your database and a test_file that contains 100 random sequences from the ones in your database to test the classifier you cill be using in the next steps.

## Making the fasta file thanks to the sequence (construction_7.txt) then modifying this file to transform it into a fasta file. First, we add the line number at the beginning of each line, then we add the ">" at the beginning of each line, we ask transform the tabulations into a change of line and supress all the spaces.
## nl -ba construction_10.txt | sed 's/^/>/g' | sed 's/ //g' | tr ["a-z"] ["A-Z"] | sed "s/-/N/g" | uniq > construction_fasta_file.fasta

## Now we will make the text file with the other text files we extracted from the csv and pasting them together to make a database with the number and the classification of the taxa.
### Modifying each construction text document separately to put them in the right template
# sed "s/$/;/g" construction_3_${FILENAME}.txt > construction_1_inter_${FILENAME}.txt     # for 3 bold and for 11 arthemis
# sed "s/$/;/g" construction_4_${FILENAME}.txt > construction_2_inter_${FILENAME}.txt     # for 4 bold and for 12 arthemis
# sed "s/$/;/g" construction_5_${FILENAME}.txt > construction_3_inter_${FILENAME}.txt     # for 5 bold and for 13 arthemis
# sed "s/$/;/g" construction_6_${FILENAME}.txt > construction_4_inter_${FILENAME}.txt     # for 6 bold and for 14 arthemis
# sed "s/$/;/g" construction_7_${FILENAME}.txt > construction_5_inter_${FILENAME}.txt     # for 7 bold and for 15 arthemis
# sed "s/$/;/g" construction_9_${FILENAME}.txt > construction_6_inter_${FILENAME}.txt     # for 9 bold and for 16 arthemis
# sed "s/$/;/g" construction_8_${FILENAME}.txt > construction_8_inter_${FILENAME}.txt     # only for the combination of the two tables
# sed "s/$/;/g" construction_10_${FILENAME}.txt > construction_8_inter_${FILENAME}.txt     # out for bold and for 17 arthemis

## Pasting all these files together, adding a line number and putting the file in the right template
# paste construction_[1234568]_inter.txt | nl -ba | sed "s/\t/ /g" | sed "s/ p__/\t p__/g" > BOLD_text_file.txt
# rm construction_*.txt

## Making of a training file for the classifier used later to blast the data. To do that, we take randomly 100 lines of the fasta and text files.
# index=1                 # Variable that will be incremented and we use to count the number of loops to generate 100 random numbers

# Taking the sequences corresponding to the random numbers in the training file from the fasta file.
# touch training_fasta_file.fasta # Creating a file for all the sequences to be implemented in
# nblines=$(wc -l construction_fasta_file.fasta | cut -d" " -f1) # Counting the number of lines in the fasta file
# echo nblines=$nblines

# for i in $(seq 1 100);do      # The number 100 is chosen arbitrarily to test the model
    # nombre=$RANDOM            # Generating a random number in the number of lines in the generated fasta file
    # let "nombre %= $nblines"  # Making a scale that allows us to chose the maximum number to chose from
    # head -n $nombre construction_fasta_file.fasta | tail -n 1 >> construction_training_fasta_file.fasta # Incrementing the training fasta file with the new randomly chosen sequence
    # let "index += 1"     # Increments the index of 1 at each loop
    # echo $index          # For debugging
# done
# sed "s/ //g" construction_training4asta_file.fasta | sed "s/\t/\n/g" > training_fasta_file.fasta # Transffering all the sequences in the final training file6
# echo "trainingfileok"
# sed "s/\t/\n/g" construction_fasta_file.fasta > BOLD_fasta_file.fasta5 # Making the final modifications on the database fasta fi9


# 2. If you want to make a local blast, uncomment the next parts. It will make a a fasta file containing the taxonomy and the sequences of your database. This part works for the database of Bold, Arthemis or the combination of both tables. You can comment or uncomment each line depending on what you want.

## Modifying each construction text document separately to put them in the right template
sed "s/$/;/g" construction_3_${FILENAME}.txt > construction_1_inter_${FILENAME}.txt     # for 3 bold and for 11 arthemis
sed "s/$/;/g" construction_4_${FILENAME}.txt > construction_2_inter_${FILENAME}.txt     # for 4 bold and for 12 arthemis
sed "s/$/;/g" construction_5_${FILENAME}.txt > construction_3_inter_${FILENAME}.txt     # for 5 bold and for 13 arthemis
sed "s/$/;/g" construction_6_${FILENAME}.txt > construction_4_inter_${FILENAME}.txt     # for 6 bold and for 14 arthemis
sed "s/$/;/g" construction_7_${FILENAME}.txt > construction_5_inter_${FILENAME}.txt     # for 7 bold and for 15 arthemis
sed "s/$/;/g" construction_9_${FILENAME}.txt > construction_6_inter_${FILENAME}.txt     # for 9 bold and for 16 arthemis
# sed "s/$/;/g" construction_8_${FILENAME}.txt > construction_8_inter_${FILENAME}.txt     # only for the combination of the two tables
# sed "s/$/;/g" construction_10_${FILENAME}.txt > construction_8_inter_${FILENAME}.txt     # out for bold and for 17 arthemis

## Here, we take out the sequences of the file and convert them to capital letters. Then, we paste all the files that contain the different levels of taxonoy and finaly adding the sequences to the file.
# tail -n+2 $FILE_NAME | cut -d";" -f 5 | sed 's/^\ *//g' |tr ["a-z"] ["A-Z"] > construction_10_${FILENAME}.txt             # for Arthemis
# tail -n+2 $FILE_NAME | cut -d";" -f 10 | sed 's/^\ *//g' |tr ["a-z"] ["A-Z"] > construction_10_${FILENAME}.txt             # for BOLD
tail -n+2 $FILE_NAME | cut -d";" -f 7 | sed 's/^\ *//g' |tr ["a-z"] ["A-Z"] > construction_10_${FILENAME}.txt             # for Arthemis and Bold

## Pasting all the files together (this is common to the three extracted tables)
paste construction_[1234568]_inter_${FILENAME}.txt | sed 's/\t/ /g' | sed "s/^/>/g" > construction_inter_${FILENAME}.txt


## Pasting the sequences to the files containing the taxonomy
paste construction_inter_${FILENAME}.txt construction_10_${FILENAME}.txt | sed "s/ //g" | sed "s/\t/\n/g" | sed 's/"//g' > fasta_file_bold_blast_local.fasta

# paste construction_inter_${FILENAME}.txt construction_10_${FILENAME}.txt | sed "s/\t/\n/g" | sed "s/ //g" > fasta_file_arthemis_blast_local.fasta

# paste construction_inter_${FILENAME}.txt construction_10_${FILENAME}.txt | sed "s/ //g" | sed "s/\t/\n/g" | sed 's/"//g' > fasta_file_bold_and_arthemis_blast_local.fasta

# Removing the files that were built in the script that don't serve any purpose
rm cons*

echo "done"
