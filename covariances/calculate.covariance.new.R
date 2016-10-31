#!/bin/env Rscript

                                        #args1 snp.file
                                        #args2 dosage file
                                        #args3 outname

args <- commandArgs(trailingOnly = TRUE)

                                        #libraries
library(data.table)
library(reshape2)
library(parallel)



                                        #snp <- read.table(args[1])

                                        #names(snp) <- c("rsid","gene")
#dblist <- list()
#for (i in 1:length(dblist.files)){
#    dblist[[i]] <- read.csv(dblist.files[i], header = TRUE)
#}

cat("reading csv file \n")
dbcsv <- read.csv(args[1], header = TRUE)

cat("Reading dose file \n")
dose <- fread(paste0("zcat ",args[2]))
names(dose)[2] <- "rsid"

cat("merging \n")
dose.merge <- merge(dbcsv[,c("rsid","gene")], dose, by = "rsid")
cat("the class of merge data fame ", class(dose.merge))


cal.cov <- function(dfm){
    dose.sub.matrix <- t(dfm[,8:ncol(dfm)])
    colnames(dose.sub.matrix) <- dfm$rsid
    dose.cov.matrix <- cov(dose.sub.matrix, use = "na.or.complete")
    dose.cov.melted <- melt(dose.cov.matrix)
    names(dose.cov.melted) <- c("RSID1","RSID2","VALUE")
    GENE <- rep(dfm$gene[1],nrow(dose.cov.melted))
    return(cbind(GENE,dose.cov.melted))
}



#cat("splitting the data frame by gene \n")
#dose.split <- split(dose.merge, dose.merge$rsid)

#cat("applying the cal.cov function \n")
#doselst <- mclapply(dose.split,cal.cov,mc.cores = 4)
#doselst <- lapply(dose.split, cal.cov)

library(dplyr)
library(dtplyr)
doselst <- dose.merge %.%
    group_by(rsid) %.%
    cal.cov

cat("done!")

#cat("merging back")
#doselst <- do.call(rbind,doselst)

cat("writing the file")
write.table(doselst,paste0(basename(args[1]),".covariance.matrix"),row.names = FALSE, col.names = FALSE, quote = FALSE)
cat("completed!")







