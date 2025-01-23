#!/bin/bash

#SBATCH --job-name="bar1_align_short_reads"
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=2
#SBATCH --partition=short


export PATH=/mnt/shared/scratch/kkeegan/apps/miniconda3/envs/minimap2/minimap2-2.28_x64-linux:$PATH

source /mnt/shared/scratch/kkeegan/apps/miniconda3/etc/profile.d/conda.sh
conda activate /mnt/shared/scratch/kkeegan/apps/miniconda3/envs/minimap2


minimap2 -ax sr $1 $2 > $3
minimap2 -ax sr $1 $4 > $5

