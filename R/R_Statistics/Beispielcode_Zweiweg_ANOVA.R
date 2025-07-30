## Beispielcode für Zweiweg-ANOVA / zweiseitige ANOVA:

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

## how many replicates of each combination
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
ggplot(Datensatz, aes(x=sqrt_Vy)) + geom_histogram()
## noch ein Versuch
ggplot(Datensatz, aes(x=sqrt_Vy)) +
  geom_histogram() +
  facet_grid(Vx1 ~ Vx2)

## Hopefully ANOVA is robust enough (weil die Plots nicht so gut sind)!
## Could use a randomisation test, to avoid assumptions.
## Or non-parameteric.

## make a graph that should tell us the answer
ggplot(Datensatz, aes(x=Vx1, y=sqrt_Vy, col=Vx2)) +
  geom_point(position=position_jitterdodge(jitter.width = 0.2))

## Degrees of freedom
## four means/Mittelwerte, so Observations - Variables

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
## definitely looks like there's an interaction

## fit full model (i.e. with interaction)
m1 <- lm(sqrt_Vy ~ Vx2 * Vx1, Datensatz)
## model diagnostics
autoplot(m1)
## surprisingly good!
anova(m1)
## yes, there is quite strong evidence of an interaction, as we expected.

## here we get the confidence intervals (default is 95% CI)
confint(m1)

## and use the summary table to give us the r-squared
summary(m1)

## at mid Vx1s, there is no effect of Vx2
## Vx2 reduce y-Wert only at low Vx1s.
## and a nice graph to show this
ggplot(Datensatz, aes(x=Vx1, y=sqrt_Vy, col=Vx2)) +
  geom_point(position=position_jitterdodge(jitter.width = 0.2,
                                           dodge.width = 0.5)) +
  geom_point(data=meanz, mapping=aes(y=mean), size=10, shape=1,
             position = position_dodge(width=0.5)) +
  theme_bw() +
  ylab(expression("y-Wert - square root cm"^"2")) +
  xlab("Vx1 on the shoreline")
