#!/bin/sh

OPTS=`getopt -o h -l out:,gwas:,nojob,pop: -n 'metaxcan' -- "$@"`

eval set -- "$OPTS"


helpmessage() {
    echo "Usage:
metaxcan --gwas /path/to/gwas/summary/files --out outputname"
}
while true; do
    case "$1" in
	--out) out=$2; shift 2 ;;
	--gwas) gwas=$2; shift 2 ;;
	--pop) pop=$2; shift 2 ;;
	--nojob) nojob=true; shift ;; 
	-h | --help) helpmessage; exit 1; shift ;;
	--) shift; break ;;
	*) exit 1 ;;
    esac
    
done




if [ -z $out ] || [ -z $gwas ];
then
    echo "One or more arguments missing
type -h for usage"
    exit 1
fi

   

wd=`dirname $0`

if [ -d $out ];
then
    echo "$out folder already exists. Check if you have already summitted this job. Either delete the folder or give a different out name"
    exit 1
fi




mkdir $out

if [ ! -z $pop ];
then
    echo "population $pop chosen"
fi

if [ ! -z $nojob ];
then
    while read i
    do
	$wd/pipeline.sh $out $gwas $wd/${i}_0.5.db $wd/${i}.txt.gz.${pop}
    done < $wd/weights.list${pop}
    
else
    
while read i
do
    echo "$wd/pipeline.sh $out $gwas $wd/${i}_0.5.db $wd/${i}.txt.gz${pop}"
    
done < $wd/weights.list${pop} > $out/$out.adispatch

head -1 $out/$out.adispatch > $out/$out.job1.adispatch

sed 1d $out/$out.adispatch > $out/$out.other.jobs.adispatch

job1id=`adispatch --mem=4g $out/$out.job1.adispatch | awk '{print $NF}'`

adispatch --mem=4g --dependency=afterok:$job1id $out/$out.other.jobs.adispatch

echo "Metaxcan jobs submitted successfully. Wait till the jobs are done. You can check the running jobs status with command 'mj'"

fi



