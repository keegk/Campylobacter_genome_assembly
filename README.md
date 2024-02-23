# Campylobacter_genome_assembly
This is a repository describing the genome assembly of *Campylobacter* isolates from greylag geese and cattle. As of January 2024, this repository contains only the isolates in the water_campy_28_9_23 (and the rerun of this same MinION flow cell on 29_9_23). This run had 4 Campylobacter isolates from four geese - FB1, FB2, FF1,FF2. It also had 2 *Camylobacter*  isolates from 2 cattle samples - FCD2,FCD3. Afurther 6 water samples were sequenced (unrelated to PhD) so that the total 12 barcodes from the kit were used. The isolates were run using the rapid kit SQKRBK004 using a FLOMIN106D flowcell. Initial run lasted only 6hrs - error 'script failed' on our sequencing computer. This was the first run we have done since ONT updated the basecaller from guppy to dorado - th last MinKNOW update completed by IT on our sequencing computer was August 2023. The flowcell stopped at 7pm on 28.9.23 - it had at this stage 8.74 Gb of data produced (pass/fail reads), 201.15k reads generated and an estimated N50 of 13.27kb. The flowcell was briefly removed from the device the morning of the 29.9.23 and the run restarted (no additonal sequencing buffer added to the MinION). The run lasted another 21 hours, 27 minutes and generated 11.35Gb of data, 195.71k reads with an N50 of 16.5Kb.

I am hoping the data generated in this run is enough to assemble the genomes of these *Campylobacter* isolates to 1) Characterise in more depth (species/strain) the *Campylobacter* found in both geese and cattle 2) Identitfy if the same strain or similar strain of *Campylobacter* is found in both the geese and cattle 3) Potentially look for areas of interest relating to AMR - 

Steps 1-2 are all run in a conda environment called read_QC.

**Step One - Super accuracy rebasecalling on HPC**

The combined pass, fail and skip reads (in fast5 format) from both the initial run (28.923) and the rerun of the same flowcell (29.9.23) will be combined in one folder and rebasecalled using super accuracy guppy basecaller (version 6.0.1), bash script titled 'super_basecalling_SQK_RBK004.sh'. *Note we could use the new Dorado basecaller here, but for now I am sticking with the guppy basecaller*


**Step Two - Read QC on superbasecalled reads**

Using Nanoplot to QC the newly basecalled reads. Nanoplot is installed via conda (conda install -c bioconda nanoplot) and generates plots/summary statistics from the sequencing_summary.txt files that are generated for each barcode that reside in the same directory where the new fastq pass/fail etc reads are generated after basecalling. 

In an interactive job on the hpcc, activate the read_QC environment, cd to a barcode directory and then run: NanoPlot -t 4 --summary sequencing_summary.txt  -o Nanoplot_barcode1_summary (t = threads/cores). This will generate a html output summarising all the QC analysis (Nanplot-report) aswell as all the individual png images from this report. For the 28-29.9.23 run with our 4 Campylobacter isolates from geese and 2 from cattle, the Nanoplot reports tells us that in general, the number of reads generated are typically looking about 6-15k for the geese, though more like 20-30k for the cattle. Read lengths look good (30-60k read lengths) and based on the Campylobacter genome being ~1.6Mb and the number of reads for any given barcode ~ 47,456,052bp, this equates to about 40x coverage of the genome (very nice!).

**Step three - Removing poor quality reads with FitLong**

