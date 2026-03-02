

cd /share/BioinfMSc/temp/doggies

# print the names of the empty files
find fastqs -type f -size 0 -printf "%f\n" > empty_files.txt

# delete the empty files
find fastqs -type f -size 0 -delete

# delete the files with no pair information (the first line tests the list of what will be deleted)
find fastqs -type f ! \( -name "*_1*" -o -name "*_2*" \)
find fastqs -type f ! \( -name "*_1*" -o -name "*_2*" \) -delete


################################
# NOW FILTER TO 15X PER SAMPLE #
################################

# list sample - run info
cut -f8,1 metadata.tsv | tail -n +2 | sort | uniq | \
awk '{runs[$2]=runs[$2]" "$1} END {for (s in runs) print s, runs[s]}' > sample_to_runs.txt







