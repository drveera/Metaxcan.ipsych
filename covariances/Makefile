#!/bin/make


#write snps/allele list


#check the allele match again
rsids.mismatch.verify: $(outname).mismatch.removed.bim $(snplist)
	Rscript $(sd)/allele.check.R $(outname).mismatch.removed.bim $(snplist)

#remove the allele mismatched snps from the plink file

$(outname).mismatch.removed.bed:rsids.mismatch  $(outname).bed
	plink --bfile $(outname) \
--exclude rsids.mismatch \
--make-bed \
--out $(outname).mismatch.removed


# check if the alleles match between bim and list files
rsids.mismatch:$(outname).bim $(snplist)
	Rscript $(sd)/allele.check.R $(outname).bim $(snplist)

#extract the snps forcing the reference-allele to 
$(outname).bed:$(plinkfile).bed
	plink --bfile $(plinkfile) \
--extract $(snplist_c1) \
--reference-allele $(snplist) \
--make-bed \
--out $(outname)




# create a table of number of snps queried and number of snps extracted
# create a list of snps not extracted along with its transcript IDs
#rscript




# write oxford format
#plink --bfile $(basename $snplist) \
      --recode oxford \
      --out $(basename $snplist)


# convert to predixcan format



# calculate the covariance matrix     
