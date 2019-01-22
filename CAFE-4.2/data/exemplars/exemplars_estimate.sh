#!cafe
load -i exemplar_filtered_OG_counts.txt -t 8 -l reports/exemplar_estimate1.txt
#Approximated ultrametric based on 763103 sites and 5 calibration points
#A NEWICK-formatted tree containing branch lengths and taxon names as they are specified in the \ref Load "input file". Branch lengths should be integer units and the tree should be ultrametric (all paths from root to tip should have the same length). If the tree is not ultrametric to a tolerance of .01%, a warning will be logged. Please note that there should be no spaces in the tree string, nor semicolons at the end of the line.
tree ((((FRAX07:14.0,(FRAX00:10.0,FRAX06:10.0):4.0):5.0,((FRAX19:10.0,FRAX11:10.0):1.0,FRAX09:11.0):8.0):17.0,Oeuropea:36.0):43.0,(Slycopersicum:37.0,Mguttatus:37.0):42.0);
lambdamu -s -t ((((1,(1,1)1)1,((1,1)1,1)1)1,3)2,(4,4)4);
report reports/exemplar_estimate1
