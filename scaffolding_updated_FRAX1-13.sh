#!/bin/sh
#$ -cwd           # Set the working directory for the job to the current directory
#$ -V
#$ -j y           # Merge the standard output and standard error
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -l h_rt=01:00:0 # Request 24 hour runtime
#$ -pe smp 12      # Request 1 CPU cores
#$ -l h_vmem=2G   # Request GB RAM
cd /data/home/btx142/log/
/data/home/eex057/SSPACE-STANDARD-3.0_linux-x86_64/SSPACE_Standard_v3.0.pl \
-s /data/SBCS-BuggsLab/Josiah/assembly/FRAX01__2017-07-10__bubblesize_5000__mincontig_200__SIMPLE__assembly.fa \
-l /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX01-sspacelibraryfile01 \
-b RUN1 \
-T 24 2>&1 >log01.txt  # -T = threads
#
#module load SOAP/2.40
#cd /data/scratch/btx142/FRAX01/
#GapCloser -a /data/scratch/btx142/FRAX01/RUN1/RUN1.final.scaffolds.fasta \
#    -b /data/scratch/btx142/FRAX01/GapCloser01.config \
#    -o GAPCLOSER01 \
#        -t 8 >log-gapcloser01.txt 2>&1                                                                             