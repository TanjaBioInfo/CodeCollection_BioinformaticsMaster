## Beispielcode Data Wrangling:


rm(list=ls())
library(tidyverse) ## immer rein nehmen
library(dplyr) ## für wrangle
library(ggplot2) ## für die ggplots
library(ggfortify) ## für autoplot()

## zeigt das aktuelle Arbeitsverzeichnis an
getwd()
## import the data (direct from where it is online, deswegen read_csv)
Datensatz <- read_csv("/Users/TR/Desktop/RStudio_Datenanalyse_2022/Master_Datasets/plant_growth_rate.csv.html")

## check the data is imported correctly
glimpse(Datensatz)
### Rows: 17

## NA verfälschen die Anzahl der Beobachtungen/observations, diese sind also auszuschliessen (omit=aussschliessen):
beobachtungenOhneNA <- na.omit(Datensatz)
nrow(Datensatz)
## still 17, so no NAs in any variables in any rows.

## check the data is imported correctly
glimpse(Datensatz)
### Rows: 17

## Get the number of each Vx2 (man will nur die Anzahl der Variablen wissen, nicht die Namen (unique))
table(Datensatz$Vx2)

## Liste einer Variablen (zB. Vx1) ausgeben, was ist alles im Datensatz (betreffend dieser Variablen)
unique(Datensatz$Vx1)

summarise(Datensatz, mean=mean(Vx2), sd=sd(Vx2))  # Datensätze zusammenfassen
group_by(Datensatz, Vy)  # Datensätze gruppieren (gruppierte Kopie einer Tabelle)
## Datensätze manipulieren:
### Zeilen extrahieren, die eine Bedingung erfüllen, mit dplyr:: davor direkt, sonst zuordnen <- :
dplyr::filter(Datensatz, Vy > 5)
filter(Datensatz, !is.na(Vx1) & !is.na(Vy))
### Zeilen anhand ihrer Positionen auswählen:
dplyr::slice(Datensatz, 5:10)
### Zeilen ordnen, anhand von Werten in einer Spalte sortieren:
arrange(Datensatz, desc(Vy))
### neue Zeilen hinzufügen:
add_row(Datensatz, Vy=1, Vx1=1)
## Variablen manipulieren:
### Variablen extrahieren, Spalten anhand des Variablennnamens auswählen:
dplyr::select(Datensatz, Vy, Vx1)
select(Datensatz, starts_with("..."))
select(Datensatz, ends_with("..."))
select(Datensatz, contains("..."))
### neue Variablen erstellen (betrifft die Spalte):
mutate(Datensatz, log10_Vy=log10(Vy))
remane(Datensatz, VarX1=Vx1)
add_column(Datensatz, Vy, before=NULL, after=NULL)

## alle Zeilen ausgeben, in welchen Vx1 und Vy nicht NA's sind
filter(Datensatz, !is.na(Vx1) & !is.na(Vy))

## Wrange the data
Datensatz1 <- Datensatz %>%
  filter(Vx1==...) %>% ## nur Variablen, welche diese Bedingung erfüllen
  select(Vx1:Vy, Vx2, Vx3) %>% ## nur diese Spalten, Reihenfolge evtl. besser wählen
  drop_na() ## drop rows with any NAs

## get the average and standard deviation of child mortality for each continent
group_by(Datensatz1, Vy) %>%
  summarise(mean=mean(Vx2),
            sd=sd(Vx2))

## plot the data, eigentlich von "Datensatz1", da dieser ohne NA's ist
ggplot(data=Datensatz, aes(x=Vx1, y=Vy))

## plot the distribution of Vy
ggplot(Datensatz, aes(x=Vy)) +
  geom_histogram()

## log transform the Vy variable
Datensatz <- mutate(Datensatz, log10_Vy=log10(Vy))

## look at the distribution of the log transformed Vy
ggplot(Datensatz, aes(x=log10_Vy)) +
  geom_histogram(bins=20)

## check distribution of Vx1
ggplot(Datensatz, aes(x=Vx1)) +
  geom_histogram(bins=20)

## look at the relationship between Vx1 and Vy
ggplot(Datensatz, aes(x=Vx1, y=log10_Vy)) +
  geom_point()
