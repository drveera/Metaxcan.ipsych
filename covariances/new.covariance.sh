#!/bin/sh

if [ ! $2 ];
then
    echo "usage ./script plinkfile snplist.file"
    exit 1
fi


#inputs
plinkfile=$1
snplist=$2

cut -f 1 $snplist > $snplist.c1

#directories
#script directory
sd=$(dirname $0)

#output
outname=$(basename snplist)

#softwares
source /com/extra/plink/1.90-beta-2016-03/load.sh

make -f $sd/Makefile  plinkfile=$plinkfile snplist=$snplist snplist_c1=$snplist.c1 outname=$outname sd=$sd





