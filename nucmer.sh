#!/bin/bash

#SBATCH --job-name="bar1_mummer4"
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=8
#SBATCH --partition=medium
#SBATCH --mem=12G


source /mnt/shared/scratch/kkeegan/apps/miniconda3/etc/profile.d/conda.sh
conda activate /mnt/shared/scratch/kkeegan/apps/miniconda3/envs/mummer4


nucmer $1 $2 -p $3
