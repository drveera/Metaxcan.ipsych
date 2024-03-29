



## Load the software


Just source the `load.sh file`

 Inside genome.dk (open)
```
source /project/BartholinGWAS/Veera/load.metaxcan.sh
```

Inside  iPSYCH (secured)
```
source /project/IGdata/faststorage/userdata/iveera/metaxcan/load.metaxcan.sh
```

## Usage 

### Format the summary statistics file

 The summary stat file should be a single file (either space or tab separated) and have columns named `SNP`,  `A1`, `A2`, `BETA` and `P`.  
 
**Note**: Even if you have odds ratio, name it as BETA

```
SNP CHR POS A1 A2 BETA P
rs3131972 1 742584 A G 0.289 0.7726
rs3131969 1 744045 A G 0.393 0.6946
rs3131967 1 744197 T C 0.443 0.658
rs1048488 1 750775 T C -0.289 0.7726
rs12562034 1 758311 A G -1.552 0.1207
rs4040617 1 769185 A G -0.414 0.6786
rs4970383 1 828418 A C 0.214 0.8303
rs4475691 1 836671 T C -0.604 0.5461
rs1806509 1 843817 A C -0.262 0.7933
```
Note: `A1` is reference allele, and `A2` is alternate allele or effect allele. 

### Run Metaxcan

You just need to provide 2 parameters: 

1. gwas summary file (with absolute path)
2. output name 

```
metaxcan --gwas summary/stats/file --out preferred_output_name
```

The above command will submit the jobs to cluster.  Once the jobs are finished, you'll see the results `csv` files for 45 tissues inside the output folder. 

**Note**: If you don't want to submit as job and like to execute in the front end,  add `--nojob` option. 

##Manhattan plots

The pipeline by default generates manhattan association plots.  The genes that are significant above the Bonferroni corrected significance threshold (`-log10(pvalue/number-of-genes)`) will be labelled by default. 

It is possible to generate Manhattan plots with user defined threshold. 

### Usage

`metaxcan --man --csv <csv.file> --labelthreshold <number>`

where, arguments `--csv` requires csv output file from metaxcan and `--labelthreshold` requires number of your preference (see the plot y axis and choose this number). 

For example,  Below is a plot showing gene associations of schizophrenia based on whole blood gene expression. Here you can see that the genes above the red line are labelled. You can change this (scroll down). 
![Manhattan plot](https://github.com/veera-dr/Metaxcan.ipsych/blob/master/support/DGN-WB_0.5.db.csv.man.png)

Lets say I wanted to label all genes above threshold 4 in Y axis. 

Then,

`metaxcan --man --csv DGN.csv --labelthreshold 4`

Here is the new plot.
![enter image description here](https://github.com/veera-dr/Metaxcan.ipsych/blob/master/support/DGN-WB_0.5.db.csv.man.new.png)

##Future Update
The current predictions are based on SNP co-variance matrices generated by the PrediXcan group using 1000 genome phase3 data.  Soon I'll make available the co-variance matrices based on iPSYCH genotypes...

