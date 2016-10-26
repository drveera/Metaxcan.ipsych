#!/bin/env Rscript


args <- commandArgs(trailingOnly = TRUE)

                                        #args1 db csv file
                                        #args2 bim file
dbsnps <- read.csv(args[1], header = TRUE)

bim <- read.table(args[2])
names(bim) <- c("chrom","rsid","v3","pos","A1","A2")

dbsnps.miss <- dbsnps[! dbsnps$rsid %in% bim$rsid,]

write.table(dbsnps.miss, args[3], sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)




