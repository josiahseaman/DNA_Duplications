#!/usr/bin/env bash
module load SOAP/2.40

cd /data/scratch/eex057/FRAX01/

GapCloser -a /data/scratch/eex057/FRAX01/RUN1/RUN1.final.scaffolds.fasta \
	-b /data/scratch/eex057/FRAX01/GapCloser01.config \
	-o GAPCLOSER01 \
        -t 8 >log-gapcloser01.txt 2>&1 

