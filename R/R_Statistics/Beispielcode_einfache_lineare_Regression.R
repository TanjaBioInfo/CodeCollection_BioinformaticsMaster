## Beispiel-Code für einfache lineare Regression:

## Clear R's memory
rm(list=ls())

## load packages
library(tidyverse)
library(readr)
library(ggplot2)
library(ggfortify)

## import the data (direct from where it is online, deswegen read_csv)
Datensatz <- read_csv("/Users/TR/Desktop/RStudio_Datenanalyse_2022/Master_Datasets/plant_growth_rate.csv.html")

## check the data is imported correctly
glimpse(Datensatz)
### Rows: 17

## NA verfälschen die Anzahl der Beobachtungen/observations, diese sind also auszuschliessen (omit=aussschliessen):
beobachtungenOhneNA <- na.omit(Datensatz)
nrow(Datensatz)
## still 17, so no NAs in any variables in any rows.

# ## Liste einer Variablen (zB. Vx1) ausgeben, was ist alles im Datensatz (betreffend dieser Variablen)
# unique(Datensatz$Vx1)
# 
# ## alle Zeilen ausgeben, in welchen Vx1 und Vy nicht NA's sind
# filter(Datensatz, !is.na(Vx1) & !is.na(Vy))
# 
# ## Wrange the data
# Datensatz1 <- Datensatz %>%
#   filter(Vx1==...) %>% ## nur Variablen, welche diese Bedingung erfüllen
#   select(Vx1:Vy, Vx2, Vx3) %>% ## nur diese Spalten, Reihenfolge evtl. besser wählen
#   drop_na() ## drop rows with any NAs
# 
# ## get the average and standard deviation of child mortality for each continent
# group_by(Datensatz1, Vy) %>%
#   summarise(mean=mean(Vx2),
#             sd=sd(Vx2))

## plot the data, eigentlich von "Datensatz1", da dieser ohne NA's ist
ggplot(data=Datensatz, aes(x=Vx1, y=Vy))

# ## log transform the Vy variable
# Datensatz <- mutate(Datensatz, log10_Vy=log10(Vy))

## guess the intercept and slope
## how many degrees of freedom for error should there be?

## statistical model, erstes statisches Modell kreieren, m1
m1 <- lm(Vy ~ Vx1, data=Datensatz)

## check the assumptions of the model
autoplot(m1, smooth.colour = NA)

## look at the summary table
summary(m1)

## Results sentence: Vy had a positive effect on Vx1
## (linear regression, slope=12.7, t=12.5, p < 0.001)

## make a nice graph for communication
qplot(x = Vx1, y = Vy, data=Datensatz) +
  geom_smooth(method = 'lm') +
  ylab("Vy-Name (mm/week)") +
  xlab("Vx1-Name (ml per 10 grams)")
theme_bw()

## one of the regressions, erstes Modell, m1
m1 <- lm(Vy ~ Vx1, data=Datensatz)
autoplot(m1, smooth.colour = NA) 
summary(m1)
## nothing significant, supporting our eyeball
## r2 0.024

## the other of the regressions, zweites Modell, m2
m2 <- lm(Vy ~ Vx2, data=Datensatz)
autoplot(m2, smooth.colour = NA) 
summary(m2)

### multiple lineare Regression

## multiple regression, drittes Modell, m3
m3 <- lm(Vy ~ Vx1 + Vx2, data=Datensatz)
autoplot(m3) 
summary(m3)
#anova(m3)

## Make a graph of the modeled/predicted relationship of (Model m3)
## Vy against Vx1 percent for mean Vx2 (in Zeilen 102-120 ist es dann anders rum)
## I.e. this is the predicted relationships, when Vx2 is kept constant
## first make the new_data to predict over
new_data <- expand.grid(Vx1 = seq(min(Datensatz$Vx1),
                                             max(Datensatz$Vx1),
                                             length=100),
                        Vx2=mean(Datensatz$Vx2))

## Now predict using the model and that new_:data
p1 <- predict(m3, newdata=new_data, interval="confidence")
## some house keeping:
pred1 <- cbind(new_data, p1)
## and plot the relationship
pred1 %>%
  ggplot() +
  geom_ribbon(aes(x = Vx1, ymin = lwr, ymax = upr), alpha = 0.2) +
  geom_line(aes(x = Vx1, y = fit)) +
  ylab("Predicted Vy-Name")



## And now for the other relationship:
## Make a graph of the modeled/predicted relationship of (Model m3)
## Vy against Vx2 for mean Vx1 percent (also genau anders rum als in Zeile 80-98)
## first make the new_data to predict over
new_data <- expand.grid(Vx1 = mean(Datensatz$Vx1),
                        Vx2 = seq(min(Datensatz$Vx2),
                                   max(Datensatz$Vx2),
                                   length=100))

## Now predict using the model and that new_data
p1 <- predict(m3, newdata=new_data, interval="confidence")
## some house keeping:
pred1 <- cbind(new_data, p1)
## and plot the relationship
pred1 %>%
  ggplot() +
  geom_ribbon(aes(x = Vx2, ymin = lwr, ymax = upr), alpha = 0.2) +
  geom_line(aes(x = Vx2, y = fit)) +
  ylab("Predicted Vy-Name")
