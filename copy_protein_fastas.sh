#!/usr/bin/env bash

GEMOMA=/data2/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5
PROTEOME=/data2/SBCS-BuggsLab/Josiah/DNA_Duplications/Ash_Proteome

# already done: FRAX01 FRAX02 FRAX03 FRAX04 FRAX05 FRAX06 FRAX07 FRAX08 FRAX11 FRAX12 FRAX13 FRAX14 FRAX15 FRAX16 FRAX20 FRAX21 FRAX23 FRAX25 FRAX26 FRAX27 FRAX28 FRAX29 FRAX30 FRAX31 FRAX32 FRAX34 FRAX09_large_72hr
for FRAXN in FRAX19 FRAX33
do
    cd ${GEMOMA}/${FRAXN}
    # add a newline to the end
    echo >> gffread_filtered_protein.fasta
    # remove killer . at end of transcript
    sed -i -e ':a;N;$!ba;s/\.\n/\n/g' gffread_filtered_protein.fasta
    cp ${GEMOMA}/${FRAXN}/gffread_filtered_protein.fasta  ${PROTEOME}/${FRAXN}.faa
done

#cp ${GEMOMA}/FRAX01/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX01.faa
#cp ${GEMOMA}/FRAX02/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX02.faa
#cp ${GEMOMA}/FRAX03/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX03.faa
#cp ${GEMOMA}/FRAX04/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX04.faa
#cp ${GEMOMA}/FRAX05/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX05.faa
#cp ${GEMOMA}/FRAX06/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX06.faa
#cp ${GEMOMA}/FRAX07/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX07.faa
#cp ${GEMOMA}/FRAX08/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX08.faa
#cp ${GEMOMA}/FRAX11/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX11.faa
#cp ${GEMOMA}/FRAX12/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX12.faa
#cp ${GEMOMA}/FRAX13/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX13.faa
#cp ${GEMOMA}/FRAX14/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX14.faa
#cp ${GEMOMA}/FRAX15/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX15.faa
#cp ${GEMOMA}/FRAX16/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX16.faa
#cp ${GEMOMA}/FRAX20/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX20.faa
#cp ${GEMOMA}/FRAX21/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX21.faa
#cp ${GEMOMA}/FRAX23/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX23.faa
#cp ${GEMOMA}/FRAX25/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX25.faa
#cp ${GEMOMA}/FRAX26/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX26.faa
#cp ${GEMOMA}/FRAX27/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX27.faa
#cp ${GEMOMA}/FRAX28/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX28.faa
#cp ${GEMOMA}/FRAX29/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX29.faa
#cp ${GEMOMA}/FRAX30/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX30.faa
#cp ${GEMOMA}/FRAX31/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX31.faa
#cp ${GEMOMA}/FRAX32/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX32.faa
#cp ${GEMOMA}/FRAX34/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX34.faa
#cp ${GEMOMA}/FRAX09_large_72hr/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX09.faa

#cp ${GEMOMA}/FRAX19/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX19.faa
#cp ${GEMOMA}/FRAX33/gffread_filtered_protein.fasta  ${PROTEOME}/FRAX33.faa
