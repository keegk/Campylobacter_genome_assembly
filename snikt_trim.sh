#!/bin/bash
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --job-name="Barcode24_snikt_trim"
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=short
#SBATCH --mem=4Gb
#SBATCH --cpus-per-task=2

source /mnt/shared/scratch/kkeegan/apps/miniconda3/etc/profile.d/conda.sh

conda activate /mnt/shared/scratch/kkeegan/apps/miniconda3/envs/read_QC

snikt.R --trim5=250 --trim3=250 --filter=500 $1 --workdir $2 --out=trimmed 
