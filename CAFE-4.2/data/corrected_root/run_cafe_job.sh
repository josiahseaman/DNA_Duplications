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
#cafe corrected_root_JSG.cafe
#python $REPORT_SCRIPT -i reports/corrected_root_JSG_l=0.00838.cafe -o reports/corrected_root_JSG_l=0.00838

#cafe corrected_root_JSG_single_rate.cafe
#python $REPORT_SCRIPT -i reports/corrected_root_JSG_single_rate.cafe -o reports/corrected_root_JSG_single_rate

#cafe corrected_root_JSG_two_rates.cafe
#python $REPORT_SCRIPT -i reports/corrected_root_JSG_two_rates.cafe -o reports/corrected_root_JSG_two_rates


cafe corrected_root_JSG_two_rate_shifted.cafe
#Shifted root rate to outgroup instead of Fraxinus
python $REPORT_SCRIPT -i reports/corrected_root_JSG_two_rate_shifted.cafe -o reports/corrected_root_JSG_two_rate_shifted

cafe corrected_root_OG_two_rate_shifted.cafe
#Switched back to OGs, see how that influences the results
python $REPORT_SCRIPT -i reports/corrected_root_OG_two_rate_shifted.cafe -o reports/corrected_root_OG_two_rate_shifted


##IMPORTANT: you need to input the name of the current result file