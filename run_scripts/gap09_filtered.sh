#!/bin/sh
#$ -cwd           # Set the working directory for the job to the current directory
#$ -V
#$ -j y           # Merge the standard output and standard error
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -l h_rt=12:0:0 # Request runtime
#$ -pe smp 1      # Request 1 CPU cores
#$ -l h_vmem=40G   # Request GB RAM

module load soapdenovo2
GapCloser -a /data/jseaman/rsynced_sequences/data/SBCS-BuggsLab/Josiah/scaffolding/FRAX09_Oct2017_filtered/FRAX09_Oct2017_filtered.final.scaffolds.fasta \
 -b FRAX09-GapCloser.config \
 -o FRAX09_filtered__GapCloser.fa \
 -t 1 > /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX09_Oct2017_filtered.log 2>&1