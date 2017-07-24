#!/usr/bin/python

from __future__ import print_function

import os
from glob import glob
import subprocess
import sys
import datetime


read_folder = '/home/jseaman/sequences/'
output_dir = '/home/jseaman/assemblies/'
server_cmd_path = "/usr/local/bin/clcserver"
parse_cmd = "/usr/local/bin/clcresultparser"
clc_server_root = 'clc://10.65.1.101:7777/clcserver/Fraxinus/'
password_token = 'BAAAAAAAAAAAAAP5d9b3a807f99338e--260f6b54-15d0dbc6aad--8000'
server_cmd = server_cmd_path + ' -S atta1.ad.kew.org -P 7777 -U jseaman -W %s ' % password_token
log_file_name = str(datetime.datetime.now()).split('.')[0] + '.log'


def log_command(args):
    command = ' '.join(args) if isinstance(args, list) else args
    print(command)
    with open(log_file_name, 'a') as log:
        log.write(command + '\n')
    return command


def call_output(args):
    command = log_command(args)
    return subprocess.check_output(command, shell=True)


def call(args):
    command = log_command(args)
    return subprocess.call(command, shell=True)
    # TODO: add error handling for bad return code


def url(name):
    """Retrieves the CLC resource URL for a specific imported file.  Fails if the file is not imported"""
    return clc_server_root + os.path.basename(name)


def remove_extensions(path):
    """Remove extension and path"""
    first_extension = os.path.splitext(path)[0]
    return os.path.splitext(first_extension)[0]


def just_the_name(path):
    """Remove extension and path"""
    return remove_extensions(os.path.basename(path))


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
    if not os.path.exists(os.path.join('/data/clcserver/Fraxinus/', subdirectory)):  # different from CLC URL
        call([server_cmd, '-A mkdir',
              '-n', subdirectory,
              '-t', clc_server_root])
    """Example output from the above command:
    Message: Trying to log on to server
    Message: Login successful
    Message: Executing command mkdir
    Name: FRAX14
    Type: Directory
    ClcUrl: clc://localhost:7777/1753281757-WAAAAAAAAAAAAAP695532d5ba6ceebf-30223f7e-15c77a61578--7fff/-298049416-HBAAAAAAAAAAAAPb7f807af1cc25381--21537d00-15c7851a624--7fff
    ClcUrl Simple: clc://server/clcserver/Fraxinus/FRAX14
    //"""

    directory = os.path.join(clc_server_root, subdirectory)
    return directory
    # Example result: clcresultparser -f mkdir_result -c FRAX14
    # clc://localhost:7777/1753281757-WAAAAAAAAAAAAAP695532d5ba6ceebf-30223f7e-15c77a61578--7fff/-298049416-HBAAAAAAAAAAAAPb7f807af1cc25381--21537d00-15c7851a624--7fff


def import_pair(R1, R2, directory_url, frax_name):
    """Imports an illumina mate pair reads with paths R1 and R2.
    Files are made available in CLC folder @directory_url
    http://resources.qiagenbioinformatics.com/manuals/clcservercommandlinetools/current/index.php?manual=ngs_import_illumina.html"""
    expected_file = os.path.join('/data/clcserver/Fraxinus/', frax_name, just_the_name(R1) + ' (paired).clc')
    if os.path.exists(expected_file):
        print(expected_file, 'already imported')
    else:
        print("Importing", R1, R2)
        # Then read in the data
        call([server_cmd, '-A ngs_import_illumina',
              '-f', R1,
              '-f', R2,
              '--paired-reads true',  # <Boolean>	Paired-end reads (default: false)
              '--read-orientation FORWARD_REVERSE',  # Read orientation (default: FORWARD_REVERSE)
              '--destination ', directory_url,  # <ClcServerObjectUrl>	Destination file or folder on server.
              ])


def strip_frax(frax_name):
    """strips the 01 if it's there"""
    return str(int(frax_name.replace('FRAX', '')))


def import_read_pairs_by_FRAX(frax_name):
    # create directory to stage all relevant read pairs in
    directory_url = make_clc_directory(frax_name)
    # import all reads as pairs (where appropriate) for one particular frax_name
    relevant_files = glob(os.path.join(read_folder, frax_name) + '*')
    try:  # have a proper FRAX01 prefix.  Renaming the files would allow you to remove this line
        stripped_number = strip_frax(frax_name)
        relevant_files += glob(os.path.join(read_folder, stripped_number) + '_*')  # The NextSeq reads don't
    except ValueError as e:
        pass  # this must be a non-Frax name
    first_pairs = [x for x in relevant_files if '_R1_' in x and 'ssembly' not in x]
    for R1 in first_pairs:
        R1 = os.path.join(read_folder, os.path.basename(R1))
        R2 = R1.replace('R1', 'R2')
        import_pair(R1, R2, directory_url, frax_name)
    return directory_url


def directory_listing_URLs(reads_directory_url):
    """clcserver -A ls --target clc://localhost:7777/clcserver/Fraxinus/FRAX01"""
    raw_text = call_output([server_cmd, '-A ls',
                            '--target', reads_directory_url])
    # all lines with Simple but not log or assembly
    # or call_output('cat raw_directory_listing.tmp | grep -v "log" | grep -v "assembly')
    processed = []
    for line in raw_text.splitlines():
        url_line_prefix = 'ClcUrl Simple: '
        if url_line_prefix in line and 'log' not in line and 'assembly' not in line:
            processed.append(line.replace(url_line_prefix, ''))
    return processed


def denovo_assembly(reads_directory_url):
    input_urls = directory_listing_URLs(reads_directory_url)
    auto_detect_paired_distances = '--auto-detect-paired-distances true'
    # <Boolean>	Determine appropriate paired distances as part of the assembly process. This is done
    # individually for each data set. If this option is not selected, the assembler will use the paired
    # distance information specified on the input data. (default: true)
    bubblesize = '--bubblesize 5000 --bubblesize-auto false'
    # Integer: 1 <= x <= 5000	Bubble size used in the de Bruijn-Graph. Increase this when expecting many
    # SNP's or systematic errors. (default: 50)
    mapping_type = '--map-reads-to-contigs SIMPLE'

    destination_url = '"' + reads_directory_url + '"'
    destination = '--destination ' + destination_url
    # <ClcServerObjectUrl> Destination file or folder on server. If not specified the folder of the first
    # input object will be used.
    input_files_string = ' '.join(['--input "%s"' % url for url in input_urls])  # <ClcObjectUrl> Input data
    # on server
    minimum_contig_length = '--minimum-contig-length 200'
    # Integer: >= 1	Mininum size of assembled contig. (default: 200)
    perform_scaffolding = '--perform-scaffolding false'
    # <Boolean>	Perform scaffolding based on paired reads. If the input data does not contain paired data,
    # scaffolding cannot be selected. (default: true)
    call([server_cmd, '-A denovo_assembly',
          auto_detect_paired_distances,
          bubblesize,
          mapping_type,
          minimum_contig_length,
          perform_scaffolding,
          input_files_string,
          destination])
    return destination_url


def rsync_sequences(frax_number):
    """Download data from QMUL"""
    #TODO: untested communicate code
    password = input(prompt='Enter password for btx142@frontend5.apocrita.hpc.qmul.ac.uk')
    p = subprocess.Popen(
        ["rsync -au --exclude '*singleton*' ",
         "btx142@frontend5.apocrita.hpc.qmul.ac.uk:/data/SBCS-BuggsLab/LauraKelly/HiSeq_data"
         "/trimmed_reads/%s_*" % frax_number,
         "/home/jseaman/sequences/"], stdin=subprocess.PIPE)
    p.communicate(input=password + '\n')

    f = subprocess.Popen(
        ["rsync -au --exclude '*singleton*' ",
         "btx142@frontend5.apocrita.hpc.qmul.ac.uk:/data/SBCS-BuggsLab/LauraKelly/NextSeq_data"
         "/trimmed_reads/%s_*" % strip_frax(frax_number),
         "/home/jseaman/sequences/"], stdin=subprocess.PIPE)
    f.communicate(input=password + '\n')


def initialize_log_file():
    with open(log_file_name, 'w') as log:
        log.write('#############Source Code at time of execution###############\n')
        with open(__file__) as source_code:
            log.write(source_code.read())
        log.write('\n\n\n\n#!/bin/bash\n#############Actual Commands executed###############\n')


def main(frax_number):
    initialize_log_file()
    # rsync_sequences(frax_number)
    # stage all the data to be used
    reads_directory_url = import_read_pairs_by_FRAX(frax_number)
    # do de novo assembly using all info
    # assembly_url = denovo_assembly(reads_directory_url)
    print("Done importing", frax_number, "\nAssembly is turned off in this version.")
    # log_command(['echo', 'Done with Assembly ', frax_number, reads_directory_url, assembly_url])


if __name__ == '__main__':
    assert sys.argv[1], "Include Frax name: e.g. FRAX01"
    frax_name = sys.argv[1]
    log_file_name = frax_name + ' ' + log_file_name
    main(frax_name)
