#!/usr/bin/env bash
module load cufflinks
GEMOMA=/data2/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5
PROTEOME=/data2/SBCS-BuggsLab/Josiah/DNA_Duplications/Ash_Proteome

cd ${GEMOMA}/$1
sed 's/prediction/mRNA/g' filtered_predictions.gff > $1_genes.gff
sed -i 's/FRAEX38873_V2_/'${1}'_/g' $1_genes.gff
gffread $1_genes.gff -g $2 -y $1.faa
gffread -w ${1}_cds.fa -g ${2} $1_genes.gff

# add a newline to the end
echo >> $1.faa
# remove killer . at end of transcript
sed -i -e ':a;N;$!ba;s/\.\n/\n/g' $1.faa
cp ${GEMOMA}/${1}/$1.faa  ${PROTEOME}/${1}.faa
