###Changes in Permafrost Bacterial Community Composition after Thaw Across Multiple Alaskan Locations 

###Bacterial relative abundance plots 

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

library(ggplot2)
library(phyloseq)
library(here)
library(dplyr)
set.seed(512)

ps5<-import(here, "ps5.rds")



################### Pulling out top 11 phylum from the data ############
(taxa_sums(ps5) > 0) %>% sum
ps5.1 <- transform_sample_counts(ps5, function(x) x/ sum(x))
PT_phylum<-tax_glom(ps5.1, taxrank="Phylum")
TopNOTUs<-names(sort(taxa_sums(PT_phylum), TRUE)[1:11])
ps5.top<-prune_taxa(TopNOTUs,PT_phylum)
ps5.top


df.PT_phylum=psmelt(ps5.top)


####################################Picking colors for top 11 charts
phylum_colors<- c(Firmicutes="#e69f00",
                  Actinobacteriota = "#56b4e9",
                  Proteobacteria = "#009e73",
                  Chloroflexi="#f0e442",
                  Bacteroidota="#7d5ddb",
                  Acidobacteriota="#0072b2",
                  Verrucomicrobiota="#000000",
                  Desulfobacterota="#dd5e00",
                  Gemmatimonadota="#cc79a7",
                  Caldisericota="#cbdf89",
                  Patescibacteria="#332288")
                  
###############################Set order for Pre-thaw abundance plots
Tinitial<-c("BEO_Ti_1",
            "BEO_Ti_2",
            "BEO_Ti_3",
            "BEO_Ti_4",
            "BEO_Ti_5",
            "BEO_Ti_6",
            "OT27_Ti_1",
            "OT27_Ti_2",
            "OT27_Ti_3",
            "OT27_Ti_4",
            "OT27_Ti_5",
            "OT27_Ti_6",
            "OT45_Ti_1",
            "OT45_Ti_2",
            "OT45_Ti_3",
            "OT45_Ti_4",
            "OT45_Ti_5",
            "OT45_Ti_6",
            "TR_Ti_1",
            "TR_Ti_2",
            "TR_Ti_3",
            "TR_Ti_4",
            "TR_Ti_5",
            "TR_Ti_6",
            "ME_Ti_1",
            "ME_Ti_2",
            "ME_Ti_3",
            "ME_Ti_4",
            "ME_Ti_5",
            "ME_Ti_6")
################################Set order for Post thaw abundance plots
Tfinal<-c("BEO_Tf_1",
          "BEO_Tf_2",
          "BEO_Tf_3",
          "BEO_Tf_4",
          "BEO_Tf_5",
          "BEO_Tf_6",
          "OT27_Tf_1",
          "OT27_Tf_2",
          "OT27_Tf_3",
          "OT27_Tf_5",
          "OT45_Tf_1",
          "OT45_Tf_2",
          "OT45_Tf_3",
          "OT45_Tf_4",
          "OT45_Tf_5",
          "OT45_Tf_6",
          "TR_Tf_1",
          "TR_Tf_2",
          "TR_Tf_3",
          "TR_Tf_4",
          "TR_Tf_5",
          "TR_Tf_6",
          "ME_Tf_1",
          "ME_Tf_2",
          "ME_Tf_3",
          "ME_Tf_4",
          "ME_Tf_5",
          "ME_Tf_6"
)


#####################Tinitial plotting only top 11 phylum ##########
ps5.Ti <- subset_samples(ps5.top, Timepoint=="Ti") #Timepoint=="Ti"
PT_phylum_Ti<-tax_glom(ps5.Ti, taxrank="Phylum")
df.PT_phylum_Ti=psmelt(PT_phylum_Ti)


ggplot(df.PT_phylum_Ti , aes(x=LocTimeRep, y=Abundance, fill=Phylum))+
  geom_bar(stat="identity", position="stack")+
  scale_fill_manual(values=phylum_colors)+
  theme(legend.position="right", axis.text.x=element_text(angle=90))+
  labs(x="SampleID", y="Relative Abundance")+scale_x_discrete(limits=Tinitial)

plot.PT_phylum.Ti<- ggplot(df.PT_phylum_Ti , aes(x=LocTimeRep, y=Abundance, fill=Phylum))+
  geom_bar(stat="identity", position="stack")+
  scale_fill_manual(values=phylum_colors)+
  theme(legend.position="right", axis.text.x=element_text(angle=90))+
  labs(x="SampleID", y="Relative Abundance")+scale_x_discrete(limits=Tinitial)



plot.PT_phylum.Ti
#Reorder the data so that most abundant is at bottom of graph....
plot.PT_phylum.Ti$data$Phylum <- reorder(plot.PT_phylum.Ti$data$Phylum, plot.PT_phylum.Ti$data$Abundance)
plot.PT_phylum.Ti

#########################Tfinal only with top 11 taxa ##########################
##New plots!!!!!
ps5.Tf <- subset_samples(ps5.top, Timepoint=="Tf") 
PT_phylum_Tf<-tax_glom(ps5.Tf, taxrank="Phylum")
df.PT_phylum_Tf=psmelt(PT_phylum_Tf)


ggplot(df.PT_phylum_Tf , aes(x=LocTimeRep, y=Abundance, fill=Phylum))+
  geom_bar(stat="identity", position="stack")+
  scale_fill_manual(values=phylum_colors)+
  theme(legend.position="right", axis.text.x=element_text(angle=90))+
  labs(x="SampleID", y="Relative Abundance")+scale_x_discrete(limits=Tfinal)

plot.PT_phylum_Tf<- ggplot(df.PT_phylum_Tf , aes(x=LocTimeRep, y=Abundance, fill=Phylum))+
  geom_bar(stat="identity", position="stack")+
  scale_fill_manual(values=phylum_colors)+
  theme(legend.position="right", axis.text.x=element_text(angle=90))+
  labs(x="SampleID", y="Relative Abundance")+scale_x_discrete(limits=Tfinal)


#Reorder the data so that most abundant is at bottom of graph....
plot.PT_phylum_Tf$data$Phylum <- reorder(plot.PT_phylum_Tf$data$Phylum, plot.PT_phylum_Tf$data$Abundance)
plot.PT_phylum_Tf



