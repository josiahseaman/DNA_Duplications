#!/bin/sh
#$ -cwd           # Set the working directory for the job to the current directory
#$ -V
#$ -j y           # Merge the standard output and standard error
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -l h_rt=01:0:0 # Request runtime
#$ -pe smp 8      # Request 1 CPU cores
#$ -l h_vmem=200M   # Request GB RAM per core

source /data/SBCS-BuggsLab/Josiah/symmetry_env/bin/activate
cd /data/SBCS-BuggsLab/Josiah/DNA_duplications/CAFE-4.1/data/cafe_orthofinder
python ../cafe_tutorial/python_scripts/cafetutorial_prep_r8s.py \
-i RAxML_result__rearranged_to_lauras_order.tre -o r8s_Frax_timetree_script.txt -s 763103 \
-p '"FRAX00,Mguttatus" "FRAX00,Slycopersicum" "FRAX00,Oeuropea" "FRAX11,FRAX07" "FRAX01,FRAX07" "FRAX11,FRAX14"' \
-c '87 79 36 19 14 11'

#python ../cafe_tutorial/python_scripts/cafetutorial_clade_and_size_filter.py -i Cafe_orthofinder_Orthogroups.GeneCount.csv -o filtered_OG_counts.txt -s

#cafe /data2/SBCS-BuggsLab/Josiah/DNA_duplications/CAFE-4.1/data/cafe_prototype/run1_orthofinder_full.sh
