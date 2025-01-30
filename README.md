# Bacteria-Alaska-Permafrost-Thaw

This repository contains details of the thaw incubation study conducted over an 8-week period, using six types of permafrost collected from various locations across Alaska. DNA was extracted at the start of the experiment and after an 8-week, four-stage thaw process, with temperature transitions at -3°C, 0°C, 3°C, and 6°C.

This repo is maintained by Alison Thurston ([@thurstonak](https://github.com/thurstonak)) and includes content from Chris Baker ([@bakerccm](https://github.com/bakerccm)).
# 16S rRNA DNA Sequencing Pipeline

This repository contains scripts used for the analysis of 16S rRNA sequencing data. Raw sequence data has been archived in the NCBI Sequence Read Archive under **BioProject: PRJNA1152638** and is not included in this repository.

## 1. Sequence Processing with DADA2

**Description:** Sequences were processed using DADA2, and a phyloseq object was created.

- **Code:** `PFT_dada2_pipeline.R`
- **Input:** 16S sequence reads, `sample_data.txt`
- **Output:** `ps.rds`

## 2. Sequence Filtering

**Description:** Sequences classified as NA, Eukaryota, and chloroplasts were removed.

- **Code:** `filtering_pipeline.R`
- **Input:** `ps.rds`
- **Output:**
  - `ps1.rds` (NA and Eukaryota sequences removed)
  - `ps2.rds` (`ps1.rds` + samples with zero abundance removed)
  - `ps3.rds` (`ps2.rds` + chloroplast sequences removed)

## 3. Mitochondrial Sequence Removal & Tree Construction

**Description:** Sequences classified as mitochondria were removed, and a phylogenetic tree was generated. Some of this step was ran on an HPC. 

- **Code:** *Multiple scripts found in Chris's code file*
- **Input:** `ps3.rds`
- **Output:** `ps3_pruned_modified_with_tree.rds`

## 4. Rarefaction & Sample Removal

**Description:** Sequences were rarefied, and DC samples were removed.

- **Code:** `PFT_rarefy.R`
- **Input:** `ps3_pruned_modified_with_tree.rds`
- **Output:**
  - `ps4.rds` (DC samples removed)
  - `ps5.rds` (Final phyloseq object after rarefying and DC removal)

---

## Bacterial Diversity & Relative Abundance

Figures 4, 5, and 6 were generated using the following scripts:

- **Alpha diversity & PCoA (Figure 4):** `PFT_alpha_diversity_and_PCoA.R`
- **Bacterial relative abundance (Figure 5):** `PFT_Bacterial_Relative_Abundance.R`
- **Differential abundance analysis (Figure 6):** `PFT_deseq.R`
- **Input:** `ps5.rds`

---

## Community Assembly

**Description:** Community assembly analysis was performed using an HPC for some steps, followed by additional modifications in Excel.

- **Code:** `PFT_assembly.R`
- **Figure 7:** Created with `PFT_plot_assembly_barchart.R`
- Input: bin\_by\_percent\_forR\_FT\_v2.csv

---

## Soil Properties

**Description:** Soil property data used for Figure 2 was plotted using an R Markdown script.

- **Code:** `PFT_soilproperties.Rmd`
- **Input:** `230810_ANOVA_Soilpropertiesv3.xlsx`

---

### Notes

- Ensure that all required dependencies and R packages are installed before running the scripts.
- Some analyses were conducted on an HPC, so modifications may be required to run locally.
- The final processed phyloseq object is `ps5.rds`, which serves as the input for most downstream analyses.

---

This revision improves structure, formatting, and readability while maintaining all essential details. Let me know if you need further refinements!

