#!/bin/bash

# script to rename my idiotly named fastq files to something
# more sensible and interpretable for the students



# Key file with ids
mapfile=/gpfs01/home/mbzlld/data/stickleback/SequencingTubingenKey.txt

# Read the mapping file into an associative array
declare -A name_map
while read -r id name; do
    name_map[$id]=$name
done < $mapfile



# move to the directory containing fastq files
cd /gpfs01/home/mbzlld/data/stickleback/fastqs



# Loop through all matching fastq files
for f in Fish_T_*_val_*.fq.gz; do
    # Extract ID number (the number after Fish_T_)
    id=$(echo $f | sed -E 's/.*Fish_T_([0-9]+)_.*/\1/')

    # Extract whether it's forward or reverse (1_val_1 = R1, 2_val_2 = R2)
    direction=$(echo $f | grep -oE '1_val_1|2_val_2')
    if [[ $direction == "1_val_1" ]]; then
        readdir="R1"
    else
        readdir="R2"
    fi

    # Look up the corresponding name from the mapping file
    newname="${name_map[$id]}_${readdir}.fq.gz"

    # Only rename if mapping found
    if [[ -n $newname ]]; then
        echo "Renaming: $f to $newname"
        mv $f $newname
    else
        echo "Warning: No mapping found for ID $id (file: $f)"
    fi
done



