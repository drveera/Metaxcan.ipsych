#!/bin/bash

sqlite3 $1 <<EOF 
.mode csv
.header on
select * from Weights;
EOF
