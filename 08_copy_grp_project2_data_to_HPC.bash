#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem=40g
#SBATCH --time=80:00:00
#SBATCH --job-name=rclone
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# load the software
module load rclone-uon/1.65.2

# copy a directory called cats from the HPC to MySite
rclone --transfers 4 --checkers 4 --bwlimit 100M --checksum copy OrgOne:BioinfMSc2425/Bill_resources /share/BioinfMSc/Bill_resources

# Check the directory has copied successfully
rclone check --one-way OrgOne:BioinfMSc2425/Bill_resources /share/BioinfMSc/Bill_resources

# unload the software
module unload rclone-uon/1.65.2
