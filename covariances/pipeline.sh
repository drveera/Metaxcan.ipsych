#!/bin/sh

if [ -z $2 ];
then
    echo "Usage: ./script dosage/folder db/folder"
    exit 1
fi


sd=$(dirname $0)

dose=$1
dbfolderlist=$2

while read i
do
basename $i
done < $dbfolderlist > dbfolder.list

#step1
if [ -d dosage.map ];
then
    echo "dosage.map folder already exists. Skipping snp mapping"
fi
   
$sd/extract.snps.from.dosages.sh $dose

#step2
while read i
do
    $sd/split.dbweights.sh $i
done < $dbfolderlist


#step3
$sd/calculate.covariance.sh $dose 

