



## How to source the software?


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

### Format the summary statistics

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
