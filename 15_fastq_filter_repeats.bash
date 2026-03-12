#!/bin/bash
# Laura Dean
# 9/2/26

# script to repeat the filtering of paired fastq files to make them smaller!
# for the files that appeared corrupted after filtering

#SBATCH --job-name=fastq_filter
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=250g
#SBATCH --time=8:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=14
# --array=14,96,93
# --array=80,87,108,110,112

##  # make the array config file
CONFIG=~/code_and_scripts/config_files/dog_fq_flt_array_config.txt
cd /share/StickleAss/doggies/repeat_filtered_fastqs

source $HOME/.bash_profile
conda activate seqtk


# calculate the number of read pairs to retain
GENOME_SIZE=2500000000
COVERAGE=8
READ_LEN=150

PAIRS_NEEDED=$(echo "$GENOME_SIZE * $COVERAGE / (2 * $READ_LEN)" | bc)
#echo "keeping $PAIRS_NEEDED reads from each file"


# set the paired file names
fastq_fwd=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)
fastq_rev=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $3}' $CONFIG)


# subsample the forward and reverse reads to retain only the number of pairs we specified
seqtk sample -s100 $fastq_fwd $PAIRS_NEEDED | gzip > ${fastq_fwd%.*.*}_filtered.fastq.gz
seqtk sample -s100 $fastq_rev $PAIRS_NEEDED | gzip > ${fastq_rev%.*.*}_filtered.fastq.gz

# print info on the files it ran on to the slurm output
echo "filtered the fastq files: $fastq_fwd and $fastq_rev"



