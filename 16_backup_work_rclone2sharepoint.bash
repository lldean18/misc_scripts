#!/bin/bash
# 4/6/26

# script to backup finished with data directories from Ada to sharepoint with rclone

#SBATCH --time=166:00:00
#SBATCH --job-name=rclone
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=8g
#SBATCH --output=slurm-%x-%j.out

# setup env
module load rclone-uon/1.65.2

# copy the directory with rclone
rclone --transfers 4 --checkers 4 --bwlimit 200M --onedrive-chunk-size 50M --copy-links \
--checksum copy /gpfs01/home/mbzlld/data/hagfish Laura2:HPC_data_dirs_backup/hagfish

# Check the directory has copied successfully
rclone check --one-way /gpfs01/home/mbzlld/data/hagfish Laura2:HPC_data_dirs_backup/hagfish

# unload module
module unload rclone-uon/1.65.2



# SUCCESSFUL LONGTERM DATA BACKUPS:

### LAURA ###

# /gpfs01/home/mbzlld/data/heap_data Laura:HPC_data_dirs_backup/heap_data
# ~/data/heap_data about 3GB
# COMPLETED

# /gpfs01/home/mbzlld/data/bryant Laura:HPC_data_dirs_backup/bryant
# ~/data/bryant = 58GB
# COMPLETED

### LAURA2 ###

# /gpfs01/home/mbzlld/data/splice_variant_search Laura2:HPC_data_dirs_backup/splice_variant_search
# ~/data/splice_variant_search 2.5TB
# COMPLTETED

# /gpfs01/home/mbzlld/data/hagfish Laura2:HPC_data_dirs_backup/hagfish
# ~/data/hagfish 2.1TB
# RUNNING

# ~/Hoverflies 2.6TB


