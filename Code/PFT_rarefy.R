###Changes in Permafrost Bacterial Community Composition after Thaw Across Multiple Alaskan Locations 

###Dada2 pipeline. 

####This script is for the thaw incubation study performed over an 8 week period with 6 types of permafrost collected around Alaska.  The study contains 6 replicates for each location. DNA was extracted in the beginning of the experiment and after an 8 week 4 step thaw (-3,0,3,6). 

# The location names were changed for the paper.
#Sample data name = Paper name
#BEO = BEO
#OT27 = PT27
#OT45 = PT45
#TR = EAFB
#ME = JR
#DC = DC
#PT_EB = EB (extraction blank)


########################

####### load the Libraries #######
#Load everything up
library(ggplot2) #https://ggplot2.tidyverse.org/
library (here)
library(ranacapa)

set.seed(512)
##############ps3 was given to Chris and he removed mitochondria and created a tree. He also changed OTU sequences to OTU names. Will import new rds object from chris and rarify from there.  

ps3<-import(here("ps3_pruned_modified_with_tree.rds")) 
ps3

################Plot rarefaction curve 
#Set 2 colorscheme

[1] "#66C2A5" "#FC8D62" "#8DA0CB" "#E78AC3" "#A6D854" "#FFD92F" "#E5C494" "#B3B3B3"
##plot rarefying curve. 
custom_colors <- c("OT27" = "#A6D854", 
                   "TR" = "#8DA0CB", 
                   "BEO" = "#66C2A5", 
                   "OT45" = "#FFD92F", 
                   "DC" = "#FC8D62", 
                   "ME" = "#E78AC3",
                  "PT_EB" = "#B3B3B3")

rarecurve <- ggrare(ps3,step = 1000,color = "Location")

###To change color of plot
plot_custom <- rarecurve + 
  geom_ribbon(aes(ymin = .S - .se, ymax = .S + .se, fill = Location), alpha = 0.3) +
  scale_fill_manual(values = custom_colors) +
  theme_bw() +  theme(text = element_text(size = 16))

print(plot_custom)

plot_custom <-plot_custom +   scale_color_manual(values = custom_colors) + theme_bw() + theme_bw() + theme(axis.text = element_text(size = 16, family = "Times New Roman"), text = element_text(size = 16, family = "Times New Roman"), legend.text = element_text(size = 14, family = "Times New Roman"), plot.title = element_text(family = "Times New Roman"), plot.subtitle = element_text(family = "Times New Roman"),plot.caption = element_text(family = "Times New Roman"),strip.text = element_text(family = "Times New Roman"))
print(plot_custom)

ggsave((here,"plot_custom.png"),plot=plot_custom,device = "png", width = 30, height = 18, units = "cm", dpi = 600, limitsize = FALSE)

####################################Filter out DC samples
#For this study is was decided that the DC samples are supplemental and not included in the main text, so DC samples are remove prior to rarefying.  

#Remove DC samples
ps4<-subset_samples(ps3, Location != "DC")
ps4

####### Make ps5 #######
##
custom_colors1 <- c("OT27" = "#A6D854", 
                   "TR" = "#8DA0CB", 
                   "BEO" = "#66C2A5", 
                   "OT45" = "#FFD92F", 
                   "ME" = "#E78AC3")
ps5<-rarefy_even_depth(ps4, sample.size = 9104, rngseed = 512)
rarecurve_after<-ggrare(ps5, step = 500, color = "Location") 

plot_custom1 <- rarecurve_after + 
  geom_ribbon(aes(ymin = .S - .se, ymax = .S + .se, fill = Location), alpha = 0.3) +
  scale_fill_manual(values = custom_colors) +
  theme_bw() +  theme(text = element_text(size = 16))

print(plot_custom1)

plot_custom1<-plot_custom1 +   scale_color_manual(values = custom_colors) + theme_bw() + theme(axis.text = element_text(size = 16, family = "Times New Roman"), text = element_text(size = 16, family = "Times New Roman"), legend.text = element_text(size = 14, family = "Times New Roman"), plot.title = element_text(family = "Times New Roman"), plot.subtitle = element_text(family = "Times New Roman"), plot.caption = element_text(family = "Times New Roman"), strip.text = element_text(family = "Times New Roman"))
print(plot_custom1)

ggsave((here,"plot_custom1.png"), plot=plot_custom1,device = "png", width = 30, height = 18, units = "cm", dpi = 600, limitsize = FALSE)

ps5


