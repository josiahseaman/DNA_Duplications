#!/bin/sh
#$ -cwd              		 # use current working directory
#$ -V                		 # this makes it verbose
#$ -m aes
#$ -M josiah.seaman@gmail.com
#$ -j y				 		 # and put all output (inc errors) into it
#$ -pe smp 1         		 # Request CPU cores
#$ -l h_rt=4:0:0	 		 # Request hours runtime (upto 240 hours)
#$ -l h_vmem=150M      		 # Request GB RAM / core, total= cores * vmem
#$ -t 1-36

module load python/3.6.3
source /data/SBCS-BuggsLab/Josiah/DNA_Duplications/script_env/bin/activate
python /data/SBCS-BuggsLab/Josiah/DNA_Duplications/read_trimming.py clip trim sickle