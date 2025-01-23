#!/bin/bash

#SBATCH --job-name="polypolish_filter"
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=2
#SBATCH --partition=short


export PATH=/mnt/shared/scratch/kkeegan/apps/miniconda3/envs/polypolish/bin:$PATH

source /mnt/shared/scratch/kkeegan/apps/miniconda3/etc/profile.d/conda.sh
conda activate /mnt/shared/scratch/kkeegan/apps/miniconda3/envs/polypolish


polypolish filter --in1 $1 --in2 $2 --out1 $3 --out2 $4
