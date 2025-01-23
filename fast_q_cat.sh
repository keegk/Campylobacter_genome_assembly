#!/bin/bash
#SBATCH --mail-user=karen.keegan@moredun.ac.uk
#SBATCH --cpus-per-task=2
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=short

dir=$1
out=$2


fastq=$(find $dir -type f -name "*.fastq.gz")

for i in $fastq ;do
  if [[ $i == *"/pass/"* ]]; then
        xargs cat $i >> $out
  fi
done

