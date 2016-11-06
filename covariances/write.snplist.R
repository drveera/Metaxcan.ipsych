args <-  commandArgs(trailingOnly = TRUE)

                                        #args1 csv file
                                        #args2 outname

library(data.table)
dfm <- fread(args[1], header = TRUE)

dfm <- dfm[!duplicated(rsid)]


write.table(dfm[,c("rsid","eff_allele"),with=FALSE],args[2],sep = "\t", row.names = FALSE, quote = FALSE, col.names = FALSE)
