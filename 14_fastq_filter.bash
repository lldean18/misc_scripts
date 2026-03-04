#!/bin/bash
# Laura Dean
# 4/2/26


conda activate tmux
tmux attach -t dogs
srun --partition defq --cpus-per-task 40 --mem 100g --time 4:00:00 --pty bash

source $HOME/.bash_profile
conda activate seqtk

# calculate the number of read pairs to retain
GENOME_SIZE=2500000000
COVERAGE=15
READ_LEN=150

PAIRS_NEEDED=$(echo "$GENOME_SIZE * $COVERAGE / (2 * $READ_LEN)" | bc)
echo "keeping $PAIRS_NEEDED reads from each file"


# set the paired file names
fastq_fwd=/share/BioinfMSc/Hannah_resources/doggies/fastqs/SRR7120208_1.fastq.gz
fastq_rev=/share/BioinfMSc/Hannah_resources/doggies/fastqs/SRR7120208_2.fastq.gz


# subsample the forward and reverse reads to retain only the number of pairs we specified
seqtk sample -s100 $fastq_fwd $PAIRS_NEEDED | gzip > /gpfs01/home/mbzlld/data/dogs/filtered_fastqs/${fastq_fwd##*/}
seqtk sample -s100 $fastq_rev $PAIRS_NEEDED | gzip > /gpfs01/home/mbzlld/data/dogs/filtered_fastqs/${fastq_rev##*/}

seqtk sample -s100 $fastq_fwd $PAIRS_NEEDED > /gpfs01/home/mbzlld/data/dogs/filtered_fastqs/${fastq_fwd##*/}

