#!/bin/bash
# Laura Dean
# 19/11/25

# Code to generate md5 checksum files for forward and reverse reads separately
# with a view to submitting the files to ENA

# setup for interactive job
conda activate tmux
tmux attach
srun --partition defq --cpus-per-task 1 --mem 50g --time 25:00:00 --pty bash

# move to the directory containing files you want to generate checksums for
cd /gpfs01/home/mbzlld/data/stickleback/cist_fqs

# generate forward file md5 checksums and save to file fwd.chk
md5sum *R1* > fwd.chk

# generate reverse file md5 checksums and save to file rev.chk
md5sum *R2* > rev.chk

# checksums can then be pasted into ENA read info spreadsheet for submission


