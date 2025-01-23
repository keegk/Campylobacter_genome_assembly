#!/bin/bash

#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=short
#SBATCH --mem=4G
source /mnt/apps/users/kkeegan/conda/etc/profile.d/conda.sh

conda activate /mnt/apps/users/kkeegan/conda/envs/read_QC

NanoPlot -t 4 --summary $1 -o $2
