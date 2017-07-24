cd /data/scratch/eex057/FRAX01/
/data/home/eex057/SSPACE-STANDARD-3.0_linux-x86_64/SSPACE_Standard_v3.0.pl \
	-s /data/SBCS-BuggsLab/LauraKelly/assembly/FRAX01_all_paired_reads_min_50bp_de_novo_assembly_max_bubble_size_5000_min_contig_length_200_contig_list.fa \
	-l /data/scratch/eex057/FRAX01/sspacelibraryfile01 \
        -b RUN1 \
	-T 24 2>&1 >log01.txt

