# Campylobacter_genome_assembly
This is a repository describing the genome assembly of *Campylobacter* isolates from greylag geese and cattle. As of January 2024, this repository contains only the isolates in the water_campy_28_9_23 (and the rerun of this same MinION flow cell on 29_9_23). This run had 4 Campylobacter isolates from four geese - FB1, FB2, FF1,FF2. It also had 2 *Camylobacter*  isolates from 2 cattle samples - FCD2,FCD3. Afurther 6 water samples were sequenced (unrelated to PhD) so that the total 12 barcodes from the kit were used. The isolates were run using the rapid kit SQKRBK004 using a FLOMIN106D flowcell. Initial run lasted only 6hrs - error 'script failed' on our sequencing computer. This was the first run we have done since ONT updated the basecaller from guppy to dorado - th last MinKNOW update completed by IT on our sequencing computer was August 2023. The flowcell stopped at 7pm on 28.9.23 - it had at this stage 8.74 Gb of data produced (pass/fail reads), 201.15k reads generated and an estimated N50 of 13.27kb. The flowcell was briefly removed from the device the morning of the 29.9.23 and the run restarted (no additonal sequencing buffer added to the MinION). The run lasted another 21 hours, 27 minutes and generated 11.35Gb of data, 195.71k reads with an N50 of 16.5Kb.

I am hoping the data generated in this run is enough to assemble the genomes of these *Campylobacter* isolates to 1) Characterise in more depth (species/strain) the *Campylobacter* found in both geese and cattle 2) Identitfy if the same strain or similar strain of *Campylobacter* is found in both the geese and cattle 3) Potentially look for areas of interest relating to AMR - 

Steps 1-2 are all run in a conda environment called read_QC.

**Step 1 - Super accuracy rebasecalling on HPC**

The combined pass, fail and skip reads (in fast5 format) from both the initial run (28.923) and the rerun of the same flowcell (29.9.23) will be combined in one folder and rebasecalled using super accuracy guppy basecaller (version 6.0.1), bash script titled 'super_basecalling_SQK_RBK004.sh'. *Note we could use the new Dorado basecaller here, but for now I am sticking with the guppy basecaller*


**Step 2 - Read QC on superbasecalled reads**

**2.1 -Nanoplot**
Using Nanoplot to QC the newly basecalled reads. Nanoplot is installed via conda (conda install -c bioconda nanoplot) and generates plots/summary statistics from the sequencing_summary.txt files that are generated for each barcode that reside in the same directory where the new fastq pass/fail etc reads are generated after basecalling. Output is a html file summarising all the QC analysis (Nanplot-report) aswell as all the individual png images from this report. For the 28-29.9.23 run with our 4 Campylobacter isolates from geese and 2 from cattle, the Nanoplot reports tells us that in general, the number of reads generated are typically looking about 6-15k for the geese, though more like 20-30k for the cattle. Read lengths look good (30-60k read lengths) and based on the Campylobacter genome being ~1.6Mb and the number of reads for any given barcode ~ 47,456,052bp, this equates to about 40x coverage of the genome (very nice!).

**2.2 Removing potential adapter contamination/noisy reads per sample using SNIKT**

SNIKT (Ranjan et al., 2022) is a tool for removing any potential barcode adapaters that may still be attached to reads after sequencing (despite adding the flag --trim_barcodes for SWK-RBK004 kit or --enable-trim-barcodes fro SQK-RBK114 skit, during guppy basecalling) and it can also filter out reads of a certain length. It is given no a priori information about the reads per sample and, by aligning reads from the 5' to 3'end, outputs a visual representation of areas where the nucleotide composition differs from the expected composition, indicating the presence of adapter contamination. The script to generate this initial 5' to 3' alignment per sample is called snikt_contamination_check.sh. For each sample I visually assessed potential sources of adapter contamination and in a follow up script (snikt_trim.sh) I manually set the amount of trim at both the 3' and 5' end for each sample to try and remove any excess noise from the reads, either from adapter contamination or poorly called nucleotides, to help with downstream genome assembly. 




**Step 3 - Genome assembly and polishing**

**3.1 Genome assembly with Flye**

Flye (flye.sh) is used to assemble the Nanopore sequenced *Campylobacter* isolates. In the script I have set the parameters --nano-hq, indicating that these are high quality reads (remember we used super accuracy basecalling on the Nanopore reads and have trimmed them of any potential adapter contamination). I have also given a reference genome size for *Campylobacter jejuni* (remember these samples are whole genome Nanopore sequences of *Campylobacter jejuni* (and one *coli*) isolates, isolated from geese and cattle). I set the reference genomes size for *Campylobacter jejuni* as 1.6Mb using the parameter -g 1.6M in the flye.sh script. Note assembly is very quick uaing Flye - only takes a few minutes to assemble each sample. 

**3.2 Assembly polishing using Medaka**

The assembled genomes generated from flye.sh were then polished with one round of Medaka. We could have increased the rounds of polishing here, but apparently the latest medaka releases don't require you to do multiple rounds of polishing, so I have left it at one round. Note that for medaka polishing, you need to set an appropriate medaka model based on the Nanopore the flow cell type, the guppy accuracy used (always super, in my case) and the version of guppy used to basecall the raw reads. It is not always possible to get a medaka model that macthes all of these criteria that the user specifically used, so in these cases the closest accurate medaka model is used.  Note that I had two Nanopore runs for my Campylobacter isolates sequenced. The first run, using the sequencing library kit SQK-RBK004, was initially used to sequence 6 isolates and the remaining isolates (24) were sequenced using the kit SQK-RBK114. You will note that I have two super accuracy guppy basecalling scripts that correspond to the fact that I had used two different sequencing libraries across these isolates - super_basecalling_SQK_RBK004_GPU.sh and super_basecalling_SQK_RBK114_GPU.sh. The medaka model chosen for the genome assemblies sequenced using the SQK-RBK004 kit was r941_sup_plant_g610 (While it says plant, it has the right flow cell, super accuracy and right version of guppy) and the medaka model used for the SQK-RBK114 kit was r1041_e82_400bps_sup_g615 (everything bar the Guppy version is correct - the guppy version 6.1.5 was the highest version they had available, but I used v 6.5.7). 

**Step 4 - assessing quality of newly polished genomes**

**4.1 - Aligning newly polished genomes to a reference C.jejuni genome using Mummer4**

Here, we want to align my polished assemblies against a reference genome, to get an indication of how similar my polished assemblies are to what we would expect. First we use the script nucmer.sh to align each of my assemblies against the reference geome and then we use the scrip mummerplot.sh to generate a .png image of the alignment, showing the reference genome on the x axis and our assembly on the y axis. We would expect to find a diaganol line on the plot, which indicates that the nucleotides are aligning well across out entire assembly to the reference genome. The reference genome for C.jejuni used was strain NCTC 11168 (GCF_000009085.1_ASM908v1_genomic.fna) which is recommended as the reference genome for C.jejuni analysis on NCBI (https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000009085.1/).



*References*:

Ranjan, P., Brown, C.A., Erb-Downward, J.R. and Dickson, R.P., 2022. SNIKT: sequence-independent adapter identification and removal in long-read shotgun sequencing data. Bioinformatics, 38(15), pp.3830-3832.
