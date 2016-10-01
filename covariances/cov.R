#!/bin/env Rscript

                                        #args1 weights file
                                        #args2 dosage.snps.map file

args <- commandArgs(trailingOnly = TRUE)

wt <- read.csv(args[1])

library(data.table)
map <- fread("dosage.map/all.snps.txt", header = FALSE)

names(map) <- c("chr","rsid")
wt <- merge(wt,map,by="rsid")


wt.split <- split(wt, wt$chr)

for (i in names(wt.split)){
    write.table(wt.split[[i]][,1:2],paste0(args[2],"/",i,".snps"),quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")
}



