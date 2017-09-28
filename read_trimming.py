#!/usr/bin/env python

from __future__ import print_function

import os
import subprocess
import sys

insert_size = '800bp_library_'
output_dir = '/data/scratch/btx142/HiSeq_data/trimmed_reads/'


def call_output(args):
    command = ' '.join(args) if isinstance(args, list) else args
    print(command)
    return subprocess.check_output(command, shell=True)


def call(args):
    command = ' '.join(args) if isinstance(args, list) else args
    print(command)
    subprocess.call(command, shell=True)
    # TODO: add error handling for bad return code


def remove_extensions(path):
    """Remove extension and path"""
    first_extension = os.path.splitext(path)[0]
    return os.path.splitext(first_extension)[0]


def just_the_name(path):
    """Remove extension and path"""
    return remove_extensions(os.path.basename(path))


def delete_file_contents(file_path):
    if 'scratch' in file_path:
        if os.path.exists(file_path):
            with open(file_path, 'w') as big_file:
                big_file.write('Contents deleted to save scratch space')
                print('File contents deleted:', file_path)
    else:
        print('ERROR: Not blanking file because it is not in a scratch directory', file_path, file=sys.stderr)


def trim_adapters(clipped_file_path, base_clipped_name, run):
    fastq_input_file_label = just_the_name(clipped_file_path)

    # Choose adapters based on if it is R1 or R2 (different adapters used)
    assert 'R1' in fastq_input_file_label or 'R2' in fastq_input_file_label, "File name should mention R1 or R2: " + fastq_input_file_label
    side = 'R1' if 'R1' in fastq_input_file_label else 'R2'
    # Step 2, Trimming the adapters out of the reads [R1 reads]
    adapters = {
        'R1': [
            'AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC',
            'GATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT',
            'GATCGGAAGAGCACACGTCTGAACTCCAGTCAC',
            'AGATCGGAAGAGCACACGTCT',
            'CTGTCTCTTATACACATCTCCGAGCCCACGAGAC',
            'CGTAATAACTTCGTATAGCATACATTATACGAAGTTATACGA',
            'TCGTATAACTTCGTATAATGTATGCTATACGAAGTTATTACG',
        ],
        'R2': [
            'AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT',
            'ACACTCTTTCCCTACACGACGCTCTTCCGATC',
            'GTGACTGGAGTTCAGACGTGTGCTCTTCCGATC',
            'GATCGTCGGACTGTAGAACTCTGAAC',
            'CTGTCTCTTATACACATCTGACGCTGCCGACGA',
            'CGTAATAACTTCGTATAGCATACATTATACGAAGTTATACGA',
            'TCGTATAACTTCGTATAATGTATGCTATACGAAGTTATTACG',
        ]
    }
    trimmed_file = os.path.join(output_dir, base_clipped_name) + '_' + insert_size + 'first_5bp_clipped_adapters_cut.fastq'
    if run:
        if os.path.exists(trimmed_file):
            print(trimmed_file, "already exists")
        else:
            print("Unable to find", trimmed_file)
            adapter_arguments = [' -b ' + x for x in adapters[side]]  # this should not be 'join' because it skips the first
            call(['/data/SBCS-BuggsLab/LauraKelly/tools/cutadapt-1.8.1/bin/cutadapt', '-O 5 ',
                  ' '.join(adapter_arguments),
                  ' -o ' + trimmed_file,
                  clipped_file_path])
        delete_file_contents(clipped_file_path)
    return trimmed_file


def clip_5bp(source_fastq_path, base_clipped_name, run):
    try:
        call(['module load fastx'])
    except OSError:
        pass  # loaded in starter script
    # Step 1, trimming reads with fast_trimmer [i.e. you have to load the fastx module]
    output_path = os.path.join(output_dir, base_clipped_name) + '_first_5bp_clipped.fastq'
    if run:
        if os.path.exists(output_path):
            print(output_path, "already exists")
        else:
            print("Unable to find", output_path)
            call(['zcat', source_fastq_path,
                  '|',
                  'fastx_trimmer -Q33 -f 6 -v',
                  '-o ' + output_path
                  ])
    return output_path


def fastqc_report(final_R1, final_R2, run):
    report_dir = 'fastqc_reports'
    R1_report = os.path.join(report_dir, just_the_name(final_R1) + '_fastqc.html')
    R2_report = os.path.join(report_dir, just_the_name(final_R2) + '_fastqc.html')
    if run:
        if os.path.exists(R1_report) and os.path.exists(R2_report):
            print(R1_report, 'already exists')
        else:
            call('module load fastqc')
            if not os.path.exists(report_dir):
                os.makedirs(report_dir)
            call(['fastqc --outdir', report_dir, final_R1])
            call(['fastqc --outdir', report_dir, final_R2])
    return R1_report, R2_report


def sickle(R1_trimmed, R2_trimmed, run):
    """Step 3, trimming the reads for quality score using sickle [sickle is in Laura's directory]"""
    singletons_output = remove_extensions(R1_trimmed).replace('R1', '') + '_quality_trimmed_min_50bp_singletons.fastq.gz'
    R1_output = remove_extensions(R1_trimmed) + '_quality_trimmed_min_50bp.fastq.gz'
    R2_output = remove_extensions(R2_trimmed) + '_quality_trimmed_min_50bp.fastq.gz'
    if run:
        if os.path.exists(singletons_output):
            print(singletons_output, "already exists")
        else:
            print("Unable to find", singletons_output)
            call(['/data/SBCS-BuggsLab/LauraKelly/other/sickle-master/sickle',
                  'pe',
                  '-f ' + R1_trimmed,
                  '-r ' + R2_trimmed,
                  '-t sanger',
                  '-g',
                  '-o ' + R1_output,
                  '-p ' + R2_output,
                  '-s ' + singletons_output,
                  '-q 20',
                  '-l 50'])
        delete_file_contents(R1_trimmed)
        delete_file_contents(R2_trimmed)
    return R1_output, R2_output


def process_one_mate_pair_file(source_fastq_path, output_name, jobs):
    # frax_name + '_' + just_the_name(source_fastq_path)  # add FRAX number
    call(['mkdir', '-p', os.path.join(output_dir, output_name)])
    R1_output = output_name
    R2_output = output_name.replace('R1', 'R2')

    # Average Run Time: 10 minutes  Memory: 70M
    clipped_file_R1 = clip_5bp(source_fastq_path, R1_output, run='clip' in jobs)
    clipped_file_R2 = clip_5bp(source_fastq_path.replace('R1', 'R2'), R2_output, run='clip' in jobs)

    # Average Run Time: 1 hour    Memory: 100M
    R1_trimmed = trim_adapters(clipped_file_R1, R1_output, run='trim' in jobs)
    R2_trimmed = trim_adapters(clipped_file_R2, R2_output, run='trim' in jobs)

    # Average Run Time: 2 hours    Memory: 100M
    final_R1, final_R2 = sickle(R1_trimmed, R2_trimmed, run='sickle' in jobs)

    # Average Run Time: 1 hour    Memory: 2G
    R1_report, R2_report = fastqc_report(final_R1, final_R2, run='fastqc' in jobs)


def starter():
    jobs = sys.argv[1:]  # set of things to do: ['clip', 'trim', 'sickle', 'fastqc']
    if not len(jobs):
        jobs = ['clip', 'trim', 'sickle', 'fastqc']
    print('Checking for previously calculated files')
    print('Jobs', jobs)

    work_array = [
        (None, None),  # one indexed:  use #$ -t 1-35
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_1/1_ATTACTCG-CTTCGCCT_L001_R1_001.fastq.gz', 'FRAX01_L001_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_1/1_ATTACTCG-CTTCGCCT_L002_R1_001.fastq.gz', 'FRAX01_L002_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_1/1_ATTACTCG-CTTCGCCT_L003_R1_001.fastq.gz', 'FRAX01_L003_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_2/2_ATTACTCG-TAAGATTA_L001_R1_001.fastq.gz', 'FRAX02_L001_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_2/2_ATTACTCG-TAAGATTA_L002_R1_001.fastq.gz', 'FRAX02_L002_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_2/2_ATTACTCG-TAAGATTA_L003_R1_001.fastq.gz', 'FRAX02_L003_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_3/3_ATTACTCG-ACGTCCTG_L001_R1_001.fastq.gz', 'FRAX03_L001_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_3/3_ATTACTCG-ACGTCCTG_L002_R1_001.fastq.gz', 'FRAX03_L002_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_3/3_ATTACTCG-ACGTCCTG_L003_R1_001.fastq.gz', 'FRAX03_L003_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_4/4_ATTACTCG-GTCAGTAC_L001_R1_001.fastq.gz', 'FRAX04_L001_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_4/4_ATTACTCG-GTCAGTAC_L002_R1_001.fastq.gz', 'FRAX04_L002_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_4/4_ATTACTCG-GTCAGTAC_L003_R1_001.fastq.gz', 'FRAX04_L003_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_5/5_TCCGGAGA-CTTCGCCT_L001_R1_001.fastq.gz', 'FRAX05_L001_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_5/5_TCCGGAGA-CTTCGCCT_L002_R1_001.fastq.gz', 'FRAX05_L002_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_5/5_TCCGGAGA-CTTCGCCT_L003_R1_001.fastq.gz', 'FRAX05_L003_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_6/6_TCCGGAGA-TAAGATTA_L001_R1_001.fastq.gz', 'FRAX06_L001_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_6/6_TCCGGAGA-TAAGATTA_L002_R1_001.fastq.gz', 'FRAX06_L002_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_6/6_TCCGGAGA-TAAGATTA_L003_R1_001.fastq.gz', 'FRAX06_L003_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_7/7_TCCGGAGA-ACGTCCTG_L001_R1_001.fastq.gz', 'FRAX07_L001_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_7/7_TCCGGAGA-ACGTCCTG_L002_R1_001.fastq.gz', 'FRAX07_L002_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_7/7_TCCGGAGA-ACGTCCTG_L003_R1_001.fastq.gz', 'FRAX07_L003_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_8/8_TCCGGAGA-GTCAGTAC_L001_R1_001.fastq.gz', 'FRAX08_L001_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_8/8_TCCGGAGA-GTCAGTAC_L002_R1_001.fastq.gz', 'FRAX08_L002_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_8/8_TCCGGAGA-GTCAGTAC_L003_R1_001.fastq.gz', 'FRAX08_L003_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_9/9_CGCTCATT-CTTCGCCT_L001_R1_001.fastq.gz', 'FRAX09_L001_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_9/9_CGCTCATT-CTTCGCCT_L002_R1_001.fastq.gz', 'FRAX09_L002_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_9/9_CGCTCATT-CTTCGCCT_L003_R1_001.fastq.gz', 'FRAX09_L003_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_10/10_CGCTCATT-TAAGATTA_L001_R1_001.fastq.gz', 'FRAX11_L001_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_10/10_CGCTCATT-TAAGATTA_L002_R1_001.fastq.gz', 'FRAX11_L002_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_10/10_CGCTCATT-TAAGATTA_L003_R1_001.fastq.gz', 'FRAX11_L003_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_11/11_CGCTCATT-ACGTCCTG_L001_R1_001.fastq.gz', 'FRAX12_L001_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_11/11_CGCTCATT-ACGTCCTG_L002_R1_001.fastq.gz', 'FRAX12_L002_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_11/11_CGCTCATT-ACGTCCTG_L003_R1_001.fastq.gz', 'FRAX12_L003_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_12/12_CGCTCATT-GTCAGTAC_L001_R1_001.fastq.gz', 'FRAX13_L001_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_12/12_CGCTCATT-GTCAGTAC_L002_R1_001.fastq.gz', 'FRAX13_L002_pairs'),
        ('/data/SBCS-BuggsLab/Josiah/Liverpool_800bp_HiSeq2500/Raw/Sample_12/12_CGCTCATT-GTCAGTAC_L003_R1_001.fastq.gz', 'FRAX13_L003_pairs'),
    ]
    task_index = int(os.environ.get('SGE_TASK_ID'))
    source_fastq_path, output_name = work_array[task_index]
    print("Starting Job:", task_index, source_fastq_path, output_name)
    process_one_mate_pair_file(source_fastq_path, output_name, jobs)


if __name__ == '__main__':
    # Original Step 1:
    # zcat /data/SBCS-BuggsLab/LauraKelly/HiSeq_data/Raw_reads_from_CGR/Raw/Fraxinus_anomala_FRAX27/350bp_library/13-2B_160615_L001_R1.fastq.gz
    #  | fastx_trimmer -Q33 -f 6 -v -o /data/SBCS-BuggsLab/LauraKelly/HiSeq_data/trimmed_reads/FRAX27_13-2B_160615_L001_R1_first_5bp_clipped.fastq

    # My modified Step 1:
    # zcat /data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_1/1_TCTCGCGC-AGGCTATA_L001_R1_001.fastq.gz
    #  | fastx_trimmer -Q33 -f 6 -v -o /data/SBCS-BuggsLab/Josiah/HiSeq_data/trimmed_reads/Raw-1/Sample_1/1_TCTCGCGC-AGGCTATA_L001_R1_001_first_5bp_clipped.fastq

    starter()
