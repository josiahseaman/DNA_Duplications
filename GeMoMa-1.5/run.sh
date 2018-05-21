#!/bin/bash
version="1.5";
GEMOMA="/data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/GeMoMa-1.5.jar"
# This script allows to run GeMoMa with minimal work from command line. 
#
# A simple example without RNA-seq is
# ./run.sh test_data/annotation.gff test_data/reference.fasta test_data/contig.fasta results/sw
#
# If you like to run GeMoMa with RNA-seq data you have to run the script with the following parameters
# ./run.sh <reference annotation> <reference geneome> <out-dir> <target genome> <library type> <mapped reads>
# where library type is one of {FR_UNSTRANDED, FR_FIRST_STRAND, FR_SECOND_STRAND} and mapped reads is a SAM or BAM file.
#
# In both cases, the final prediction is located in ${out}/filtered_predictions.gff.

#parameters
annotation=$1
reference=$2
target=$3
out=$4

if [ $# -ne 4 ]; then
	echo "GeMoMa using RNA-seq data: library type=" $5 "mapped reads=" $6
	lib=$5;
	reads=$6;
else 
	echo "GeMoMa without RNA-seq data"
fi



echo "============================================================================="
echo ""
echo "check versions:"
echo ""

java -version

echo ""

tblastn -version

echo ""
echo "============================================================================="
echo ""

if [ $# -ne 4 ]; then
	echo "ERE:"
	echo ""

	java -jar ${GEMOMA} CLI ERE c=true s=${lib} m=${reads} outdir=${out}

	echo ""
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo ""
fi
#echo "Extractor:"
#echo ""
#
#java -jar ${GEMOMA} CLI Extractor a=${annotation} g=${reference} outdir=${out} f=false Ambiguity=AMBIGUOUS
#
#echo ""
#echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
#echo ""
echo "makeblastdb:"
echo ""

makeblastdb -out ${out}/blastdb -hash_index -in ${target} -title "target" -dbtype nucl

echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo "tblastn:"
echo ""
#running BLAST search; have kept all parameter settings the same as the example given in run.sh, apart from the e-value (for which I changed it from 100 to 1e-5) + using multiple threads
tblastn -num_threads 4 -query ${out}/cds-parts.fasta -db ${out}/blastdb -evalue 1e-5 -out ${out}/tblastn.txt -outfmt "6 std sallseqid score nident positive gaps ppos qframe sframe qseq sseq qlen slen salltitles" -db_gencode 1 -matrix BLOSUM62 -seg no -word_size 3 -comp_based_stats F -gapopen 11 -gapextend 1

echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo "GeMoMa:"
echo ""

if [ $# -eq 4 ]; then
	java -jar ${GEMOMA} CLI GeMoMa t=${out}/tblastn.txt c=${out}/cds-parts.fasta a=${out}/assignment.tabular tg=${target} outdir=${out}
else
	if [ ${lib} == "FR_UNSTRANDED" ]; then
echo "UNSTRANDED"
		java -jar ${GEMOMA} CLI GeMoMa t=${out}/tblastn.txt c=${out}/cds-parts.fasta a=${out}/assignment.tabular tg=${target} outdir=${out} i=${out}/introns.gff coverage=UNSTRANDED  coverage_unstranded=${out}/coverage.bedgraph
	else
echo "STRANDED"
		java -jar ${GEMOMA} CLI GeMoMa t=${out}/tblastn.txt c=${out}/cds-parts.fasta a=${out}/assignment.tabular tg=${target} outdir=${out} i=${out}/introns.gff coverage=STRANDED  coverage_forward=${out}/coverage_forward.bedgraph coverage_reverse=${out}/coverage_reverse.bedgraph
	fi
fi

echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo "GAF:"
echo ""

java -jar ${GEMOMA} CLI GAF g=${out}/predicted_annotation.gff outdir=${out}
