#!/usr/bin/env python

from __future__ import print_function

import os
from datetime import datetime
import sys
from DNASkittleUtils.CommandLineUtils import call
from DNASkittleUtils.Contigs import read_contigs, write_contigs_to_file
from os.path import splitext, join, dirname, exists


output_dir = '/data/SBCS-BuggsLab/Josiah/scaffolding/'
time_stamp = datetime.now().strftime('%yyyy-%mm-%dd__%HH.%MM.%SS')
log_file_name = 'scaffold_' + time_stamp + '.log'


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
          '-T %i' % linux_processors_available(24),  # -T = threads'])
          '2>&1 > "' + out_log_file_name(assembly_name) + '"',
          ])
    print("Done Scaffolding")


def linux_processors_available(default):
    """Detects the number of processors allocated to this program in a Linux environment.
    Returns default with any other configuration."""
    import re
    m = re.search(r'(?m)^Cpus_allowed:\s*(.*)$',
                  open('/proc/self/status').read())
    if m:
        try:
            return bin(int(m.group(1).replace(',', ''), 16)).count('1')
        except BaseException:
            pass
    return default


def gap_closer(frax_number, prefile, gap_file):
    """
    module load SOAP/2.40
    cd /data/scratch/eex057/FRAX01/
    GapCloser -a /data/scratch/eex057/FRAX01/RUN1/RUN1.final.scaffolds.fasta \
    	-b /data/scratch/eex057/FRAX01/GapCloser01.config \
    	-o GAPCLOSER01 \
            -t 8 >log-gapcloser01.txt 2>&1
    """
    call(['cd', output_dir])
    call(['GapCloser',
          '-a', prefile,
          '-b /data/SBCS-BuggsLab/Josiah/DNA_Duplications/data/' + frax_number + '-GapCloser.config',
          '-o', gap_file,
          '-t %i' % linux_processors_available(4),
          '>', splitext(gap_file)[0] + '.log', '2>&1',
          ])


def preprocess_for_gapcloser(input_fasta, output_name):
    scaffolds = read_contigs(input_fasta)
    scaffolds.sort(key=lambda fragment: -len(fragment.seq))
    l_scaffolds, short_scaff = [], []
    for scaff in scaffolds:
        if scaff.seq.count('N') > 100:  # if it doesn't have gaps, don't bother
            l_scaffolds.append(scaff)
        else:
            short_scaff.append(scaff)
    long_sum = sum([len(c.seq) for c in l_scaffolds])
    short_sum = sum([len(c.seq) for c in short_scaff])
    print("Eliminated %i scaffolds" % (len(scaffolds) - len(l_scaffolds)))
    if long_sum > short_sum:
        print("WARNING: More than half of the sequence was eliminated in preprocessing.", file=sys.stderr)

    write_contigs_to_file(output_name, l_scaffolds)
    leftover_name = splitext(input_fasta)[0] + '__remaining_short_scaffolds' + splitext(input_fasta)[1]
    write_contigs_to_file(leftover_name, short_scaff)
    return leftover_name


def check_if_done(target_output, do_job):
    print("Checking for file", target_output)
    ret = None
    # Checks if existing file is of Zero size
    if exists(target_output) and os.path.getsize(target_output):
        print(target_output, "already exists, skipping to next step.")
    else:
        ret = do_job()
        assert exists(target_output), \
            "Job didn't create the intended file\nThere may be a name mismatch"
        print("Created", target_output)
    return ret


def merge_results(gap_file, leftover_name, merged_file):
    """Merge the results from GapCloser with the contigs that were not touched.
    There is a chance of a partial duplication of a short scaffold if GapCloser
    reconstitutes the same short scaffold from raw sequence fastq.gz and uses it
    to fill in an existing N gap.
    I've previously used 'bwa fastmap' to detect these erroneous duplications
    before the merge."""
    call(["cat",
          gap_file,
          leftover_name,
          ">", merged_file
          ])


def fasta_stats_to_sheets(merged_file):
    pass


def main(frax_number, assembly_name, path, options):
    # Get CLC denovo assembly

    # Scaffold using long mate pairs
    scaffold_path = join(output_dir, assembly_name, assembly_name + '.final.scaffolds.fasta')

    check_if_done(scaffold_path,
                  lambda: SSPACE_scaffolding(frax_number, assembly_name, path, 'extend' in options))

    # Close gaps in scaffolded assembly
    prefile = splitext(scaffold_path)[0] + '__pre_gapcloser' + splitext(scaffold_path)[1]
    leftover_name = check_if_done(prefile,
                  lambda: preprocess_for_gapcloser(scaffold_path, prefile))
    working_dir = dirname(prefile)
    gap_file = join(working_dir, name + '__GAPCLOSER.fa')
    check_if_done(gap_file,
                  lambda: gap_closer(frax_number, prefile, gap_file))
    merged_file = join(working_dir, frax_number + '__GAPCLOSER__cat_merged.fa')
    merge_results(gap_file, leftover_name, merged_file)
    # fasta_stats_to_sheets(merged_file)
    print("Done with everything")


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