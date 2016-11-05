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

cat("reading expression file \n")
expression <- fread(args[1], header = TRUE, colClasses = "numeric")
genes <- names(expression)

cat("reading fam file \n")
fam <- fread(args[2], header = FALSE, sep = "\t")
fam <- fam[,1:2,with=FALSE]
names(fam) <- c("FID","IID")

print(head(fam))

cat("binding fam and expression \n")
expression <- cbind(fam,expression)
dim(expression)

cat("reading phenotypes \n")
pheno <- fread(args[3], header = TRUE)
outcome <- names(pheno)[ncol(pheno)]

cat("reading covariance file \n")
covariance <- fread(args[4], header = TRUE)
covs <- names(covariance)[3:ncol(covariance)]

cat("merge1: pheno and covariance files \n")
pheno.cov <- merge(pheno,covariance, by = c("FID","IID"))

cat("merge2 pheno.cov with expression \n")
dfm <- merge(pheno.cov,expression, by = c("FID","IID"))

if (nrow(dfm) < 1){
    cat("no samples left to analyse in merged file quitting ")
    q()
}

                                        #ANALYSIS

gene.assoc <- function(dfm,gene,outcome,cov){
    fm <- as.formula(paste0(outcome,"~",outcome,"+",paste(cov,collapse = "+")))
    mod <- glm(fm,data= dfm)
    return(summary(mod)$coefficients[2,])
}

result <- foreach (gene = genes,
                   .combine = rbind,
                   .errorhandling = 'remove') %dopar%
    gene.assoc(dfm,gene,outcome,covs)

names(result) <- c("BETA","STD.ERROR","T-Stats","Pvalue")

write.table(result,args[5], quote = FALSE, sep = "\t", rownames = FALSE)
