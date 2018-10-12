#!/bin/sh
#$ -cwd           # Set the working directory for the job to the current directory
#$ -V
#$ -j y           # Merge the standard output and standard error
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -l h_rt=12:0:0 # Request runtime
#$ -pe smp 8      # Request 1 CPU cores
#$ -l h_vmem=1G   # Request GB RAM per core

REPORT_SCRIPT=/data/SBCS-BuggsLab/Josiah/DNA_Duplications/CAFE-4.1/data/cafe_tutorial/python_scripts/cafetutorial_report_analysis.py

cafe oleaceae_homeologs_l009_m015.cafe
#Switched back to OGs, see how that influences the results
python $REPORT_SCRIPT -i reports/oleaceae_homeologs_l009_m015.cafe -o reports/oleaceae_homeologs_l009_m015


##IMPORTANT: you need to input the name of the current result file
