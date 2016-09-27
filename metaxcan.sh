#!/bin/sh

OPTS=`getopt -o h -l outdir:,gwas: -n 'metaxcan' -- "$@"`

eval set -- "$OPTS"


helpmessage() {
    echo "Usage:
metaxcan --gwas /path/to/gwas/summary/files --outdir /path/to/output/folder"
}
while true; do
    case "$1" in
	--outdir) outdir=$2; shift 2 ;;
	--gwas) gwas=$2; shift 2 ;;
	-h | --help) helpmessage; exit 1; shift ;;
	--) shift; break ;;
	*) exit 1 ;;
    esac
    
done




if [ -z $outdir ] || [ -z $gwas ];
then
    echo "type -h for usage"
    exit 1
fi

   

wd=`dirname $0`

while read i
do
    echo "$wd/pipeline.sh $outdir $gwas ${i}_0.5.db ${i}.txt.gz"
    
done < $wd/weights.list

