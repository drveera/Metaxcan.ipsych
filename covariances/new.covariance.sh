#!/bin/sh

if [ ! $2 ];
then
    echo "usage ./script plinkfile snplist.file"
    exit 1
fi


#inputs
plinkfile=$1
db=$2

#directories
#script directory
sd=$(dirname $0)

#output
outname=$(basename $db)

#softwares
source /com/extra/plink/1.90-beta-2016-03/load.sh

#make $outname.covariance.matrix.gz -f $sd/Makefile  plinkfile=$plinkfile outname=$outname sd=$sd db=$db $3

for i in $(seq 22)
do
    echo "make $outname.chr$i.covariance.matrix.gz \
-f $sd/Makefile2 \
outname=$outname.chr$i \
outname_nochr=$outname \
sd=$sd \
db=$db \
chr=$i "
done 






