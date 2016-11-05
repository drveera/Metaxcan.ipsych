#!/bin/sh

args <- commandArgs(trailingOnly = TRUE)

##args1 expression
##args2 fam
##args3 pheno
##args4 cov
##args5 outname

##libraries

library(data.table)
library(parallel)

cat("reading fam file \n")
fam <- read.table(args[2])
fam <- fam[1:100,1:2]
names(fam) <- c("FID","IID")

print(head(fam))


cat("reading phenotypes \n")
pheno <- fread(args[3], header = TRUE)
outcome <- names(pheno)[ncol(pheno)]

cat("reading covariance file \n")
covariance <- fread(args[4], header = TRUE)
covs <- names(covariance)[3:ncol(covariance)]

cat("reading expression file \n")
expression <- fread(args[1], header = TRUE, colClasses = "numeric", nrows = 100)
genes <- names(expression)

cat("binding fam and expression \n")
expression <- cbind(fam,expression)
dim(expression)

cat("merge1: pheno and covariance files \n")
pheno.cov <- merge(pheno,covariance, by = c("FID","IID"))

pheno.cov$IID <- as.vector(pheno.cov$IID)
pheno.cov$FID <- as.vector(pheno.cov$FID)

cat("merge2 pheno.cov with expression \n")
dfm <- merge(pheno.cov,expression, by = c("FID","IID"))

if (nrow(dfm) < 1){
    cat("no samples left to analyse in merged file quitting ")
    q()
}

                                        #ANALYSIS

cl <- makeCluster(4)
registerDoParallel(cl)

gene.assoc <- function(dfm,gene,outcome,cov){
    fm <- as.formula(paste0(outcome,"~",outcome,"+",paste(cov,collapse = "+")))
    mod <- glm(fm,data= dfm)
    mod.sum <- summary(mod)$coefficients
    res1 <- row.names(mod.sum)[2]
    res2 <- mod.sum[2,]
    return(c(res1,res2))
}

result <- foreach (gene = genes,
                   .combine = rbind,
                   .errorhandling = 'remove') %dopar%
    gene.assoc(dfm,gene,outcome,covs)

stopImplicitCluster()

names(result) <- c("BETA","STD.ERROR","T-Stats","Pvalue")

write.table(result,args[5], quote = FALSE, sep = "\t", rownames = FALSE)
