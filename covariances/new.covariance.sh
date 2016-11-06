#!/bin/sh

if [ ! $2 ];
then
    echo "usage ./script plinkfile db.csv working_directory "
    exit 1
fi


#inputs
plinkfile=$1
db=$2
wd=$3

#directories
#script directory
sd=$(dirname $0)

#output
outname=$(basename $db)

#softwares
source /com/extra/plink/1.90-beta-2016-03/load.sh

echo "make $outname.covariance.matrix.gz -f $sd/Makefile  plinkfile=$plinkfile outname=$outname sd=$sd db=$db $3" > $outname.job1.adispatch

for i in $(seq 22)
do
    echo "make $wd/$outname.chr$i.covariance.matrix.gz \
-f $sd/Makefile2 \
outname=$wd/$outname.chr$i \
outname_nochr=$wd/$outname \
sd=$sd \
db=$db \
chr=$i "
done > $outname.job2.adispatch






