#!/bin/sh
#$ -V                		 # this makes it verbose
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -j y				 		 # and put all output (inc errors) into it
#$ -pe smp 4         		 # Request CPU cores
#$ -l h_rt=24:0:0	 		 # Request hours runtime (upto 240 hours)
#$ -l h_vmem=1G      		 # Request GB RAM / core, total= cores * vmem
NUM_THREADS=4
name=$1
genome=$2
echo $1 $2

#module load ruby
#module load blast+
#module load mafft
#module load cufflinks

GEM_HOME="/data2/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/"
CWD=${GEM_HOME}${name}/
#DATABASE_PATH=${CWD}validation.db
DATABASE_PATH=/data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/cds-parts.fasta
INPUT_FASTA_FILE=${CWD}gffread_filtered_protein.fasta
BLAST_TAB_FILE=hits.csv
genevalidator=/data2/SBCS-BuggsLab/Josiah/genevalidator-1.7.2-linux-x86_64/bin/genevalidator
cd ${CWD}
rm -r gffread_filtered_protein.fasta.html
#sed 's/prediction/mRNA/g' filtered_predictions.gff > filtered_predictions_EDITED.gff
#gffread filtered_predictions_EDITED.gff -g ${genome} -y gffread_filtered_protein.fasta
#/data2/SBCS-BuggsLab/Josiah/genevalidator-1.7.2-linux-x86_64/bin/makeblastdb -in /data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/cds-parts.fasta -dbtype prot -parse_seqids

#This command actually works
$genevalidator -d $DATABASE_PATH -num_threads $NUM_THREADS $INPUT_FASTA_FILE

#/data2/SBCS-BuggsLab/Josiah/genevalidator-1.7.2-linux-x86_64/bin/makeblastdb

#$genevalidator -d /data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/gene_validator/cds-parts.fasta -n 8 /data/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/${name}/gffread_filtered_protein.fasta


# Run BLAST (tabular output)
#/data2/SBCS-BuggsLab/Josiah/genevalidator-1.7.2-linux-x86_64/bin/blastp -db $DATABASE_PATH -num_threads $NUM_THREADS -outfmt '7 qseqid sseqid sacc slen qstart qend sstart send length qframe pident nident evalue qseq sseq' -out $BLAST_TAB_FILE -query $INPUT_FASTA_FILE

# Optional: Generate a fasta file for the BLAST hits.
# Note: this works best if you use the same database used to create the BLAST OUTPUT file.
#$genevalidator -d $DATABASE_PATH -e -t $BLAST_TAB_FILE -o 'qseqid sseqid sacc slen qstart qend sstart send length qframe pident nident evalue qseq sseq'

# Run GeneValidator
## If you ran the previous command (i.e. if you produced fasta file for the BLAST hits)
#Josiah: I'm not 100% certain what RAW_SEQUENCES_FILE is
#RAW_SEQUENCES_FILE=${genome}
#genevalidator -n $NUM_THREADS -t $BLAST_TAB_FILE -o 'qseqid sseqid sacc slen qstart qend sstart send length qframe pident nident evalue qseq sseq' -r $RAW_SEQUENCES_FILE $INPUT_FASTA_FILE

## If you did not generate the BLAST hits fasta file (this will automatically run the previous command for you)
#$genevalidator -d $DATABASE_PATH -n $NUM_THREADS -t $BLAST_TAB_FILE -o 'qseqid sseqid sacc slen qstart qend sstart send length qframe pident nident evalue qseq sseq' $INPUT_FASTA_FILE

