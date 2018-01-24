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
BUSCO.py --in /data/SBCS-BuggsLab/LauraKelly/ash_reference_genome/BATG-0.5_updated_organellar_scaffolds_PhiX_removed_new_copy.fa --out BATG_BUSCO --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX01
BUSCO.py --in /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX01_800bp_HiSeq2500/FRAX01_GAPCLOSER__cat_merged.fa --out FRAX01_BUSCO --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX02
BUSCO.py --in /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX02_800bp_HiSeq2500/FRAX02_GAPCLOSER__cat_merged.fa --out FRAX02_BUSCO --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX03
#BUSCO.py --in /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX03_800bp_HiSeq2500/FRAX03_GAPCLOSER__cat_merged.fa --out FRAX03_BUSCO --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX04
#BUSCO.py --in /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX04_800bp_HiSeq2500/FRAX04_GAPCLOSER__cat_merged.fa --out FRAX04_BUSCO --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX05
#BUSCO.py --in /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX05_800bp_HiSeq2500/FRAX05_GAPCLOSER__cat_merged.fa --out FRAX05_BUSCO --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX06
BUSCO.py --in /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX06_800bp_HiSeq2500/FRAX06_32_hour_stall_merged.fa --out FRAX06_BUSCO_partial --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX07
BUSCO.py --in /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX07_800bp_HiSeq2500/FRAX07_GAPCLOSER__cat_merged.fa --out FRAX07_BUSCO --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX08
#BUSCO.py --in /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX08_800bp_HiSeq2500/FRAX08_GAPCLOSER__cat_merged.fa --out FRAX08_BUSCO --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX09
BUSCO.py --in /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX09_Oct2017_unfiltered/Pennsylvanica_gapcloser_merge_unfiltered_with_bwa.fa --out FRAX09_BUSCO --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX10
#BUSCO.py --in /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX10_800bp_HiSeq2500/FRAX10_GAPCLOSER__cat_merged.fa --out FRAX10_BUSCO --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX11
BUSCO.py --in /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX11_800bp_HiSeq2500/FRAX11_GAPCLOSER__cat_merged.fa --out FRAX11_BUSCO --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX12
#BUSCO.py --in /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX12_800bp_HiSeq2500/FRAX12_GAPCLOSER__cat_merged.fa --out FRAX12_BUSCO --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato

#RUN WITH WITH FRAX13
#BUSCO.py --in /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX13_800bp_HiSeq2500/FRAX13_GAPCLOSER__cat_merged.fa --out FRAX13_BUSCO --lineage /data/home/btw437/embryophyta_odb9 --mode genome -c 8 -e 1e-05 -sp tomato