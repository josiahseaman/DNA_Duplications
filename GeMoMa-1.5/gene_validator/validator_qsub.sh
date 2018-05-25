#!/bin/sh
#$ -cwd              		 # use current working directory
#$ -V                		 # this makes it verbose
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -j y				 		 # and put all output (inc errors) into it
#$ -pe smp 8         		 # Request CPU cores
#$ -l h_rt=5:0:0	 		 # Request hours runtime (upto 240 hours)
#$ -l h_vmem=1G      		 # Request GB RAM / core, total= cores * vmem
module load ruby
module load blast+
module load mafft
/data/home/btx142/bin/genevalidator -d /data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/gene_validator/cds-parts.fasta -n 8 /data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/${1}/predicted_protein.fasta
