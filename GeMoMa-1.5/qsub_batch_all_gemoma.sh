#!/bin/sh
#$ -cwd              		 # use current working directory
#$ -V                		 # this makes it verbose
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -j y				 		 # and put all output (inc errors) into it
#$ -pe smp 4         		 # Request CPU cores
#$ -l h_rt=4:0:0	 		 # Request hours runtime (upto 240 hours)
#$ -l h_vmem=1G      		 # Request GB RAM / core, total= cores * vmem
ASSEMBLY="/data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/"
export ASSEMBLY="/data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/"
GEM_HOME="/data2/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/"

#INPUT_LINE=$(sed -n "${SGE_TASK_ID}p" task_list.csv)
# ${GEM_HOME}/gene_validator/validator_qsub.sh $INPUT_LINE


./translation_from_annotation.sh FRAX01 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX01_800bp_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX02 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX02_800bp_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX03 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX03_800bp_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX04 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX04_800bp_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX05 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX05_800bp_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX06 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX06_800bp_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX07 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX07_800bp_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX08 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX08_800bp_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX11 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX11_800bp_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX12 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX12_800bp_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX13 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX13_800bp_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX14 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX14_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX15 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX15_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX16 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX16_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX19 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX19_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX20 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX20_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX21 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX21_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX23 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX23_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX25 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX25_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX26 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX26_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX27 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX27_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX28 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX28_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX29 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX29_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX30 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX30_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX31 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX31_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX32 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX32_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX33 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX33_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX34 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX34_CLC_SSPACE_GAPCLOSER.fasta
./translation_from_annotation.sh FRAX09 /data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/F_pennsylvanica_Feb_2018_all_files/fraxinus_pennsylvanica_20Feb2018_scaffolds_over5kbp.fa


# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX01 ${ASSEMBLY}FRAX01_800bp_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX02 ${ASSEMBLY}FRAX02_800bp_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX03 ${ASSEMBLY}FRAX03_800bp_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX04 ${ASSEMBLY}FRAX04_800bp_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX05 ${ASSEMBLY}FRAX05_800bp_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX06 ${ASSEMBLY}FRAX06_800bp_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX07 ${ASSEMBLY}FRAX07_800bp_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX08 ${ASSEMBLY}FRAX08_800bp_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX11 ${ASSEMBLY}FRAX11_800bp_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX12 ${ASSEMBLY}FRAX12_800bp_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX13 ${ASSEMBLY}FRAX13_800bp_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX14 ${ASSEMBLY}FRAX14_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX15 ${ASSEMBLY}FRAX15_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX16 ${ASSEMBLY}FRAX16_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX19 ${ASSEMBLY}FRAX19_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX20 ${ASSEMBLY}FRAX20_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX21 ${ASSEMBLY}FRAX21_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX23 ${ASSEMBLY}FRAX23_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX25 ${ASSEMBLY}FRAX25_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX26 ${ASSEMBLY}FRAX26_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX27 ${ASSEMBLY}FRAX27_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX28 ${ASSEMBLY}FRAX28_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX29 ${ASSEMBLY}FRAX29_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX30 ${ASSEMBLY}FRAX30_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX31 ${ASSEMBLY}FRAX31_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX32 ${ASSEMBLY}FRAX32_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX33 ${ASSEMBLY}FRAX33_CLC_SSPACE_GAPCLOSER.fasta
# ${GEM_HOME}/gene_validator/validator_qsub.sh FRAX34 ${ASSEMBLY}FRAX34_CLC_SSPACE_GAPCLOSER.fasta
#translation_from_annotation.sh FRAX09 ${ASSEMBLY}F_pennsylvanica_Feb_2018_all_files/Fraxinus_pennsylvanica_20Feb2018_lPmM4.fasta

#FRAX09 = Pennsylvanica
#FRAX10 - doesn't appear to be a 10
#FRAX17 - unsequenced polyploid
#FRAX18 - unsequenced polyploid
#FRAX22 - unsequenced polyploid
#FRAX24 - unsequenced polyploid





