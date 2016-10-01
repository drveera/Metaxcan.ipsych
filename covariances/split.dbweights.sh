#!/bin/sh

if [ -z $1 ];
then
    echo "usage: ./script db.file"
    exit 1
fi

sd=`dirname $0`
db=$1


dbname=$(basename $db)

if [ -d $dbname ];
then
    echo "folder $dbname already exists"
    exit 1
fi
mkdir $dbname

#step1 extract weights from the db file
echo "extracting weights from $1"
sh $sd/extract.weights.sh $db > $dbname/$dbname.weights.csv


#write snps and genes chromosome wise
Rscript $sd/cov.R $dbname/$dbname.weights.csv $dbname






#step3 write chromosome wise snps and genes


