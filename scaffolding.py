#!/usr/bin/env python

from __future__ import print_function

import os
import subprocess
import sys

insert_size = '800bp_library_'
output_dir = '/data/scratch/btx142/HiSeq_data/trimmed_reads/'


def call(args):
    command = ' '.join(args) if isinstance(args, list) else args
    print(command)
    subprocess.call(command, shell=True)

call('cd /data/scratch/eex057/FRAX01/')
"""
/data/home/eex057/SSPACE-STANDARD-3.0_linux-x86_64/SSPACE_Standard_v3.0.pl \
	-s /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX01_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa \ # contigs
	-l /data/scratch/eex057/FRAX01/sspacelibraryfile01 \ # generated by ...
        -b RUN1 \  # output folder to create
	-T 24 2>&1 >log01.txt  # -T = threads
"""

"""
module load SOAP/2.40

cd /data/scratch/eex057/FRAX01/

GapCloser -a /data/scratch/eex057/FRAX01/RUN1/RUN1.final.scaffolds.fasta \
	-b /data/scratch/eex057/FRAX01/GapCloser01.config \
	-o GAPCLOSER01 \
        -t 8 >log-gapcloser01.txt 2>&1
"""

"""
module load SOAP/2.40

cd /data/scratch/eex057/FRAX01/

GapCloser -a /data/scratch/eex057/FRAX01/RUN1/RUN1.final.scaffolds.fasta \
	-b /data/scratch/eex057/FRAX01/GapCloser01.config \
	-o GAPCLOSER01 \
        -t 8 >log-gapcloser01.txt 2>&1 
"""