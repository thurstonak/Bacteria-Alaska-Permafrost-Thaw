# Bacteria-Alaska-Permafrost-Thaw

This repository contains details of the thaw incubation study conducted over an 8-week period, using 6 types of permafrost collected from various locations across Alaska. DNA was extracted at the start of the experiment and after an 8-week, 4-stage thaw process, with temperature transitions at -3°C, 0°C, 3°C, and 6°C.

This repo is maintained by Alison Thurston ([@thurstonak](https://github.com/thurstonak)) and includes content from Chris Baker ([@bakerccm](https://github.com/bakerccm)) and Stacey Doherty.

This repository contains scripts used for the analysis of 16S rRNA sequencing data. Raw sequence data has been archived in the NCBI Sequence Read Archive under **BioProject: PRJNA1152638** and is not included in this repository.

The location names were changed for the paper.
- Sample data name = **Paper name**
- BEO = **BEO**
- OT27 = **PT27**
- OT45 = **PT45**
- TR = **EAFB**
- ME = **JR**
- DC = **DC**

## 16S rRNA DNA Sequencing Pipeline

## 1. DADA2 and Phyloseq 

**Description:** Sequences were processed using DADA2, and a phyloseq object was created.

- **Code:** [`PFT_dada2_pipeline.R`](Code/PFT_dada2_pipeline.R)
- **Input:** 16S sequence reads, [`sample_data.txt`](Data/sample_data.txt)
- **Output:** [`ps.rds`](outputs/ps.rds)

## 2. Sequence Filtering

**Description:** Sequences classified as NA, Eukaryota, and chloroplasts were removed.

- **Code:** [`filtering_pipeline.R`](Code/filtering_pipeline.R)
- **Input:** [`ps.rds`](outputs/ps.rds)
- **Output:**
  - [`ps1.rds`](outputs/ps1.rds) (NA and Eukaryota sequences removed)
  - [`ps2.rds`](outputs/ps2.rds) ([`ps1.rds`](outputs/ps1.rds) + samples with zero abundance removed)
  - [`ps3.rds`](outputs/ps3.rds) ([`ps2.rds`](outputs/ps2.rds) + chloroplast sequences removed)

## 3. Mitochondrial Sequence Removal & Tree Construction

**Description:** Sequences classified as mitochondria were removed, and a phylogenetic tree was generated. Some of this step was run on an HPC. 

- **Code:** [snakefile](Code/Chris's code/PFT_SEPP_placement_Chris/snakefile)
- **Input:** [`ps3.rds`](Code/Chris's code/PFT_SEPP_placement_Chris/data/ps3.rds) (copy of file at [`ps3.rds`](outputs/ps3.rds))
- **Output:** [`ps3_pruned_modified_with_tree.rds`](Code/Chris's code/PFT_SEPP_placement_Chris/out/ps3_pruned_modified_with_tree.rds)

## 4. Rarefying & Sample Removal

**Description:** Sequences were rarefied, and DC samples were removed.

- **Code:** [`PFT_rarefy.R`](Code/PFT_rarefy.R)
- **Input:** [`ps3_pruned_modified_with_tree.rds`](outputs/ps3_pruned_modified_with_tree.rds) (copy of file at [`ps3_pruned_modified_with_tree.rds`](Code/Chris's code/PFT_SEPP_placement_Chris/out/ps3_pruned_modified_with_tree.rds))
- **Output:**
  - [`ps4.rds`](outputs/ps4.rds) (DC samples removed)
  - [`ps5.rds`](outputs/ps5.rds) (final phyloseq object after rarefying and DC removal)

---

## Bacterial Diversity & Relative Abundance

Figures 4, 5, and 6 were generated using the following scripts:

- **Alpha diversity & PCoA (Figure 4):** [`PFT_alpha_diversity_and_PCoA.R`](Code/PFT_alpha_diversity_and_PCoA.R)
- **Bacterial relative abundance (Figure 5):** [`PFT_Bacterial_Relative_Abundance.R`](Code/PFT_Bacterial_Relative_Abundance.R)
- **Differential abundance analysis (Figure 6):** [`PFT_deseq.R`](Code/PFT_deseq.R)
- **Input:** [`ps5.rds`](outputs/ps5.rds)

---

## Community Assembly

**Description:** Community assembly analysis was performed using an HPC for some steps, followed by additional modifications in Excel.

- **Code:** [`PFT_assembly.R`](Code/PFT_assembly.R)
- **Input:** [`ps5.rds`](outputs/ps5.rds)
- **Figure 7:** Created with [`PFT_plot_assembly_barchart.R`](Code/PFT_plot_assembly_barchart.R)
- **Input:** [`bin_by_percent_forR_FT_v2.csv`](Data/Data/bin_by_percent_forR_FT_v2.csv)

---

## Soil Properties

**Description:** Soil property data used for Figure 2 was plotted using an R Markdown script.

- **Code:** [`PFT_soilproperties.Rmd`](Code/PFT_soilproperties.Rmd)
- **Input:** [`230810_ANOVA_Soilpropertiesv3.xlsx`](Data/230810_ANOVA_Soilpropertiesv3.xlsx)

---

### Notes
- Some analyses were conducted on an HPC, so modifications may be required to run locally.
- The final processed phyloseq object is [`ps5.rds`](outputs/ps5.rds), which serves as the input for most downstream analyses.

