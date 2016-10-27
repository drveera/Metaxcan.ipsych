#!/bin/env Rscript

                                        #args1 snp.file
                                        #args2 dosage file
                                        #args3 outname

args <- commandArgs(trailingOnly = TRUE)

                                        #libraries
library(data.table)
library(reshape2)
library(parallel)

cat("Reading snp files","\n")
dblist.files <- readLines(args[1])
                                        #snp <- read.table(args[1])

                                        #names(snp) <- c("rsid","gene")
#dblist <- list()
#for (i in 1:length(dblist.files)){
#    dblist[[i]] <- read.csv(dblist.files[i], header = TRUE)
#}

dbcsv <- read.csv(args[1], header = TRUE)

cat("Reading dose file")
dose <- fread(paste0("zcat ",args[2]))



cal.cov <- function(dfm){
    dose.sub <- dose[V2 %in% dfm$rsid]
    dose.sub.matrix <- t(dose.sub[,7:ncol(dose.sub),with=FALSE])
    colnames(dose.sub.matrix) <- dose.sub$V2
    dose.cov.matrix <- cov(dose.sub.matrix, use = "na.or.complete")
    dose.cov.melted <- melt(dose.cov.matrix)
    names(dose.cov.melted) <- c("RSID1","RSID2","VALUE")
    GENE <- rep(dfm$gene[1],nrow(dose.cov.melted))
    print("done!")
    print(GENE[1])
    return(cbind(GENE,dose.cov.melted))
}



snp.split <- split(dbcsv,dbcsv$gene)
#doselst <- mclapply(snp.split,cal.cov,mc.cores = 4)
doselst <- lapply(snp.split, cal.cov)
doselst <- do.call(rbind,doselst)
write.table(doselst,paste0(basename(args[1]),".covariance.matrix"),row.names = FALSE, col.names = FALSE, quote = FALSE)    







