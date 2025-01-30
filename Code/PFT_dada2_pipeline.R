###Changes in Permafrost Bacterial Community Composition after Thaw Across Multiple Alaskan Locations 

###Dada2 pipeline. 
###Alison Thurston
####This script is for the thaw incubation study performed over an 8 week period with 6 types of permafrost collected around Alaska.  The study contains 6 replicates for each location. DNA was extracted in the beginning of the experiment and after an 8 week 4 step thaw (-3,0,3,6). 

# The location names were changed for the paper.
#Sample data name = Paper name
#BEO = BEO
#OT27 = PT27
#OT45 = PT45
#TR = EAFB
#ME = JR
#DC = DC


########################

####### load the Libraries #######
#Load everything up
library(ggplot2) #https://ggplot2.tidyverse.org/
library(gridExtra)
library(dada2) #https://benjjneb.github.io/dada2/
library(tidyverse) #https://www.tidyverse.org/

set.seed(512)

####### Pre-processing Pipeline #######

#Set the path to directory where sequences are located.
miseq_path <- "~/16S" 

#List out files to check
list.files(miseq_path)

# Seperate the forward and reverse reads. It's important to keep the read order the same. The program just matches based on order of list not on name. 
#Forward and reverse fastq filenames have format: SAMPLENAME-R1.fastq and SAMPLENAME-R2.fastq
fnFs <- sort(list.files(miseq_path, pattern="-R1.fastq", full.names = TRUE))
fnRs <- sort(list.files(miseq_path, pattern="-R2.fastq", full.names = TRUE))

#Check order of forward and reverse reads
fnFs
fnRs

# Extract sample names, filenames have format: SAMPLENAME-XXX.fastq
sample.names <- sapply(strsplit(basename(fnFs), "-"), `[`, 1)

#list sample names and check order
sample.names

#Check the quality of the reads by plotting.
fnFSlength <- length(fnFs)
plotQualityProfile(fnFS[1:fnFslength])

#Check the quality of the reads by plotting.
fnRSlength <- length(fnRs)
plotQualityProfile(fnRS[1:fnRslength])


# Place filtered files in filtered/ subdirectory
filtFs <- file.path(miseq_path, "filtered", paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path(miseq_path, "filtered", paste0(sample.names, "_R_filt.fastq.gz"))
names(filtFs) <- sample.names
names(filtRs) <- sample.names


out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs,trimLeft = 34, truncLen=c(216,170),
                     maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE,
                     compress=TRUE, multithread=FALSE) 
head(out)

#and view the new trimmed sequences

#Check the quality of the reads by plotting
filtFslength <- length(filtFs)
plotQualityProfile(filtFs[1:filtFslength])


#Check the quality of the reads by plotting
filtRslength <- length(filtRs)
plotQualityProfile(filtRs[1:filtRslength]) 

#Convert it into a dataframe
out1 <- as.data.frame(out)
#And look at the percent lost
out2 <- mutate(out1, percent_lost=((reads.in-reads.out)/reads.in*100))

#Next need to dereplicate 

derepF1 <- derepFastq(filtFs, verbose=TRUE)
derepR1 <- derepFastq(filtRs, verbose=TRUE)


#Learned error rates
errF <- learnErrors(derepF1, multithread=FALSE)

plotErrors(errF, nominalQ=TRUE)


errR <- learnErrors(derepR1, multithread=FALSE)

plotErrors(errR, nominalQ=TRUE)

#run dada2 and infer sequence variance
dadaF1 <- dada(derepF1, err=errF, multithread=FALSE)
print(dadaF1)
dadaR1 <- dada(derepR1, err=errR, multithread=FALSE)
print(dadaR1)

#merge paired reads

merger1 <- mergePairs(dadaF1, derepF1, dadaR1, derepR1, verbose=TRUE)

#make a sequence table
seqtab <- makeSequenceTable(merger1)
dim(seqtab)

# Inspect distribution of sequence lengths
table(nchar(getSequences(seqtab)))

#Remove Chimeras
seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=FALSE, verbose=TRUE)
dim(seqtab.nochim)

sum(seqtab.nochim)/sum(seqtab)

#Track reads
getN <- function(x) sum(getUniques(x))
track <- cbind(out, sapply(dadaF1, getN), sapply(dadaR1, getN), sapply(merger1, getN),rowSums(seqtab.nochim))
colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")
rownames(track) <- sample.names
head(track)

Seq.tracked <- as.data.frame(track)
write.table(Seq.tracked, file = "Seq_tracked.txt", col.names = NA,quote = FALSE)

####Assign Taxonomy########
# We used the SILVA database Update nr99 v138.  Downloaded on 9/2/2020. https://zenodo.org/records/3986799#.X1Ev2HlKhaQ

SILVAassignment <-"silva_nr99_v138_train_set.fa.gz"
taxa_SILVA <- assignTaxonomy(seqtab.nochim, SILVAassignment,outputBootstraps=TRUE, multithread=FALSE)


#seperate bootstrap data from maxtrix
taxaSILVA.max<-as.matrix(taxa_SILVA[["tax"]])
#make as a dataframe to view
taxa_SILVA.df<-data.frame(taxa_SILVA)
write.csv(taxa_SILVA.df, "~/taxa_silva_df.csv",row.names=FALSE)
write.csv(taxaSILVA.max, "C~/taxa_silva_max.csv",row.names=FALSE)

##################Hand off to phyloseq to create a phyloseq object####################################

 
library(phyloseq) #https://joey711.github.io/phyloseq/

sample_dataframe <- as.data.frame(read.table("sample_data.txt",sep="\t", header=TRUE, row.names = 1))

samdf <- sample_data(sample_dataframe)

#combine all the sample data, taxa table and ASV table

ps <- phyloseq(otu_table(seqtab.nochim, taxa_are_rows=FALSE), 
               sample_data(samdf), 
               tax_table(taxaSILVA.max))
library(rio) #data import and export 

export(ps,"ps.rds") #ps.rds is all data after dada2 and phyloseq pipeline 
