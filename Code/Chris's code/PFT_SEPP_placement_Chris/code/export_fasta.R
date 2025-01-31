# code to extract FASTA from phyloseq object and rename ASVs

# load packages

    # note phyloseq install instructions at https://joey711.github.io/phyloseq/install.html use BiocLite rather than BiocManager as used here; the latter is preferred with R > 3.5
    # library("BiocManager")
    # BiocManager::install("phyloseq")
    library("phyloseq")

    library("Biostrings")

# get file names from command line arguments

    args = commandArgs(trailingOnly=TRUE)

    filenames <- list(
        input_phyloseq = args[1], # .rds file for input phyloseq object
        output_phyloseq = args[2], # .rds file name phyloseq object with sequences extracted and modified ASV names
        output_fasta = args[3] # .fasta file name to save sequences to
    )

# get input data

    ps <- readRDS(filenames$input_phyloseq)

# rename ASVs and store DNA sequences in the refseq slot of the phyloseq object [can be accessed later with refseq(ps)]

    dna <- Biostrings::DNAStringSet(taxa_names(ps))
    names(dna) <- taxa_names(ps)
    ps <- merge_phyloseq(ps, dna)
    taxa_names(ps) <- paste0("ASV_16S_", sprintf("%04d",1:ntaxa(ps)))

# save phyloseq object

    saveRDS(ps, file = filenames$output_phyloseq)

# save sequences to FASTA file

    writeXStringSet(refseq(ps), filepath = filenames$output_fasta)
