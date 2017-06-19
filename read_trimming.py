from subprocess import call
call(["ls", "-l"])

# Grammar: (L001, L002, L003, L004, L005, L006)  x  (R1, R2, Singletons) x (350bp, 550bp, 800bp)

call(['module load fastx'])
# Step 1, trimming reads with fast_trimmer [i.e. you have to load the fastx module]
base_clipped_name = 'FRAX27_13-2B_160615_L001_'
sample_name = base_clipped_name.replace('-', '_')
trimmed_dir = '/data/SBCS-BuggsLab/LauraKelly/HiSeq_data/trimmed_reads/'
R1_trimmed = trimmed_dir + sample_name + 'R1_350bp_library_first_5bp_clipped_adapters_cut'
R2_trimmed = trimmed_dir + sample_name + 'R2_350bp_library_first_5bp_clipped_adapters_cut'
source_fastq = '/data/SBCS-BuggsLab/LauraKelly/HiSeq_data/Raw_reads_from_CGR/Raw/Fraxinus_anomala_FRAX27/350bp_library/13-2B_160615_L001_R1.fastq.gz'
call(['zcat', source_fastq,
      '|',
      'fastx_trimmer -Q33 -f 6 -v',
      '-o ' + trimmed_dir + base_clipped_name + 'R1_first_5bp_clipped.fastq'])


# Step 2, Trimming the adapters out of the reads [R1 reads]
adapters = ['GATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT',
            'AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC',
            'AGATCGGAAGAGCACACGTCT',
            'GATCGGAAGAGCACACGTCTGAACTCCAGTCAC',
            'CTGTCTCTTATACACATCTCCGAGCCCACGAGAC']
adapters_string = [' -b ' + x for x in adapters]
call(['/data/SBCS-BuggsLab/LauraKelly/tools/cutadapt-1.8.1/bin/cutadapt', '-O 5 ',
      adapters_string,
      ' -o ' + R1_trimmed + '.fastq',
      trimmed_dir + base_clipped_name + 'R1_first_5bp_clipped.fastq'])

# Step 2, Trimming the adapters out of the reads [R2 reads] [cutadapt is in Laura's directory]
adapters = ['ACACTCTTTCCCTACACGACGCTCTTCCGATC',
            'AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT',
            'GATCGTCGGACTGTAGAACTCTGAAC',
            'GTGACTGGAGTTCAGACGTGTGCTCTTCCGATC',
            'CTGTCTCTTATACACATCTGACGCTGCCGACGA']
adapters_string = [' -b ' + x for x in adapters]
call(['/data/SBCS-BuggsLab/LauraKelly/tools/cutadapt-1.8.1/bin/cutadapt', '-O 5 -b ',
      adapters_string,
      ' -o ' + R2_trimmed + '.fastq',
      trimmed_dir + base_clipped_name + 'R2_first_5bp_clipped.fastq'])

# Step 3, trimming the reads for quality score using sickle [sickle is in Laura's directory]
call(['/data/SBCS-BuggsLab/LauraKelly/other/sickle-master/sickle',
      'pe',
      '-f ' + R1_trimmed + '.fastq.gz',
      '-r ' + R2_trimmed + '.fastq.gz',
      '-t sanger',
      '-g',
      '-o ' + R1_trimmed + '_quality_trimmed_min_50bp.fastq.gz',
      '-p ' + R2_trimmed + '_quality_trimmed_min_50bp.fastq.gz',
      '-s ' + trimmed_dir + sample_name + '350bp_library_first_5bp_clipped_adapters_cut_quality_trimmed_min_50bp_singletons.fastq.gz',
      '-q 20',
      '-l 50'])

'zcat /data/SBCS-BuggsLab/LauraKelly/HiSeq_data/Raw_reads_from_CGR/Raw/Fraxinus_anomala_FRAX27/350bp_library/13-2B_160615_L001_R1.fastq.gz ' \
'| ' \
'fastx_trimmer -Q33 -f 6 -v -o /data/SBCS-BuggsLab/LauraKelly/HiSeq_data/trimmed_reads/FRAX27_13-2B_160615_L001_R1_first_5bp_clipped.fastq'


'zcat /data/SBCS-BuggsLab/Endymion/CGR-New-May2017/Raw-1/Sample_1/1_TCTCGCGC-AGGCTATA_L001_R1_001.fastq.gz | fastx_trimmer -Q33 -f 6 -v -o /data/SBCS-BuggsLab/Josiah/HiSeq_data/trimmed_reads/Raw-1/Sample_1/1_TCTCGCGC-AGGCTATA_L001_R1_001_first_5bp_clipped.fastq'