#!/bin/env Rscript

                                        #args1 summary file
                                        #args2 summary folder



args <- commandArgs(trailingOnly = TRUE)

library(data.table)

gwas <- fread(args[1])

                                        #gwas <- fread("/home/veera/BartholinGWAS/Veera/metaxcan/temp/pgc_scz/pgc.scz.full.2012-04.txt")


                                        #names(gwas) <- c("SNP","CHR","POS","A1","A2","BETA","SE","PVAL","INFO","NGT","CEUaf")

                                        #write.table(gwas, "/home/veera/BartholinGWAS/Veera/metaxcan/temp/pgc_scz/formatted.summary", quote=FALSE, row.names = FALSE, sep = "\t")



gwas.split <- split(gwas,gwas$CHR)

for (i in names(gwas.split)){
    write.table(gwas.split[[i]], paste0(args[2],"/",i,".sum"), quote = FALSE, sep = "\t", row.names = FALSE)
}
