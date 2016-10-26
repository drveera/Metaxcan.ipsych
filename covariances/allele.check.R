
args <- commandArgs(trailingOnly = TRUE)

##args1 bim file
##args2 csv file
##args3 outfile

bim <- read.table(args[1])
                                        #4th column is a1 allele
names(bim) <- c("chrom","rsid","v3","pos","A1","A2")
class(bim$A2) <- "character"
class(bim$A1) <- "character"


snp <- read.csv(args[2], header = TRUE)

                                        #2nd column is a1 allele
class(snp$ref_allele) <- "character"
class(snp$eff_allele) <- "character"



dfm <- merge(bim,snp,by="rsid")

dfm.sub <- dfm[!(dfm$A1 == dfm$eff_allele & dfm$A2 == dfm$ref_allele),]

write.table(dfm.sub$rsid,args[3], sep = "\t", quote = FALSE,
            row.names = FALSE, col.names = FALSE)





