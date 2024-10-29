#!/bin/bash

#SBATCH --job-name="campy_isol_12.3.24"
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=short
#SBATCH --partition=gpu
#SBATCH --gpus=1
#SBATCH --mem=4G


export PATH=/mnt/shared/projects/jhi/bioss/kkeegan_onttestdata/ont_guppy_gpu/ont-guppy/bin:$PATH
echo "Input path is $1"
echo "Save path is $2"


guppy_basecaller --input_path $1 --save_path $2 --recursive --config $3 --barcode_kits "SQK-RBK114-24" --enable_trim_barcodes --device cuda:all --compress_fastq

