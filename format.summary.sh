#!/bin/sh

sum=$1
sd=$(dirname $0)
if [ -z $1 ];
then
    echo "usage: ./script summary.file"
    exit 1
fi


sumname=$(basename $sum)

if [ -d $sumname.chfiles ];
then
    echo "folder $sumname.chfiles already exists in the current directory. Either delete it or run the script in a different folder"
    echo "Exiting"
    exit 1
fi

mkdir $sumname.chfiles

Rscript $sd/format.summary.R $sum $sumname.chfiles 
    
    
   
