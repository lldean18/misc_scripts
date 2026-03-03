#!/bin/bash
# Laura Dean
# 26/2/26

# code used to download dog data for GWAS group project


# setup env
conda activate tmux
tmux new -t dogs
srun --partition defq --cpus-per-task 1 --mem 10g --time 08:00:00 --pty bash
source $HOME/.bash_profile
cd /share/BioinfMSc/temp/doggies




###################################################
####### This worked but it took forever ###########
###################################################

# download all of the run information for all sample accessions
while read accession <&3; do
  esearch -db sra -query "${accession}[BioSample]" |
  efetch -format runinfo >> full_runinfo.csv
done 3< sample_accessions.txt

# remove the duplicated header lines
sed '0,/^Run,ReleaseDate,LoadDate,spots,bases,spots_with_mates,avgLength,size_MB,AssemblyName,download_path,Experiment,LibraryName,LibraryStrategy,LibrarySelection,LibrarySource,LibraryLayout,InsertSize,InsertDev,Platform,Model,SRAStudy,BioProject,Study_Pubmed_id,ProjectID,Sample,BioSample,SampleType,TaxID,ScientificName,SampleName,g1k_pop_code,source,g1k_analysis_group,Subject_ID,Sex,Disease,Tumor,Affection_Status,Analyte_Type,Histological_Type,Body_Site,CenterName,Submission,dbgap_study_accession,Consent,RunHash,ReadHash/!{/^Run,ReleaseDate,LoadDate,spots,bases,spots_with_mates,avgLength,size_MB,AssemblyName,download_path,Experiment,LibraryName,LibraryStrategy,LibrarySelection,LibrarySource,LibraryLayout,InsertSize,InsertDev,Platform,Model,SRAStudy,BioProject,Study_Pubmed_id,ProjectID,Sample,BioSample,SampleType,TaxID,ScientificName,SampleName,g1k_pop_code,source,g1k_analysis_group,Subject_ID,Sex,Disease,Tumor,Affection_Status,Analyte_Type,Histological_Type,Body_Site,CenterName,Submission,dbgap_study_accession,Consent,RunHash,ReadHash/d}' full_runinfo.csv > NCBI_run_info.csv

# put the read lengths in a new file
cut -d',' -f1,7 NCBI_run_info.csv > read_lengths.tsv



###########################################
####### This was much quicker #############
###########################################

# try downloading from the ENA instead of NCBI
while read accession; do
curl -s "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=${accession}&result=read_run&fields=run_accession,read_count,base_count,library_layout,library_strategy,library_source,study_accession,sample_accession,scientific_name,tax_id,instrument_platform,instrument_model,fastq_ftp"
done < sample_accessions.txt >> ena_full.tsv

# remove duplicated header lines
awk 'NR==1 || $0 !~ /^run_accession[[:space:]]+read_count/' ena_full.tsv > ena_info.tsv

# remove the file with headers throughout it
rm ena_full.tsv

# select only the runs with PAIRED ILLUMINA data
awk -F'\t' 'NR==1 || ($4=="PAIRED" && $11=="ILLUMINA")' ena_info.tsv > run_info.tsv

# retain only the individuals to keep based on my R investigation of the metadata
awk -F'\t' '
FNR==NR {keep[$1]; next}      # first file: store accessions
FNR==1 {print; next}           # second file: print first line (header)
$8 in keep                     # keep only lines where 8th column is in the list
' accessions_to_keep.txt run_info.tsv > run_info_flt.tsv


# take the column with the ftp paths into a new file
cut -f13 -d$'\t' run_info_flt.tsv > ftp_paths.txt
# remove the header
sed -i '1d' ftp_paths.txt
# split entries onto single lines
sed -i 's/;/\n/g' ftp_paths.txt



#########################################
###### Download the fastq files #########
#########################################

srun --partition defq --cpus-per-task 2 --mem 30g --time 100:00:00 --pty bash
source $HOME/.bash_profile
cd /share/BioinfMSc/temp/doggies
mkdir fastqs
cd fastqs

wget --input-file=../ftp_paths.txt


########################################################
###### Make the metadata file for the students #########
########################################################


cut -f1-12 -d$'\t' run_info_flt.tsv > metadata_reads.tsv

# from my laptop pull the metadata
scp ada:/share/BioinfMSc/temp/doggies/metadata_reads.tsv ./





