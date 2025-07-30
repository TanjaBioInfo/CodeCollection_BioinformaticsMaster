## R^2 berechnen wie im mock exam, bzw. R^2 decomposed, erklärt die Proportion der Varianz erklärt von allen Vx:
# --> zeigt die relative Wichtigkeit im erklären der Daten auf 

## clear R
rm(list = ls())
## load some libraries
library(tidyverse)
library(ggfortify)
library(relaimpo)
library(coefplot)


Datensatz_all <- read_delim("~/Desktop/RStudio_Datenanalyse_2022/Master_Datasets/Datensatz.txt", "\t")
# oder:
# Datensatz_all <- read::read_delim("~/Desktop/RStudio_Datenanalyse_2022/Master_Datasets/Datensatz.txt", "\t", escape_double = FALSE, trim_ws = TRUE)
# oder:
# Datensatz_all <- read_csv("https://Datensatz.csv")

# And, we'll do one more, and that is set R to fail if there are NAs. 
# This is quite important, as some model comparison methods will happily compare models using different datasets, 
# which can be caused by have NAs in some variables and not others.
options(na.action = "na.fail")

# And keep only the important variables, and remove duplicates:
Datensatz <- dplyr::select(Datensatz_all, Vy, Vx2, Vx11, Vx6, Vx7, Vx10, Vx4, Vx12,
                           Vx8, Vx9, Vx1, Vx5, Vx3) %>%
  na.omit()

## histogram of the Vy measurements
ggplot(data=Datensatz, aes(x=Vy)) + geom_histogram(bins=20)

## plot distributions of each of the variables
## this uses the gather function to wrangle the data into tidy format, for easy plotting by qplot
ggplot(data=gather(Vy, key=variable, value=value),
       aes(x=value)) +
  geom_histogram(bins=20) +
  facet_wrap(~variable, scales="free")

## look at the graphs of variables plotted against each other,
## to get an idea of which variables might best predict Vy.
pairs(Vy)

## make the three models...
m_both <- lm(Vy ~ Vx2 + Vx1, data=Datensatz)
m_Vx1 <- lm(Vy ~ Vx1, data=Datensatz)
m_Vx2 <- lm(Vy ~ Vx2, data=Datensatz)
## and get the r-squared of each
summary(m_both)$r.squared
summary(m_Vx1)$r.squared
summary(m_Vx2)$r.squared

## unique to Vx2 (ist both minus Vx1), das ist Importance = effect size der Vx2
summary(m_both)$r.squared - summary(m_Vx1)$r.squared
## unique to Vx1 (ist both minus Vx2), das ist Importance = effect size der Vx1
summary(m_both)$r.squared - summary(m_Vx2)$r.squared

## shared (ist both minus unique to Vx2 minus unique to Vx1), das ist die Teilmenge = Korrelation = Kolinerity
summary(m_both)$r.squared - (summary(m_both)$r.squared - summary(m_Vx1)$r.squared)-
  (summary(m_both)$r.squared - summary(m_Vx2)$r.squared)

####################################

m1 <- lm(Vy ~ ., Datensatz)  # m1 ist das full model mit allen Variablen
m1ToDecompose <- calc.relimp(m1)$lmg

########################################################## if you want to make the Venn-diagram, this is one way...
# library(VennDiagram)
# draw.pairwise.venn(area1 = 66, area2 = 38, cross.area = 32, category = c("Vx2", 
#                                                                         "Vx1"))
# 
# draw.triple.venn(area1 = 22, area2 = 20, area3 = 13, n12 = 11, n23 = 4, n13 = 5, 
#                  n123 = 1)                         

## here's another package for venn diagrams
## I did not make it plot our current results
## I just played :)
# library(venn)
# venn(3)
# venn("1--")
# venn("1--", ilabels = TRUE)
# venn(4, lty = 5, col = "navyblue")
# venn(4, lty = 5, col = "navyblue", ellipse = TRUE)

#################################################################

set.seed(56)
x <- rnorm(100, mean=1, sd=2)
z <- rnorm(100, sd=2) + 0.1*x

y <- 2*x + 3*z + rnorm(100, sd=10)

m.both <- lm(y~x+z)
m.x <- lm(y~x)
m.z <- lm(y~z)

summary(m.both)$r.squared
summary(m.x)$r.squared
summary(m.z)$r.squared

summary(m.both)$r.squared * cor(x,z,method="pearson")

a <- summary(m.both)$r.squared - summary(m.x)$r.squared
b <- summary(m.both)$r.squared - summary(m.z)$r.squared
summary(m.both)$r.squared - a - b
