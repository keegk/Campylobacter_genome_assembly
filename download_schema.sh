#!/bin/bash
#SBATCH --job-name="Download_schema_chewBACCA"
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --partition=medium

source /mnt/shared/scratch/kkeegan/apps/miniconda3/etc/profile.d/conda.sh

conda activate /mnt/shared/scratch/kkeegan/apps/miniconda3/envs/chewBBACA

chewBBACA.py DownloadSchema -sp 4 -sc 1 -o $1
