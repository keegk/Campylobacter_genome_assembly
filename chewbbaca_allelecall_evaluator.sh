#!/bin/bash
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --job-name="chewbbaca_allele_call"
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=long
#SBACTH --mem=4Gb


source /mnt/apps/users/kkeegan/conda/etc/profile.d/conda.sh

conda activate /mnt/apps/users/kkeegan/conda/envs/chewBBACA


chewBBACA.py AlleleCallEvaluator -i $1 -g $2 -o $3 --cpu 4
