#!/bin/sh

if [ -z $1 ];
then
    echo "usage: ./script <folder containing db weights> <dosage folder>"
    exit 1
fi

dbwtdir=$1
dosedir=$2

mkdir $dbwtdir/covariances

sd=$(dirname $0)

for i in `seq 22`;
do
    Rscript $sd/calculate.covariance.R \
	    $dbwtdir/$i.snps \
	    $dosedir/*chr$i.*gz \
	    $dbwtdir/covariances/$i.covariance
done

dbname=$(basename $dbwtdir)

cat $dbwtdir/covariances/*covariance > $dbname.covariance2

echo "GENE RSID1 RSID2 VALUE" > $dbname.head


cat $dbname.head $dbname.covariance2 > $dbname.covariance
gzip $dbname.covariance
rm $dbname.head
rm $dbname.covariance2
rm -r $dbwtdir
