# Setup ####
rm(list = ls())
if(!requireNamespace("pacman", quietly = T))   install.packages("pacman")
pacman::p_load("gganimate", "ggforce", "tidyverse", "av", "ape", "formatR")

# Problem 2: Heritability of HIV set-point viral load ####
# a) 
tree_spvl <- read.tree(file = "tree_spvl")
plot(tree_spvl)


# b) 
# Check what extract.clade does -> what do we need?

# This function gives the label of an internal node connected to the certain tip
find_node <- function(id, tree) { # id represents viral load
  # Find a position/order of a corresponding tip to id 
  tip <- match(??, ??)
  
  # Get the internal node connected to the tip that we found above in the edge list
  node <- tree$edge[match(as.numeric(??), tree$edge[, 2]), ][1]
  
  if(!is.na(node)) { 
    return(as.numeric(node))
  }
}

# This function returns c(NA,NA) if this patient (tip label = id) is not in a transmission
# pair or returns the name of the tip labels if he/she is in a transmission pair
# (so the tip label of the patient and the other member of the pair)
find_pair <- function(tree, id) { 
  # Keep all the tips from a given node
  clade <- extract.clade(??)
  
  # Check the length of extracted clade and return the desired output
  # hint: Think of what criteria will be required to indicate a pair
  if (length(clade$tip.label) != ??) {
    return (c(NA, NA)) 
  } else { 
    return (??) 
  }
}

#This function returns all transmission pairs
transmission_pairs <- function(tree) { 
  # Return a list of the transmission pair using find_pair function across tips
  pair <- lapply(??, FUN=function(a) {find_pair(tree, a)})
  
  # Select the non NA & unique transmission pairs
  # hint: You want to go through all lists in "pair" to see whether the element in each list is NA or not
  pair <- unqiue(pair[sapply(pair, function(a){??})])
  
  # creating a pair matrix to indicate which tip is connected to which
  pair_mat <- matrix(c(map_chr(pair, 1), map_chr(pair, 2)), ncol = 2)
  colnames(pair_mat) <- c("tip1", "tip2")
  row.names(pair_mat) <- paste0("pair", 1:nrow(pair_mat))
  
  return(??)
}

# Get all transmission pairs in the tree
pairs <- ??
print(pairs)

# Plot the tree again, highlighting the transmission pair that you found with transmission_pair function
col <- rep("darkblue", length(tree_spvl$tip.label))
for (i in 1:length(tree_spvl$tip.label)){
  if (tree_spvl$tip.label[i] %in% ??){col[i] <- "gold"}
}
plot(tree_spvl, tip.color = col)


# c)
# Create a matrix for transmission pairs
pairs_num <- matrix(as.numeric(pairs), ncol = 2)
colnames(pairs_num) <- colnames(pairs)
row.names(pairs_num) <- row.names(pairs)

# Select the first element in pairs_num matrix as parent
parent <- pairs_num[??]
print(paste0("parents: ", paste0(parent, collapse = ", ")))

# Select the second element in pairs_num matrix as offspring
offspring <- pairs_num[??]
print(paste0("offspring: ", paste0(offspring, collapse = ", ")))

# Perform a linear regression and extract coefficients
heritability = coefficients(lm(parent ~ offspring))[2]


# d) Random sampling for parent and offspring
heritability_random = c()
for(i in 1:1000){
  parent_rand <- 
  offspring_rand <- 
  
  heritability_random[i] = coefficients(lm(parent_rand~offspring_rand))[2]
}

hist(heritability_random) # variability in the set point viral load
Rmisc::CI(heritability_random) # gives you CI


# e)


# Functions ####
find_node <- function(id, tree) {
  tip <- match(id, tree$tip.label)
  node <- tree$edge[match(as.numeric(tip), tree$edge[, 2]), ][1]
  
  if(!is.na(node)) {return(as.numeric(node))}
}

find_pair <- function(tree, id){
  clade <- extract.clade(tree, find_node(id, tree)) 
  if (length(clade$tip.label) != 2) {return (c(NA, NA))} 
  else {return (clade$tip.label)}
}

transmission_pair <- function(tree){
  pair <- lapply(tree$tip.label, FUN=function(a) {find_pair(tree, a)})
  pair <- unique(pair[sapply(pair, function(a){!is.na(a[1])})]) 
  
  pair_mat <- matrix(c(map_chr(pair, 1), map_chr(pair, 2)), ncol = 2)
  colnames(pair_mat) <- c("tip1", "tip2")
  row.names(pair_mat) <- paste0("pair", 1:nrow(pair_mat))
  
  return(pair_mat)
}