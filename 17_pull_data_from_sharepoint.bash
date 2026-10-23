#!/bin/bash
# Laura Dean
# 23/10/26

# script to pull data to Ada from sharepoint with rclone

#SBATCH --time=166:00:00
#SBATCH --job-name=rclone
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=8g
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# setup env
module load rclone-uon/1.65.2

# copy the directory with rclone
rclone --transfers 4 --checkers 4 --bwlimit 200M --onedrive-chunk-size 50M --copy-links \
--checksum copy MacCollLab1:Laura_Dean/HPC_data_backup/qtl/trimmed_fqs /gpfs01/home/mbzlld/data/stickleback/

# Check the directory has copied successfully
rclone check --one-way MacCollLab1:Laura_Dean/HPC_data_backup/qtl/trimmed_fqs /gpfs01/home/mbzlld/data/stickleback/

# unload module
module unload rclone-uon/1.65.2


