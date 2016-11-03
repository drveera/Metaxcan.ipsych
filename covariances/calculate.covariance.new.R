#!/bin/env Rscript

                                        #args1 snp.file
                                        #args2 dosage file
                                        #args3 outname

args <- commandArgs(trailingOnly = TRUE)

                                        #libraries
library(data.table)
library(reshape2)



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
    dose.cov.matrix <- cov(dose.sub.matrix, use="pairwise.complete.obs")
    dose.cov.melted <- melt(dose.cov.matrix)
    names(dose.cov.melted) <- c("RSID1","RSID2","VALUE")
    GENE <- rep(dfm$gene[1],nrow(dose.cov.melted))
    return(cbind(GENE,dose.cov.melted))
}

imputeNA <- function(vec){
    vec <- as.numeric(as.character(vec))
    vec <- replace(vec,is.na(vec),vec[1])
    return(vec)
}

cat("imputing the NAs \n")
newdoseA <- dose.merge[,1:5]
print(head(newdoseA))
print(nrow(newdoseA))
newdoseB <- apply(dose.merge,1,function(x) imputeNA(x[6:length(x)]))
newdoseB <- as.data.frame(t(newdoseB))
print(head(newdoseB[,1:10]))
print(nrow(newdoseB))
newdose <- as.data.frame(rbind(newdoseA,newdoseB))

cat("done \n")


newdosename=gsub(".gz","",args[2])
cat("writing the new dosage file\n")
write.table(newdose,paste0(newdosename,".new.dosage"), row.names=F,col.names=F,quote=F)
cat("done \n")
library(dplyr)

cat("calculating cov \n")
doselst <- newdose %>%
    group_by(gene) %>%
    do(cal.cov(.))

cat("done! \n")

cat("writing the file")
write.table(doselst,args[3],row.names = FALSE, col.names = FALSE, quote = FALSE)
cat("completed!")
