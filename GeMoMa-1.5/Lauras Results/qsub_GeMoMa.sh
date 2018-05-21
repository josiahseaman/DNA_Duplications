#!/bin/sh
#$ -cwd              		 # use current working directory
#$ -V                		 # this makes it verbose
#$ -o log_gemoma_FRAX33.out  # specify an output file - change 'outputfile.out'
#$ -j y				 		 # and put all output (inc errors) into it
#$ -pe smp 13         		 # Request 4 CPU cores
#$ -l h_rt=24:0:0	 		 # Request 24 hour runtime (upto 240 hours)
#$ -l h_vmem=2G      		 # Request 1GB RAM / core, i.e. 4GB total

echo 'STARTING JOB'

module load java/oracle/1.8.0_11
module load blast+/2.2.29

##TEST WITH FRAX04##
#running Extractor tool for formatting of files
java -jar GeMoMa-1.1.3.jar CLI Extractor v=true a=/data/SBCS-BuggsLab/LauraKelly/mapping/Fraxinus_excelsior_38873_TGAC_v2.gff3 g=/data/SBCS-BuggsLab/LauraKelly/ash_reference_genome/BATG-0.5_updated_organellar_scaffolds_PhiX_removed_new_copy.fa
#then need to run a separate BLAST search - making a database of the sequences that I want to map the reference gene models to
makeblastdb -out ./blastdb -hash_index -in /data/SBCS-BuggsLab/LauraKelly/phasing/FRAX04_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_mpileup_output_filtered_consensus.fasta -title "target" -dbtype nucl
#running BLAST search; have kept all parameter settings the same as the example given in run.sh, apart from the e-value (for which I changed it from 100 to 1e-5) + using multiple threads
tblastn -num_threads 12 -query cds-parts.fasta -db ./blastdb -evalue 1e-5 -out tblastn.txt -outfmt "6 std sallseqid score nident positive gaps ppos qframe sframe qseq sseq qlen slen salltitles" -db_gencode 1 -matrix BLOSUM62 -seg no -word_size 3 -comp_based_stats F -gapopen 11 -gapextend 1 -max_hsps 0
#Running GeMoMa tool, using same parameters as used in run.sh file (there are additional parameters that can be set)
java -jar GeMoMa-1.1.3.jar CLI GeMoMa t=tblastn.txt c=cds-parts.fasta a=assignment.tabular tg=/data/SBCS-BuggsLab/LauraKelly/phasing/FRAX04_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_mpileup_output_filtered_consensus.fasta  outdir=.
#analysis quit with this error "FRAEX38873_v2_000000100	FRAEX38873_V2_000000100.1java.util.concurrent.ExecutionException: de.jstacs.data.WrongAlphabetException: Symbol "J" from input not defined in alphabet."
#This is caused by a "J" in one of the HSP for the BLAST results for FRAEX38873_V2_000000100 (which is an ambiguous amino acid meaning 
#Because my consensus sequences have ambiguous bases in them it means that matches tblastn between the FEXC gene models and the target sequence could also have ambiguous amino acids in them
#can try to provide a custom genetic code in a file using the "g" parameter (genetic code (optional user-specified genetic code, OPTIONAL)), but don't know the format that the file needs to be in
#have added "J" to genetic code file given to me by the author; just adding J for now to see if this helps (if it works for "J" then could add other ambiguous amino acid bases
java -jar GeMoMa-1.1.3.jar CLI GeMoMa t=tblastn.txt c=cds-parts.fasta g=custom_genetic_code.txt a=assignment.tabular tg=/data/SBCS-BuggsLab/LauraKelly/phasing/FRAX04_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_mpileup_output_filtered_consensus.fasta outdir=test_results
#providing a custom genetic code file does not seem to help - author (Jens Keilwagen) suggests replacing the amino acid ambiguity codes B, J & Z with an X because GeMoMa cannot handle these
#have checked tblastn results file and I don't think the characters J, B or Z appear anywhere apart from the in the subject sequence (which is where it would be expected according to the information from BLAST sent by Jens)
#will use sed to replace the characters with Xs
sed 's/J/X/g' tblastn.txt | sed 's/B/X/g' | sed 's/Z/X/g' > tblastn_corrected.txt
#rerunning GeMoMa with corrected version of blast results
java -jar GeMoMa-1.1.3.jar CLI GeMoMa t=tblastn_corrected.txt c=cds-parts.fasta a=assignment.tabular tg=/data/SBCS-BuggsLab/LauraKelly/phasing/FRAX04_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_mpileup_output_filtered_consensus.fasta  outdir=.
#this took c. 15 min to run and used just under 10 GB RAM; resulting predicted protein file includes 41,915 sequences (there are multiple sequences for some gene models -> I provided full gff file as input, so included multiple splice variants)
#the default setting with GeMoMa is to only output a single predicted protein per transcript, therefore if I gave a gff file with only the single longest transcripts in as the input I should only get one predicted protein per gene model
#used grep & uniq to check how many of the gene models are represented in the output file - 34,875 gene models are represented from the total of 38,949 gene models (therefore 4074 models from FEXC do not have a predicted gene model for FRAX04)
#it's also possible to provide a list of gene model names to output predicted proteins for, so I could use this parameter to limit the predictions to only genes that do not need phasing
#output for GeMoMa is a gff file and a fasta file with proteins in; don't think it's possible to get DNA sequences as output, but I could get this from the gff file (using bedtools)

##TEST WITH FRAX01##
#testing with 
#making a database of the sequences that I want to map the reference gene models to (can use the same reference gene models as made previously - see above)
#makeblastdb -out ./blastdb -hash_index -in /data/SBCS-BuggsLab/LauraKelly/mapping/FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa -title "target" -dbtype nucl
#running BLAST search; have kept all parameter settings the same as the example given in run.sh, apart from the e-value (for which I changed it from 100 to 1e-5) + using multiple threads
tblastn -num_threads 12 -query cds-parts.fasta -db ./blastdb -evalue 1e-5 -out tblastn.txt -outfmt "6 std sallseqid score nident positive gaps ppos qframe sframe qseq sseq qlen slen salltitles" -db_gencode 1 -matrix BLOSUM62 -seg no -word_size 3 -comp_based_stats F -gapopen 11 -gapextend 1 -max_hsps 0
#using sed to replace problematic characters in blast report with Xs
sed 's/J/X/g' tblastn.txt | sed 's/B/X/g' | sed 's/Z/X/g' > tblastn_corrected.txt
java -jar GeMoMa-1.1.3.jar CLI GeMoMa t=tblastn_corrected.txt c=cds-parts.fasta a=assignment.tabular tg=/data/SBCS-BuggsLab/LauraKelly/mapping/FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa  outdir=.
#counting the number of predicted proteins with an X in their sequence
grep -v ">" predicted_protein.fasta | grep -c "X"
#28770 of the proteins contain at least one X
#total number of proteins predicted is 41,903
#used grep & uniq to check how many of the gene models are represented in the output file - 34,863 gene models are represented from the total of 38,949 gene models (therefore 4086 models from FEXC do not have a predicted gene model)
#using bedtools to extract DNA sequences for gene models predicted by GeMoMa
#first extracting lines from gff file for co-ordinates that span the whole of each predicted gene model
#grep "prediction" predicted_annotation.gff > predicted_annotation_prediction_lines.gff
#using samtools to create an index file for consensus sequence (when I tried to run bedtools without doing this I kept on getting an error)
module load samtools/1.3.1
samtools faidx /data/SBCS-BuggsLab/LauraKelly/mapping/FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa
#using bedtools "getfasta" to extract selected sequences from the consensus for FRAX01
module load bedtools/2.25.0
bedtools getfasta -fi /data/SBCS-BuggsLab/LauraKelly/mapping/FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa -bed predicted_annotation_prediction_lines_sorted.gff -fo FRAX01_predicted_gene_models_full_sequences.fasta
#this generates the file, but only gives the first 60bp of each sequence; might be due to a problem with encoding of the original file (because it was created in Windows)
#checked part of file to look for Windows line end encoding (Windows character is "\r\n"), using the following option (should see ^M if it uses Windows format)
#cat -v FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa | head
#this confirmed the there is Windows encoding on the line end. Using the following command to convert the Windows characters with Linux formatting:
#tr -d '\r' < FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa > FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus_new.fa
#will try re-running bedtools on the new version of the consensus sequence - will see if it runs without first having to create the index file
#module load bedtools/2.25.0 
#bedtools getfasta -fi /data/SBCS-BuggsLab/LauraKelly/mapping/FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus_new.fa -bed predicted_annotation_prediction_lines_sorted.gff -fo FRAX01_predicted_gene_models_full_sequences_test2.fasta
#this seems to work - now get the full sequences for the gene models, therefore deleting previous version of consensus sequence and renaming "FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus_new.fa" as "FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa"
#will try running just with the single longest transcript for each gene so that I only get one GeMoMa sequence per gene model
#running Extractor tool for formatting of files
#java -jar GeMoMa-1.1.3.jar CLI Extractor v=true a=/data/SBCS-BuggsLab/LauraKelly/mapping/Fraxinus_excelsior_38873_TGAC_v2.longestCDStranscript.gff3 g=/data/SBCS-BuggsLab/LauraKelly/ash_reference_genome/BATG-0.5_updated_organellar_scaffolds_PhiX_removed_new_copy.fa
#remaking database of the sequences that I want to map the reference gene models to (because I created a new version of the file - see above)
#makeblastdb -out ./blastdb -hash_index -in /data/SBCS-BuggsLab/LauraKelly/mapping/FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa -title "target" -dbtype nucl
#running BLAST search; have kept all parameter settings the same as the example given in run.sh, apart from the e-value (for which I changed it from 100 to 1e-5) + using multiple threads
#tblastn -num_threads 12 -query cds-parts.fasta -db ./blastdb -evalue 1e-5 -out tblastn.txt -outfmt "6 std sallseqid score nident positive gaps ppos qframe sframe qseq sseq qlen slen salltitles" -db_gencode 1 -matrix BLOSUM62 -seg no -word_size 3 -comp_based_stats F -gapopen 11 -gapextend 1 -max_hsps 0
#using sed to replace problematic characters in blast report with Xs
#sed 's/J/X/g' tblastn.txt | sed 's/B/X/g' | sed 's/Z/X/g' > tblastn_corrected.txt
#also, because I had to change the consensus file while the BLAST was running to remove "_consensus" from the contig names (see file "/Users/Laura/Projects/Ash/Data/Illumina/Illumina_data_for_genus_wide_study/Mapping/CLC/READ_ME.txt")
#will also remove "_consensus" from the BLAST results file, otherwise the extraction by GeMoMa might not work properly
#sed -e 's/_consensus//g' tblastn_corrected.txt > tblastn_corrected2.txt
#then removing original corrected file and renaming the second one
#rm tblastn_corrected.txt
#mv tblastn_corrected2.txt tblastn_corrected.txt
#running GeMoMa to generate gene models
#java -jar GeMoMa-1.1.3.jar CLI GeMoMa t=tblastn_corrected.txt c=cds-parts.fasta a=assignment.tabular tg=/data/SBCS-BuggsLab/LauraKelly/mapping/FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa  outdir=.
#predicted protein file contains 34688 models
#counting the number of predicted proteins with an X in their sequence
#grep -v ">" predicted_protein.fasta | grep -c "X"
#23763 of the models contain an X, indicating that the sequence contained a heterozygous base that induces an amino acid change

#will try to use bedtools to extract CDS sequence for each gene model using info in the gff file
#first imported gff file ("predicted_annotation.gff") into CLC and then exported bed files -> CLC generates a separate bed file for each feature type (i.e. "prediction" and "CDS" in this case)
#Using the following command to convert the Windows characters with Linux formatting:
#tr -d '\r' < predicted_annotation_CDS.bed > predicted_annotation_CDS_new.bed
#removing original file and renaming new file
#rm predicted_annotation_CDS.bed
#mv predicted_annotation_CDS_new.bed predicted_annotation_CDS.bed
#using bedtools with options "-split" and "-name" to try to output only sequence for the CDS, with the gene model name (i.e. name in original format from reference models) in header line instead of the contig name
#see this page for more info: http://bedtools.readthedocs.io/en/latest/content/tools/getfasta.html?highlight=getfasta
#module load bedtools/2.25.0 
#bedtools getfasta -fi /data/SBCS-BuggsLab/LauraKelly/mapping/FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa -bed predicted_annotation_CDS.bed -split -name -fo FRAX01_predicted_gene_models_CDS_sequences_test.fasta
#seems like the "bed" output from CLC is not in the proper format (some lines do not seem to have exons specified + the gene names have not been transposed from original gff file to the bed file, end up with "CDS" as the name for the sequence)
#I think the lines where there are fewer columns in the bed file (which is causing an error with bedtools) are for genes that only have a single exon (and therefore exons do not need splicing together)
#trying the bed file for "predictions" instead (i.e. with coordinates spanning the whole of the gene model) with "-name" option 
#bedtools getfasta -fi /data/SBCS-BuggsLab/LauraKelly/mapping/FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa -bed predicted_annotation_Prediction.bed -name -fo FRAX01_predicted_gene_models_full_sequences_with_names.fasta
#I forgot to reformat line end characters first, but it seemed to work ok. The Windows type line endings might not be a problem for the sequence file (i.e. the sequence to extract gene models from)
#checking for gene models that contain at least one ambiguous base within their full length sequence - not checking for Ns because these also represent gaps (low coverage regions)
#using egrep because it allows for searching for regular expressions
#grep -v ">" FRAX01_predicted_gene_models_full_sequences_with_names.fasta | egrep -c "M|R|W|S|Y|K|V|H|D|B"
#a total of 31288 of the models contain at least one of these ambiguity codes (= c. 90% of the 34688 gene models predicted have at least one heterozygous variant)
#will try to use Perl scrip available on github to extract CDS sequence using the original gff file generated by GeMoMa (so I don't have to try reformatting the bed file from CLC so that it will work properly)
#perl gff2fasta.pl /data/SBCS-BuggsLab/LauraKelly/mapping/FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa predicted_annotation.gff test_output
#script did not print any errors, but all of the output files are empty
#have checked script and for merging of CDSs it is looking for the key word "mRNA" or "transcript" in order to merge the following CDS lines, therefore will edit the gff file so that "prediction" is changed to "mRNA"
#sed -e 's/prediction/mRNA/g' predicted_annotation.gff > predicted_annotation_EDITED.gff
#rerunning Perl script on edited gff file
#perl gff2fasta.pl /data/SBCS-BuggsLab/LauraKelly/mapping/FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa predicted_annotation_EDITED.gff test_output
#this now generates some output, but am getting a lot of errors about the length of "mergedEXON_seq" being uninitialised. My gff file doesn't contain any info on exons, therefore I will comment out that part of the Perl script
#perl gff2fasta_modified.pl /data/SBCS-BuggsLab/LauraKelly/mapping/FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa predicted_annotation_EDITED.gff test_output
#this runs without error - some of the output files created are empty because they appropriate annotations are not included in the gff file
#only keeping the CDS and protein files -> will use these to check against the protein output generated from GeMoMa to see if the gff2fasta script is running correctly
#script does not generate a model for the final gene in the gff file (this is a known error that was reported on biostars/stack-overflow); this is for a Cp gene, therefore in this case it doesn't matter because I will not use the organellar gene models
#checking proteins from gff2fasta script against proteins generated by GeMoMa via blastp
#module load blast+/2.2.29
#blastp -task blastp -num_threads 12 -db predicted_protein.fasta -evalue 1e-5 -query test_output.pep.fasta -outfmt 6 -max_target_seqs 1 -max_hsps 1 -out blastp_hits_gff2fasta_proteins_compared_with_GeMoMa_proteins.txt
#most of the sequences predicted by gff2fasta file are the same as the GeMoMa proteins (c. 30,000 appear to be an exact match) but some have missmatches
#and some do not have a top hit to the correct gene model (suggesting that the CDS sequences have not been correctly merged together) and some have no hit
#also BLASTing GeMoMa protein sequences back to themselves, to check whether they all have hits
#blastp -task blastp -num_threads 12 -db predicted_protein.fasta -evalue 1e-5 -query predicted_protein.fasta -outfmt 6 -max_target_seqs 1 -max_hsps 1 -out blastp_hits_GeMoMa_proteins_vs_themselves.txt
#not all the proteins have hits - out of 34688 models, 34639 have hits. It might be that the dust filter is resulting in some proteins not having hits (possibly models with a large number of Xs do not have hits)
#using diff to compare the protein sequences from GeMoMa and gff2fasta line by line
#reformatted gff2fasta output file in Textwranger so that protein sequences are on a single line (rather than being wrapped), then used diff
#diff /Users/Laura/Projects/Ash/Data/Illumina/Illumina_data_for_genus_wide_study/Phasing/GeMoMa_analyses/predicted_protein.fasta /Users/Laura/Projects/Ash/Data/Illumina/Illumina_data_for_genus_wide_study/Phasing/GeMoMa_analyses/test_output.pep.fasta > lines_that_diff_in_protein_model.txt
#3466 gene models differ in their protein sequence (+ as noted above, one gene model is missing from gff2fasta predictions)
#checking some of the individual gene models to see how the sequences differ; seems that the sequences differ where there are ambiguous amino acids - the protein sequences from the Perl script have B, J & Z, whereas the GeMoMa results do not (for reasons outlined above)
#replacing characters in Perl script output with Xs and then will compare with GeMoMa results again
#sed 's/J/X/g' test_output.pep.fasta | sed 's/B/X/g' | sed 's/Z/X/g' > test_output.pep.modified.fasta
#then comparing modified file with GeMoMa results
#diff predicted_protein.fasta test_output.pep.modified.fasta > lines_that_diff_in_protein_model_after_sed.txt
#now output only differs for 15 of the gene models
#examined the protein sequence for each of these 15 pairs to see how they differ -> all only differ by a single residue, where an unambiguous base is included in the GeMoMa output, but an X in the gff2fasta output.
#have not looked in detail why these differences occur
#instead will try a different software suggested by Roddy which should give output from a gff file:
#testing the use of gffread for extracting CDS sequences (part of cufflinks); "-x" is to output a spliced CDS for each transcript in the gff file, "-y" is to get the protein translation
#NOTE!! need to use modified version of gff file from GeMoMa where "prediction" is replaced with "mRNA" (or could be "transcript" I expect), otherwise gffread will output individual fasta seqs for each exon rather than splicing them together
#module load cufflinks/2.2.1
#gffread predicted_annotation_EDITED.gff -g /data/SBCS-BuggsLab/LauraKelly/mapping/FRAX01_all_read_pairs_mapped_to_BATG0.5.sorted_duplicates_marked_RG_info_added_realigned_consensus.fa -x gffread_CDS.fasta -y gffread_protein.fasta
#this runs very quickly and gives desired output (also output ambiguity codes in protein sequence, as did gff2fasta, which is not possible with GeMoMa
#therefore, can use GeMoMa to get gff file and then get CDS and protein sequences using gffread (I check some of the output files and compared protein seqs with those from GeMoMa - appears that exons are correctly being spliced together etc.)
#checking how many of the CDS sequences for the gene models contain at least one ambiguity code (excluding Ns, because these might signify low coverage)
#first reformatted CDS file so sequences aren't wrapped over multiple lines, then using egrep to search for ambiguities
#grep -v ">" /Users/Laura/Projects/Ash/Data/Illumina/Illumina_data_for_genus_wide_study/Phasing/GeMoMa_analyses/gffread_CDS_unwrapped.fasta | egrep -c "M|R|W|S|Y|K|V|H|D|B"
#27671 of the CDSs have at least one ambiguity code, out of a total of 34688 (c.80%)
#if I count Ns as well ("M|R|W|S|Y|K|V|H|D|B|N") then there are 27964 CDSs with at least one of these bases (80.6%)
#counting how many of the CDSs begin with a start codon
#grep -v ">" /Users/Laura/Projects/Ash/Data/Illumina/Illumina_data_for_genus_wide_study/Phasing/GeMoMa_analyses/gffread_CDS_unwrapped.fasta | egrep -c "^ATG"
#33467 of the sequences begin with a start codon (96.48005%)
#checking how many of the CDSs both start with a start codon and end with a stop codon
#grep -v ">" /Users/Laura/Projects/Ash/Data/Illumina/Illumina_data_for_genus_wide_study/Phasing/GeMoMa_analyses/gffread_CDS_unwrapped.fasta | egrep "^ATG" | egrep -c "TAA|TAG|TGA^"
#33438 of the CDSs have both (96.39645%) and therefore appear to be complete


##TEST WITH FRAX33##
##Testing with denovo assembly for FRAX33 that was generated with CLC
#making a database of the sequences that I want to map the reference gene models to (can use the same reference gene models as made previously - see above)
#makeblastdb -out ./blastdb -hash_index -in /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX33_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_1000_contig_list.fa -title "target" -dbtype nucl
#running BLAST search; have kept all parameter settings the same as the example given in run.sh, apart from the e-value (for which I changed it from 100 to 1e-5) + using multiple threads
#tblastn -num_threads 12 -query cds-parts.fasta -db ./blastdb -evalue 1e-5 -out tblastn.txt -outfmt "6 std sallseqid score nident positive gaps ppos qframe sframe qseq sseq qlen slen salltitles" -db_gencode 1 -matrix BLOSUM62 -seg no -word_size 3 -comp_based_stats F -gapopen 11 -gapextend 1 -max_hsps 0
#using sed to replace problematic characters in blast report with Xs
#sed 's/J/X/g' tblastn.txt | sed 's/B/X/g' | sed 's/Z/X/g' > tblastn_corrected.txt
#running GeMoMa to generate gene models
java -jar GeMoMa-1.1.3.jar CLI GeMoMa t=tblastn_corrected.txt c=cds-parts.fasta a=assignment.tabular tg=/data/SBCS-BuggsLab/LauraKelly/assembly/FRAX33_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_1000_contig_list.fa  outdir=.
#this quit with an error "java.lang.NullPointerException", worked out this is because the sequence names for FRAX33 contigs contain Bs, so making the "corrected" blast results file changes the names
#therefore I can't correct the BLAST results in this way
#will rename contigs in FRAX33 assembly and save a copy in the GeMoMa folder
sed 's/18_8B_160615_L001_350bp_library_first_5bp_clipped_adapters_cut_quality_trimmed_min_50bp_paired_//g' /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX33_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_1000_contig_list.fa > FRAX33_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_1000_contig_list_contigs_renamed.fa
#will also correct the contigs names in the blast report so that they match those in the new contigs file
sed 's/18_8B_160615_L001_350bp_library_first_5bp_clipped_adapters_cut_quality_trimmed_min_50bp_paired_//g' tblastn.txt | sed 's/J/X/g' | sed 's/B/X/g' | sed 's/Z/X/g' > tblastn_corrected2.txt
#running GeMoMa on files with modified contig names to generate gene models
java -jar GeMoMa-1.1.3.jar CLI GeMoMa t=tblastn_corrected2.txt c=cds-parts.fasta a=assignment.tabular tg=FRAX33_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_1000_contig_list_contigs_renamed.fa  outdir=.
#predicted protein file contains 34,661 models (from the total of 38,949 gene models; therefore c. 89% of the reference models from BATG have a predicted protein for FRAX33)
#the number of reference models represented might increase once I have scaffolded assembly (or run it through AlignGraph)
#none of the FRAX33 proteins contain an X (which is expected because one or other haplotype is selected during de novo assembly in CLC - will need to map reads back to consensus to get an idea of heterozygosity).
#will do blastp of predicted proteins for FRAX33 against BATG gene model protein sequences to see how many appear to be +/- full length
#makeblastdb -in Fraxinus_excelsior_38873_TGAC_v2.longestCDStranscript.gff3.pep.fa -dbtype prot
blastp -task blastp -num_threads 12 -db Fraxinus_excelsior_38873_TGAC_v2.longestCDStranscript.gff3.pep.fa -evalue 1e-5 -query predicted_protein.fasta -outfmt 6 -max_target_seqs 1 -max_hsps 1 -out blastp_hits_of_FRAX33_predicted_proteins_against_BATG0.5_proteins.txt


##TESTS WITH TEST DATA##
#testing gemoma using test files provided; program can be run via the provided "run.sh" script (test reference and contigs files each contain a single sequence)
#for more info on options see: http://www.jstacs.de/index.php/GeMoMa#Download
./run.sh test_data/annotation.gff test_data/reference.fasta test_data/contig.fasta
#get errors to say that blast commands are not found - might need to load module for blast first because this is not loaded automatically
#module load blast+/2.2.29 
./run.sh test_data/annotation.gff test_data/reference.fasta test_data/contig.fasta
#this solves blast error, but get java exceptions (which also got for first test) + error for tblastn "Command line argument error: Argument "query". File is not accessible:  `results/sw//cds-parts.fasta"
#seems to be looking for a query sequence that doesn't exist - looking for "cds_parts" file in the output path ("results/sw") that has been created (according to my reading of the shell script)
#there is a file "precomputed_cds-parts.fasta" in the "test_data" folder, so will copy this to the "sw" folder and rename as "cds-parts.fasta" to see if this works (but might need to modify the test script because there is an extra "/" in the path to the cds-parts file
#./run.sh test_data/annotation.gff test_data/reference.fasta test_data/contig.fasta
#this now seems to run ok (after copying the cds-parts file - see above) and get an output tblastn file, but nothing else; think that only the blast parts of the script are running and not the java part (which actually runs GeMoMa)
#the cds-parts file probably did not exist because the java command did not execute
#version of java that is automatically available is java version "1.6.0_39", so could try loading a more recent version
#module load java/oracle/1.8.0_11
#./run.sh test_data/annotation.gff test_data/reference.fasta test_data/contig.fasta
#this seems to run ok, therefore need to load more recent version of java to get software to run correctly

echo 'JOB ENDED'


