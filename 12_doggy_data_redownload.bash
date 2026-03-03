#!/bin/bash
# Laura Dean
# 2/3/26

cd /gpfs01/home/mbzlld/data/dogs

# copy run info & make it tab separated for clarity
cp /share/BioinfMSc/Hannah_resources/doggies/NCBI_run_info.csv ./
sed -i 's/,/\t/g' NCBI_run_info.csv

# select only the runs with PAIRED ILLUMINA data
awk -F'\t' 'NR==1 || ($16=="PAIRED" && $19=="ILLUMINA")' NCBI_run_info.csv > run_info_flt.tsv

# filter to keep only reads with an average size of 190 - 310
awk -F'\t' 'NR==1 || ($7>=190 && $7<=310)' run_info_flt.tsv > run_info_flt2.tsv

# filter to keep only SRR runs
awk -F'\t' 'NR==1 || ($1~/SRR/)' run_info_flt2.tsv > run_info_flt3.tsv

# filter to keep only one run per sample
(head -n 1 run_info_flt3.tsv && tail -n +2 run_info_flt3.tsv | sort -t $'\t' -k26,26 -k5,5nr | awk -F'\t' '!seen[$26]++') > run_info_flt4.tsv

# filter the run into to only keep the inds we want
# retain only the individuals to keep based on my R investigation of the metadata
awk -F'\t' '
FNR==NR {keep[$1]; next}      # first file: store accessions
FNR==1 {print; next}           # second file: print first line (header)
$26 in keep                     # keep only lines where 8th column is in the list
' /share/BioinfMSc/Hannah_resources/doggies/accessions_to_keep.txt run_info_flt4.tsv > run_info_flt5.tsv

# write a file of the final runs to keep
cut -f1 run_info_flt5.tsv > runs_tokeep.txt
sed -i '1d' runs_tokeep.txt



##################################################



# take the run info we want to use from shared dir
cp /share/BioinfMSc/Hannah_resources/doggies/run_info.tsv ./
# filter it to contain only the runs we're keeping
awk -F'\t' '
FNR==NR {keep[$1]; next}      # first file: store run ids
FNR==1 {print; next}           # second file: print first line (header)
$1 in keep                     # keep only lines where 1st column is in the list
' runs_tokeep.txt run_info.tsv > final_read_info_all.tsv



##################################################



# take the column with the ftp paths into a new file
cut -f13 -d$'\t' final_read_info_all.tsv > new_ftp_paths.txt
# remove the header
sed -i '1d' new_ftp_paths.txt
# split entries onto single lines
sed -i 's/;/\n/g' new_ftp_paths.txt
# then manually removed all the paths to files with no pair


#########################################
###### Download the fastq files #########
#########################################

srun --partition defq --cpus-per-task 2 --mem 30g --time 100:00:00 --pty bash
source $HOME/.bash_profile
cd /gpfs01/home/mbzlld/data/dogs 
mkdir fastqs
cd fastqs

wget --input-file=../new_ftp_paths.txt


########################################################
###### Make the metadata file for the students #########
########################################################


cut -f1-12 -d$'\t' final_read_info_all.tsv > metadata_reads.tsv

# from my laptop pull the metadata
scp ada:/share/BioinfMSc/temp/doggies/metadata_reads.tsv ./


#############
# move half the download to the shared dir to make space in my home for the rest
#############

# get the first 138 file names from the file passed to wget
cd /gpfs01/home/mbzlld/data/dogs
head -n 138 new_ftp_paths.txt > files_to_move.txt
sed -i 's|.*/||' files_to_move.txt

# move the files in the list to the shared dir
cd fastqs
while IFS= read -r f; do
  mv -- "$f" /share/BioinfMSc/Hannah_resources/doggies/fastqs/
done < ../files_to_move.txt







