###Changes in Permafrost Bacterial Community Composition after Thaw Across Multiple Alaskan Locations 

###Deseq pipeline. 
### Robert Jones

#####This script is for the thaw incubation study performed over an 8 week period with 6 types of permafrost collected around Alaska.  The study contains 6 replicates for each location.  DNA was extracted in the beginning of the experiment and after an 8 week 4 step thaw (-3,0,3,6). 

# In the paper location names are different than in files names.
#BEO=BEO
#OT27=PT27
#OT45=PT45
#TR=EAFB
#ME=JR


#Load libraries

library(htmltools)
library( "DESeq2" )
library (dplyr)

#font_import()#imports everything.Needs to load 1st time to import all fonts, is time consuming. Then use library("extrafont")


#load in ps5 rsd file
ps5

Raw.phy<-tax_glom(ps5, taxrank="Phylum")

##A list of the top 11 was created for plotting, however all data is included in the calculations
Toprawphylum<-names(sort(taxa_sums(Raw.phy), TRUE)[1:11])
R.ps5.top<-prune_taxa(Toprawphylum,Raw.phy)

Phy11 <- (as.data.frame(R.ps5.top@tax_table))$Phylum

######## First we need to separate each location into its own object


Raw.phy.BEO <- subset_samples(Raw.phy, Location=="BEO")

Raw.phy.OT27 <- subset_samples(Raw.phy, Location=="OT27")

Raw.phy.OT45 <- subset_samples(Raw.phy, Location=="OT45")

Raw.phy.TR <- subset_samples(Raw.phy, Location=="TR")

Raw.phy.ME <- subset_samples(Raw.phy, Location=="ME")


##### convert to a deseq object

#this alpha will make it so we grab everything
alpha=100

#### BEO

#convert to deseq object
dBEO <- phyloseq_to_deseq2(Raw.phy.BEO, ~ Timepoint)

#run deseq
dBEO <- DESeq(dBEO,test = "Wald", fitType = "parametric")

#output the results
resBEO <- results(dBEO,cooksCutoff = FALSE)

#convert them to a datatable
sigtabBEO = resBEO[which(resBEO$padj < alpha), ]

#combine it with taxa
sigtabBEO = cbind(as(sigtabBEO, "data.frame"), as(tax_table(Raw.phy.BEO)[rownames(sigtabBEO), ], "matrix"))
#bring in the location

sigtabBEO$Location <- "BEO"
#and remove unnecessary columns
sigtabBEO <-sigtabBEO %>%  select(!c(Class,Order,Family,Genus))

#### OT27

dOT27 <- phyloseq_to_deseq2(Raw.phy.OT27, ~ Timepoint)
dOT27 <- DESeq(dOT27,test = "Wald", fitType = "parametric")
resOT27 <- results(dOT27,cooksCutoff = FALSE)
sigtabOT27 <- resOT27[which(resOT27$padj < alpha), ]
sigtabOT27 <-  cbind(as(sigtabOT27, "data.frame"), as(tax_table(Raw.phy.OT27)[rownames(sigtabOT27), ], "matrix"))
sigtabOT27$Location <- "OT27"
sigtabOT27 <-sigtabOT27 %>%  select(!c(Class,Order,Family,Genus))

#### OT45

dOT45 <- phyloseq_to_deseq2(Raw.phy.OT45, ~ Timepoint)
dOT45 <- DESeq(dOT45,test = "Wald", fitType = "parametric")
resOT45 <- results(dOT45,cooksCutoff = FALSE)
sigtabOT45 <- resOT45[which(resOT45$padj < alpha), ]
sigtabOT45 <-  cbind(as(sigtabOT45, "data.frame"), as(tax_table(Raw.phy.OT45)[rownames(sigtabOT45), ], "matrix"))
sigtabOT45$Location <- "OT45"
sigtabOT45 <-sigtabOT45 %>%  select(!c(Class,Order,Family,Genus))

####TR

dTR <- phyloseq_to_deseq2(Raw.phy.TR, ~ Timepoint)
dTR <- DESeq(dTR,test = "Wald", fitType = "parametric")
resTR <- results(dTR,cooksCutoff = FALSE)
sigtabTR <- resTR[which(resTR$padj < alpha), ]
sigtabTR <-  cbind(as(sigtabTR, "data.frame"), as(tax_table(Raw.phy.TR)[rownames(sigtabTR), ], "matrix"))
sigtabTR$Location <- "TR"
sigtabTR <-sigtabTR %>%  select(!c(Class,Order,Family,Genus))

####ME

dME <- phyloseq_to_deseq2(Raw.phy.ME, ~ Timepoint)
dME <- DESeq(dME,test = "Wald", fitType = "parametric")
resME <- results(dME,cooksCutoff = FALSE)
sigtabME <- resME[which(resME$padj < alpha), ]
sigtabME <-  cbind(as(sigtabME, "data.frame"), as(tax_table(Raw.phy.ME)[rownames(sigtabME), ], "matrix"))
sigtabME$Location <- "ME"
sigtabME <-sigtabME %>%  select(!c(Class,Order,Family,Genus))

### Bind them togetherinto one file

dALL <- rbind(sigtabBEO,sigtabME)
dALL <- rbind(dALL,sigtabOT27)
dALL <- rbind(dALL,sigtabOT45)
dALL <- rbind(dALL,sigtabTR)

#this will make a new column to indicate whether the difference was signifcant or not
dALL.m <- dALL %>% mutate(Sig=ifelse(padj<.05,"Significant","Not Significant"))

#create a dataframe of the top phylum 
Raw.phy.m <- psmelt(Raw.phy)

#in order to connect the significance to the phylum and the location i'm making a dummy variable of the combined data in the deseq output and in the phyloseq dataframe
dALL.m$LocSig <- paste(dALL.m$Location,dALL.m$Phylum)
Raw.phy.m$LocSig <- paste(Raw.phy.m$Location,Raw.phy.m$Phylum)

#make a dataframe of just the columns we need
dAll.ms <- dALL.m %>% select(Sig,LocSig)

#and merge them together
Raw.phy.msig <- merge(Raw.phy.m,dAll.ms,by="LocSig")


################ This plot includes all the taxa
test_plot<-ggplot(data=Raw.phy.msig)+geom_boxplot(mapping = aes(x=LocTime,y=Abundance,fill=Sig))+facet_wrap(.~Phylum,scales="free_y",ncol=3)+scale_fill_manual(values = c("#000000","#FF0800")) + theme_bw() + theme(axis.text= element_text(size=16), text = element_text(size=16), legend.text = element_text(size = 16), axis.title.x=element_blank()) +  theme(text = element_text(family = "Times New Roman")) + theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1, family = "Times New Roman"))


test_plot + theme_bw() + theme(axis.text= element_text(size=16), text = element_text(size=16), legend.text = element_text(size = 16), axis.title.x=element_blank()) +  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1,)) +  theme(text = element_text(family = "Times New Roman"))

###### This plot contains just the top 11 phyla but all data is included in calculations

#Change order for paper consistency
propord <- c("BEO_Ti","BEO_Tf","OT27_Ti","OT27_Tf","OT45_Ti","OT45_Tf","TR_Ti","TR_Tf", "ME_Ti","ME_Tf")

test_plot<-ggplot(data=(filter(Raw.phy.msig, Phylum %in% Phy11)))+geom_boxplot(mapping = aes(x=LocTime,y=Abundance,fill=Sig))+facet_wrap(.~Phylum,scales="free_y",ncol=3)+scale_fill_manual(values = c("#000000","#FF0800"))+scale_x_discrete(limits=propord) + theme_bw() + theme(axis.text= element_text(size=16), text = element_text(size=16), legend.text = element_text(size = 16), axis.title.x=element_blank()) +  theme(text = element_text(family = "Times New Roman")) + theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1, family = "Times New Roman")) 

test_plot

test_plot<-test_plot + theme_bw() + theme(axis.text= element_text(size=16), text = element_text(size=16), legend.text = element_text(size = 16), axis.title.x=element_blank()) +  theme(axis.text.x = element_text(angle = 50, vjust = 1, hjust=1,))+  theme(text = element_text(family = "Times New Roman")) + theme(legend.position = "none")


###########Plot with legend and x axis removed for figure creation.

test_plot<-test_plot + theme_bw() +  theme(axis.text = element_text(color = "black")) + theme(axis.text= element_text(size=14), text = element_text(size=16), legend.text = element_text(size = 16), axis.title.x=element_blank()) +  theme(axis.text.x = element_blank()) +  theme(text = element_text(family = "Times New Roman")) + theme(legend.position = "none") + theme(panel.grid.minor.y = element_blank())


test_plot


ggsave("~test_plot.png", plot=test_plot,device = "png", scale=1, width=18, height=22, units = "cm", dpi = 1200)


