# code to add tree back to phyloseq object following SEPP

# load packages

    # note phyloseq install instructions at https://joey711.github.io/phyloseq/install.html use BiocLite rather than BiocManager as used here; the latter is preferred with R > 3.5
    # library("BiocManager")
    # BiocManager::install("phyloseq")
    library("phyloseq")

# get file names

    args = commandArgs(trailingOnly=TRUE)

    filenames <- list(
        "phyloseq" = args[1], # .rds file containing phyloseq object with renamed ASVs
        "placement" = args[2], # placement tree from SEPP
        "output" = args[3] # .rds file containing phyloseq object with placement tree included
    )

# load input phyloseq object

    ps <- readRDS(filenames$`phyloseq`)
    
# attach SEPP placement tree

    sepp_tree <- read_tree_greengenes(filenames$`placement`)

    ps_with_tree <- merge_phyloseq(ps, phy_tree(sepp_tree))

# save phyloseq object with tree

    saveRDS(ps_with_tree, file = filenames$output)
