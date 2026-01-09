# Laura Dean
# 19th december 25
# code was run from the terminal on my Mac (except for the conversion to flatfile)
# code used to submit a genome assembly with annotation to ENA

# before any submission, need to convert the fasta asm and gff annotation to EMBL flat file format for submission
# ON ADA
#conda create --name embl -c bioconda emblmygff3
conda activate embl
cd /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag
# convert the assembly and annotation to flatfile format
EMBLmyGFF3 maker.gff3 ragtag.scaffolds_only.fasta \
        --topology linear \
        --molecule_type 'genomic DNA' \
        --transl_table 1  \
        --species 'Drosophila melanogaster' \
        --locus_tag LOCUSTAG \
        --project_id PRJXXXXXXX \
        -o result.embl


# Genome assemblies can only be submitted using the webin-cli
# downloaded webincli from github
mkdir -p ~/software/webin-cli
cd ~/software/webin-cli
wget https://github.com/enasequence/webin-cli/releases/download/9.0.1/webin-cli-9.0.1.jar

# then I had to update my java version

# then create and move to a dir for all the submission files
mkdir -p /Users/lauradean/Library/CloudStorage/OneDrive-TheUniversityofNottingham/BioinfTech/05_DeepSeq/OrgOne/01_sumatran_tiger/ENA_asm_submission
cd /Users/lauradean/Library/CloudStorage/OneDrive-TheUniversityofNottingham/BioinfTech/05_DeepSeq/OrgOne/01_sumatran_tiger/ENA_asm_submission

# copy the assembly and the annotation files to the submission dir from the HPC
scp ada:/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/annotation_summary.tsv ./
scp ada:/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/




# after that from the command line:
java -jar /Users/lauradean/software/webin-cli/webin-cli-9.0.1.jar \
	-username Webin-XXXXX \
	-password YYYYYYY \
	-context genome \
	-manifest manifest.txt \
	-validate

