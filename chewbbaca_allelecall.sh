#!/bin/bash
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --job-name="chewbbaca_allele_call"
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=long
#SBACTH --mem=4Gb


source /mnt/apps/users/kkeegan/conda/etc/profile.d/conda.sh

conda activate /mnt/apps/users/kkeegan/conda/envs/chewBBACA

chewBBACA.py AlleleCall -i $1 -g $2 --ptf $3 -o $4 --cpu 4 --output-novel --prodigal-mode meta  
