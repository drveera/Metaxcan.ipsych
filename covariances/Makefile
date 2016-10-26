#!/bin/make


# format in to predixcan
#predixcan file
$(outname).dosage.gz:$(outname).first5columns $(outname).maf $(outname).gen.traw
	paste $(outname).first5columns $(outname).maf $(cut -f 7- $(outname).gen.traw) | gzip > $(outname).dosage.gz
# first 5 columns
$(outname).first5columns:$(outname).gen.traw
	awk '{print "chr" $1 "\t" $2 "\t" $4 "\t" $6 "\t" $5}' $(outname).gen.traw > $(outname).first5columns 
# maf column
$(outname).maf:$(outname).frq
	awk '{print $5}' $(outname).frq | sed 1d > $(outname).maf 

# calculate allele frequencies
$(outname).frq:$(outname).gen $(outname).mismatch.removed.bim
	plink --bfile $(outname).mismatch.removed \
--freq --out $(outname)

# write recode A-transpose format
$(outname).gen.traw:$(outname).mismatch.removed.bim $(outname).snps.not.extracted $(outname).rsids.mismatch.verify
	plink --bfile $(outname).mismatch.removed \
--recode A-transpose tab \
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
