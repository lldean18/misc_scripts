#!/bin/bash
# Laura Dean
# 4/2/26


###  # testing on a single individual
###  # this used 85GB of memory!!
###  conda activate tmux
###  tmux attach -t dogs
###  srun --partition defq --cpus-per-task 40 --mem 100g --time 4:00:00 --pty bash

##  # make the array config file
CONFIG=~/code_and_scripts/config_files/dog_fq_flt_array_config.txt
cd /share/BioinfMSc/Hannah_resources/doggies/fastqs
##  \ls > $CONFIG
##  # remove file endings to leave run IDs
##  sed -i 's/_.*//' $CONFIG
##  # remove duplicate IDs
##  sort $CONFIG | uniq > ~/tmp && mv ~/tmp $CONFIG
##  # duplicate the run ID into a second column on the same line
##  awk '$2=$1' $CONFIG > ~/tmp && mv ~/tmp $CONFIG
##  # add file endings to the two file beginnings
##  awk '$1=$1 "_1.fastq.gz"' $CONFIG > ~/tmp && mv ~/tmp $CONFIG
##  awk '$2=$2 "_2.fastq.gz"' $CONFIG > ~/tmp && mv ~/tmp $CONFIG
##  # add array numbers to the beginning of the file
##  awk '{print NR,$0}' $CONFIG > ~/tmp && mv ~/tmp $CONFIG


source $HOME/.bash_profile
conda activate seqtk


# calculate the number of read pairs to retain
GENOME_SIZE=2500000000
COVERAGE=8
READ_LEN=150

PAIRS_NEEDED=$(echo "$GENOME_SIZE * $COVERAGE / (2 * $READ_LEN)" | bc)
#echo "keeping $PAIRS_NEEDED reads from each file"


# set the paired file names
#fastq_fwd=/share/BioinfMSc/Hannah_resources/doggies/fastqs/SRR7120208_1.fastq.gz
#fastq_rev=/share/BioinfMSc/Hannah_resources/doggies/fastqs/SRR7120208_2.fastq.gz
fastq_fwd=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)
fastq_rev=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $3}' $CONFIG)


# subsample the forward and reverse reads to retain only the number of pairs we specified
seqtk sample -s100 $fastq_fwd $PAIRS_NEEDED | gzip > /gpfs01/home/mbzlld/data/dogs/filtered_fastqs/${fastq_fwd##*/}
seqtk sample -s100 $fastq_rev $PAIRS_NEEDED | gzip > /gpfs01/home/mbzlld/data/dogs/filtered_fastqs/${fastq_rev##*/}


