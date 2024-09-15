###Changes in Permafrost Bacterial Community Composition after Thaw Across Multiple Alaskan Locations 

###alpha diversity and PCoA plot 

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
set.seed(512)
################################################################
ps5<-import(here, "ps5.rds")

ps5_Ti<-subset_samples(ps5, Timepoint == "Ti")
ps5_Ti

ps5_Tf<-subset_samples(ps5, Timepoint == "Tf")
ps5_Tf

alphadiversity<-ps5

Shannon_div <- plot_richness(alphadiversity, x="LocTime", measures=c("Shannon"))+geom_boxplot()+theme(axis.text= element_text(size=12),panel.background = element_rect(fill="white", color="#708090"),panel.border = element_rect(fill = NA, color="Black"),panel.grid.major = element_line(colour = "grey92"), panel.grid.minor = element_line(color = "white", size = 0.25), axis.text.x = element_text(size=12), strip.text=element_text(size=12), axis.title.x = element_text(size=12), axis.title.y = element_text(size=12))+scale_shape_manual(values=c(15,19),na.value=17)+ scale_x_discrete(limits=c("BEO_Ti","BEO_Tf","OT27_Ti","OT27_Tf", "OT45_Ti","OT45_Tf","TR_Ti","TR_Tf", "ME_Ti","ME_Tf"))

print(Shannon_div)

#######################################PCoA plots #####
##################Ordination Plots

PT_samples <- ordinate(ps5, "PCoA", "bray")## Can change type of plot and distance and add k=n to increase the dimensions in NMDS.

samples_plot1<- plot_ordination(ps5,PT_samples, type = "samples", color = "Location", shape= "Timepoint") +theme(axis.text= element_text(size=16), legend.text = element_text(size=16),panel.background = element_rect(fill="white", color="#708090"),panel.border = element_rect(fill = NA, color="Black"),panel.grid.major = element_line(colour = "grey92"),panel.grid.minor = element_line(colour = "white", size = 0.25),axis.text.x = element_text(size=16),strip.text=element_text(size=16),axis.title.x = element_text(size=16),axis.title.y = element_text(size=16)) 

samples_plot1<- samples_plot1 + geom_point(size=4) + scale_shape_manual(values = c(16,17))
samples_plot1$layers<-samples_plot1$layers[-1]
#samples_plot1$layers<-samples_plot1$layers[-1] Removes double layering 

#label = "Replicate" #Adding this in labels the replicates 
samples_plot1

#Seperates out inital and final from combined plot
samples_plot1 +facet_wrap(~Timepoint, 1)



