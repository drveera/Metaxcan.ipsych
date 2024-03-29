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
library(foreach)
library(doParallel)

cat("reading fam file \n")
fam <- read.table(args[2])
fam <- fam[,1:2]
names(fam) <- c("FID","IID")




cat("reading phenotypes \n")
pheno <- fread(args[3], header = TRUE)
names(pheno)[ncol(pheno)] = "outcome"

cat("reading covariance file \n")
covariance <- fread(args[4], header = TRUE)
covs <- names(covariance)[3:ncol(covariance)]

cat("reading expression file \n")
expression <- fread(args[1], header = TRUE, colClasses = "numeric")
expression[1:10,1:10]
genes <- names(expression)

cat("binding fam and expression \n")
expression <- cbind(fam,expression)
dim(expression)

cat("merge1: pheno and covariance files \n")
pheno.cov <- merge(pheno,covariance, by = c("FID","IID"))
pheno.cov$IID <- as.character(pheno.cov$IID)





expression$IID <- as.character(expression$IID)
expression$FID <- as.vector(expression$FID)


cat("merge2 pheno.cov with expression \n")
dfm <- merge(pheno.cov,expression, by = c("FID","IID"))

if (nrow(dfm) < 1)
   {
    cat("no samples left to analyse in merged file quitting ")
    q()
   }
   cat("dimensions of merged data frame \n")
   dim(dfm)

   cat("case control counts \n")
   print(table(dfm$outcome))
   
   

                                        #ANALYSIS

   cl <- makeCluster(16)
   cat("registering 16 cores for parallel processing \n")
   registerDoParallel(cl)
   cat("done! \n")

gene.assoc <- function(dfm,gene,cov){
    fm <- as.formula(paste0("outcome~",gene,"+",paste(cov,collapse = "+")))
    mod <- glm(fm,data= dfm, family = "binomial")
    mod.sum <- summary(mod)$coefficients
    res1 <- row.names(mod.sum)[2]
    res2 <- mod.sum[2,]
    return(c(res1,res2))
}



cat("running logistic regression in 16 cores")


result <- foreach (gene = genes,
                   .combine = rbind,
                   .errorhandling = 'remove') %dopar%
    gene.assoc(dfm,gene = gene,cov = covs)

stopImplicitCluster()



cat("done \n writing the results")

dim(result)
class(result)
head(result)

colnames(result) <- c("TRANSCRIPT","BETA","STD.ERROR","T-Stats","Pvalue")

fwrite(as.data.frame(result),args[5], quote = FALSE, sep = "\t", row.names = FALSE)
