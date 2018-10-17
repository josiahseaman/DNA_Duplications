#!/data/SBCS-BuggsLab/Josiah/tools/cafe
tree ((((((((((FRAX30:2.0,FRAX32:2.0):1.0,FRAX28:3.0):2.0,FRAX12:5.0):4.0,(FRAX07:8.0,FRAX29:8.0):1.0):4.0,FRAX08:13.0):1.0,(((((FRAX01:2.0,FRAX16:2.0):4.0,FRAX15:6.0):2.0,FRAX00:8.0):2.0,(FRAX06:9.0,FRAX23:9.0):1.0):3.0,FRAX25:13.0):1.0):3.0,FRAX21:17.0):2.0,(((FRAX19:8.0,FRAX20:8.0):2.0,((FRAX11:5.0,FRAX27:5.0):4.0,FRAX04:9.0):1.0):1.0,(((((FRAX03:1.0,FRAX09:1.0):1.0,FRAX13:2.0):2.0,(FRAX26:2.0,FRAX14:2.0):2.0):3.0,FRAX05:7.0):2.0,FRAX33:9.0):2.0):8.0):15.0,FRAX31:34.0):2.0,Oeuropea:36.0):36.0;
load -i homeolog_counts.txt -t 10 -l reports/error_sim/cafe_final_log.txt
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX29
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX16
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX31
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX32
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX15
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX12
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX13
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX11
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX19
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX23
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX05
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX04
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX07
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX06
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX01
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX00
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX03
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX28
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX27
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX26
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX25
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX09
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX08
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX21
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX20
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX30
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX14
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp FRAX33
errormodel -model reports/error_sim/cafe_errormodel_0.1.txt -sp Oeuropea;
lambdamu -s
report reports/error_sim/cafe_final_report