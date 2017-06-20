#!/usr/bin/env python

from __future__ import print_function
import subprocess
import os

insert_size = '800bp_library_'
output_dir = '/data/scratch/btx142/HiSeq_data/trimmed_reads/'


def call(args):
    command = ' '.join(args) if isinstance(args, list) else args
    print(command)
    subprocess.call(command, shell=True)


def just_the_name(path):
    """Remove extension and path"""
    first_extension = os.path.splitext(os.path.basename(path))[0]
    return os.path.splitext(first_extension)[0]


def trim_adapters(source_fastq_path, base_clipped_name):
    fastq_input_file_label = just_the_name(source_fastq_path)

    # Choose adapters based on if it is R1 or R2 (different adapters used)
    assert 'R1' in fastq_input_file_label or 'R2' in fastq_input_file_label, "File name should mention R1 or R2: " + fastq_input_file_label
    side = 'R1' if 'R1' in fastq_input_file_label else 'R2'
    # Step 2, Trimming the adapters out of the reads [R1 reads]
    adapters = {
        'R1': [
            ' -b AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC',
            ' -b GATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT',
            ' -b GATCGGAAGAGCACACGTCTGAACTCCAGTCAC',
            ' -b AGATCGGAAGAGCACACGTCT',
            ' -b CTGTCTCTTATACACATCTCCGAGCCCACGAGAC',
            ' -b CGTAATAACTTCGTATAGCATACATTATACGAAGTTATACGA',
            ' -b TCGTATAACTTCGTATAATGTATGCTATACGAAGTTATTACG', ],
        'R2': [
            ' -b AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT',
            ' -b ACACTCTTTCCCTACACGACGCTCTTCCGATC',
            ' -b GTGACTGGAGTTCAGACGTGTGCTCTTCCGATC',
            ' -b GATCGTCGGACTGTAGAACTCTGAAC',
            ' -b CTGTCTCTTATACACATCTGACGCTGCCGACGA',
            ' -b CGTAATAACTTCGTATAGCATACATTATACGAAGTTATACGA',
            ' -b TCGTATAACTTCGTATAATGTATGCTATACGAAGTTATTACG', ]
    }
    trimmed_file = os.path.join(output_dir, base_clipped_name) + '_' + insert_size + 'first_5bp_clipped_adapters_cut'
    call(['/data/SBCS-BuggsLab/LauraKelly/tools/cutadapt-1.8.1/bin/cutadapt', '-O 5 ',
          ' '.join(adapters[side]),
          ' -o ' + trimmed_file + '.fastq',
          source_fastq_path])
    return trimmed_file


def clip_5bp(source_fastq_path, base_clipped_name):
    try:
        call(['module load fastx'])
    except OSError:
        pass  # loaded in starter script
    # Step 1, trimming reads with fast_trimmer [i.e. you have to load the fastx module]
    output_path = os.path.join(output_dir, base_clipped_name) + '_first_5bp_clipped.fastq'
    call(['zcat', source_fastq_path,
          '|',
          'fastx_trimmer -Q33 -f 6 -v',
          '-o ' + output_path
          ])
    return output_path


def process_one_mate_pair_file(source_fastq_path, output_name):
    # frax_name + '_' + just_the_name(source_fastq_path)  # add FRAX number
    call(['mkdir', '-p', os.path.join(output_dir, output_name)])
    R1_output = output_name
    R2_output = output_name.replace('R1', 'R2')

    clipped_file_R1 = clip_5bp(source_fastq_path, R1_output)
    clipped_file_R2 = clip_5bp(source_fastq_path.replace('R1', 'R2'), R2_output)

    print("Output", clipped_file_R1)
    print("Output", clipped_file_R2)
    #
    # R1_trimmed = trim_adapters(clipped_file_R1, R1_output)
    # R2_trimmed = trim_adapters(clipped_file_R2, R2_output)
    #
    # # Step 3, trimming the reads for quality score using sickle [sickle is in Laura's directory]
    # call(['/data/SBCS-BuggsLab/LauraKelly/other/sickle-master/sickle',
    #       'pe',
    #       '-f ' + R1_trimmed + '.fastq.gz',
    #       '-r ' + R2_trimmed + '.fastq.gz',
    #       '-t sanger',
    #       '-g',
    #       '-o ' + R1_trimmed + '_quality_trimmed_min_50bp.fastq.gz',
    #       '-p ' + R2_trimmed + '_quality_trimmed_min_50bp.fastq.gz',
    #       '-s ' + R1_trimmed.replace('R1', '') + '_quality_trimmed_min_50bp_singletons.fastq.gz',
    #       '-q 20',
    #       '-l 50'])


def starter():
    call(['mkdir', '-p', os.path.join('/data/scratch/btx142/HiSeq_data/trimmed_reads/', 'test_result')])
    # source_directory = os.path.dirname(source_fastq_path)
    # sample_mapping = {
    #     'Sample_1':  'FRAX01',
    #     'Sample_2':  'FRAX02',
    #     'Sample_3':  'FRAX03',
    #     'Sample_4':  'FRAX04',
    #     'Sample_5':  'FRAX05',
    #     'Sample_6':  'FRAX06',
    #     'Sample_7':  'FRAX07',
    #     'Sample_8':  'FRAX08',
    #     'Sample_9':  'FRAX09',
    #     'Sample_10': 'FRAX11',
    #     'Sample_11': 'FRAX12',
    #     'Sample_12': 'FRAX13'}
    # sample_name = os.path.basename(source_directory)
    # frax_name = sample_mapping[sample_name]  # 'FRAX27_'
    work_array = [
        (None, None),  # one indexed:  use #$ -t 1-35
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw/Sample_1/1_TCTCGCGC-AGGCTATA_L001_R1_001.fastq.gz', 'FRAX01_L003_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw/Sample_2/2_TCTCGCGC-GCCTCTAT_L001_R1_001.fastq.gz', 'FRAX02_L003_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw/Sample_3/3_TCTCGCGC-AGGATAGG_L001_R1_001.fastq.gz', 'FRAX03_L003_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw/Sample_4/4_TCTCGCGC-TCAGAGCC_L001_R1_001.fastq.gz', 'FRAX04_L003_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw/Sample_5/5_TCTCGCGC-CTTCGCCT_L001_R1_001.fastq.gz', 'FRAX05_L003_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw/Sample_6/6_TCTCGCGC-TAAGATTA_L001_R1_001.fastq.gz', 'FRAX06_L003_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw/Sample_7/7_TCTCGCGC-ACGTCCTG_L001_R1_001.fastq.gz', 'FRAX07_L003_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw/Sample_8/8_TCTCGCGC-GTCAGTAC_L001_R1_001.fastq.gz', 'FRAX08_L003_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw/Sample_9/9_AGCGATAG-AGGCTATA_L001_R1_001.fastq.gz', 'FRAX09_L003_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw/Sample_10/10_AGCGATAG-GCCTCTAT_L001_R1_001.fastq.gz', 'FRAX11_L003_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw/Sample_11/11_AGCGATAG-AGGATAGG_L001_R1_001.fastq.gz', 'FRAX12_L003_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw/Sample_12/12_AGCGATAG-TCAGAGCC_L001_R1_001.fastq.gz', 'FRAX13_L003_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_1/1_TCTCGCGC-AGGCTATA_L001_R1_001.fastq.gz', 'FRAX01_L001_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_1/1_TCTCGCGC-AGGCTATA_L002_R1_001.fastq.gz', 'FRAX01_L002_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_2/2_TCTCGCGC-GCCTCTAT_L001_R1_001.fastq.gz', 'FRAX02_L001_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_2/2_TCTCGCGC-GCCTCTAT_L002_R1_001.fastq.gz', 'FRAX02_L002_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_3/3_TCTCGCGC-AGGATAGG_L001_R1_001.fastq.gz', 'FRAX03_L001_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_3/3_TCTCGCGC-AGGATAGG_L002_R1_001.fastq.gz', 'FRAX03_L002_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_4/4_TCTCGCGC-TCAGAGCC_L001_R1_001.fastq.gz', 'FRAX04_L001_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_4/4_TCTCGCGC-TCAGAGCC_L002_R1_001.fastq.gz', 'FRAX04_L002_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_5/5_TCTCGCGC-CTTCGCCT_L001_R1_001.fastq.gz', 'FRAX05_L001_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_5/5_TCTCGCGC-CTTCGCCT_L002_R1_001.fastq.gz', 'FRAX05_L002_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_6/6_TCTCGCGC-TAAGATTA_L001_R1_001.fastq.gz', 'FRAX06_L001_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_6/6_TCTCGCGC-TAAGATTA_L002_R1_001.fastq.gz', 'FRAX06_L002_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_7/7_TCTCGCGC-ACGTCCTG_L001_R1_001.fastq.gz', 'FRAX07_L001_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_7/7_TCTCGCGC-ACGTCCTG_L002_R1_001.fastq.gz', 'FRAX07_L002_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_8/8_TCTCGCGC-GTCAGTAC_L001_R1_001.fastq.gz', 'FRAX08_L001_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_8/8_TCTCGCGC-GTCAGTAC_L002_R1_001.fastq.gz', 'FRAX08_L002_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_9/9_AGCGATAG-AGGCTATA_L001_R1_001.fastq.gz', 'FRAX09_L001_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_9/9_AGCGATAG-AGGCTATA_L002_R1_001.fastq.gz', 'FRAX09_L002_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_10/10_AGCGATAG-GCCTCTAT_L001_R1_001.fastq.gz', 'FRAX11_L001_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_10/10_AGCGATAG-GCCTCTAT_L002_R1_001.fastq.gz', 'FRAX11_L002_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_11/11_AGCGATAG-AGGATAGG_L001_R1_001.fastq.gz', 'FRAX12_L001_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_11/11_AGCGATAG-AGGATAGG_L002_R1_001.fastq.gz', 'FRAX12_L002_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_12/12_AGCGATAG-TCAGAGCC_L001_R1_001.fastq.gz', 'FRAX13_L001_R1'),
        ('/data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_12/12_AGCGATAG-TCAGAGCC_L002_R1_001.fastq.gz', 'FRAX13_L002_R1'),
    ]
    index = int(os.environ.get('SGE_TASK_ID'))
    source_fastq_path, output_name = work_array[index]
    print("Starting Job:", index, source_fastq_path, output_name)
    process_one_mate_pair_file(source_fastq_path, output_name)


if __name__ == '__main__':
    # Original Step 1:
    # zcat /data/SBCS-BuggsLab/LauraKelly/HiSeq_data/Raw_reads_from_CGR/Raw/Fraxinus_anomala_FRAX27/350bp_library/13-2B_160615_L001_R1.fastq.gz
    #  | fastx_trimmer -Q33 -f 6 -v -o /data/SBCS-BuggsLab/LauraKelly/HiSeq_data/trimmed_reads/FRAX27_13-2B_160615_L001_R1_first_5bp_clipped.fastq

    # My modified Step 1:
    # zcat /data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_1/1_TCTCGCGC-AGGCTATA_L001_R1_001.fastq.gz
    #  | fastx_trimmer -Q33 -f 6 -v -o /data/SBCS-BuggsLab/Josiah/HiSeq_data/trimmed_reads/Raw-1/Sample_1/1_TCTCGCGC-AGGCTATA_L001_R1_001_first_5bp_clipped.fastq

    starter()
