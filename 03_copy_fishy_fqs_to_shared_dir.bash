#!/bin/bash
# Laura Dean
# 12/11/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=cp_fqs_to_share
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=30g
#SBATCH --time=12:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# copy the fastqs to the shared dir
cp /gpfs01/home/mbzlld/data/stickleback/fastqs/* /share/BioinfMSc/fastqs/

