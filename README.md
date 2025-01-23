# Campylobacter_genome_assembly
This is a repository describing the genome assembly of *Campylobacter* isolates from greylag geese and cattle. This repository contains the scripts for read quality checks, genome assembly, genome assembly checks, hybrid assembly, AMR and phylogenetic analysis. Two Nanopore runs were conducted that generated the data for this thesis chapter. 

Run 1: The first run, using the rapid sequencing kit SQK-RBK004 and a FLOMIN106D flowcell, had 4 *Campylobacter* isolates from four geese - FB1, FB2, FF1,FF2. It also had 2 *Camylobacter*  isolates from 2 cattle samples - FCD2,FCD3. Initial run lasted only 6hrs - error 'script failed' on our sequencing computer. This was the first run we have done since ONT updated the basecaller from guppy to dorado - th last MinKNOW update completed by IT on our sequencing computer was August 2023. The flowcell stopped at 7pm on 28.9.23 - it had at this stage 8.74 Gb of data produced (pass/fail reads), 201.15k reads generated and an estimated N50 of 13.27kb. The flowcell was briefly removed from the device the morning of the 29.9.23 and the run restarted (no additonal sequencing buffer added to the MinION). The run lasted another 21 hours, 27 minutes and generated 11.35Gb of data, 195.71k reads with an N50 of 16.5Kb.

Run 2: 

**Aims of chapter**

The data (assembled whole genomes of C jejuni/C.coli) generated here will be applied to attempt to answer the following questions:

1) Characterise in more depth (sequence type) the *Campylobacter jejuni/coli* found in both geese and cattle
2) cgMLST evalution and generation of phylogenetic tree to compare relatedness of C.jejuni strains isolated from cattle and geese
3) Scan the assembled genomes for AMR and virulence genes



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

**Step 4 - Assessing quality of newly polished genomes**

**4.1 - Aligning newly polished genomes to a reference C.jejuni genome using Mummer4**

Here, we want to align my polished assemblies against a reference genome, to get an indication of how similar my polished assemblies are to what we would expect. First we use the script nucmer.sh to align each of my assemblies against the reference geome and then we use the scrip mummerplot.sh to generate a .png image of the alignment, showing the reference genome on the x axis and our assembly on the y axis. We would expect to find a diaganol line on the plot, which indicates that the nucleotides are aligning well across out entire assembly to the reference genome. The reference genome for C.jejuni used was strain NCTC 11168 (GCF_000009085.1_ASM908v1_genomic.fna) which is recommended as the reference genome for C.jejuni analysis on NCBI (https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000009085.1/).

**4.2 - QUAST to assess QC metrics of polished assemblies against a reference genome**

QUAST is also looking at the quality of an alignment to a reference genome, but outputs a report stating quality metrics (% genome covered, N50,L50 etc), as opposed to mummer4 which in our use case is generating the alignment plot only between our polished assemblies and a reference genome. Note here that we use the same reference C. jejuni genome (strain NCTC 11168) as we did in mummer4 in the quast.sh script using the -R parameter. 



**Step 5 - Hybrid assemblies**

For the majority of our *C.jejuni* isolates sequenced (N = 30 with one replicate isolate, FF1) we also have corresponding Illumina forward and reverse sequencing reads and here we are going to use thes reads to polish our existing genome assemblies, in the hope that we may get even better results when we try to assign sequence types for each of our isolates and when we generate a phylogenetic tree to indicate how similar strains are to each other (for example, do we find that strains associated with geese are the same or dissimilar to those found in cattle?). 


**5.1 - Polishing existing Nanopore genomes with illumina short reads using polypolish**

***5.1.1 - Align illumina reads to Nanopore genomes with minimap2***

Using the script polypolish_align_reads.sh, here we use minimap2 to align the illumina paired-end fastq.gz reads to our Nanopore assemblies and outputting two sam files which correspond to 1) alignment of the forward illumina reads to the Nanopore genome and 2) alignment of the reverse illumina reads to the Nanopore genome. Note that in the polypolish documentation (https://github.com/rrwick/Polypolish/wiki/How-to-run-Polypolish), they use BWA to align the illumina reads to the Nanopore assembly. BWA has now been replced with minimap2 for PACBIO and Nanopore alignment (https://github.com/lh3/bwa), hence why we use this instead.  Note the flags used in this polypolish_align_reads.sh script ; The flag option -x, which sets multiple parameters at the same time, the -a option, which I believe corresponds to the -a flag in BWA (The -a option is key! This makes BWA align each read to all possible locations, not just the best location. Polypolish needs this to polish repeat sequences, source:(https://github.com/rrwick/Polypolish/wiki/How-to-run-Polypolish)  and the -sr option, indicating that these are short reads to be aligned. 

***5.1.2 - Filtering these .sam alignments using polypolish***

Using the script polypolish_filter.sh, we use the tool polypolish to filter these newly created .sam alignments between the illumina paired-end reads and the Nanopore assemblies. This is an optional, but recommended step with polypolish. 

***5.1.3 - Polishing the Nanopore assemblies with the .sam alignments generated from the illumina paired-end reads***

The final step in creating the hybrid assemblies, is to finally polish the Nanopore assemblies with the newly created .sam alignments generated from the paired-end illumina reads. Note I use the flag --careful which will make Polypolish discard reads that align to more than one place in the Nanopore assembly. This does limit the ability of Polypolish to polish over repeat regions and is recommended to be used if the sequencing depth (coverage?) is less than 25x. **NB -I've set this flag for all my hybrid assemblies, but I wonder if it might be worth going back and only using it on some of my assemblies with this low coverage**

**5.2 - QUAST to assessing quality of hybrid assemblies**

Using the quast.sh script again to assess the quality of the hybrid assemblies now against the reference *C.jejuni* strain NCTC 11168.



**DATA ANALYSIS**

In this section, we will now look at the scripts/analysis used to  analyse the Nanopore assemblies (N = 30) and hybrid assemblies (N = 24) to answer the following questions:


**Section 1**  

***Aim: Assign sequence types of *Campylobacter jejuni/coli* to the Nanopore/hybrid assemblies found in both geese and cattle***

The final Nanopore genomes and hybrid genomes were uploaded to the ***Campylobacter jejuni/coli*** PubMLST (https://pubmlst.org/bigsdb?db=pubmlst_campylobacter_seqdef&page=sequenceQuery) and screened against the PubMLST Campylobacter schemas to assign sequence types (ST) to the genomes. First of all, some definitions: MLST stands for multi-locus sequence typing and PubMLST is simply a public repository of MLST schemes, including Campylobacter jejuni/coli. MLST schemes help us to characterise Campylobacter isolates (a single colony of Campylobacter that has been isolated from Campylobacter cultured in th lab), by looking at areas where loci in the genome are the same, or different between, these isolates. Essentially by using several of these loci, we can generate a genomic "fingerprint" to each isolate and from that determine how closely or distantly related isolates are to each other. There are two "schemes" for C.jejuni/coli in PubMLST, the standard MLST (Dingle et al., 2001), comprising of 7 housekeeping genes (7 loci) established using 194 C. jejuni isolates of diverse origins and the cgMLST (v1) which contain 1,343 loci derived from the reference strain NCTC 11168 (Cody et al., 2017). There is also a cgMLST (v2) on PubMLST (https://pubmlst.org/bigsdb?db=pubmlst_campylobacter_seqdef&page=schemeInfo&scheme_id=8) that contains 1142 loci, although I've not been able to get much info on whether this scheme is also based on loci found in the reference strain NCTC 11168 - I assume it is and just has slightly less loci than the original scheme (maybe to increase the likelihood that loci will be detected in query assemblies/sequences - perhaps some of these missing loci are not found consistently in many Campylobacter strains).


2)cgMLST evalution and generation of phylogenetic tree to compare relatedness of C.jejuni strains isolated from cattle and geese*

**Section 2 -chewBBACA to examine core genome MLST (cgMLST) of C.jejuni Nanopore and hybrid assemblies**





*References*:
Cody, A.J., Bray, J.E., Jolley, K.A., McCarthy, N.D. and Maiden, M.C., 2017. Core genome multilocus sequence typing scheme for stable, comparative analyses of Campylobacter jejuni and C. coli human disease isolates. Journal of clinical microbiology, 55(7), pp.2086-2097.
Dingle, K.E., Colles, F.M., Wareing, D.R.A., Ure, R., Fox, A.J., Bolton, F.E., Bootsma, H.J., Willems, R.J.L., Urwin, R. and Maiden, M.C.J., 2001. Multilocus sequence typing system for Campylobacter jejuni. Journal of clinical microbiology, 39(1), pp.14-23.
Ranjan, P., Brown, C.A., Erb-Downward, J.R. and Dickson, R.P., 2022. SNIKT: sequence-independent adapter identification and removal in long-read shotgun sequencing data. Bioinformatics, 38(15), pp.3830-3832.
