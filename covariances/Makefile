#!/bin/make


#write snps/allele list


#extract the snps with force-reference-allele option
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
