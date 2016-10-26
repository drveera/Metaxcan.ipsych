#!/bin/sh

awk '{ 
printf chr$1"\t"$2"\t"$3"\t"$4"\t"$5"\t";
for (i=6; i<=NF; i = i+3)
printf sum/(NF-6)"\t"
{
if($(i+0) == 0 && $(i+1) == 0 && $(i+2) == 0) printf "\tNA"; 
else printf "\t"$(i+0)*0+$(i+1)*1+$(i+2)*2
}; printf "\n"

}' $1


