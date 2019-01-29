#!/bin/sh
#$ -cwd                          # use current working directory
#$ -V                            # this makes it verbose
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -j y                                          # and put all output (inc errors) into it
#$ -pe smp 8                     # Request CPU cores
#$ -l h_rt=2:0:0                         # Request hours runtime (upto 240 hours)
#$ -l h_vmem=5G                 # Request GB RAM / core, total= cores * vmem
NUM_THREADS=8
source /data/SBCS-BuggsLab/Josiah/symmetry_env/bin/activate
module load singularity
alias raxml="singularity run /data/containers/raxml-ng/raxml-ng raxml-ng"

#Original command lacking outgroups
#/data2/SBCS-BuggsLab/Josiah/OrthoFinder-2.2.6_source/orthofinder.py -f /data/SBCS-BuggsLab/Josiah/DNA_Duplications/Ash_Proteome -t $NUM_THREADS -S diamond -T raxml

#Add outgroups
#/data2/SBCS-BuggsLab/Josiah/OrthoFinder-2.2.6_source/orthofinder.py \
#-f /data/SBCS-BuggsLab/Josiah/DNA_Duplications/Ash_Proteome \
#-t $NUM_THREADS -S diamond -M msa -T raxml

#Now force our species tree for the Ortholog identification
#/data2/SBCS-BuggsLab/Josiah/OrthoFinder-2.2.6_source/orthofinder.py \
#-fg /data/SBCS-BuggsLab/Josiah/DNA_Duplications/Ash_Proteome/Results_Jun25 \
#-s /data/SBCS-BuggsLab/Josiah/DNA_Duplications/CAFE-4.1/data/cafe_orthofinder/Primary_concordance__short_names.tre \
#-t $NUM_THREADS -S diamond -M msa -T raxml

#Using corrected species tree with correct outgroup rooting
/data/SBCS-BuggsLab/Josiah/OrthoFinder-2.2.6_source/orthofinder.py \
--from-trees /data/SBCS-BuggsLab/Josiah/DNA_Duplications/Ash_Proteome/Results_Jun25/Orthologues_Jul04_2/ \
-s /data/SBCS-BuggsLab/Josiah/DNA_Duplications/CAFE-4.2/data/corrected_root/Species_tree_corrected_root_ultrametric_integers.tre \
-t 1 
