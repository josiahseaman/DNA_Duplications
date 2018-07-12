#!cafe
load -i filtered_OG_counts.txt -t 8 -l reports/estimate_full.txt
#Approximated ultrametric based on 763103 sites and 5 calibration points
#A NEWICK-formatted tree containing branch lengths and taxon names as they are specified in the \ref Load "input file". Branch lengths should be integer units and the tree should be ultrametric (all paths from root to tip should have the same length). If the tree is not ultrametric to a tolerance of .01%, a warning will be logged. Please note that there should be no spaces in the tree string, nor semicolons at the end of the line.
tree (((((((((((FRAX30:2,FRAX32:2):1,FRAX28:3):2,FRAX12:5):4,(FRAX07:8,FRAX29:8):1):4,FRAX08:13):1,(((((FRAX01:2,FRAX16:2):4,FRAX15:6):2,FRAX00:8):2,(FRAX06:9,FRAX23:9):1):3,FRAX25:13):1):3,FRAX21:17):2,(((FRAX19:8,FRAX20:8):2,((FRAX11:5,FRAX27:5):4,FRAX04:9):1):1,(((((FRAX03:1,FRAX09:1):1,FRAX13:2):2,(FRAX26:2,FRAX14:2):2):3,FRAX05:7):2,FRAX33:9):2):8):15,FRAX31:34):2,Oeuropea:36):43,(Slycopersicum:37,Mguttatus:37):42);
lambdamu -s 
report reports/estimate_full
