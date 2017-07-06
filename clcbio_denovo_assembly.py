#!/usr/bin/python

from __future__ import print_function

import os
from glob import glob
import subprocess


def call_output(args):
    command = ' '.join(args) if isinstance(args, list) else args
    print(command)
    return subprocess.check_output(command, shell=True)


def call(args):
    command = ' '.join(args) if isinstance(args, list) else args
    print(command)
    return subprocess.call(command, shell=True)
    # TODO: add error handling for bad return code


def url(name):
    """Retrieves the CLC resource URL for a specific imported file.  Fails if the file is not imported"""
    return clc_server_root + os.path.basename(name)


read_folder = '/home/jseaman/sequences/'
output_dir = '/home/jseaman/assemblies/'
server_cmd_path = "/usr/local/bin/clcserver"
parse_cmd = "/usr/local/bin/clcresultparser"
clc_server_root = 'clc://10.65.1.101:7777/clcserver/Fraxinus/'
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
    call([server_cmd, '-A mkdir',
          '-n', subdirectory,
          '-t', clc_server_root,
          '-O mkdir_result.txt'])
    """Example output from the above command:
    Message: Trying to log on to server
    Message: Login successful
    Message: Executing command mkdir
    Name: FRAX14
    Type: Directory
    ClcUrl: clc://localhost:7777/1753281757-WAAAAAAAAAAAAAP695532d5ba6ceebf-30223f7e-15c77a61578--7fff/-298049416-HBAAAAAAAAAAAAPb7f807af1cc25381--21537d00-15c7851a624--7fff
    ClcUrl Simple: clc://server/clcserver/Fraxinus/FRAX14
    //"""

    return call_output([parse_cmd,
                        '-f mkdir_result.txt',
                        '-c', subdirectory])
    # Example result: clcresultparser -f mkdir_result -c FRAX14
    # clc://localhost:7777/1753281757-WAAAAAAAAAAAAAP695532d5ba6ceebf-30223f7e-15c77a61578--7fff/-298049416-HBAAAAAAAAAAAAPb7f807af1cc25381--21537d00-15c7851a624--7fff


def import_pair(R1, R2, directory_url):
    """Imports an illumina mate pair reads with paths R1 and R2.
    Files are made available in CLC folder @directory_url
    http://resources.qiagenbioinformatics.com/manuals/clcservercommandlinetools/current/index.php?manual=ngs_import_illumina.html"""
    print("Importing", R1, R2)
    # Then read in the data
    call([server_cmd, '-A ngs_import_illumina',
          '-f', R1,
          '-f', R2,
          '--paired-reads true',  # <Boolean>	Paired-end reads (default: false)
          '--read-orientation FORWARD_REVERSE',  # Read orientation (default: FORWARD_REVERSE)
          '--destination ', directory_url,  # <ClcServerObjectUrl>	Destination file or folder on server.
          ])


def import_read_pairs_by_FRAX(frax_name):
    # create directory to stage all relevant read pairs in
    directory_url = make_clc_directory(frax_name)
    # import all reads as pairs (where appropriate) for one particular frax_name
    relevant_files = glob(os.path.join(read_folder, frax_name) + '*')
    stripped_number = str(int(frax_name.replace('FRAX', '')))  # strips the 01 if it's there
    relevant_files += glob(os.path.join(read_folder, stripped_number) + '_*')  # The NextSeq reads don't
    # have a proper FRAX01 prefix.  Renaming the files would allow you to remove this line
    first_pairs = [x for x in relevant_files if '_R1_' in x]
    for R1 in first_pairs:
        R1 = os.path.join(read_folder, os.path.basename(R1))
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
    assembly_url = call_output([server_cmd, '-A denovo_assembly',
                                auto_detect_paired_distances, bubblesize, input_folder,
                                minimum_contig_length, perform_scaffolding])
    return assembly_url


def main():
    frax_number = 'FRAX01'
    # stage all the data to be used
    read_directory = import_read_pairs_by_FRAX(frax_number)
    # do de novo assembly using all info
    # assembly_url = denovo_assembly(read_directory)
    print('Done with Assembly ', frax_number, read_directory)#assembly_url)


if __name__ == '__main__':
    main()
