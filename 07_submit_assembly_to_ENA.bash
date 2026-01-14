# Laura Dean
# 19th december 25
# code was run from the terminal on my Mac (except for the conversion to flatfile)
# code used to submit a genome assembly with annotation to ENA


################################################
# before any submission, need to convert the fasta asm and gff annotation to EMBL flat file format for submission
# ON ADA
conda activate tmux
tmux new -t ENA
srun --partition defq --cpus-per-task 1 --mem 20g --time 2:00:00 --pty bash
#conda create --name embl -c bioconda emblmygff3
conda activate embl
cd /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag
# remove the locus tag since EMBLmyGFF3 seems to add it
sed 's/locus_tag=PTIG_/locus_tag=/g' ptigris_annotation_formatted.gff > ptigris_annotation_formatted_noloctag.gff
# this was wrong go with the locus tag version

# convert the assembly and annotation to flatfile format
EMBLmyGFF3 ptigris_annotation_formatted.gff ragtag.scaffolds_only.fasta \
        --topology linear \
        --molecule_type 'genomic DNA' \
        --transl_table 1  \
        --species 'Panthera tigris' \
        --locus_tag PTIG \
        --project_id PRJEB74210 \
        -o result3.embl
conda deactivate

gzip -k result3.embl

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
#scp ada:/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/annotation_summary.tsv ./
#scp ada:/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/
scp ada:/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag/result2.embl.gz ./

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

