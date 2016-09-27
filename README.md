



## How to source the software?


Just source the `load.sh file`

 Inside genome.dk (open)
```
source /project/BartholinGWAS/Veera/load.metaxcan.sh
```

Inside  iPSYCH (secured)
```
source /project/IGdata/faststorage/userdata/iveera/metaxcan/Metaxcan.ipsych/metaxcan.sh
```

## Usage 

### Format the summary statistics

The summary stat file should be split in to individual chromosomes. Each file should be named `.sum` extension. For example, chr1.sum, chr2.sum etc. Each file should have a column named `BETA` and a column named `P`

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

### Run Metaxcan

You just need to provide 2 parameters: 

1. path to gwas summary stats folder
2. path to output folder

```
metaxcan --gwas /path/to/gwas/summary/stats/ --outdir /path/to/output/folder
```

The above command will create a `.adispatch` file in the working directory prefixed with the out name you provided.  Now submit the job to the cluster

For example, if the adispatch file is named `sample.adispatch`, then
```
adispatch --mem=4g sample.adispatch
```
Once the jobs are finished, you'll see the results `csv` files for 45 tissues inside the output folder.

##Future Update

I'll add scripts to create manhattan plots sometime soon. 
