#!/bin/sh

wd=`dirname $0`
outdir=$1
gwas=$2
weight=$3
cov=$4
metaxcan=$wd/../MetaXcan/software/MetaXcan.py

sd=$(dirname $0)

outname=`basename $weight`
$metaxcan \
    --beta_folder $outdir/beta \
    --weight_db_path $weight \
    --covariance $cov \
    --gwas_folder $gwas \
    --gwas_file_pattern ".*sum" \
    --beta_column BETA \
    --pvalue_column P \
    --output_file $outdir/$outname.csv

$sd/manhattan.R $outdir/$outname.csv $sd/ensembl.gene.id.position
