#!/bin/env Rscript


##args1 summary file
##args2 db csv file
##args3 outname

args <- commandArgs(trailingOnly = TRUE)


##libraries
library(data.table)

##read the summary file

assoc <- fread(args[1], header = TRUE)

assoc <- assoc[assoc$TEST == "ADD",]
names(assoc)[2] <- "rsid"

## read the bim file to get allele information

db <- fread(args[2], sep = ",", header = TRUE)


dfm <- merge(assoc,db,by = "rsid")

dfm <- dfm[,c("CHR","rsid","A1","ref_allele","OR","P")]

print(table(dfm$A1 == dfm$effect_allele))

dfm.split <- split(dfm,dfm$CHR)

for (i in 1:length(dfm.split)){
    fwrite(dfm.split[[i]],paste0(args[3],".chr",i,"sum"), sep = "\t", row.names = FALSE, quote = FALSE)
}









