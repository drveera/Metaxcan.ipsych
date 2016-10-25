args <-  commandArgs(trailingOnly = TRUE)


dfm <- read.csv(args[1], header = TRUE)
dfm <- dfm[! duplicated(dfm$rsid),]

write.table(dfm[,c("rsid","eff_allele")],paste0(args[1],".snp.list") ,sep = "\t", row.names = FALSE, quote = FALSE, col.names = FALSE)
