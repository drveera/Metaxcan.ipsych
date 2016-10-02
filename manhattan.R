#!/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
                                        #libraries
library(ggplot2)

                                        #load the data
gwas <- read.csv(args[1])

ensembl <- read.table("/home/veera/BartholinGWAS/Veera/metaxcan/ensembl.gene.id.position")

names(ensembl) <- c("chrom","bp","gene")

gwas <- merge(gwas,ensembl,by="gene")

gwas$chrom <- as.character(gwas$chrom)
gwas$chrom <- gsub("chr","",gwas$chrom)

                                        #group chromosomses
gwas$chrgroup <- replace(gwas$chrom, gwas$chrom %in% seq(1,22,2), 1)
gwas$chrgroup <- replace(gwas$chrgroup, gwas$chrgroup != 1, 0)

class(gwas$chrom) <- "numeric"

gwas$chrom <- factor(gwas$chrom, levels = 1:22)

                                        #reorder
gwas <- gwas[order(gwas$chrom, gwas$bp),]
gwas$index <- 1:nrow(gwas)

sigline <- -log10(0.05/nrow(gwas))
gwas$label <- gwas$gene_name
gwas$label <- replace(gwas$label, -log10(gwas$pvalue) < sigline, NA)

gwas.split <- split(gwas,gwas$chrom)
xbreaks <- sapply(gwas.split,function(x) x$index[round(nrow(x)/2)])



ggplot(gwas,aes(
                index,-log10(pvalue), colour = chrgroup,
                size = -log10(pvalue), label = label
            ))+
    geom_point(shape = 18)+
    scale_size(range= c(0,3))+
    geom_label(nudge_x = 500, colour = "black", size = 2.5) +
    scale_x_continuous(breaks = xbreaks, labels = names(xbreaks)) +
    geom_hline(aes(yintercept = sigline), colour = "red") +
    theme(legend.position="none", panel.grid.minor = element_blank()) +
    labs(x = "chromosome", title = "Manhattan")

  
ggsave(paste0(args[1],".man.pdf"))
