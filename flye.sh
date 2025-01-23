#!/bin/bash
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --job-name="bar14_flye"
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=2
#SBATCH --partition=short
#SBATCH --mem=8G

source /mnt/shared/scratch/kkeegan/apps/miniconda3/etc/profile.d/conda.sh
conda activate /mnt/shared/scratch/kkeegan/apps/miniconda3/envs/genome_assembly

flye --nano-hq $1 -g 1.6M -o $2
