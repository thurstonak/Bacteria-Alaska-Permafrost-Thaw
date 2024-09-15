###Changes in Permafrost Bacterial Community Composition after Thaw Across Multiple Alaskan Locations 

###Filtering Pipeline. 

####This script is for the thaw incubation study performed over an 8 week period with 6 types of permafrost collected around Alaska.  The study contains 6 replicates for each location. DNA was extracted in the beginning of the experiment and after an 8 week 4 step thaw (-3,0,3,6). 

# The location names were changed for the paper.
#Sample data name = Paper name
#BEO = BEO
#OT27 = PT27
#OT45 = PT45
#TR = EAFB
#ME = JR
#DC = DC


####This script follows the "PFT_dada2_pipeline.R" script. Filtering was performed after creation of the phyloseq object "ps"

library(phyloseq)
library(rio)


#import ps.rds
ps<-import(~ps.rds)
#view object
ps.rds

###Determine how many ASVs are in a Kingdom or phylum. Output: ## Archaea = ##, Bacteria = ##, Eukaryota = ##, NA=2##. Does not give information about frequency or abundance.  
table_kingdom<-data.frame(table(tax_table(ps)[, "Kingdom"], exclude = NULL))


#Sequences binned as NA and Eukaryota were checked blasted on NCBI against 16S database for a match.If no match then sequences were removed from the dataset.  
#THis code removed the eukaryota and the NA's sequences, resulting in phyloseq object "ps1".
ps1<-subset_taxa(ps, Kingdom!="Eukaryota")
ps1

#Double check to make sure that ASVs were removed.
table_kingdom_filtered<-data.frame(table(tax_table(ps1)[, "Kingdom"], exclude = NULL))
# now there are Archaea = 104, Bacteria = 9287, for a total of 9391 taxa.


###Get rid of any samples that have zero abundance, resulting in phyloseq object "ps2". 
ps2 <- prune_samples(sample_sums(ps1)>0,ps1)
ps2


##Remove chloroplasts, resulting in phyloseq object "ps3". It is important to include is.na(Order) so that NAs remain in the dataset. 
#https://github.com/joey711/phyloseq/issues/1152
ps3 <- subset_taxa(ps2, (Order!="Chloroplast") | is.na(Order))
ps3


#checked data frame for removal of taxa.  
ps3.taxa.df<-data.frame(ps3@tax_table)
ps2.taxa.df<-data.frame(ps2@tax_table)


# If want exported as csv file, use....
write.csv(ps2.taxa.df,"~ps2.taxa.df.csv")
write.csv(ps3.taxa.df,"~ps3.taxa.df.csv")


############## AT this point ps3.rds was utilized in another program for tree creation. Mitochondria were also removed during this process. See script "xxxx" for next steps.  

