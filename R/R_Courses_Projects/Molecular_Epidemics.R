
# Molecular Epidemiology Exercise Solutions
# Annotated R Script

# Required Libraries
if (!requireNamespace("ape", quietly = TRUE)) {
  install.packages("ape")
}
library(ape)
if (!requireNamespace("phangorn", quietly = TRUE)) {
  install.packages("phangorn")
}
library(phangorn)

# Section 1: Data Import and Preparation
setwd("/Users/TR/Desktop/BIO 445, quantitative life science/day05_2024_Molecular_Epi_Students")
# Importing FASTA files for analysis
primates <- read.dna(file = "sequences_primates.fasta", format = "fasta", as.character = TRUE, as.matrix = FALSE)
primates_unequal <- read.dna(file = "sequences_primates_unequal_length.fasta", format = "fasta", as.character = TRUE, as.matrix = FALSE)
hiv_siv <- read.dna(file = "HIV_SIV_alignment.fasta", format = "fasta", as.character = TRUE, as.matrix = FALSE)
criminal_case <- read.dna(file = "criminal_case_aligned.fasta", format = "fasta", as.character = TRUE, as.matrix = FALSE)

# Section 2: Exercise 1 - Measure the similarity between sequences

# (a) Function to calculate Hamming distance
hamming_2seq <- function(seq1, seq2) {
  sum(seq1 != seq2, na.rm = TRUE)
}

hamming_alignment <- function(alignment) {
  n <- length(alignment)
  m <- matrix(nrow = n, ncol = n)
  for (i in 1:n) {
    for (j in i:n) {
      m[j, i] <- m[i, j] <- hamming_2seq(alignment[[i]], alignment[[j]])
    }
  }
  rownames(m) <- names(alignment)
  colnames(m) <- names(alignment)
  return(m)
}

# Calculate Hamming distance for primates dataset
dist_hamming <- hamming_alignment(primates)
print("Hamming Distance Matrix:")
print(dist_hamming)

# (b) JC69 Model Implementation
jc69_distance <- function(hamming_dist, seq_length) {
  p <- hamming_dist / seq_length
  -3/4 * log(1 - (4/3) * p)
}

# Example JC69 calculation
seq_length <- nchar(primates[[1]])
dist_jc69 <- jc69_distance(dist_hamming, seq_length)
print("JC69 Distance Matrix:")
print(dist_jc69)

# Section 3: Exercise 2 - Phylogenetic Tree with UPGMA
# (a) Using the UPGMA skeleton code provided to build a tree
# (To be completed)

# Section 4: Application of Phylogenetics
# (a) HIV phylogeny analysis using Neighbor Joining
dist_hiv_siv <- dist.dna(hiv_siv, model = "JC69")
nj_tree <- nj(dist_hiv_siv)
plot(nj_tree, main = "Phylogenetic Tree: HIV and SIV")

# Section 5: Criminal Case Analysis
# (a) Phylogenetic analysis of the criminal case dataset
dist_criminal_case <- dist.dna(criminal_case, model = "JC69")
criminal_tree <- nj(dist_criminal_case)
plot(criminal_tree, main = "Criminal Case Phylogenetic Tree")

# Additional sections for discussion and interpretation can be added here.

