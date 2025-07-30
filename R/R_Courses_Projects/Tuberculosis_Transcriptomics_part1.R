rm(list = ls())

# set working directory
setwd("/Users/TR/Desktop/BIO 445, quantitative life science/06_forstudents")

##############
####Part 1####
##############

# Install pacman if not already installed
if (!requireNamespace("pacman", quietly = TRUE)) {
  install.packages("pacman")
}

# Load pacman
library(pacman)

# Use pacman to load or install packages
p_load(matrixStats, 
       ggplot2, 
       tidyverse, 
       ggridges, 
       FactoMineR, 
       factoextra, 
       foreach,
       doParallel,
       ComplexHeatmap,
       pheatmap,
       cowplot,
       pROC)

#Load raw data data
counts <- read.csv("/Users/TR/Desktop/BIO 445, quantitative life science/06_forstudents/rnaseq_starter_script_part1.R", row.names = c(1))

####Exercise 1 data descriptives and transformation
  #Distribution of patient gene expression (distribution of each column)
  ...
  
  #Transformation log transformed
  # log transform counts
  logcounts <- 
  #Visualize distribution again
  ...

##foreach loop EXAMPLE
  # library(foreach)
  m <- matrix(rnorm(400000), 25000, 16)
  start = Sys.time()
  foreach_example <- foreach(i=1:nrow(m), .combine=c) %do% {
    tres <- t.test(m[i,1:8],m[i,9:16])
    return(tres$p.value)
  }
  stop = Sys.time()
  ## or in parallel (performance benefit with lots of iterations)  
  ## usability depends on your system
  # library(doParallel)
  ##number of usable cores depend on your system, less cores might be actually faster depending on the setup
  registerDoParallel(cores = 4)
  start_par = Sys.time()
  foreach_example_par <- foreach(i=1:nrow(m), .combine=c) %dopar% {
    # T.test
    tres <- t.test(m[i,1:8],m[i,9:16])
    return(tres$p.value)
  }
  stop_par = Sys.time()
  ## Compare runtimes of non-parallelized vs parallelized
  stop - start
  stop_par - start_par
  ##END OF EXAMPLE

####Exercise 2 Volcano

  ##Transpose data (switch rows with columns if required, genes should be columns)
  volcano_data <- ...
  
  # Compare TB to NONTB patients
  # foreach loop: iterate over all genes and calculate a t.test between TB and NONTB patients
  volcano_results <- foreach(i = ..., .combine = "rbind") %dopar%{
    #Make t test
    t_res <- t.test(...)
    #Return the respective gene name, the pvalue, and the mean difference/lfc as a vector
    return(....)
  }
  colnames(volcano_results) <- c("gene","pval","lfc")
  volcano_results <- as.data.frame(volcano_results) %>% 
    mutate_at(c("pval", "lfc"), as.numeric) 
  
  # Volcano plot
  volcano_results %>%
    ggplot(.) ...

####Exercise 3
  # Expected number of significants with 22.000 tests and pvalue threshold 0.05?
  # ????

####Exercise 4 Filter

  ##Calculate the mean and standard deviation of each individual gene
  ## use the "logcount" data frame
  genemeans <- ...
  genesd <- ...
  
  ## Plot mean vs standarddeviation
  plot(...)
  
  # Find lower 25 quantile of means or any other threshold of your choosing
  q25 <- quantile(..., ...)
  # Select genes with mean above the 25 quantile
  whichtosave <- which(...)
  # Filter those genes not selected above
  filtered_counts <- ...
  
  # Select those with a interquartile range above 1 or any threshold of your choosing
  # Use the forexample apply function 
  iqr_pass <- ...
  filtered_counts <- filtered_counts[iqr_pass, ]

####Exercise 5 PCA

  # Transpose data again (if required, genes should be the columns)
  pca_data <- ...
  
  ##PCA basic 
  # Calculate PCA 
  pca_result <- prcomp(...)
  
  # PCA summary
  ...
  
  #extract principal components 
  pcs <- ...
  
  # Plot PC1 vs PC2 ggplot and color by TB status way
  pcs %>% 
    ...
    ggplot(.) ...
  
  # PCA alternative with factorextra and factorminer
  gene_pca_facto <- PCA(...)
  
  # Explained variance
  fviz_screeplot(...)
  
  # Contributions of variables to PC1
  pc1_cont_top10 <- fviz_contrib(...) 
  # Select top 10 contributing variables
  pc1_cont_top10 <- pc1_cont_top10$data %>% ...
  # Contributions of variables to PC2
  pc2_cont_top10 <- fviz_contrib(...) 
  # Select top 10 contributing variables
  pc2_cont_top10 <- pc2_cont_top10$data %>% ...
  
  # Direction of top 10 variables for PC1 and 2
  fviz_pca_var(..., select.var = list(name = c(...)))
  
  # Color PCs by TB status
  fviz_mca_ind(gene_pca_facto, habillage = ..., geom = "point",
               addEllipses = TRUE, repel = TRUE)


####Exercise 6 Heatmap
  # use the filtered_counts data frame
  
  # Heatmap 
  
  #may be required to change col-/row names
  ...
  
  # use functions from the following libraries or the basic R heatmap function
  # library(ComplexHeatmap)
  # library(pheatmap)


####Analyses gene sets
####Exercise 7

  # Gensets modules
  gene_sets <- read.csv("gene_sets.csv")
  
  # Subset to relevant genes previously selected (filtered_counts)
  gene_sets <- gene_sets %>% ...
  
  # 1.
  # Calculate patients wise mean per gene set
  genesets_means <- foreach(i = unique(...), .combine = "rbind") %do% {
    #select genes with the gene set i
    genes_temp <- ...
    #calculated means for each patient for the genes in the gene set i
    temp_data <- ...
    #Return matrix with columns genset_ID, gene set the description, the mean, and the TBstatus with a row for each patient 
    return(cbind(...))
  }
  colnames(genesets_means) <- c("genset_ID","description","mean","TBstatus")
  
  # Transform the data from long to wide format. So that every patient has its own column again
  genesets_means <- genesets_means %>% as.data.frame() %>% 
    pivot_wider(names_from = ..., values_from = ...)
  
  # 2.
  # Calculate t.test, and TBstatus-group-means (use loop or alternatively use the apply function (see example))
  
  #EXAMPLE for t test over each row with a matrix
  ma <- matrix(c(1:20, 1, 10:30), nrow = 7)
  apply(ma, 1, function(x) t.test(x[1:3],x[4:6])$p.value)
  #END OF EXAMPLE 
  
  #based on the example above, calculate the pvalue using a t.test and the group means
  genset_pvalues <- ...
  genset_TB_means <- ...
  genset_NONTTB_means <- ... 
  
  # Add them to the data
  genesets_means <- cbind(...,
                          ...,
                          ...,
                          ...
  )
  
  # Name the added columns
  colnames... <- c("pval","meanTB","meanNONTB")
  
  # Calculate log fold change
  genesets_means <- genesets_means %>% 
    # Some variables may need to be defined as numeric
    mutate(...) %>%
    # Calculate logfoldchange
    mutate(lfc = ...) 
  
  # 3.
  # Volcano plot of geneset pvalues vs logfoldchange
  genesets_means %>%
    ggplot(.) ...
  
  # 4. ggridge plot up and downregulated with TB
  # Select top 10 most significant downregulated/suppressed and upregulated/expressed geneset_IDs
  most_signif_supp <- ...
  most_signif_expr <- ...
  
  # make data frame for downregulated/suppressed genes
  genesets_ridgedat_supp <- genesets_means %>% 
    # filter to above selected top10 genesets
    filter(genset_ID %in% ...) %>%
    # transform back into the long format (keep everything besides the patient specific means in wide format)
    pivot_longer(...) %>%
    # Recode the TBstatus column to "TB" and "NONTB" (if necessary)
    mutate(TBstatus = ...) %>%
    # Define variables as numeric if required
    mutate(...)
  
  # make ridge plot
  down_reg_fig <- ... + geom_density_ridges()
  
  # repeat for upregulated/expressed genes
  ...
  
  # Combine down- and upregulated figure
  # library(cowplot)
  plot_grid(...)

# BONUS 8 machine learning
  # The 'caret' package provides a framework for application of ML algorithms
  # and diagnostics for data analysis
  
  # Perform the following steps:
  # 1. Split the dataset into training and testing subsets 
  
  # 2. Define a tuning grid for hyperparameter tuning 
  # A tuning grid is actually a dataframe or matrix which defines the parameters to be tuned during the training process
  # We are only tuning the mtry parameter controlling for random variables picked during the model training
  
  # use this code
  tunegrid <- expand.grid(.mtry = (1:100)) 
  
  # 3. fit a model
  model <- train(TBstatus ~ ., data = train, 
                 method = "rf",
                 metric = 'Accuracy',
                 tuneGrid = tunegrid,
                 verbose = TRUE,
                 n.trees = 1000)
  
  # 4. Evaluate the performance using the predict function and computing a confusion matrix
  # Tip: Use the pROC package to compute a ROC-Curve and calculate the AUC

