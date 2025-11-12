#!/bin/bash
# Laura Dean
# 12/11/25
# for running on the UoN HPC Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=40g
#SBATCH --time=48:00:00
#SBATCH --job-name=fishy_fq_transfer
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# rclone remotes I have configured:
# Laura
# MacCollLab1
# MacCollLab2
# OrgOne
# OrgOne2

# load Rclone
source $HOME/.bash_profile
conda activate rclone

# Copy all of the files from your folder on Augusta to a folder on sharepoint
rclone --transfers 1 --checkers 1 --bwlimit 100M --checksum copy MacCollLab1:Laura_Dean/HPC_data_backup/Tubingen_data/Named_trimmed_reads  ~/data/stickleback/fastqs

# and check that the two folders are identical
rclone check --one-way MacCollLab1:Laura_Dean/HPC_data_backup/Tubingen_data/Named_trimmed_reads  ~/data/stickleback/fastqs

# unload rclone
conda deactivate


