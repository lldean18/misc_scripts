#!/bin/bash
# Laura Dean
# 19th december 25
# 13th Feb 26 (stupid thing!)
# code was run from the terminal on my Mac (except for the conversion to flatfile)
# code used to submit a genome assembly with annotation to ENA


################################################
# before any submission, need to convert the fasta asm and gff annotation to EMBL flat file format for submission
# ON ADA
conda activate tmux
tmux new -t ENA
srun --partition defq --cpus-per-task 1 --mem 20g --time 6:00:00 --pty bash
#conda create --name embl -c bioconda emblmygff3
conda activate embl
cd /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag


# convert the assembly and annotation to flatfile format
EMBLmyGFF3 annotated.gff3 ragtag.scaffolds_only.fasta \
        --topology linear \
        --molecule_type 'genomic DNA' \
        --transl_table 1  \
        --species 'Panthera tigris' \
        --locus_tag PTIG \
        --project_id PRJEB74210 \
        -o result6.embl

gzip -k result6.embl

################################################
# ON MY MAC
# Genome assemblies can only be submitted using the webin-cli
# downloaded webincli from github
mkdir -p ~/software/webin-cli
cd ~/software/webin-cli
wget https://github.com/enasequence/webin-cli/releases/download/9.0.1/webin-cli-9.0.1.jar

# then I had to update my java version

# then create and move to a dir for all the submission files
mkdir -p /Users/lauradean/Library/CloudStorage/OneDrive-TheUniversityofNottingham/BioinfTech/05_DeepSeq/OrgOne/01_sumatran_tiger/ENA_asm_submission
cd /Users/lauradean/Library/CloudStorage/OneDrive-TheUniversityofNottingham/BioinfTech/05_DeepSeq/OrgOne/01_sumatran_tiger/ENA_asm_submission

## copy the assembly and the annotation files to the submission dir from the HPC
#scp ada:/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag/result2.embl.gz ./
#scp ada:/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag/result3.embl.gz ./
#scp ada:/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag/result4.embl.gz ./
#scp ada:/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag/result5.embl.gz ./
scp ada:/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag/result6.embl.gz ./

# the files must be zipped for submission
gzip chromosome_list.txt
gzip result.embl


# after that from the command line:
java -jar /Users/lauradean/software/webin-cli/webin-cli-9.0.1.jar \
	-username Webin-154 \
	-password hjsH3ZTp \
	-context genome \
	-manifest manifest.txt \
	-validate


# and once it would validate successfully submit using:
java -jar /Users/lauradean/software/webin-cli/webin-cli-9.0.1.jar \
        -username Webin-154 \
        -password hjsH3ZTp \
        -context genome \
        -manifest manifest.txt \
        -submit

# this worked :D
# temp accession: ERZ29076574


