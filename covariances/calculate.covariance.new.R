#!/bin/env Rscript

                                        #args1 plink traw file
                                        #args2 plink frq  file
                                        #args3 db csv file
                                        #args4 outname


args <- commandArgs(trailingOnly = TRUE)

                                        #libraries
library(data.table)
library(reshape2)
library(doParallel)
library(foreach)
library(parallel)



cat("reading csv file \n")
dbcsv <- fread(args[3], header = TRUE, sep = ",")
dbcsv <- as.data.frame(dbcsv)
cat("Reading dose file \n")

##args1 gene.traw file
dose <- fread(args[1], header = TRUE)
dose <- as.data.frame(dose)

##args[2] freq file
frq <- fread(args[2], header = TRUE)
frq <- as.data.frame(frq)

maf2 <- frq$MAF*2
dose$maf <- frq$MAF
dose <- dose[,c(1,2,4,6,5,ncol(dose),7:(ncol(dose)-1))]



cal.cov <- function(dfm){
    dose.sub.matrix <- t(dfm[,8:ncol(dfm)])
    colnames(dose.sub.matrix) <- dfm$rsid
    dose.cov.matrix <- cov(dose.sub.matrix, use="pairwise.complete.obs")
    dose.cov.melted <- melt(dose.cov.matrix)
    names(dose.cov.melted) <- c("RSID1","RSID2","VALUE")
    GENE <- rep(dfm$gene[1],nrow(dose.cov.melted))
    return(cbind(GENE,dose.cov.melted))
}


imputeNA <- function(vec){
    vec <- as.numeric(as.character(vec))
    vec <- replace(vec,is.na(vec),vec[1]*2)
    return(vec)
}


impute1NA <- function(maf,vec){
    nacols <- is.na(vec)
    vec[nacols] <- maf[nacols]
    return(vec)
}



cat("imputing the NAs \n")
newdoseA <- dose[,1:6]

cl <- makeCluster(16)
registerDoParallel(cl)

newdoseB <- foreach(cnum = 7:ncol(dose),
                    .combine = cbind,
                    .errorhandling = 'remove') %dopar%
    impute1NA(maf2,dose[,cnum])

stopImplicitCluster()

newdose <- as.data.frame(cbind(newdoseA,newdoseB))
names(newdose)[2] <- "rsid"
cat("done \n")



cat("writing the new dosage file\n")
write.table(newdose,paste0(args[4],".dosage"), row.names=F,col.names=F,quote=F)
cat("done \n")

cat("merging \n")
dose.merge <- merge(dbcsv[,c("rsid","gene")], newdose, by = "rsid")


library(dplyr)

cat("calculating cov \n")
doselst <- dose.merge %>%
    group_by(gene) %>%
    do(cal.cov(.))

cat("done! \n")

cat("writing the file")
write.table(doselst,paste0(args[4],".covariance.matrix"),row.names = FALSE, col.names = FALSE, quote = FALSE)
cat("completed!")
