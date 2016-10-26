args <-  commandArgs(trailingOnly = TRUE)

                                        #args1 csv file
                                        #args2 outname


dfm <- read.csv(args[1], header = TRUE)
dfm <- dfm[! duplicated(dfm$rsid),]

write.table(dfm[,c("rsid","eff_allele")],args[2],sep = "\t", row.names = FALSE, quote = FALSE, col.names = FALSE)
