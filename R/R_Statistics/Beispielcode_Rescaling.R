## Beispielcode Rescaling, --> zeigt die relative Wichtigkeit der Effektgrösse auf
# nur Wertänerung ändert nur Slope und SE des Wertes, 
# aber Standardisierung (slope/SD) ändert alles ausser R^2 und p-Value (der Slope), 
# (und evtl. auch nur minimal veränderter t-Value der slope, evtl. gleich?):

## clear R
rm(list = ls())

## load some libraries
library(tidyverse)
library(ggfortify)
library(relaimpo)
library(coefplot)
library(GGally)

# Datensatz_all <- read_delim("~/Desktop/RStudio_Datenanalyse_2022/Master_Datasets/Datensatz.txt", "\t")
# oder:
Datensatz_all <- read::read_delim("~/Desktop/RStudio_Datenanalyse_2022/Master_Datasets/Datensatz.txt", "\t", escape_double = FALSE, trim_ws = TRUE)
# oder:
# Datensatz_all <- read_csv("https://Datensatz.csv")

# And, we'll do one more, and that is set R to fail if there are NAs. 
# This is quite important, as some model comparison methods will happily compare models using different datasets, 
# which can be caused by have NAs in some variables and not others.
options(na.action = "na.fail")

# # And keep only the important variables, and remove duplicates:
Datensatz <- dplyr::select(Datensatz_all, Vy, Vx2, Vx11, Vx6, Vx7, Vx10, Vx4, Vx12,
                           Vx8, Vx9, Vx1, Vx5, Vx3) %>%
  na.omit()

# Vx1 ist in Pfund, soll zu Vx1_kg rescaled werden

Vy <- mutate(Datensatz, Vx1_kg=Vx1*0.45)
m_pounds <- lm(Vy ~ Vx2 + Vx1, data=Datensatz)
m_kg <- lm(Vy ~ Vx2 + Vx1_kg, data=Datensatz)
summary(m_pounds)
summary(m_kg)
-0.14800/-0.32890

# ## out of interest, here is what happens if we put both Vx1 variables in the model...
# ## for one we fail to get statistics... because it is
# ## perfectly correlated with the other Vx1 variable
# m_kg_pounds <- lm(Vy ~ Vx2 + Vx1_kg + Vx1, data=Datensatz)
# summary(m_kg_pounds)

####### now scale the variables...
Vy <- dplyr::mutate(Vy, scaled_Vx1=scale(Vx1),
                    scaled_Vx2=scale(Vx2),
                    scaled_Vx3=scale(Vx3),
                    scaled_Vx4=scale(Vx4),
                    scaled_Vx5=scale(Vx5))
m_kg_pounds_scaled <- lm(Vy ~ scaled_Vx2 + scaled_Vx1, data=Datensatz)
summary(m_kg_pounds_scaled)

## Visualising coefficients (effect sizes)
## Lets say we'd like to visualise the coefficients of a model
## with more of the explanatory variables... e.g. 
m_more <- lm(Vy ~ scaled_Vx2 + scaled_Vx1 +
               scaled_Vx3 + scaled_Vx4 + scaled_Vx5,
             data=Datensatz)

## we can use either of two packages, or do it more manually
library(coefplot) 
coefplot(m_more) ## not working at the moment

library(arm)
coefplot(m_more, mar=c(1,6,6,1))
box()

## more manually
## use the tidy function from the broom packaage to put the coefficients and
## associated statistics into a tidy data frame...
library(broom)
tidy_mod <- tidy(m_more)
## and plot this, without the intercept, since its not so interesting
tidy_mod %>%
  filter(term != "(Intercept)") %>%
  ggplot(aes(x = estimate, y = term)) + 
  geom_vline(xintercept = 0, col = "grey") +
  geom_point() +
  geom_errorbarh(aes(xmin = estimate - 2 * std.error,
                     xmax = estimate + 2 * std.error),
                 Vx4 = 0.2)
