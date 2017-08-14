#!/bin/sh
#$ -cwd           # Set the working directory for the job to the current directory
#$ -V
#$ -j y           # Merge the standard output and standard error
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -l h_rt=08:00:0 # Request hours of runtime
#$ -pe smp 12      # Request CPU cores
#$ -l h_vmem=2G   # Request GB RAM
cd /data/scratch/btx142/
/data/home/eex057/SSPACE-STANDARD-3.0_linux-x86_64/SSPACE_Standard_v3.0.pl \
-s /data/SBCS-BuggsLab/Josiah/assembly/FRAX01__2017-07-10__bubblesize_5000__mincontig_200__SIMPLE__assembly.fa \
-l /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX01-sspacelibraryfile01 \
-b FRAX01__2017-07-10 \
-T 24 2>&1 > /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX01__2017-07-10__SSPACE.log  # -T = threads
#
module load SOAP/2.40
cd /data/scratch/btx142/
GapCloser -a /data/scratch/btx142/FRAX01__2017-07-10/FRAX01__2017-07-10.final.scaffolds.fasta \
    -b /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX01-GapCloser01.config \
    -o FRAX01__2017-07-10__GAPCLOSER \
        -t 8 > /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX01__2017-07-10__gapcloser.log 2>&1                                                                             