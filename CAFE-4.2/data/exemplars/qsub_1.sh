#!/bin/sh
#$ -cwd           # Set the working directory for the job to the current directory
#$ -V
#$ -j y           # Merge the standard output and standard error
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -l h_rt=12:0:0 # Request runtime
#$ -pe smp 8      # Request 1 CPU cores
#$ -l h_vmem=1G   # Request GB RAM per core

#source /data/SBCS-BuggsLab/Josiah/symmetry_env/bin/activate
cd /data/SBCS-BuggsLab/Josiah/DNA_Duplications/CAFE-4.2/data/exemplars
#python ../cafe_tutorial/python_scripts/cafetutorial_prep_r8s.py \
#-i RAxML_result__rearranged_to_lauras_order.tre -o r8s_Frax_timetree_script.txt -s 763103 \
#-p "FRAX00,Mguttatus FRAX00,Slycopersicum FRAX00,Oeuropea FRAX11,FRAX07 FRAX01,FRAX07 FRAX11,FRAX14" \
#-c="87,79,36,19,14,11"

#r8s -b -f r8s_Frax_timetree_script.txt > r8s.tmp
#tail -n 1 r8s.tmp  | cut -c 16- > Frax_species_tree_ultrametric.tre

#python ../cafe_tutorial/python_scripts/cafetutorial_clade_and_size_filter.py -i Cafe_orthofinder_Orthogroups.GeneCount.csv -o filtered_OG_counts.txt -s

#head filtered_OG_counts.txt -n 1 > Random_Sample_1000.GeneCount.txt  # important to add header
#shuf -n 1000 filtered_OG_counts.txt >> Random_Sample_1000.GeneCount.txt

cafe /data/SBCS-BuggsLab/Josiah/DNA_Duplications/CAFE-4.2/data/exemplars/run_cafe_orthofinder.sh

#summarize results with python2.7
#IMPORTANT: you need to input the name of the current result file
python /data/SBCS-BuggsLab/Josiah/DNA_Duplications/CAFE-4.1/data/cafe_tutorial/python_scripts/cafetutorial_report_analysis.py -i reports/exemplars_reestimate.txt -o reports/latest_summary
