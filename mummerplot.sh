#!/bin/bash

#SBATCH --job-name="bar1_mummer4"
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=2
#SBATCH --partition=short


export PATH=/home/kkeegan/projects/jhi/bioss/kkeegan/apps/miniconda3/envs/mummer4/bin/gnuplot:$PATH

source /mnt/shared/scratch/kkeegan/apps/miniconda3/etc/profile.d/conda.sh
conda activate /mnt/shared/scratch/kkeegan/apps/miniconda3/envs/mummer4

cd $1
mummerplot --png -f $2
