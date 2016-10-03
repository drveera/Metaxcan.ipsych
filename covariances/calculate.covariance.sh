#!/bin/sh

if [ -z $1 ];
then
    echo "usage: ./script <folder containing db weights> <dosage folder>"
    exit 1
fi


dosedir=$1


sd=$(dirname $0)

for i in `seq 22`;
do
	Rscript $sd/calculate.covariance.R \
	    $i.snps \
	    $dosedir/*chr$i.*gz \
	    covariances/$i.covariance
done

while read i;
do
    dbname=$(basename $i)
    cat $i/covariances/*covariance > $dbname.covariance2
    echo "GENE RSID1 RSID2 VALUE" > $dbname.head
    cat $dbname.head $dbname.covariance2 > $dbname.covariance
    gzip $dbname.covariance
    rm $dbname.head
    rm $dbname.covariance2
    rm -r $i
done < dbfolder.list



