## kompakter Beispielcode für Zweiweg-ANOVA / zweiseitige ANOVA:

## clear R
rm(list=ls())
## load required libraries
library(tidyverse)
library(ggfortify)
## read in the data
Datensatz <- read_csv("https://Datensatz.csv")
## take a look at it
Datensatz
## check if we have any NAs
NaDatensatz <- na.omit(Datensatz)
NaDatensatz
## same number of rows as before, so no NAs

## how many Variables of each combination
table(Datensatz$Vx1, Datensatz$Vx2)
## ... and all the same, which means the design is *balanced*

## check the distribution of the response variable
ggplot(Datensatz, aes(x=Vy)) +
  geom_histogram()

## and for each treatment combination
ggplot(Datensatz, aes(x=Vy)) +
  geom_histogram() +
  facet_wrap(Vx1 ~ Vx2)

## square root transform the Vy response variable
Datensatz <- mutate(Datensatz, sqrt_Vy = sqrt(Vy))

## look again at the histogram
ggplot(Datensatz, aes(x=sqrt_Vy)) + 
  geom_histogram() +
  facet_grid(Vx1 ~ Vx2)

## make a graph
ggplot(Datensatz, aes(x=Vx1, y=sqrt_Vy, col=Vx2)) +
  geom_point(position=position_jitterdodge(jitter.width = 0.2))

## Calculate the mean and standard deviation of each treatment combination
meanz <- Datensatz %>% group_by(Vx2, Vx1) %>%
  summarise(mean=mean(sqrt_Vy),
            sd=sd(sqrt_Vy))
meanz

## lets put the mean of each treatment combination onto the graph
ggplot(Datensatz, aes(x=Vx2, y=sqrt_Vy, col=Vx1)) +
  geom_point(position=position_jitterdodge(jitter.width = 0.2,
                                           dodge.width = 0.5)) +
  geom_point(data=meanz, mapping=aes(y=mean), size=10, shape=1,
             position = position_dodge(width=0.5))
## does it look like there's an interaction?

## fit full model (i.e. with interaction)
m1 <- lm(sqrt_Vy ~ Vx2 * Vx1, Datensatz)
## model diagnostics
autoplot(m1)
anova(m1)
## evidence of an interaction?

## here we get the confidence intervals (default is 95% CI)
confint(m1)

## and use the summary table to give us the r-squared
summary(m1)

## a nice graph
ggplot(Datensatz, aes(x=Vx1, y=sqrt_Vy, col=Vx2)) +
  geom_point(position=position_jitterdodge(jitter.width = 0.2,
                                           dodge.width = 0.5)) +
  geom_point(data=meanz, mapping=aes(y=mean), size=10, shape=1,
             position = position_dodge(width=0.5)) +
  theme_bw() +
  ylab(expression("y-Wert - square root cm"^"2")) +
  xlab("Vx1 on the shoreline")
