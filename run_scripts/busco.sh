#!/bin/sh
#$ -cwd                 # use current working directory
#$ -V                   # this makes it verbose
#$ -o log_BUSCO.out     # specify an output file - change 'outputfile.out'
#$ -j y                                 # and put all output (inc errors) into it
#$ -pe smp 8            # Request CPU cores
#$ -l h_rt=24:0:0               # Request 24 hour runtime (upto 240 hours)
#$ -l h_vmem=1G         # Request 1GB RAM / core, i.e. 4GB total

echo 'STARTING JOB'
module load busco/2.0
#setting environmental variable for Augustus configuration file
#NEED TO DO THIS AFTER LOADING BUSCO MODULE, otherwise it gets overwritten
export AUGUSTUS_CONFIG_PATH=/data/home/btw437/config
#I have increased the default e-value threshold for BLAST hits from 1e-03 to 1e-05
#Checked the available species in Augustus with following command after loading module "augustus --species=help"; will change setting to "tomato" (default when using the plant database is arabidopsis; options are arabidopsis, tomato or maize)


#RUN WITH WITH BATG0.5
BUSCO.py --in /data/SBCS-BuggsLab/LauraKelly/ash_reference_genome/BATG-0.5_updated_organellar_scaffolds_PhiX_removed_new_copy.fa --out BATG_RUN --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX01
#BUSCO.py --in /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX01_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa --out FRAX01_RUN --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX02
#BUSCO.py --in /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX02_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa --out FRAX02_RUN --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX03
BUSCO.py --in /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX03_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa --out FRAX03_RUN --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX04
#BUSCO.py --in /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX04_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa --out FRAX04_RUN --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX05
#BUSCO.py --in /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX05_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa --out FRAX05_RUN --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX06
#BUSCO.py --in /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX06_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa --out FRAX06_RUN --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX07
BUSCO.py --in /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX07_800bp_HiSeq2500/FRAX07_GAPCLOSER__cat_merged.fa --out FRAX07_RUN --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX08
#BUSCO.py --in /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX08_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa --out FRAX08_RUN --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX09
#BUSCO.py --in /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX09_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa --out FRAX09_RUN --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX10
#BUSCO.py --in /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX10_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa --out FRAX10_RUN --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX11
#BUSCO.py --in /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX11_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa --out FRAX11_RUN --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX12
#BUSCO.py --in /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX12_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa --out FRAX12_RUN --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX13
#BUSCO.py --in /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX13_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa --out FRAX13_RUN --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato