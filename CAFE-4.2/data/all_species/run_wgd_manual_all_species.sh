cafe wgd_manual_all_species.cafe

#summarize results with python2.7
#IMPORTANT: you need to input the name of the current result file
REPORT_SCRIPT=/data/SBCS-BuggsLab/Josiah/DNA_Duplications/CAFE-4.1/data/cafe_tutorial/python_scripts/cafetutorial_report_analysis.py
python $REPORT_SCRIPT -i reports/WGD_manual_all_species.cafe -o reports/WGD_manual_all_species
