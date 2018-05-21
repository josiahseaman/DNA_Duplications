#!/usr/bin/perl
#filter_similar_gene_models.pl
use strict;
use warnings;
# A program to take a BLAST results file with additional info printed for results (see details in "qsub_GeMoMa.sh" script
# Created to find gene models that have a high degree of overlap and sequence similarity (to remove gene models predicted in the same place)
# but which do not necessairly share the same coordinates

#Declare and initialize variables
my $infile;
my @current_line_parts= ();


#Ask user for the path to the first input file
print "Please enter the path to the BLAST results file (see file qsub_GeMoMa.sh for required format):\n";
$infile = <STDIN>;
chomp $infile;

#Create output file for saving results in (gene models to discard), or print an error if file cannot be made
open (OUTFILE, ">>Filtered_gene_models.txt") or die "Could not write to file \">Filtered_gene_models.txt\": $!\n";

#Open first input file, or print an error if file cannot be opened
open (INONE, "<$infile") or die "Could not open file \"$infile\": $!\n";

#Read in input file, one line at a time
while (<INONE>) {
 	#remove the newline character from the current line
 	chomp $_;
 	#split current line to separate out elements and add it to an array
 	@current_line_parts = split(/\t/, $_);
 	#check to see if the current hit is a self hit
 	unless ($current_line_parts[0] eq $current_line_parts[1]) {
 		#if the current hit is not a self hit, check the % of the query sequence in the HSP (only the top HSP is saved in the results) and the percentage similarity in the alignment
 		if (($current_line_parts[2] == 100) and ($current_line_parts[15] >= 90)) {
 	 		#if at least 90% of the query sequence is involved in the hit and there is 100% similarity between the query and subject, save name to second output file
 	 		print OUTFILE "$current_line_parts[0]\n";
 	 		#because some gene models have multiple non self-hits (only 2 hits were allowed) then some names will be added to file twice
 	 		#these can be removed subsequently with "uniq"
	 	}
 	}
 }
 	

#Close input file
close INONE;

#Close output files
close OUTFILE;

#exit the program
exit;