#!/bin/sh
#$ -cwd           # Set the working directory for the job to the current directory
#$ -V
#$ -j y           # Merge the standard output and standard error
#$ -l h_rt=00:01:00 # Request runtime
#$ -pe smp 2      # Request 1 CPU cores
#$ -l h_vmem=1G   # Request GB RAM

module load python/3.6.3
source /data/SBCS-BuggsLab/Josiah/DNA_Duplications/script_env/bin/activate
python /data/SBCS-BuggsLab/Josiah/DNA_Duplications/processor_test.py
