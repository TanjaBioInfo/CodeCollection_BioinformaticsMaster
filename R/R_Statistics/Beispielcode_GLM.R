## Beispiel-Code GLM (eigentlich count data):

rm(list=ls())
library (dplyr)
library (ggplot2)
library (ggfortify)
Datensatz <- read.csv("/Users/TR/Desktop/RStudio_Datenanalyse_2022/Master_Datasets/Datensatz.csv")
glimpse(Datensatz)
ggplot(Datensatz, aes(x=Vx, y=Vy)) + 
  geom_point() + 
  geom_smooth(method="lm", se=FALSE) + 
  geom_smooth(span=1, colour="red", se=FALSE) + 
  xlab("Vx-Name") + 
  ylab("Vy-Name")
Datensatz.glm <- glm(Vy ~ Vx, data=Datensatz, family=poisson(link=log))  # andere families: quasipoisson
# andere glm's: glm.nb()  negativ binomial Regression bei binary Daten
autoplot(Datensatz.glm)
anova(Datensatz.glm)
anova(Datensatz.glm, test="Chisq")
# oder:
# pchisq(deviance explained-Wert, 1, lower.tail = F)  (allg: pchisq(deviance explained-Wert, df von Chiquadrat, lower.tail = F) )
## dispersions-check: residuen deviance/df, , 1 ist ok, >2 --> Überdispersion
summary(Datensatz.glm)

## $ verwenden um eine Spalte/Variable (hier Vx) aus einem Datensatz auszuwählen
min.size <- min(Datensatz$Vx)
max.size <- max(Datensatz$Vx)
## neue x-Werte machen. Den alten Variablennamen (Vx) muss man beibehalten 
## wie er in den Originaldaten ist und somit überschreiben.
new.x <- expand.grid(
  Vx=seq(min.size, max.size, length=1000)
## gebrauche predict() und data.frame() um die neuen y's zu generieren.
## mach fits (fit) und standard errors (se) auf die neuen x-Werte passend.
new.y = predict(Datensatz.glm, newdata = new.x, se.fit = TRUE)
new.y = data.frame(new.y)
## check it
head(new.y)
## housekeeping um new.x und new.y zusammen zu bringen
addThese <- data.frame(new.x, new.y)
addThese <- rename(addThese, Vy=fit)
## check it
head(addThese)
addThese <- mutate(addThese, 
                   lwr=Vy-1.96*se.fit, 
                   upr=Vy+1.96*se.fit)
## Graphik:
ggplot(Datensatz, aes(x=Vx, y=Vy)) + 
  ## zuerst nur die Rohdaten darstellen
  geom_point(size=3, alpha=0.5) +
  ## jetzt fit und CI dazu tun
  geom_smooth(data=addThese, 
              aes(ymin=lwr, ymax=upr), 
              stat='identity') + 
              theme_bw()

