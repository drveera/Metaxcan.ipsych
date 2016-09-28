#!/bin/env Rcscript

args <- commandArgs(trailingOnly = TRUE)

                                        #load result file
res <- read.csv(args[1])

res <- read.csv("/home/veera/BartholinGWAS/Veera/example/sample/DGN-WB_0.5.db.csv")

                                        #load ensembl file
bed <- read.table("knowngenes.bed1", header = TRUE)

dfm <- merge(res,bed,by = c("gene_name"))

dfm <- dfm[, c("gene_name","chr","pos","pvalue")]

names(dfm) <- c("SNP", "CHR", "BP", "P")

dfm$CHR <- as.numeric(as.vector(dfm$CHR))

library(qqman)

manhattan(dfm)
