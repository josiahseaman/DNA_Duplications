#!/bin/sh
#$ -cwd              		 # use current working directory
#$ -V                		 # this makes it verbose
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -o test_FRAX33.out        # specify an output file - change 'outputfile.out'
#$ -j y				 		 # and put all output (inc errors) into it
#$ -pe smp 4         		 # Request CPU cores
#$ -l h_rt=1:0:0	 		 # Request 24 hour runtime (upto 240 hours)
#$ -l h_vmem=10G      		 # Request 1GB RAM / core, i.e. 4GB total

echo 'STARTING JOB'

module load java/1.8.0_152-oracle
module load blast+/2.7.1

#running GeMoMa on files with modified contig names to generate gene models
java -jar /data2/SBCS-BuggsLab/Josiah/GeMoMa/GeMoMa-1.5/GeMoMa-1.5.jar CLI GeMoMa t=/data2/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/test_with_FRAX33_longest_single_transcript/run_on_assembly_with_max_bubble_size_1000/tblastn_corrected2.txt       c=/data2/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/cds-parts.fasta a=/data2/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/assignment.tabular tg=/data2/SBCS-BuggsLab/LauraKelly/tools/GeMoMa/test_with_FRAX33_longest_single_transcript/run_on_assembly_with_max_bubble_size_1000/FRAX33_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_1000_contig_list_contigs_renamed.fa  outdir=/data2/SBCS-BuggsLab/Josiah/GeMoMa/GeMoMa-1.5/test_FRAX33/
# Run was mostly successful except for FRAEX38873_v2_000312950 FRAEX38873_V2_000312950.2java.util.concurrent.ExecutionException: java.lang.StringIndexOutOfBoundsException: String index out of range: 50
# There may be an issue with mixing file versions and getting slight index mismatches in the blast results: try finding out how long new blast takes.

#predicted protein file contains 34,661 models (from the total of 38,949 gene models; therefore c. 89% of the reference models from BATG have a predicted protein for FRAX33)
#the number of reference models represented might increase once I have scaffolded assembly (or run it through AlignGraph)
#none of the FRAX33 proteins contain an X (which is expected because one or other haplotype is selected during de novo assembly in CLC - will need to map reads back to consensus to get an idea of heterozygosity).







echo 'JOB ENDED'
