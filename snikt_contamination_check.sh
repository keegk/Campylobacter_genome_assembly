#!/bin/bash
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --job-name="Barcode2_snikt_preQC"
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=short
#SBATCH --mem=2Gb
#SBATCH --cpus-per-task=2

source /mnt/shared/scratch/kkeegan/apps/miniconda3/etc/profile.d/conda.sh

conda activate /mnt/shared/scratch/kkeegan/apps/miniconda3/envs/read_QC

snikt.R --skim=0  --notrim $1 --workdir $2 
