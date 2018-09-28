#!/bin/sh
#$ -cwd           # Set the working directory for the job to the current directory
#$ -V
#$ -j y           # Merge the standard output and standard error
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -l h_rt=24:0:0 # Request runtime
#$ -pe smp 8      # Request 1 CPU cores
#$ -l h_vmem=3G   # Request GB RAM per core
cd /data/SBCS-BuggsLab/Josiah/DNA_Duplications/Green_Ash_Annotation_Transfer/flo_pennsylvanica
rake /data/SBCS-BuggsLab/Josiah/DNA_Duplications/Green_Ash_Annotation_Transfer/flo/Rakefile