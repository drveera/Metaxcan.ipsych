#!/bin/sh

awk '{ 
printf $1"\t"
for (i=1; i<=NF; i = i+3)
printf $i + $(i+1) + $(i+2) "\t"
printf "\n"
}' $1

