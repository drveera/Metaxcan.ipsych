#!/bin/sh

if [ -z $1 ];
then
    echo "usage: ./script dosage folder"
    exit 1
fi

dosage=$1

if [ -d dosage.map ];
then
    echo "folder dosage.map already exists"
    exit 1
fi

mkdir dosage.map

ls $dosage/*gz > dosage.map/dosage.list

while read dosage
do
    echo "Extracting snp information from $dosage"
    out=$(basename $dosage)
    zcat $dosage | cut -f 1,2  > dosage.map/$out.snps
done < dosage.map/dosage.list

cat dosage.map/*snps > dosage.map/all.snps.txt


