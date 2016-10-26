#!/bin/bash

sqlite3 $1 <<EOF 
.mode csv
.header on
select chr from construction
union all
select * from Weights;
EOF
