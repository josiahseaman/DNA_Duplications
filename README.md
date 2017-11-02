# DNA_Duplications
## Investigating polyploidy and paralog history

Currently a disorganized collection of scripts I'm using to work on data for my thesis.  

1. Genome Assembly
2. Genome Alignment
3. Mapping all Orthologs
4. Inferring All Gene Trees
    - Comparing with Phylogenetic tree for Genus
    - Possibility of interbreeding
5. Inferring Ancestral Gene Counts
    - Mapping duplication events to particular WGD events
6. Hypothesis: Gene retention rates vary by type
    - Types inferred by Augustus Annotation and comparing with other annotations
7. Repeat Retention by Type
8. Hypothesis: Gene retention varies because of dosage sensitivity
    - … because of Stoichiometric sensitivity
    - … measured by Protein Interactome (not available)
9. Parsimony of WGD versus local duplication


## Setup on the QMUL cluster

```
git clone 
cd DNA_Duplications
virtualenv script_env --include-lib
source script_env/bin/activate
pip install -r Requirements.txt
```
Refer to run_scripts/ for examples on how to load modules.
