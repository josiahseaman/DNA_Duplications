#!/bin/sh
#$ -cwd              		 # use current working directory
#$ -V                		 # this makes it verbose
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -j y				 		 # and put all output (inc errors) into it
#$ -pe smp 12         		 # Request CPU cores
#$ -l h_rt=24:0:0	 		 # Request hours runtime (upto 240 hours)
#$ -l h_vmem=1G      		 # Request GB RAM / core, total= cores * vmem
module load blast+/2.7.1
module load java/1.8.0_152-oracle

name=FRAX09_large_72hr
target=/data/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/F_pennsylvanica_Feb_2018_all_files/fraxinus_pennsylvanica_20Feb2018_scaffolds_over5kbp.fa

echo $name $target
echo This is a variant script specifically for resuming FRAX09 pennsylvanica

out=/data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/${name}
mkdir ${out}
root=/data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/
GEMOMA=/data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/GeMoMa-1.5.jar
cds=${root}FRAX09_large_72hr/cds-parts__minus_FRAX09_large_72hr.fasta
echo ${cds}


#makeblastdb -out ${out}/blastdb -hash_index -in ${target} -title "target" -dbtype nucl
#echo "tblastn:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
#running BLAST search; have kept all parameter settings the same as the example given in run.sh, apart from the e-value (for which I changed it from 100 to 1e-5) + using multiple threads
tblastn -num_threads 12 -query ${cds} -db ${out}/blastdb -evalue 1e-5 -out ${out}/tblastn-2.txt -outfmt "6 std sallseqid score nident positive gaps ppos qframe sframe qseq sseq qlen slen salltitles" -db_gencode 1 -matrix BLOSUM62 -seg no -word_size 3 -comp_based_stats F -gapopen 11 -gapextend 1

echo "GeMoMa:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
java -jar ${GEMOMA} CLI GeMoMa t=${out}/tblastn-2.txt c=${cds} a=${root}/assignment.tabular tg=${target} outdir=${out}

echo "GAF:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
java -jar ${GEMOMA} CLI GAF g=${out}/predicted_annotation.gff outdir=${out}
