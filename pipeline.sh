#!/bin/sh

wd=`dirname $0`
outdir=$1
gwas=$2
weight=$3
cov=$4
metaxcan=$wd/software/MetaXcan/software/MetaXcan.py

$metaxcan \
    --beta_folder $outdir/beta \
    --weight_db_path $weight \
    --covariance $cov \
    --gwas_folder $gwas \
    --gwas_file_pattern ".*gz" \
    --compressed \
    --beta_column BETA \
    --pvalue_column P \
    --output_file $outdir/$weight.csv

