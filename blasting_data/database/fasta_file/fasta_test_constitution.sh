#!/bin/sh
#SBATCH --job-name=biosphere
#SBATCH --account=biomics
#SBATCH --partition=defq
#SBATCH --time=96:00:00

FILE_NAME=$1

# Making a function that takes as an argument the number of the embranchment (1=Phylum, 2=Class, 3=Order, 4=Family, 5=Genus, 6=Species) and adds the proper level of embranchment to the TAXA variable

taxaname () {
    tail -n+2 $FILE_NAME | cut -d";" -f $1 | cut -d'"' -f2 | sed 's/^\ *//g' > construction_$1.txt
}

# Using the function created above to extract each column of the global database and use them later

for i in $(seq 8); do
    taxaname $i
done

echo "functionok"

# Making the fasta file thanks to the sequence (construction_7.txt) then modifying this file to transform it into a fasta file. First, we add the line number at the beginning of each line, then we add the ">" at the beginning of each line, we ask transform the tabulations into a change of line and supress all the spaces.

nl -ba construction_7.txt | sed 's/^/>/g' | sed "s/\t/\n/g" | sed 's/ //g' > fasta_file.fas

echo "fastafileok"

# Now we will make the text file with the other text files we extracted from the csv and pasting them together to make a database with the number and the classification of the taxa.

## Modifying each construction text document separately

sed "s/^/p__/g" construction_1.txt | sed "s/$/;/g" > construction_1_inter.txt
sed "s/^/c__/g" construction_2.txt | sed "s/$/;/g" > construction_2_inter.txt
sed "s/^/o__/g" construction_3.txt | sed "s/$/;/g" > construction_3_inter.txt
sed "s/^/f__/g" construction_4.txt | sed "s/$/;/g" > construction_4_inter.txt
sed "s/^/g__/g" construction_5.txt | sed "s/$/;/g" > construction_5_inter.txt
sed "s/^/s__/g" construction_6.txt | sed "s/$/;/g" > construction_6_inter.txt
sed "s/^/ssp__/g" construction_8.txt | sed "s/$/;/g" > construction_8_inter.txt

echo "contructioninterok"

# Pasting all these files together, adding a line number and putting the file in the right template

paste construction_[1234568]_inter.txt | nl -ba | sed "s/\t/ /g" | sed "s/ p__/\t p__/g" > text_file.txt

rm construction_*.txt

echo "done"
