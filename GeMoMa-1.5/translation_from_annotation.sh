#!/usr/bin/env bash
module load cufflinks
GEMOMA=/data2/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5
PROTEOME=/data2/SBCS-BuggsLab/Josiah/DNA_Duplications/Ash_Proteome

cd ${GEMOMA}/$1
#sed 's/prediction/mRNA/g' filtered_predictions.gff > $1_genes.gff
#sed -i 's/FRAEX38873_V2_/'${1}'_/g' $1_genes.gff
gffread $1_genes.gff -g $2 -x $1_CDS.fna
#gffread $1_genes.gff -g $2 -y $1.faa
#gffread -w ${1}_cds.fa -g ${2} $1_genes.gff

# add a newline to the end
echo >> $1.fa
# remove killer . at end of transcript
#sed -i -e ':a;N;$!ba;s/\.\n/\n/g' $1.faa
#cp ${GEMOMA}/${1}/$1.fa  ${PROTEOME}/${1}.faa
cp ${GEMOMA}/${1}/$1_CDS.fna  ${GEMOMA}/CDS/

#single run for BATG
#sed 's/FRAEX38873_V2_/FRAX00_/g' Fraxinus_excelsior_38873_TGAC_v2.gff3 > FRAX00_genes.gff3
#gffread FRAX00_genes.gff3 -g BATG-0.5_updated_organellar_scaffolds_PhiX_removed_new_copy.fa -x FRAX00_CDS.fna