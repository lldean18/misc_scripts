#!/bin/bash

# activate tmux conda environment
conda activate tmux

# create a new tmux window
tmux new -s EnaUpload

# request an interactive session
srun --partition defq --cpus-per-task 1 --mem 50g --time 48:00:00 --pty bash

# move to the location of the files to be uploaded
cd /gpfs01/home/mbzlld/data/stickleback

# upload the files with curl
curl --upload-file QTL22188_R1.fastq.gz --user username:password ftp://webin2.ebi.ac.uk

# did for all files but showing one as an example because need to hide username and password

