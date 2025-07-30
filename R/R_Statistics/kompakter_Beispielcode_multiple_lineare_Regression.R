## kompakter Beispielcode für multiple lineare Regression:

## Clear R
rm(list=ls())
## load libraries (packages)
library(tidyverse)
library(ggfortify)
## read the data (from where Owen put it online) earthworm analysis ("https://")
Datensatz <- read_csv("https://Datensatz.csv")
## check the data is imported correctly
glimpse(Datensatz)
### Rows: n
## NA verfälschen die Anzahl der Beobachtungen/observations, diese sind also auszuschliessen (omit=aussschliessen):
beobachtungenOhneNA <- na.omit(Datensatz)
nrow(Datensatz)
## still n, so no NAs in any variables in any rows.
## Get the number of each Vx2 (man will nur die Anzahl der Variablen wissen, nicht die Namen (unique))
table(Datensatz$Vx2)
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
## make the linear model, erstes Modell, m1
m1 <- lm(log10_Vy ~ Vx1, Datensatz)
## check the model diagnostics
autoplot(m1)
## get the summary information table
summary(m1)
## make a lovely graph!
ggplot(Datensatz, aes(x=Vx1, y=log10_Vy)) +
  geom_point() +
  xlab("Vx1-Name (mm)") +
  ylab("Vy-Name (g)") +
  geom_smooth(method="lm")
## anderer einfacher Relationship anschauen:
ggplot(Datensatz, aes(x=Vx2, y=log10_Vy)) +
  geom_boxplot() +
  geom_point()
m2 <- lm(log10_Vy ~ Vx2, Datensatz)
autoplot(m2)
summary(m2)
anova(m2)
## Main-Aktion-Modell:
ggplot(Datensatz, aes(x=Vx1, y=log10_Vy, colour=Vx2)) +
  geom_point()
m3 <- lm(log10_Vy ~ Vx1 + Vx2, Datensatz)
autoplot(m3)
summary(m3)
## Interaktionsmodell:
m4 <- lm(log10_Vy ~ Vx1 * Vx2, Datensatz)
autoplot(m4)
summary(m4)

## And make a nice graph
ggplot(Datensatz, aes(x=Vx1, y=log10_Vy, colour=Vx2)) +
  geom_point() +
  xlab("Vx1-Name (mm)") +
  ylab("Vy-Name (g)") +
  geom_smooth(method="lm")

## Here we can make a graph using predict()
## with the model without the interaction, where the lines have the same slope
## here: m3
## make new data to plot over.
new_data <- expand.grid(Vx1=seq(min(Datensatz$Vx1), max(Datensatz$Vx1), length=100),
                        Vx2=unique(Datensatz$Vx2)) ## new_data heisst neue Vx's machen
## make predictions with that data and model m3 (no interaction)
p1 <- predict(m3, newdata = new_data, interval = "confidence") ## m3 ist log_Vy ~ Vx1
## combine the predicted and new data to make plotting easier
n1 <- cbind(p1, new_data)
## And make the graph
ggplot(Datensatz, aes(x=Vx1, y=log10_Vy, colour=Vx2)) +
  geom_point() +
  geom_smooth(data=n1, mapping=aes(y=fit, ymin=lwr, ymax=upr), stat="identity")




### multiple lineare Regression, Auszug aus simple lineare Regression

## multiple regression, m3
m3 <- lm(Vy ~ Vx1 + Vx2, data=Datensatz)
autoplot(m3) 
summary(m3)
#anova(m3)

## Make a graph of the modeled/predicted relationship of (Model m3)
## Vy against Vx1 percent for mean Vx2
## I.e. this is the predicted relationships, when Vx2 is kept constant
## first make the new_data to predict over
new_data <- expand.grid(Vx1 = seq(min(Datensatz$Vx1),
                                  max(Datensatz$Vx1),
                                  length=100),
                        Vx2=mean(Datensatz$Vx2))
## Now predict using the model and that new_data
p1 <- predict(m3, newdata=new_data, interval="confidence")
## some house keeping:
pred1 <- cbind(new_data, p1)
## and plot the relationship
pred1 %>%
  ggplot() +
  geom_ribbon(aes(x = Vx1, ymin = lwr, ymax = upr), alpha = 0.2) +
  geom_line(aes(x = Vx1, y = fit)) +
  ylab("Predicted Vy-Name")

## And now for the other way round relationship:
## Make a graph of the modeled/predicted relationship of (Model m3)
## Vy against Vx2 for mean Vx1 percent
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
