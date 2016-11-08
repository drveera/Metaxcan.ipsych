#!/bin/env Rscript


##args1 summary file
##args2 bim file 
##args3 outname

args <- commandArgs(trailingOnly = TRUE)


##libraries
library(data.table)

##read the summary file

assoc <- fread(args[1], header = TRUE)

assoc <- assoc[assoc$TEST == "ADD",]
names(assoc)[2] <- "rsid"

## read the bim file to get allele information
bim <- fread(args[2])
names(bim) <- c("chr","rsid","cm","bp","a1","a2")

dfm <- merge(assoc,bim,by = "rsid")
dfm <- dfm[complete.cases(dfm),]
dfm$BETA <- log(dfm$OR)

dfm <- dfm[,c("chr","rsid","bp","a1","a2","OR","BETA","P")]

fwrite(dfm,args[3], sep = "\t", row.names = F, quote = FALSE)
