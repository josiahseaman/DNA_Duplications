#!/bin/sh
#$ -cwd                 		
#$ -V                   		
#$ -o log_cat_files.out   
#$ -j y							
#$ -t 1-18547 #use this specify how many array jobs you have (i.e. should be the same as the number of genes/input files) 
#$ -l h_rt=24:0:0	# I don't know how long it will take to run
#$ -m n


#Merging individual files for all gene models in list of selected gene models shared by 14 assemblies
#the "list.txt" should contain a list of all the names of the files you want to process 
INPUTFILE="$(sed -n -e "$SGE_TASK_ID p" //data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/list_of_split_files_for_gene_models_shared_by_14_assemblies.txt)"
#specifies names for output files (replaces the extension '.fasta' with '.nex')
OUTPUTSTR=`echo $INPUTFILE.fasta`

cat /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/BATG0.5_split_output/$INPUTFILE /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/FRAX01_split_output/$INPUTFILE /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/FRAX02_split_output/$INPUTFILE /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/FRAX03_split_output/$INPUTFILE /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/FRAX04_split_output/$INPUTFILE /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/FRAX05_split_output/$INPUTFILE /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/FRAX06_split_output/$INPUTFILE /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/FRAX07_split_output/$INPUTFILE /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/FRAX08_split_output/$INPUTFILE /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/FRAX09_split_output/$INPUTFILE /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/FRAX10_split_output/$INPUTFILE /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/FRAX11_split_output/$INPUTFILE /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/FRAX12_split_output/$INPUTFILE /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/FRAX13_split_output/$INPUTFILE /data/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/runs_with_version_1.3.2/selected_shared_gene_models/FRAX19_split_output/$INPUTFILE > $OUTPUTSTR 