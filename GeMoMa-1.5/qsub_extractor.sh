#!/bin/sh
#$ -cwd              		 # use current working directory
#$ -V                		 # this makes it verbose
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -j y				 		 # and put all output (inc errors) into it
#$ -pe smp 1         		 # Request CPU cores
#$ -l h_rt=4:0:0	 		 # Request hour runtime (upto 240 hours)
#$ -l h_vmem=10G      		 # Request GB RAM / core,
module load blast+/2.7.1
module load java/1.8.0_152-oracle

java -jar /data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/GeMoMa-1.5.jar CLI Extractor a=/data/SBCS-BuggsLab/LauraKelly/mapping/Fraxinus_excelsior_38873_TGAC_v2.gff3 g=/data/SBCS-BuggsLab/LauraKelly/ash_reference_genome/BATG-0.5_updated_organellar_scaffolds_PhiX_removed_new_copy.fa outdir=/data2/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/Extractor f=false Ambiguity=AMBIGUOUS