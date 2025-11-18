#!/bin/bash

# setup for interactive job
conda activate tmux
tmux attach
srun --partition defq --cpus-per-task 1 --mem 50g --time 25:00:00 --pty bash

# generate forward file md5 checksums
md5sum *R1* > fwd.chk

# generate reverse file md5 checksums
md5sum *R2* > rev.chk




