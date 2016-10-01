#!/bin/sh

dosage=$1
outdir=$2

ls $dosage/*gz >$outdir/dosage.list

while read dosage
do
    echo "Extracting snp information from $dosage"
    out=$(basename $dosage)
    zcat $dosage | cut -f 1,2 -d " " > $outdir/$out.snps
done < $outdir/dosage.list


