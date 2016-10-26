#!/bin/make

# write oxford format

$(outname).gen:$(outname).mismatch.removed.bim
	plink --bfile $(outname).mismatch.removed \
--recode oxford \
--out $(outname).gen


#write snps/allele list
# create a table of number of snps queried and number of snps extracted
# create a list of snps not extracted along with its transcript IDs

$(outname).snps.not.extracted:$(outname).weights.csv $(outname).mismatch.removed.bim
	Rscript $(sd)/write.snp.report.R $(outname).weights.csv $(outname).mismatch.removed.bim $(outname).snps.not.extracted


#check the allele match again
$(outname).rsids.mismatch.verify: $(outname).mismatch.removed.bim $(outname).snplist $(outname).rsids.mismatch
	Rscript $(sd)/allele.check.R $(outname).mismatch.removed.bim $(outname).weights.csv $(outname).rsids.mismatch.verify

#remove the allele mismatched snps from the plink file
$(outname).mismatch.removed.bim:$(outname).rsids.mismatch  $(outname).bim
	plink --bfile $(outname) \
--exclude $(outname).rsids.mismatch \
--reference-allele $(outname).snplist \
--make-bed \
--out $(outname).mismatch.removed


# check if the alleles match between bim and list files
$(outname).rsids.mismatch:$(outname).bim $(outname).snplist
	Rscript $(sd)/allele.check.R $(outname).bim $(outname).weights.csv $(outname).rsids.mismatch

#extract the snps forcing the reference-allele to 
$(outname).bim:$(plinkfile).bim $(outname).snplist.c1 $(outname).snplist
	plink --bfile $(plinkfile) \
--extract $(outname).snplist.c1 \
--reference-allele $(outname).snplist \
--make-bed \
--out $(outname)


#write snplist and snplist_c1
$(outname).snplist.c1:$(outname).snplist
	cut -f 1 $(outname).snplist > $(outname).snplist.c1
$(outname).snplist:$(outname).weights.csv
	Rscript $(sd)/write.snplist.R $(outname).weights.csv $(outname).snplist

#extract the weights
$(outname).weights.csv: $(db) 
	sh $(sd)/extract.weights.sh $(db) > $(outname).weights.csv
