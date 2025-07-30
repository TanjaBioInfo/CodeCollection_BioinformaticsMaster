## kompakter Beispiel-Code für einfache lineare Regression:

## Clear R's memory
rm(list=ls())
## load packages
library(tidyverse)
library(readr)
library(ggplot2)
library(ggfortify)
## import the data 
plant_gr <- read_csv("/Users/TR/Desktop/RStudio_Datenanalyse_2022/Master_Datasets/Datensatz.csv.html")
glimpse(Datensatz)
nrow(Datensatz)
beobachtungenOhneNA <- na.omit(Datensatz)
nrow(beobachtungenOhneNA)
unique(Datensatz$Vx1)
filter(Datensatz, !is.na(Vx1) & !is.na(Vy))
## Wrange the data
Datensatz1 <- Datensatz %>%
  filter(Vx1==...) %>% ## nur Variablen, welche diese Bedingung erfüllen
  select(Vx1:Vy, Vx2, Vx3) %>% ## nur diese Spalten
  drop_na() ## drop rows with any NAs
## plot the data
ggplot(data=Datensatz, aes(x=Vx1, y=Vy))
## statistical model
model <- lm(Vy ~ Vx1, data=Datensatz)
## check the assumptions of the model
autoplot(model, smooth.colour = NA)
## look at the summary table
summary(model)
## make a nice graph for communication
qplot(x = Vx1, y = Vy, data=Datensatz) +
  geom_smooth(method = 'lm') +
  ylab("Vy-Name (mm/week)") +
  xlab("Vx1-Name (ml per 10 grams)")
theme_bw()