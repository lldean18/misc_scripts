#!/bin/bash
# Laura Dean
# 20/11/25

# information and commands used to backup the 24/25 students shared directory on Ada before it is wiped
# ready for this year's students.
# These commands were run from /Volumes/Expansion/BioinfMSc_24_25_backup on my laptop
# Via wired ethernet connection in my office


# I was initially trying transfering each subdirectory in the BioinfMSc shared dir with checksums to verify file integrity (-c flag)
# this was fine for smaller directories but suuuuuper slow for larger ones.

# checksum completed copies:
# 412M	ada:/share/BioinfMSc/rotation3
# 1.0M	ada:/share/BioinfMSc/ro3_group2
# 1.3M	ada:/share/BioinfMSc/Tbrucei
# 1.3M	ada:/share/BioinfMSc/hap1_vs_hap2
# 512K	ada:/share/BioinfMSc/output_dir
# 297M	ada:/share/BioinfMSc/Unicycler
# 111G	ada:/share/BioinfMSc/Matt_resources
# 313G	ada:/share/BioinfMSc/ml_projects

# all completed with e.g.
rsync -rvhc --progress ada:/share/BioinfMSc/ml_projects ./

# for the largest two directories I had to switch to the -a flag instead (which is shorthand for):
# -r  (recursive)
# -l  (copy symlinks as symlinks)
# -p  (preserve permissions)
# -t  (preserve modification times)
# -g  (preserve group)
# -o  (preserve owner *only if* running as root)
# -D  (preserve device files and special files)

# so using:
rsync -rvha --progress ada:/share/BioinfMSc/Bill_resources ./
rsync -rvha --progress ada:/share/BioinfMSc/2425 ./

# leaving these running. Hopefully this will be quicker

