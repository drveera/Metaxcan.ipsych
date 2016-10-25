
args <- commandArgs(trailingOnly = TRUE)

##args1 bim file
##args2 list file

bim <- read.table(args[1])
                                        #4th column is a1 allele
names(bim) <- c("chrom","rsid","v3","pos","A1","A2")

snp <- read.table(args[2])
                                        #2nd column is a1 allele
names(snp) <- c("rsid","a1")

dfm <- merge(bim,snp,by="rsid")

dfm.sub <- dfm[! dfm$A1 == dfm$a1,]

write.table(dfm.sub$rsid,"rsids.mismatch" sep = "\t", quote = FALSE,
            row.names = FALSE, col.names = FALSE)





