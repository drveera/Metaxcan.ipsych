#!/bin/sh

if [ -z $2 ];
then
    echo "Usage: ./script dosage/folder db/file"
    exit 1
fi


sd=$(dirname $0)

dose=$1
db=$2

#step1
if [ -d dosage.map ];
then
    echo "dosage.map folder already exists. Skipping snp mapping"
fi
   
$sd/extract.snps.from.dosages.sh $dose

#step2
$sd/split.dbweights.sh $db

#step3
dbfolder=$(basename $db)
$sd/calculate.covariance.sh $dbfolder $dose 

