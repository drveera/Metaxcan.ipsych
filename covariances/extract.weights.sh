#!/bin/bash

sqlite3 $1 <<EOF 
.mode csv
.header on
select chr from construction
union
select * from Weights;
EOF
