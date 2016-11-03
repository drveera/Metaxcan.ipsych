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


imputeNA <- function(x){
    #column 6 is maf
    imputedvalue <- x[6]*2
    return(as.data.frame(gsub("NA",imputedvalue,x)))
}

cal.cov <- function(dfm){
    dose.sub.matrix <- t(dfm[,8:ncol(dfm)])
    colnames(dose.sub.matrix) <- dfm$rsid
    dose.cov.matrix <- cov(dose.sub.matrix, use="pairwise.complete.obs")
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

newdose <- dose.merge %>%
    rowwise() %>%
    do(imputeNA(.))

newdose_name=convert = gsub(".gz","",args[2])
write.table(newdose,newdose_name,row.names = FALSE, col.names = FALSE, quote = FALSE)
system(paste0("rm ",args[2]))
system(paste0("gzip ",newdose_name))

doselst <- newdose %>%
    group_by(gene) %>%
    do(cal.cov(.))

cat("done! \n")

print(class(doselst))
print(head(doselst))
print(dim(doselst))


#cat("merging back")
#doselst <- do.call(rbind,doselst)

cat("writing the file")
write.table(doselst,args[3],row.names = FALSE, col.names = FALSE, quote = FALSE)
cat("completed!")
