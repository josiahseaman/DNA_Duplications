#!/bin/sh
#$ -cwd              		 # use current working directory
#$ -V                		 # this makes it verbose
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -j y				 		 # and put all output (inc errors) into it
#$ -pe smp 4         		 # Request CPU cores
#$ -l h_rt=18:0:0	 		 # Request 24 hour runtime (upto 240 hours)
#$ -l h_vmem=3G      		 # Request 1GB RAM / core, i.e. 4GB total
module load blast+/2.7.1
module load java/1.8.0_152-oracle

/data/home/btx142/BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/run.sh /data/SBCS-BuggsLab/LauraKelly/mapping/Fraxinus_excelsior_38873_TGAC_v2.gff3       /data/SBCS-BuggsLab/LauraKelly/ash_reference_genome/BATG-0.5_updated_organellar_scaffolds_PhiX_removed_new_copy.fa       /data2/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/test_with_FRAX33_longest_single_transcript/run_on_assembly_with_max_bubble_size_1000/FRAX33_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_1000_contig_list_contigs_renamed.fa       /data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/FRAX33

