## Beispielcode für Einweg-ANOVA / einseitige ANOVA:

## clear R
rm(list=ls())

## load required libraries
library(tidyverse)
library(ggfortify)

## read in the data
Datensatz <- read_csv("https://....csv")

## take a look at it
Datensatz

## check if we have any NAs
na.omit(Datensatz)
## same number of rows as before, so no NAs

## how many replicates
table(Datensatz$Vx1)

## check the distribution of the response variable
ggplot(Datensatz, aes(x=Vy)) +
  geom_histogram()

# ## square root transform the Vy response variable
# Datensatz <- mutate(Datensatz, sqrt_Vy = sqrt(Vy))
# ## look again at the histogram
# ggplot(Datensatz, aes(x=sqrt_Vy)) + geom_histogram()

## make a graph
ggplot(Datensatz, aes(x=Vx1, y=Vy) +
  geom_point(position=position_jitterdodge(jitter.width = 0.2))

## Calculate the mean and standard deviation 
meanz <- Datensatz %>% group_by(Vx1) %>%
  summarise(mean=mean(Vy),
            sd=sd(Vy))
meanz

## lets put the mean of each treatment onto the graph
ggplot(Datensatz, aes(x=Vx1, y=Vy)) +
  geom_point(position=position_jitterdodge(jitter.width = 0.2,
                                           dodge.width = 0.5)) +
  geom_point(data=meanz, mapping=aes(y=mean), size=10, shape=1,
             position = position_dodge(width=0.5))

m1 <- lm(Vy ~ Vx1, Datensatz)

autoplot(m1)

anova(m1)

confint(m1)

summary(m1)

## and a nice graph
ggplot(Datensatz, aes(x=Vx1, y=Vy) +
  geom_point(position=position_jitterdodge(jitter.width = 0.2,
                                           dodge.width = 0.5)) +
  geom_point(data=meanz, mapping=aes(y=mean), size=10, shape=1,
             position = position_dodge(width=0.5)) +
  theme_bw() +
  ylab(expression("y-Wert - square root cm"^"2")) +
  xlab("Vx1 on the shoreline")
