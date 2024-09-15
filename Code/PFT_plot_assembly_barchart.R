# This script will import a csv file plot assembly processes
library(dplyr)

# First change the working directory to where the data is.
setwd("")
# Import data from .csv file. Data file should have one header row and columns containing each categorical variable.
assem_process = read.csv("bin_by_percent_forR_FT_v2.csv", header=TRUE, sep = ",", dec = ".")



assem_process$process <- factor(assem_process$process,levels = c("Homogeneous_selection", "Heterogeneous_selection", "Homogenizing_dispersal", "Dispersal_limited_Drift", "Drift_alone"))
assem_process$sample <- factor(assem_process$sample,levels = c("BEO-Ti","BEO-Tf","PT27-Ti","PT27-Tf","PT45-Ti","PT45-Tf","EAFB-Ti","EAFB-Tf","JR-Ti","JR-Tf"))
assem_process$tiJR <- factor(assem_process$tiJR,levels = c("Ti", "Tf"))
assem_process$site <- factor(assem_process$site,levels = c("BEO", "PT27", "PT45", "EAFB", "JR"))


# Load ggplot2
library(ggplot2)
#library(wesanderson)
# Values were plotted as a bar chart

# Stacked reverse order - USED THIS ONE
ggplot(assem_process, aes(fill=process, y=value, x=tiJR)) + 
  geom_bar(position="stack", stat="identity") + facet_grid(cols = vars(site)) + theme_classic(base_size = 16) + scale_fill_brewer(palette="RdYlBu", direction=-1) + xlab("Site") + ylab("Relative Contribution (%)") + labs(fill = "Assembly Process")


