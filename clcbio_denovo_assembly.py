#!/usr/bin/env python

from __future__ import print_function

import os
from glob import glob
from read_trimming import call, call_output


def url(name):
    """Retrieves the CLC resource URL for a specific imported file.  Fails if the file is not imported"""
    return name


read_folder = '/home/jseaman/sequences/'  # TODO: needs to be filtered by FRAX number
output_dir = '/home/jseaman/assemblies/'
server_cmd_path = "/usr/local/bin/clcserver"
parse_cmd = "/usr/local/bin/clcresultparser"
password_token = 'BAAAAAAAAAAAAAP5d9b3a807f99338e--260f6b54-15d0dbc6aad--8000'
server_cmd = server_cmd_path + ' -S atta1.ad.kew.org -P 7777 -U jseaman -W %s ' % password_token


def make_clc_directory(subdirectory):
    """$SERVERCMD -A mkdir \
               -t ${tmpdir} \
               -n ${subdirectory} \
               -O mkdir_result.txt
    check_return_code "Make sub dir"
    destdir=`$PARSECMD -f mkdir_result.txt \
                       -p "-d" \
                       -c $subdirectory`
                       """
    call([server_cmd, '-A mkdir'
                      '-n', subdirectory,
          '-t', "clc://server"
                '-O mkdir_result.txt'])
    return call_output([parse_cmd,
                        '-f mkdir_result.txt',
                        '-p "-d"',
                        '-c', subdirectory])


def import_pair(R1, R2, directory_url):
    """Imports an illumina mate pair reads with paths R1 and R2.
    Files are made available in CLC folder @directory_url
    http://resources.qiagenbioinformatics.com/manuals/clcservercommandlinetools/current/index.php?manual=ngs_import_illumina.html"""
    call([server_cmd, '-A ngs_import_illumina',
          '--paired-reads true',  # <Boolean>	Paired-end reads (default: false)
          '--read-orientation FORWARD_REVERSE',  # Read orientation (default: FORWARD_REVERSE)
          ('--destination ' + directory_url),  # <ClcServerObjectUrl>	Destination file or folder on server.
          '--log fasle',
          '-f', R1,
          '-f', R2])


def import_read_pairs_by_FRAX(frax_name):
    # create directory to stage all relevant read pairs in
    directory_url = make_clc_directory(frax_name)

    # import all reads as pairs (where appropriate) for one particular frax_name
    relevant_files = glob(os.path.join(read_folder, frax_name) + '*')
    #TODO: shiv
    R1 = read_folder + \
         '1_S1_L001_R1_001_Run1_first_10bp_last_5bp_clipped_adapters_cut_quality_trimmed_min_50bp.fastq.gz'
    R2 = R1.replace('R1', 'R2')
    import_pair(R1, R2, directory_url)
    return directory_url


def denovo_assembly(reads_directory):
    auto_detect_paired_distances = '--auto-detect-paired-distances true'
    # <Boolean>	Determine appropriate paired distances as part of the assembly process. This is done
    # individually for each data set. If this option is not selected, the assembler will use the paired
    # distance information specified on the input data. (default: true)
    bubblesize = '--bubblesize 5000'
    # Integer: 1 <= x <= 5000	Bubble size used in the de Bruijn-Graph. Increase this when expecting many
    # SNP's or systematic errors. (default: 50)
    # destination = '--destination ' + url(output_dir)
    # <ClcServerObjectUrl> Destination file or folder on server. If not specified the folder of the first
    # input object will be used.
    input_folder = '--input ' + url(reads_directory)
    # <ClcObjectUrl>	Input data on server
    minimum_contig_length = '--minimum-contig-length 200'
    # Integer: >= 1	Mininum size of assembled contig. (default: 200)
    perform_scaffolding = '--perform-scaffolding false'
    # <Boolean>	Perform scaffolding based on paired reads. If the input data does not contain paired data,
    # scaffolding cannot be selected. (default: true)
    assembly_url = call_output([server_cmd, auto_detect_paired_distances, bubblesize, input_folder,
                                minimum_contig_length, perform_scaffolding])
    return assembly_url


def main():
    frax_number = 'FRAX01'
    # stage all the data to be used
    read_directory = import_read_pairs_by_FRAX(frax_number)
    # do de novo assembly using all info
    assembly_url = denovo_assembly(read_directory)
    print('Done with Assembly ', frax_number, assembly_url)
