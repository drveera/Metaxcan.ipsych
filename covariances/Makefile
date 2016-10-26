#!/bin/make


#write snps/allele list
# create a table of number of snps queried and number of snps extracted
# create a list of snps not extracted along with its transcript IDs



#check the allele match again
$(outname).rsids.mismatch.verify: $(outname).mismatch.removed.bim $(db).snplist $(outname).rsids.mismatch
	Rscript $(sd)/allele.check.R $(outname).mismatch.removed.bim $(db).snplist $(outname).rsids.mismatch.verify

#remove the allele mismatched snps from the plink file
$(outname).mismatch.removed.bim:$(outname).rsids.mismatch  $(outname).bim
	plink --bfile $(outname) \
--exclude $(outname).rsids.mismatch \
--reference-allele $(db).snplist \
--make-bed \
--out $(outname).mismatch.removed


# check if the alleles match between bim and list files
$(outname).rsids.mismatch:$(outname).bim $(db).snplist
	Rscript $(sd)/allele.check.R $(outname).bim $(db).snplist $(outname).rsids.mismatch

#extract the snps forcing the reference-allele to 
$(outname).bim:$(plinkfile).bim
	plink --bfile $(plinkfile) \
--extract $(db).snplist.c1 \
--reference-allele $(db).snplist \
--make-bed \
--out $(outname)


#write snplist and snplist_c1
$(db).snplist.c1:$(db).snplist
	cut -f 1 $(db).snplist > $(db).snplist.c1
$(db).snplist:$(db).weights.csv
	Rscript $(sd)/write.snplist.R $(db).weights.csv $(db).snplist

#extract the weights
$(db).weights.csv: $(db) 
	sh $(sd)/extract.weights.sh $(db) > $(db).weights.csv




#rscript



# write oxford format
#plink --bfile $(basename $snplist) \
      --recode oxford \
      --out $(basename $snplist)


# convert to predixcan format



# calculate the covariance matrix     
