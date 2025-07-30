rm(list = ls())

#set working directory
setwd("/Users/TR/Desktop/BIO 445, quantitative life science/06_forstudents")

################
#####Part 2#####
################
# Alternative analysis with edgeR

# Install BiocManager
if (!requireNamespace("BiocManager", quietly = TRUE)) {install.packages("BiocManager")}


#Install Packages
BiocManager::install("TBSignatureProfiler")
BiocManager::install("clusterProfiler")
BiocManager::install("enrichplot")
BiocManager::install("edgeR")
BiocManager::install(organism, character.only = TRUE)
#Load packages
library(edgeR)
library(enrichplot)
library(org.Hs.eg.db)
library(clusterProfiler)
library(TBSignatureProfiler)
library(tidyverse)

# load data
hivtb_data <- TB_hiv

# Extract counts per million 
hivtb_data <- mkAssay(hivtb_data, log = TRUE, counts_to_CPM = TRUE)

# Look for genes with at least 3 counts above 0.5 count per million
cpmdat <- cbind(hivtb_data@NAMES,hivtb_data@assays@data@listData[["counts_cpm"]]) %>% as.data.frame() %>% rowwise() %>% 
  mutate(tbsum = sum(across(R01_1:R01_9, ~sum(.x>0.5)))) %>% 
  mutate(hivsum = sum(across(R02_17:R02_31, ~sum(.x>0.5)))) %>% 
  filter(hivsum > 2 & tbsum > 2) 

# extract raw counts and filter those out with less than 3 genes with 0.5 counts per million, transform all samples columns into numeric variables
countdat <- cbind(hivtb_data@NAMES,hivtb_data@assays@data@listData[["counts"]]) %>% as.data.frame() %>% filter(V1 %in% cpmdat$V1) %>% 
  mutate(across(R01_1:R02_31, ~as.numeric(.x)))

# create edgeR object (group "1" = TB, group "0" = noTB)
egr <- DGEList(counts = as.matrix(countdat[,2:32]), group = c(rep(1,16),rep(0,15)))

# calculated normalization factors in gene expression samples
egr <- calcNormFactors(egr)

# Dispersion / distribution of gene counts
egr <- estimateDisp(egr)

# Common dispersion is assuming equal mean and sd among genes
# Tagwise dispersion assumes gene-specific dispersions (or genes with a similar distribution)
plotBCV(egr)

# Test gene expression differences between TB and noTB 
# The test is based on a negative binomial distribution 
et <- exactTest(egr)

et$table %>% 
  mutate(logp = -log10(PValue)) %>%
  ggplot(., aes(logFC,logp )) +
  geom_point(aes(color = logp), size = 2/5) +
  xlab(expression("log2 fold change")) + 
  ylab(expression("-log10 pvalue")) +
  scale_color_viridis_c() + theme_minimal()


####################################################
########### Geneset enrichment analysis ###############
####################################################

# We need to specify our organism of interest, so humans.
organism <- "org.Hs.eg.db"

# We need logfoldchange from the previous analysis and gene names
genes <- cbind(et$table$logFC,cpmdat$V1) %>% as.data.frame()

# The gene names, as they are right now are in the "Gene card symbol" format.
# For the analysis we should changed them to the ensembl coding.
hs <- org.Hs.eg.db
genenames <- AnnotationDbi::select(hs, 
                                  keys = genes$V2,
                                  columns = c("ENSEMBL", "SYMBOL"),
                                  keytype = "SYMBOL",
                                  multiVals = "First")

# Some genes could not be recognized and are NA. Other have multiple ensembl ids.
# For simplicity remove the NAs and duplciates (take the first).
genes <- genes %>% merge(.,genenames, by.x = "V2", by.y = "SYMBOL") %>% filter(ENSEMBL != "<NA>") %>% filter(!duplicated(ENSEMBL))

# Now extract the log2fold changes into a single vector, 
# name each value with the corresponding ensembl gene name, and sort the values decreasingly.
genenrich <- as.numeric(genes$V1)
names(genenrich) <- genes$ENSEMBL

# Sort the list in decreasing order 
genenrich <- sort(genenrich, decreasing = TRUE)

# Now we can run the geneenrichment analysis
gse <- gseGO(geneList=genenrich, 
             ont ="ALL", 
             keyType = "ENSEMBL", 
             minGSSize = 3, 
             maxGSSize = 800, 
             pvalueCutoff = 0.05, 
             verbose = TRUE, 
             OrgDb = organism, 
             pAdjustMethod = "none",
             eps = 0)

# Visualisation of enrichment
dotplot(gse, font.size = 5, showCategory=10, split=".sign") + facet_grid(.~.sign)
ridgeplot(gse) + labs(x = "enrichment distribution") + theme(axis.text.y = element_text())

####################################################
########### Bonus: KEGG Pathway analysis ###########
####################################################
BiocManager::install("pathview")
library(pathview)
# Convert gene IDs for gseKEGG function
# We will lose some genes here because not all IDs will be converted
ids <- bitr(names(genenrich), fromType = "ENSEMBL", toType = "ENTREZID", OrgDb=organism)
# remove duplicate IDS (here I use "ENSEMBL", but it should be whatever was selected as keyType)
dedup_ids <- ids[!duplicated(ids[c("ENSEMBL")]),]

# Create a new dataframe df2 which has only the genes which were successfully mapped using the bitr function above
kegg_gene_list <- genenrich[names(genenrich) %in% dedup_ids$ENSEMBL] 

# Name vector with ENTREZ ids
names(kegg_gene_list) <- dedup_ids$ENTREZID

# omit any NA values 
kegg_gene_list <- na.omit(kegg_gene_list)

# sort the list in decreasing order (required for clusterProfiler)
kegg_gene_list <- sort(kegg_gene_list, decreasing = TRUE)

kegg_organism <- "hsa"
kk2 <- gseKEGG(geneList     = kegg_gene_list,
               organism     = kegg_organism,
               minGSSize    = 3,
               maxGSSize    = 800,
               pvalueCutoff = 0.05,
               pAdjustMethod = "none",
               keyType       = "ncbi-geneid",
               eps = 0)

# Produce the native KEGG plot (PNG)
# pick gene set from names(kk2@geneSets) for pathway.id
dme <- pathview(gene.data=kegg_gene_list, pathway.id="...", species = kegg_organism)

