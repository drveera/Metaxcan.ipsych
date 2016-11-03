#!/bin/sh

while IFS= read line
do
    maf=$(echo $line | cut -f 6 -d " ")
    navalue=$(echo $maf*2 | bc -l)
    echo $line | sed s/NA/$navalue/g 
done < $1
