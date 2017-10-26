#!/usr/bin/env python

from __future__ import print_function

import os
import subprocess
import datetime

import sys

output_dir = '/data/scratch/btx142/'
log_file_name = 'scaffold ' + str(datetime.datetime.now()).split('.')[0] + '.log'


def out_log_file_name(assembly_name):
    return assembly_name + '__' + log_file_name[:-3] + 'out'


def log_command(args):
    command = ' '.join(args) if isinstance(args, list) else args
    print(command)
    with open(log_file_name, 'a') as log:
        log.writelines([command])
    return command


def call(args):
    command = log_command(args)
    return subprocess.check_output(command, shell=True)


def SSPACE_scaffolding(frax_number, assembly_name, assembly_path):
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
          '-l /data/SBCS-BuggsLab/Josiah/DNA_Duplications/sspacelibraryfile_' + frax_number ,
          '-b ', assembly_name,  # output folder to create
          '-x 1',  # added by Josiah to enable extending contigs and help out gap filler
          '-T 24',  # -T = threads'])
          '2>&1 >' + out_log_file_name(assembly_name),
          ])
    print("Done Scaffolding")

    return os.path.join(output_dir, assembly_name, assembly_name + '.final.scaffolds.fasta')


def gap_closer(frax_number, name, scaffold_path):
    """
    module load SOAP/2.40
    cd /data/scratch/eex057/FRAX01/
    GapCloser -a /data/scratch/eex057/FRAX01/RUN1/RUN1.final.scaffolds.fasta \
    	-b /data/scratch/eex057/FRAX01/GapCloser01.config \
    	-o GAPCLOSER01 \
            -t 8 >log-gapcloser01.txt 2>&1
    """
    call('module load SOAP/2.40')
    call(['cd', output_dir])
    call(['GapCloser',
          '-a', scaffold_path,
          '-b /data/SBCS-BuggsLab/Josiah/scaffolding/' + frax_number + '-GapCloser01.config',
          '-o', name + '__GAPCLOSER',
          '-t 8',
          '> /data/SBCS-BuggsLab/Josiah/scaffolding/' + name + '__gapcloser.log 2>&1',
          ])


def main(frax_number, name, path):
    # Get CLC denovo assembly


    # Scaffold using long mate pairs
    scaffold_path = SSPACE_scaffolding(frax_number, name, path)

    # Close gaps in scaffolded assembly
    # gap_closer(frax_number, name, scaffold_path)


if __name__ == '__main__':
    assert len(sys.argv) == 4, "Include Frax number, Assembly name, Input path: e.g. FRAX01 FRAX01__2017-07-10 /data/SBCS-BuggsLab/Josiah/assembly/FRAX01__2017-07-10__bubblesize_5000__mincontig_200__SIMPLE__assembly.fa"
    frax_number, name, path = sys.argv[1], sys.argv[2], sys.argv[3]
    log_file_name = frax_number + ' ' + log_file_name
    main(frax_number, name, path)


"""
module load SOAP/2.40

cd /data/scratch/eex057/FRAX01/

GapCloser -a /data/scratch/eex057/FRAX01/RUN1/RUN1.final.scaffolds.fasta \
	-b /data/scratch/eex057/FRAX01/GapCloser01.config \
	-o GAPCLOSER01 \
        -t 8 >log-gapcloser01.txt 2>&1 
"""