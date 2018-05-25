#!/usr/bin/env bash
GEM_HOME="/data2/SBCS-BuggsLab/Josiah/DNA_Duplications/GeMoMa-1.5/"
cd ${GEM_HOME}$1
sed 's/prediction/mRNA/g' filtered_predictions.gff > filtered_predictions_EDITED.gff
gffread filtered_predictions_EDITED.gff -g $2 -y gffread_filtered_protein.fasta

