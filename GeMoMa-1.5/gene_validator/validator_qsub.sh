#!/bin/sh
#$ -cwd              		 # use current working directory
#$ -V                		 # this makes it verbose
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -j y				 		 # and put all output (inc errors) into it
#$ -pe smp 8         		 # Request CPU cores
#$ -l h_rt=3:0:0	 		 # Request hours runtime (upto 240 hours)
#$ -l h_vmem=1G      		 # Request GB RAM / core, total= cores * vmem
name=$1
genome=$2
echo $1 $2

module load ruby
module load blast+
module load mafft
module load cufflinks

#GEM_HOME="/data2/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/"
#cd ${GEM_HOME}${name}
#sed 's/prediction/mRNA/g' filtered_predictions.gff > filtered_predictions_EDITED.gff
#gffread filtered_predictions_EDITED.gff -g ${genome} -y gffread_filtered_protein.fasta

/data/home/btx142/bin/genevalidator -d /data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/gene_validator/cds-parts.fasta -n 8 /data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/${name}/gffread_filtered_protein.fasta
