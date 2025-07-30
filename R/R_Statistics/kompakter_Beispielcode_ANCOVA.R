## kompakter Beispielcode für ANCOVA, wichtig zu wissen: Vx1 ist kategorisch, und Vx2 ist kontinuierlich (ANCOVA), Vy ist kontinuierlich:

## clear R
rm(list=ls())
## load required libraries
library(tidyverse)
library(ggfortify)
## read in the data
Datensatz <- read_csv("https://Datensatz.csv")
# ## take a look at it
# Datensatz
## or:
glimpse(Datensatz)
## check if we have any NAs, NA's dürfen bei ANCOVA nicht in die Analyse einfliessen (p-Value-Verfälschung)
na.omit(Datensatz)
## same number of rows as before, so no NAs

# Anzahl der NA's einer Variablen finden:
sum(is.na(Vx1))
sum(is.na(Vx2))
# ein neues Datasatz ohne NA's kreieren:
Datensatz_ohne_NA <- select(Datensatz, Vx1, Vx2, Vy) %>% na.omit()

#### wichtig zu wissen: Vx1 ist kategorisch, und Vx2 ist kontinuierlich (ANCOVA), Vy ist kontinuierlich

# ## how many variables of each combination
# table(Datensatz$Vx1, Datensatz$Vx2)
# ## ... and all the same, which means the design is *balanced*
# 
# ## check the distribution of the response variable
# ggplot(Datensatz, aes(x=Vy)) +
#   geom_histogram()
# 
# ## and for each treatment combination
# ggplot(Datensatz, aes(x=Vy)) +
#   geom_histogram() +
#   facet_wrap(Vx1 ~ Vx2)
# 
# ## square root transform the Vy response variable
# Datensatz <- mutate(Datensatz, sqrt_Vy = sqrt(Vy))
# 
# ## look again at the histogram
# ggplot(Datensatz, aes(x=sqrt_Vy)) + 
#   geom_histogram() +
#   facet_grid(Vx1 ~ Vx2)

## make a graph, wichtig zu wissen: Vx1 ist kategorisch, und Vx2 ist kontinuierlich (ANCOVA), Vy ist kontinuierlich
ggplot(Datensatz, aes(x=Vx1, y=sqrt_Vy, col=Vx2)) +
  geom_point(position=position_jitterdodge(jitter.width = 0.2))

## Calculate the mean and standard deviation of each treatment combination
meanz <- Datensatz %>% group_by(Vx2, Vx1) %>%
  summarise(mean=mean(sqrt_Vy),
            sd=sd(sqrt_Vy))
meanz

## lets put the mean of each treatment combination onto the graph,wichtig zu wissen: 
# Vx1 ist kategorisch, und Vx2 ist kontinuierlich (ANCOVA), Vy ist kontinuierlich 
ggplot(Datensatz, aes(x=Vx2, y=sqrt_Vy, col=Vx1)) +
  geom_point(position=position_jitterdodge(jitter.width = 0.2,
                                           dodge.width = 0.5)) +
  geom_point(data=meanz, mapping=aes(y=mean), size=10, shape=1,
             position = position_dodge(width=0.5))
## does it look like there's an interaction?

## fit full model (i.e. with interaction), wichtig zu wissen: 
# Vx1 ist kategorisch, und Vx2 ist kontinuierlich (ANCOVA), Vy ist kontinuierlich
m1 <- lm(sqrt_Vy ~ Vx2 * Vx1, Datensatz)
## model diagnostics
autoplot(m1)
anova(m1)
## evidence of an interaction?

## here we get the confidence intervals (default is 95% CI)
confint(m1)

## and use the summary table to give us the r-squared
summary(m1)

## a nice graph, wichtig zu wissen: 
# Vx1 ist kategorisch, und Vx2 ist kontinuierlich (ANCOVA), Vy ist kontinuierlich
# evtl. wegen col=Vx2, eher auf Vx1 wechseln?
ggplot(Datensatz, aes(x=Vx1, y=sqrt_Vy, col=Vx2)) +
  geom_point(position=position_jitterdodge(jitter.width = 0.2,
                                           dodge.width = 0.5)) +
  geom_point(data=meanz, mapping=aes(y=mean), size=10, shape=1,
             position = position_dodge(width=0.5)) +
  theme_bw() +
  ylab(expression("y-Wert - square root cm"^"2")) +
  xlab("Vx1 on the shoreline")

## mach einen neuen Graphen und nimm die fitted lines dazu
## zuerst - neue x-Werte - an welchen Stellen wollen wir die sqrt_Vy voraussagen?
new.x <- expand.grid(
  Vx2=seq(from=8, to=45, length.out=10), 
  Vx1=levels(Datensatz$Vx1))

## brauche predict() und data.frame() um die neuen y's zu generieren, dann
## sammle sie (housekeeping) um sie zu plotten, und zwar in einem Object namens
## (preds.for.plot oder hier eher) addThese
new.y <- predict(m1, newdata=new.x, interval=`confidence`)

## housekeeping um new.x und new.y zusammen zu bringen
addThese <- data.frame(new.x, new.y)
addThese <- rename(addThese, sqrt_Vy=fit)

## mach den Graphen (Rohdaten mit points) und nimm lines und CI dazu (smooth):
ggplot(Datensatz, aes(x=Vx2, y=sqrt_Vy, colour=Vx1)) + 
  geom_point(size=5) + 
  geom_smooth(data=addThese, 
              aes(ymin=lwr, ymax=upr, fill=Vx1), 
              stat='identity') + 
  scale_colour_manual(values=c(Vx11="green", Vx12="red")) + 
  scale_fill_manual(values=c(Vx11="green", Vx12="red")) + 
  theme_bw()
