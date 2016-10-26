
args <- commandArgs(trailingOnly = TRUE)

##args1 bim file
##args2 csv file
##args3 outfile

bim <- read.table(args[1])
                                        #4th column is a1 allele
names(bim) <- c("chrom","rsid","v3","pos","A1","A2")
bim$A2 <- as.character(bim$A2)
bim$A1 <- as.character(bim$A1)


snp <- read.csv(args[2], header = TRUE)

                                        #2nd column is a1 allele
snp$ref_allele <- as.character(snp$ref_allele)
snp$eff_allele <- as.character(snp$eff_allele)



dfm <- merge(bim,snp,by="rsid")

dfm.sub <- dfm[!(dfm$A1 == dfm$ref_allele & dfm$A2 == dfm$eff_allele),]

write.table(dfm.sub$rsid,args[3], sep = "\t", quote = FALSE,
            row.names = FALSE, col.names = FALSE)





