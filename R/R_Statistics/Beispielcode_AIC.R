## Beispielcode für Modell-Selektionen (anhand von Informationskriterien, AIC, AICc, BIC):

## clear R
rm(list=ls())

library(dplyr)
library(ggplot2)
library(readr)
library(MASS)
library(MuMIn)   # for dregging
library(AICcmodavg)
library(patchwork) # for the final plot, sei aber schon in MASS drin

Datensatz_all <- read_delim("~/Desktop/RStudio_Datenanalyse_2022/Master_Datasets/Datensatz.txt", "\t")
# oder:
Datensatz_all <- read_csv("https://Datensatz.csv")

# And, we'll do one more, and that is set R to fail if there are NAs. 
# This is quite important, as some model comparison methods will happily compare models using different datasets, 
# which can be caused by have NAs in some variables and not others.

options(na.action = "na.fail")

# And keep only the important variables, and remove duplicates:
Datensatz <- dplyr::select(Datensatz_all, Vy, Vx2, Vx11, Vx6, Vx7, Vx10, Vx4, Vx12,
                    Vx8, Vx9, Vx1, Vx5, Vx3) %>%
  na.omit()

## Doing it ourselves
# Here we start with a model, and ourselves aDatensatz or take away variables.
# Below, I start with the model with all main effects.
# Then I ask R to report the change in model performance when each single term is removed.
# I then remove the variable that results in the least decrease in model performance (might even increase it.
# We'll use AIC as the measure of model performance.

m1 <- lm(Vy ~ ., Datensatz)  # m1 ist das full model mit allen Variablen
#m1 <- lm(Vy ~ Vx2 + Vx11 + Vx6 + Vx10 + Vx4 + Vx12 +
#           Vx8 + Vx9 + Vx1 + Vx5 + Vx3 + Vx13 + Vx14, data=Datensatz)  # m1 ist das full model mit allen Variablen

AICc(m1)
## 1414 könnte zB ein Wert sein

anova(m1)

######### schrittweise Variablenselektion von Hand:
dropterm(m1, sorted=TRUE)
dt2 <- update(m1, . ~ . - Vx1)
AICc(dt2)    # oder summary(dt2)

dropterm(dt2, sorted=TRUE)
dt3 <- update(dt2, . ~ . - Vx2)
AICc(dt3)

dropterm(dt3, sorted=TRUE)
dt4 <- update(dt3, . ~ . - Vx3)
AICc(dt4)

dropterm(dt4, sorted=TRUE)
dt5 <- update(dt4, . ~ . - Vx4)
AICc(dt5)

dropterm(dt5, sorted=TRUE)
dt6 <- update(dt5, . ~ . - Vx5)
AICc(dt6)

dropterm(dt6, sorted=TRUE)
dt7 <- update(dt6, . ~ . - Vx6)
AICc(dt7)

dropterm(dt7, sorted=TRUE)
dt8 <- update(dt7, . ~ . - Vx7)
AICc(dt8)

dropterm(dt8, sorted=TRUE)
dt9 <- update(dt8, . ~ . - Vx8)
AICc(dt9)

dropterm(dt9, sorted=TRUE)
dt10 <- update(dt9, . ~ . - Vx9)
AICc(dt10)

dropterm(dt10, sorted=TRUE)
dt11 <- update(dt10, . ~ . - Vx10)
AICc(dt11)

dropterm(dt11, sorted=TRUE)
dt12 <- update(dt11, . ~ . - Vx11)
AICc(dt12)

dropterm(dt12, sorted=TRUE)
dt13 <- update(dt12, . ~ . - Vx12)
AICc(dt13)

# Liste aller Modelle erstellen:

mods <- list(m1=m1, dt2=dt2, dt3=dt3, dt4=dt4, dt5=dt5, dt6=dt6, dt7=dt7,
             dt8=dt8, dt9=dt9, dt10=dt10, dt11=dt11, dt12=dt12, dt13=dt13)
model.sel(mods)

## nun schrittweise Variablenselektion via computer (automated), nicht von Hand:
fit1 <- lm(Vy ~ ., Datensatz)
fit2 <- lm(Vy ~ 1, Datensatz)
step_forward <- stepAIC(fit2, direction = "forward", scope=list(upper=fit1,lower=fit2))
step_backward <- stepAIC(m1, direction = "backward")
step_both <- stepAIC(m1, direction = "both", scope=list(upper=fit1,lower=fit2))
mods <- list(step_backward=step_backward, step_forward=step_forward, step_both=step_both)
model.sel(mods)

# wenn das zu verschiedenen Resultaten führt, welche in verschiedene Richtungen gehen, führt: dredge = baggern
s1 <- dredge(m1)

# In this table each row is a model. It is sorted by AIC. Best model is when the AIC is lowest.
## to get the best model we look at the one with deltaAIC == 0
model.sel(get.models(s1, subset = delta<1))
best_dredge <- get.models(s1, subset = delta==0)[[1]]
model.sel(best_dredge)
anova(best_dredge)
summary(best_dredge)

## compare various approaches (anhand dt11):
mods <- list(dt11=dt11, step_backward=step_backward, step_forward=step_forward, step_both=step_both,
             best_dredge=best_dredge)
model.sel(mods)

## Model averaging 
s1_subset <- get.models(s1, subset = delta < 3)
mod_ave <- model.avg(s1_subset)
summary(mod_ave)

## How good is the model (dt11 vs. dt12)?
p1 <- tibble(dt11=predict(dt11),
             dt12=predict(dt12))
Datensatz1 <- bind_cols(Datensatz, p1)
ggplot(Datensatz1, aes(x=dt11, y=Vy)) +
  geom_point()
ggplot(Datensatz1, aes(x=dt12, y=Vy)) +
  geom_point()

############## automatic model selection for predictive models in R:
r.AIC <- stepAIC(Datensatz, direction=c('backward'), trace=FALSE, AICc=TRUE)
AICc(r.AIC)

############## Codes um verschiedene Regressions-Modelle gegeneinander auszutesten:
m1 <- lm(Vy ~Vx1+Vx2+Vx3+Vx4, data=Datensatz)
m2 <- lm(Vy ~Vx1+Vx2+Vx3, data=Datensatz)
m3 <- lm(Vy ~Vx1+Vx2, data=Datensatz)
m4 <- lm(Vy ~Vx1, data=Datensatz)
# eine Liste von Modellen machen und den AIC für jedes Modell ausrechnen (mit der aictab()-Funktion):
models <- list(m1, m2, m3, m4)
modelnames <- c('Vx1.Vx2.Vx3.Vx4', 'Vx1.Vx2.Vx3', 'Vx1.Vx2', 'Vx1')
aictab(cand.set = models, modnames = modelnames)


############## wir wollen automatic model selection machen mit forward/backward/both und auch das dredging:###################
## clear R
rm(list=ls())

## Load required libraries
library(tidyverse)
library(MASS)
library(ggfortify)
library(MuMIn)
library(patchwork) ## for the final plot

Datensatz_all <- read_csv("https://....csv")
## ... observations

## we will use all the variables in the dataset.
## let us therefore create a version without NAs in any variables
Datensatz <- na.omit(Datensatz_all)
## still ... observations, so we know there were no NAs

## The response variable is Vy
ggplot(Datensatz, aes(x=Vy)) + geom_histogram(bins=15)

## the full model (m1) with no interactions
m1 <- lm(Vy ~ Vx4 + Vx1 + Vx5 + Vx3 + Vx6 +
                 Vx7 + Vx8 + Vx2, Datensatz)

## get the AIC of the full model
extractAIC(m1)

## get the AIC of the full model and of models without each of the individual variables: start für backwards
dropterm(m1, sorted = T)

## for interest, we can look at some of the features of the full model
summary(m1)
## e.g explanatory power is about 50% (R^2), eher was für decomensate R^2
anova(m1)
## and f-tests suggest strong relationships for many of the included variables

## remove the Vx1 variable from the full model, also backwards
dt1 <- update(m1, . ~ . - Vx1)

## get the the r-squared of this new model
summary(dt1)
## no difference from when Vx1 was included

## look at which variable we could next drop
dropterm(dt1, sorted = T)
## removing Vx2 will decrease the AIC..
dt2 <- update(dt1, . ~ . - Vx2)

## look at which variable we could next drop
dropterm(dt2, sorted = T)
dt3 <- update(dt2, . ~ . - Vx3)

## look at which variable we could next drop
dropterm(dt3, sorted = T)  # ...
## now, if we drop anything, there would be an increase in AIC of over 4 units 

## we can review the models we created by putting them in a list, also nur die guten Modelle in eine Liste packen
mods <- list(m1=m1, dt1=dt1, dt2=dt2, dt3=dt3)
## and giving that to the model.sel function, gibt dem Delta-Vergleich zu diesen Modellen aus (Delta AIC)
model.sel(mods)

## model diagnostics
autoplot(dt3)

##############################3## Use step AIC, automated, automatisiertes step back/forward/both: ############
m0 <- lm(Vy ~ 1, Datensatz)
## backward stepwise selection
s1 <- stepAIC(m1, direction = "backward", AICc=TRUE)
## forward stepwise selection
s2 <- stepAIC(m0, direction = "forward", AICc=TRUE,
              scope=list(lower=m0, upper=m1))
## backwards and forwards stepwise selection
s3 <- stepAIC(m0, direction = "both", AICc=TRUE,
              scope=list(lower=m0, upper=m1))

model.sel(list(dt3=dt3, s1=s1, s2=s2, s3=s3))

########################### and now we look at all (!!!) possible models with the dredge function ###########
## to use this we have to set the na.action argument we we make the full model (m1)
m1 <- lm(Vy ~ Vx4 + Vx1 + Vx5 + Vx3 + Vx6 +
                 Vx7 + Vx8 + Vx2,
               data = Datensatz,
               na.action = "na.fail")
## there we have said that if there are any NAs, please create and error and stop
## we already checked there are no NAs, but this double safety check is still very wise

# Wieviele möglichen Modelle gibt es, wenn man ... explanantory Variablen hat?
AnzVexpl <- ...
2^(AnzVexpl)-1
# oder
sum(choose(rep(AnzVexpl, AnzVexpl), c(1 : AnzVexpl)))

############## do the dredge
dredge_out <- dredge(m1)

## get and look at the best model
best_dredge <- get.models(dredge_out, subset = delta==0)[[1]]
anova(best_dredge)

## look at the models that are with five AIC units of the best
s1_subset <- get.models(dredge_out, subset = delta < 5)
model.sel(s1_subset)

## we could create a model average of this subset of models:
mod_ave <- model.avg(s1_subset)
summary(mod_ave)

## How to report the findings, focusing on practical importance?
## and to validate how well the model works
## this is an interesting and important graph --
## it shows the predicted versus the observed number of Vy
p1 <- ggplot(mapping=aes(x=Datensatz$Vy, y = fitted(dt3))) +
  geom_point() +
  geom_abline(intercept = 0, slope=1) +
  coord_fixed(ratio = 1) +
  xlab("Observed age\n(number of growth Vy)") +  # Vy entspricht age minus 1.5 years
  ylab("Predicted age\n(number of growth Vy)")
p2 <- ggplot(mapping = aes(x = Datensatz$Vy - fitted(dt3))) +
  geom_histogram() +
  xlab("Error in predicted age")
p1 + p2 + plot_annotation(tag_levels = 'A')
