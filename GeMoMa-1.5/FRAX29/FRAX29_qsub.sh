#!/bin/sh
#$ -cwd              		 # use current working directory
#$ -V                		 # this makes it verbose
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -j y				 		 # and put all output (inc errors) into it
#$ -pe smp 4         		 # Request CPU cores
#$ -l h_rt=18:0:0	 		 # Request 24 hour runtime (upto 240 hours)
#$ -l h_vmem=3G      		 # Request 1GB RAM / core, i.e. 4GB total
module load blast+/2.7.1
module load java/1.8.0_152-oracle
name="FRAX29"
target="/data2/SBCS-BuggsLab/Fraxinus_scaffolded_assemblies/FRAX29_CLC_SSPACE_GAPCLOSER.fasta"
root=/data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/
out=/data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/${name}
GEMOMA=/data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/GeMoMa-1.5.jar

makeblastdb -out ${out}/blastdb -hash_index -in ${target} -title "target" -dbtype nucl
echo "tblastn:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
#running BLAST search; have kept all parameter settings the same as the example given in run.sh, apart from the e-value (for which I changed it from 100 to 1e-5) + using multiple threads
tblastn -num_threads 4 -query ${root}/cds-parts.fasta -db ${out}/blastdb -evalue 1e-5 -out ${out}/tblastn.txt -outfmt "6 std sallseqid score nident positive gaps ppos qframe sframe qseq sseq qlen slen salltitles" -db_gencode 1 -matrix BLOSUM62 -seg no -word_size 3 -comp_based_stats F -gapopen 11 -gapextend 1

echo "GeMoMa:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
java -jar ${GEMOMA} CLI GeMoMa t=${out}/tblastn.txt c=${root}/cds-parts.fasta a=${root}/assignment.tabular tg=${target} outdir=${out}

echo "GAF:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
java -jar ${GEMOMA} CLI GAF g=${out}/predicted_annotation.gff outdir=${out}


