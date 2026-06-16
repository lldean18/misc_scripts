#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem=40g
#SBATCH --time=168:00:00
#SBATCH --job-name=rclone_student_data
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# load the software
module load rclone-uon/1.65.2

# copy a directory called cats from the HPC to MySite
rclone --transfers 4 --checkers 4 --bwlimit 100M --checksum --copy-links copy /share/BioinfMSc/Hannah_resources OrgOne:BioinfMSc2526/Hannah_resources
#rclone --transfers 4 --checkers 4 --bwlimit 100M --checksum copy /share/BioinfMSc/life4136_2526 OrgOne:BioinfMSc2526/life4136_2526

# Check the directory has copied successfully
rclone check --one-way /share/BioinfMSc/Hannah_resources OrgOne:BioinfMSc2526/Hannah_resources
#rclone check --one-way /share/BioinfMSc/life4136_2526 OrgOne:BioinfMSc2526/life4136_2526

# unload the software
module unload rclone-uon/1.65.2


# directories successfully backed up to OrgOne:BioinfMSc2526 as of June 2026
# Bill_resources
# Matt_resources 149 GB
# life4141 146 GB
# Hannah_resources 1.4TB


# still waiting to do
# then finally their huge working dir life4136_2526 which is likely too big

