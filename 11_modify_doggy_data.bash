

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



# merge runs for each sample

sample_file=/share/BioinfMSc/Hannah_resources/doggies/sample_runs.txt
fastq_dir=/share/BioinfMSc/Hannah_resources/doggies/fastqs
merged_dir=/gpfs01/home/mbzlld/data/doggies/merged
mkdir -p "$merged_dir"

# Read each line of the file
while read -r line; do
    # Get sample ID (first column)
    sample=$(echo "$line" | awk '{print $1}')
    # Get all run IDs (columns 2 onward)
    runs=$(echo "$line" | cut -d' ' -f2-)
    # Prepare file paths for _1 and _2
    files1=()
    files2=()
    
    for run in $runs; do
        files1+=("$fastq_dir/${run}_1.fastq.gz")
        files2+=("$fastq_dir/${run}_2.fastq.gz")
    done
    
    # Merge or copy _1 files
    if [ "${#files1[@]}" -eq 1 ]; then
        cp "${files1[0]}" "$merged_dir/${sample}_1.fastq.gz"
        cp "${files2[0]}" "$merged_dir/${sample}_2.fastq.gz"
    else
        cat "${files1[@]}" > "$merged_dir/${sample}_1.fastq.gz"
        cat "${files2[@]}" > "$merged_dir/${sample}_2.fastq.gz"
    fi
    
    echo "Processed sample $sample"
done < "$sample_file"


###################################


# setup dirs
conda activate tmux
tmux attach -t dogs
srun --partition defq --cpus-per-task 2 --mem 30g --time 48:00:00 --pty bash 
conda activate bbmap
cd /share/BioinfMSc/Hannah_resources/doggies/fastqs
mkdir -p /gpfs01/home/mbzlld/data/doggies/subsampled /gpfs01/home/mbzlld/data/doggies/logs /gpfs01/home/mbzlld/data/doggies/tmp

# setup env
GENOME_SIZE=2500000000
COVERAGE=15
READ_LEN=150   # adjust if needed

PAIRS_NEEDED=$(echo "$GENOME_SIZE * $COVERAGE / (2 * $READ_LEN)" | bc)
echo $PAIRS_NEEDED

while read SAMPLE RUNS; do
    echo "Processing $SAMPLE"

    R1_MERGED="/gpfs01/home/mbzlld/data/doggies/tmp/${SAMPLE}_R1_merged.fastq.gz"
    R2_MERGED="/gpfs01/home/mbzlld/data/doggies/tmp/${SAMPLE}_R2_merged.fastq.gz"

    # Merge all R1 and R2 files for this sample
    for RUN in $RUNS; do
        R1="${RUN}_1.fastq.gz"
        R2="${RUN}_2.fastq.gz"

        if [[ -f "$R1" && -f "$R2" ]]; then
            cat $R1 >> $R1_MERGED
            cat $R2 >> $R2_MERGED
        else
            echo "Missing files for $RUN" >> /gpfs01/home/mbzlld/data/doggies/logs/missing.log
        fi
    done

    # Skip if no merged files
    #[[ ! -f $R1_MERGED || ! -f $R2_MERGED ]] && continue

    # Subsample using BBTools
    reformat.sh \
        in1=$R1_MERGED \
        in2=$R2_MERGED \
        out1=/gpfs01/home/mbzlld/data/doggies/subsampled/${SAMPLE}_R1.fastq.gz \
        out2=/gpfs01/home/mbzlld/data/doggies/subsampled/${SAMPLE}_R2.fastq.gz \
        samplereadstarget=$PAIRS_NEEDED \
        overwrite=true \
        2> /gpfs01/home/mbzlld/data/doggies/logs/${SAMPLE}.log

done < ../sample_to_runs.txt


######################################
######################################
######################################
######################################
######################################

while read SAMPLE RUNS; do
    echo "Processing $SAMPLE"

    R1_FILES=""
    R2_FILES=""

    for RUN in $RUNS; do
        R1="${RUN}_1.fastq.gz"
        R2="${RUN}_2.fastq.gz"

        if [[ -f "$R1" && -f "$R2" ]]; then
            R1_FILES="$R1_FILES $R1"
            R2_FILES="$R2_FILES $R2"
            echo $R1_FILES
            echo $R2_FILES
        else
            echo "Missing files for $RUN" >> /gpfs01/home/mbzlld/data/doggies/logs/missing.log
        fi
    done

    # skip if no files
    [[ -z "$R1_FILES" ]] && continue

    reformat.sh \
        in1=$R1_FILES \
        in2=$R2_FILES \
        out1=/gpfs01/home/mbzlld/data/doggies/subsampled/${SAMPLE}_R1.fastq.gz \
        out2=/gpfs01/home/mbzlld/data/doggies/subsampled/${SAMPLE}_R2.fastq.gz \
        samplereadstarget=$PAIRS_NEEDED \
        overwrite=true \
        2> /gpfs01/home/mbzlld/data/doggies/logs/${SAMPLE}.log


done < ../sample_to_runs.txt

