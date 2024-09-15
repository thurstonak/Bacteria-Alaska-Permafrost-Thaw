# code to remove mitochondria from phyloseq object supplied by Alison

# load packages

    # note phyloseq install instructions at https://joey711.github.io/phyloseq/install.html use BiocLite rather than BiocManager as used here; the latter is preferred with R > 3.5
    # library("BiocManager")
    # BiocManager::install("phyloseq")
    library("phyloseq")

# get file names from command line arguments

    args = commandArgs(trailingOnly=TRUE)

    filenames <- list(
        input_phyloseq = args[1], # .rds file for phyloseq object from Alison
        output_phyloseq = args[2] # .rds file name for phyloseq object with mitochondria removed
    )

# get data provided by Alison

    ps <- readRDS(filenames$input_phyloseq)

# rename ASVs identified as mitochondria

    ps_filtered <- subset_taxa(ps, Family != "Mitochondria" | is.na(Family))
    
# remove any samples that now have zero reads

    ps_filtered <- prune_samples(sample_sums(ps_filtered) > 0, ps_filtered) 

# save filtered phyloseq object

    saveRDS(ps_filtered, file = filenames$output_phyloseq)
