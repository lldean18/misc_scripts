#!/bin/bash
# 4/6/26

# script to backup finished with data directories from Ada to sharepoint with rclone

#SBATCH --time=24:00:00
#SBATCH --job-name=rclone
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=16g


# setup env
module load rclone-uon/1.65.2

# copy the directory with rclone
rclone --transfers 4 --checkers 4 --bwlimit 100M --onedrive-chunk-size 5M \
--checksum copy /gpfs01/home/mbzlld/data/heap_data Laura:HPC_data_dirs_backup/heap_data

# Check the directory has copied successfully
rclone check --one-way /gpfs01/home/mbzlld/data/heap_data Laura:HPC_data_dirs_backup/heap_data

# unload module
module unload rclone-uon/1.65.2
