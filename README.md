# Fraxinus Fractionation
## Investigating polyploidy and paralog history in Ash Trees

These are the scripts used in my PhD for processing the outputs of OrthoFinder, CAFE, and r8s.  

#### Important Scripts
* Homeologs_Analysis.ipynb 
    - Identifying Homeologs via OrthoFinder gene tree parsed copy number analysis
* KsPlots.ipynb 
    - Verify homeolog identification with Ks values using DNA aligned gene families
* TreeCountAnalysis_Oleaceae_Homeologs.ipynb
     - Fractionation: Do some gene families lose a disproportionate number of gene copies?
* TreeCountAnalysis_Simulated_Homeologs.ipynb 
     - copy of above for null model data

#### Important Data Files

*Note: Out of date data files are still included in this repository as this is a backup of everything. The final results are in the CAFE-4.2/data/2020 directory.*
* /onerate/ the results reported in chapter 4.
* /simulate_onerate/ the null model results reported in chapter 4.
* 2020_Feb08_homeolog_filtered_counts.txt
    - the canonical input for analysis of gene family sizes, filtered for extreme outliers
* 2020_Feb08_homeolog_gene_set.csv
    - has the complete list of gene names for each gene family. The first digit of gene families are either a 1 or 2 representing the 2 homeolog subtrees from an N2 duplication (see 4.2.1). Much information can be extracted from this file including species names or counts for every subtree.
* Species_tree_corrected_root_ultrametric_integers.tre
    - The canonical species tree with FRAX species names used to interpret the CAFE outputs. This was used as input to Orthofinder's RAXML and in KsPlots.ipynb. It's also helpful to keep things in context. It's rooted at Solanum.
* Oleaceae_two_WGD.tre
    - An alternative species tree used to simulate CAFE with the older Oleaceae WGD. Results are contained in CAFE-4.2/data/2020/static_empty/ folder. This approach was ultimately rejected as likely artefactual.



## Setup on the QMUL cluster

```
git clone https://github.com/josiahseaman/DNA_Duplications.git
cd DNA_Duplications
virtualenv script_env --include-lib
source script_env/bin/activate
pip install -r Requirements.txt
```

