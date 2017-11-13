#!/bin/sh
#$ -cwd           # Set the working directory for the job to the current directory
#$ -V
#$ -j y           # Merge the standard output and standard error
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -l h_rt=08:0:0 # Request runtime
#$ -pe smp 2      # Request 1 CPU cores
#$ -l h_vmem=5G   # Request GB RAM

module load soapdenovo2
GapCloser -a /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX09_Oct2017_unfiltered/FRAX09_Oct2017_unfiltered.final.scaffolds.fasta \
	-b /data/home/btx142/BuggsLab/Josiah/DNA_Duplications/data/FRAX09-GapCloser.config \
	-o GAPCLOSER09 \
        -t 8 > FRAX09-gapcloser.log 2>&1