#!/usr/bin/env python

from __future__ import print_function

import os
import datetime
import sys
from DNASkittleUtils.CommandLineUtils import call

output_dir = '/data/scratch/btx142/'
log_file_name = 'scaffold_' + datetime.datetime.now().strftime('%y-%m-%d__%H.%M.%S') + '.log'


def out_log_file_name(assembly_name):
    return assembly_name.strip() + '__' + log_file_name[:-3] + 'out'


def SSPACE_scaffolding(frax_number, assembly_name, assembly_path, do_extension=False):
    """
    /data/home/eex057/SSPACE-STANDARD-3.0_linux-x86_64/SSPACE_Standard_v3.0.pl \
    	-s /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX01_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa \ # contigs
    	-l /data/scratch/eex057/FRAX01/sspacelibraryfile01 \ # generated by ...
            -b RUN1 \  # output folder to create
    	-T 24 2>&1 >log01.txt  # -T = threads

    "-x  Indicate whether to extend the contigs of -s using paired reads in -l. (-x 1=extension, -x 0=no extension, default -x 0)"
    #Maybe we should be extending the contigs instead of defaulting to 0

    """
    call(['cd', output_dir])
    call(['/data/SBCS-BuggsLab/Josiah/SSPACE-STANDARD-3.0_linux-x86_64/SSPACE_Standard_v3.0.pl',
          '-s', assembly_path,  # contigs
          '-l /data/SBCS-BuggsLab/Josiah/DNA_Duplications/data/sspacelibraryfile_' + frax_number,
          '-b ', assembly_name,  # output folder to create
          '-x 1' if do_extension else '',  # extends read ends, added by Josiah
          '-T 24',  # -T = threads'])
          '2>&1 > "' + out_log_file_name(assembly_name) + '"',
          ])
    print("Done Scaffolding")


def gap_closer(frax_number, name, scaffold_path):
    """
    module load SOAP/2.40
    cd /data/scratch/eex057/FRAX01/
    GapCloser -a /data/scratch/eex057/FRAX01/RUN1/RUN1.final.scaffolds.fasta \
    	-b /data/scratch/eex057/FRAX01/GapCloser01.config \
    	-o GAPCLOSER01 \
            -t 8 >log-gapcloser01.txt 2>&1
    """
    call('module load soapdenovo2')
    call(['cd', output_dir])
    call(['GapCloser',
          '-a', scaffold_path,
          '-b /data/SBCS-BuggsLab/Josiah/DNA_Duplications/data/' + frax_number + '-GapCloser.config',
          '-o', name + '__GAPCLOSER',
          '-t 8',
          '> /data/SBCS-BuggsLab/Josiah/scaffolding/' + name + '__gapcloser.log 2>&1',
          ])


def main(frax_number, assembly_name, path, options):
    # Get CLC denovo assembly


    # Scaffold using long mate pairs
    scaffold_path = os.path.join(output_dir, assembly_name, assembly_name + '.final.scaffolds.fasta')
    SSPACE_scaffolding(frax_number, assembly_name, path, 'extend' in options)
    print(scaffold_path)

    # Close gaps in scaffolded assembly
    # gap_closer(frax_number, assembly_name, scaffold_path)


if __name__ == '__main__':
    if len(sys.argv) < 4:
        print("Include Frax number, Assembly name, Input path: e.g. FRAX01 FRAX01__2017-07-10 /data/SBCS-BuggsLab/Josiah/assembly/FRAX01__2017-07-10__bubblesize_5000__mincontig_200__SIMPLE__assembly.fa")
        exit(1)
    frax_number, name, path = sys.argv[1], sys.argv[2], sys.argv[3]
    options = []
    if len(sys.argv) >= 5:
        options = sys.argv[4]  # include 'extend' for SSPACE extension
    if frax_number == 'FRAX':
        print("You forgot to label your FRAX number (first argument) e.g. scaffold.py FRAX03")
        exit(1)
    log_file_name = frax_number + '_' + log_file_name
    main(frax_number, name, path, options)


"""
module load SOAP/2.40

cd /data/scratch/eex057/FRAX01/

GapCloser -a /data/scratch/eex057/FRAX01/RUN1/RUN1.final.scaffolds.fasta \
	-b /data/scratch/eex057/FRAX01/GapCloser01.config \
	-o GAPCLOSER01 \
        -t 8 >log-gapcloser01.txt 2>&1
        
        
GapCloser -a /data1/SBCS-BuggsLab/Josiah/scaffolding/FRAX09_Oct2017_draft_80GB/FRAX09_Oct2017_draft_80GB.final.scaffolds.fasta \
-b /data/SBCS-BuggsLab/Josiah/DNA_Duplications/data/FRAX09-GapCloser.config -o FRAX09_Oct2017_draft_80GB__GAPCLOSER \
-t 8 > /data/SBCS-BuggsLab/Josiah/scaffolding/FRAX09_Oct2017_draft_80GB__gapcloser.log 2>&1
         
"""