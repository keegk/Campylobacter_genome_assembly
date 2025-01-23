#!/bin/bash

#SBATCH --job-name="barcodefb1_hybrid_quast"
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=2
#SBATCH --partition=short

export PATH=/home/kkeegan/projects/jhi/bioss/kkeegan/apps/miniconda3/envs/quast/bin/:$PATH

source /mnt/apps/users/kkeegan/conda/etc/profile.d/conda.sh

conda activate /mnt/apps/users/kkeegan/conda/envs/quast

quast.py $1 -R $2 -o $3




