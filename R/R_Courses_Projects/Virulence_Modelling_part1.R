# Setup ####
rm(list = ls())

# Laden der notwendigen Pakete
# Wir benötigen ggplot2 für die Visualisierung und dplyr für die Datenmanipulation
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("dplyr")) install.packages("dplyr")
if (!require("ape")) install.packages("ape")
if(!requireNamespace("pacman", quietly = T))   install.packages("pacman")
pacman::p_load("gganimate", "ggforce", "tidyverse", "av", "ape", "formatR")

# Laden der Datensätze
getwd()
setwd("/Users/TR/Desktop/BIO 445, quantitative life science/09_for-students/")
getwd()
vl_tr_data <- read.csv("/Users/TR/Desktop/BIO 445, quantitative life science/09_for-students/vl_tr_data.csv", header = FALSE)
colnames(vl_tr_data) <- c("viruslast", "transmissionsrate")

vl_aids_data <- read.csv("/Users/TR/Desktop/BIO 445, quantitative life science/09_for-students/vl_aids_data.csv", header = FALSE)
colnames(vl_aids_data) <- c("viruslast", "zeit_bis_aids")


# Problem 1: Evolution of HIV virulence ####
# a) Load the dataset vl_tr_data.csv. Transform the viral load values to log10 and discuss with your partner why. 


# b) Perform a linear interpolation using approx function in R. 
vl_tr_fun <- approxfun(vl_tr$logvl, vl_tr$tr, method = "linear", rule = 2)


# c) Try to understand what we are plotting with the provided code. 
plot(seq(1, 7, by = 0.1), sapply(seq(1, 7, by = 0.1), vl_tr_fun), 
     type = "l", lty = 2, xlim = c(3, 6), 
     xlab = "log10 viral load", ylab = "transmission rate")


# d) Load the dataset vl_aids_data.csv, prepare dataset, and visualize the association between the viral load and time to AIDS.


# e) Write a function that approximates the viral fitness as the product of transmission rate and mean time until AIDS progression. 
# Then, plot the association between viral load and viral fitness. For which viral load does the viral fitness peak?
fitness_fun <- function(x) {??}


# f) For simulation, please follow the following steps and complete the given R code. 
# i) 
population_size <- 1000
number_generations <- 500

# ii) 
sigma_environmental <- 0.8
sigma_mutation <- 0.1

# iii) 
population_genetic <- ?
population_realized <- ?
  
# iv) 
initial_vl <- 3
population_genetic[, 1] <- ?
  
# v)
#for loop over the number of generations
for(k in 1:(number_generations - 1)) { 
  # extract the genetic component of virus load in the kth generation of the matrix
  genetic_vl <- population_genetic[k, ]
    
  # add normal distributed environmental term to get the realized virus load
  population_realized[k, ] <- genetic_vl + rnorm(population_size, mean=0, sd=sigma_environmental)
    
  # get the fitness of the kth population using fitness_fun function
  fitness <- sapply(population_realized[k, ], fitness_fun())
  
  # get the number of offspring in the next generation 
  # by using a multinomial distribution with the calculated fitness
  # the population size remains constant but fitter individuals are
  # more likely to have offspring
  help (rmultinom)

  number_offspring <- rmultinom(1, population_size, ?)
  
  # unmutated genetic component is passed on to the offspring
  genetic_vl_unmutated <- unlist(sapply(??, FUN = function(x) {rep(genetic_vl[x], number_offspring[x])}))
  
  # add mutations to the viral component, approximated by normal distribution
  # then, save it as genetic components of next generation 
  population_genetic[, k + 1] <- ?
}


# g) Make a plot to show how the population mean viral load behaves over time.
plot(?)


# h) Combine our plot from e) with the distribution of the viral load in different generations 
# nice colors: start with blue colors and go more and more towards coral colored ones
palette <- colorRampPalette(c("darkblue", "coral"))

# which generation do we want to show?
colour_seq <- seq(10, 80, by = 10)
palette <- palette(length(colour_seq))

for(k in colour_seq){ 
  lines(density(??), col = palette[k/10], lwd = 2)
}
legend("topright", col = palette, legend = paste("gen", colour_seq), lwd = 1)
