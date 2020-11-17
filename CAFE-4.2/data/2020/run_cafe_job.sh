#!/bin/sh
#$ -cwd           # Set the working directory for the job to the current directory
#$ -V
#$ -j y           # Merge the standard output and standard error
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -l h_rt=01:0:0 # Request runtime
#$ -pe smp 8      # Request 1 CPU cores
#$ -l h_vmem=1G   # Request GB RAM per core

REPORT_SCRIPT=/data/SBCS-BuggsLab/Josiah/DNA_Duplications/CAFE-4.1/data/cafe_tutorial/python_scripts/cafetutorial_report_analysis.py
cd /data/SBCS-BuggsLab/Josiah/DNA_Duplications/CAFE-4.2/data/homeologs_only

#Just used preset values to see if it parses.
#cafe oleaceae_homeologs_l009_m015.cafe
#python $REPORT_SCRIPT -i reports/oleaceae_homeologs_l009_m015.cafe -o reports/oleaceae_homeologs_l009_m015

#Actually search for ideal parameters QSUB
#cafe oleaceae_homeologs_one_rate.cafe
#python $REPORT_SCRIPT -i reports/oleaceae_homeologs_one_rate.cafe -o reports/oleaceae_homeologs_one_rate

# python caferror.py -i oleaceae_homeologs_one_rate.cafe -d reports/error_files -e .08 -f 1
# python caferror.py -i oleaceae_homeologs_one_rate.cafe -d reports/species_error_files -e .08 -f 1 -s 1

## Rate search with fixed error model
#cafe oleaceae_homeologs_0.1_error.cafe
#python $REPORT_SCRIPT -i reports/oleaceae_homeologs_0.1_error.cafe -o reports/oleaceae_homeologs_0.1_error

## Final results with fixed rates and fixed error model
#cafe oleaceae_homeologs_0.1_error_l00097_m010.cafe
#python $REPORT_SCRIPT -i reports/oleaceae_homeologs_0.1_error_l00097_m010.cafe -o reports/oleaceae_homeologs_0.1_error_l00097_m010



##IMPORTANT: you need to input the name of the current result file
