#!/bin/sh

sd=`dirname $0`
db=
out=
#step1 extract weights from the db file

sh $sd/extract.weights.sh $db > $out.weights
