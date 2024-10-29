#!/bin/bash

#SBATCH --job-name="superbasecalling_SQK_RBK004"
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=medium
#SBATCH --partition=gpu
#SBATCH --gpus=1

export PATH=/home/kkeegan/projects/jhi/bioss/kkeegan_onttestdata/ont-guppy-cpu/bin:$PATH
echo "Input path is $1"
echo "Save path is $2"


guppy_basecaller --input_path $1 --save_path $2 --recursive --config $3 --barcode_kits "SQK-RBK004" --trim_barcodes


