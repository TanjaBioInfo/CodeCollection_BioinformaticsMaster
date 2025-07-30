## Beispielcode für count data:

# verschiedene Poisson-Wahrscheinlichkeitsverteilungen mit verschiedenen factorials (?)
lambda <- 2.5

lambda^0/factorial(0) *exp(-lambda)
dpois(0,lambda)

lambda^1/factorial(1) *exp(-lambda)
dpois(1,lambda)

lambda^2/factorial(2) *exp(-lambda)
dpois(2,lambda)

lambda^3/factorial(3) *exp(-lambda)
dpois(3,lambda)

plot(0:10,dpois(0:10,lambda),type="h")

########################################################################################
# Polyps example

# Example: Patient of age 50, without treatment:
exp(4.529 + 50*(-0.0388))
exp(4.529 + 49*(-0.0388))

exp(-0.0388*10)

# Example: Patient of age 50, *with* treatment:
exp(4.529 - 1.359 + 50*(-0.0388))

# Factor of reduction of polyps by the treatment:
exp(-1.359)

e <- 2.71828

############################### Frauen die arm sind bekommen eher und früher Kinder (bei Männern genau umgekehrt): achtung GLM
# Gleichung für female: intersept + (age_first-slope * age) + (income-slpoe * income)
1.78 + (-0.0234 * 32) + (-0.0052 * 80)
## 0.6152, muss mit Poisson gelöst werden:
exp(0.6152)
# 1.850027

############################################################### GLM polyps mit Number~treat+age+sex, poisson:
# female ist Ref., also ist Gleichung für male, untreated: 
# exp(intersept + (age-slope * age) + sexmale-slope)
exp(0.001871 + (0.022484*50) + 0.143101)
# 3.557905
# treated wäre: 1.27994
# female ist Ref., also ist Gleichung für female untreated: 
# exp(intersept + (age-slope * age))
exp(0.001871 + (0.022484*50))
# 3.083518
# treated wäre: 1.109281
# Polypenzumahne pro zehn Jahre: exp(age-slope*10)
exp(0.022484*10)
# 1.252122, dh 1.25 - 1 = 0.25, also Zunahme von 0.25 alle 10 Jahre

######################################## GLM systolic blood pressure mit diseased~SBP+smoking, binomial, not aggregated:
# non-smoking (=0) ist Ref., also ist Gleichung für smokers (=1) mit WertBD 140: 
# exp(intersept + (SBP-slope*WertBD) + smoking-slope)
exp(-6.12246 + (0.02905*140) + 0.63698)
# 0.2420817
# Wahrscheinlichkeit eine Coronarkrankheit zu bekommen:
0.2420817 / (1 + 0.2420817)
# 0.1949
## Odds-Faktor-Zunahme von einem Raucher, um an einer Coronarerkrankung zu erkranken, gegenüber eines Nichtrauchers:
# nur die smoker-slope beachten, da diese schon die Differenz zwischen Smoker und Nichtsmoker ist:
# exp(smoker-slope)
exp(0.63698)
# 1.890762

################################################################ num_legs_dose_exam2 (count data):  
# finde die Datei nirgends, count data, balanced (20 lines per treatment (3))
# --> GLM mit poisson machen

rm(list=ls())
library(tidyverse) ## immer rein nehmen
library(dplyr) ## für wrangle
library(ggplot2) ## für die ggplots
library(ggfortify) ## für autoplot()

Datensatz <- read.csv("/Users/TR/Desktop/RStudio_Datenanalyse_2022/Master_Datasets/num_legs_dose_exam2.csv")
## 60 Beob., 3 Varialblen:  (Vx's) dose (3 treatments/factors: "Low", "Medium", "High" dose radioactivity), individual, und Num_legs (Vy)

## check the data is imported correctly
glimpse(Datensatz)
### Rows: 60, columns: 3

## NA verfälschen die Anzahl der Beobachtungen/observations, diese sind also auszuschliessen (omit=aussschliessen):
beobachtungenOhneNA <- na.omit(Datensatz)
nrow(beobachtungenOhneNA)
## still 60, so no NAs in any variables in any rows.

# IndOhneBeine <- Datensatz %>%
#   filter(Num_legs==0) %>% ## nur Variablen, welche diese Bedingung erfüllen
#   select(Num_legs) %>% ## nur diese Spalten
# sum(IndOhneBeine)

## GLM verwenden:
ggplot(Datensatz, aes(x=dose, y=Num_legs)) + 
  geom_point() + 
  geom_smooth(method="lm", se=FALSE) + 
  geom_smooth(span=1, colour="red", se=FALSE) + 
  xlab("dose-Name") + 
  ylab("Num_legs-Name")
Datensatz.glm <- glm(Num_legs ~ dose, data=Datensatz, family=poisson(link=log))  # andere families: quasipoisson
# andere glm's: glm.nb()  negativ binomial Regression bei binary Daten
autoplot(Datensatz.glm)
anova(Datensatz.glm)  # dispersion: 61.84/57=1.084912
anova(Datensatz.glm, test="Chisq")  # p-Value: 2.2e-16
# oder:
# pchisq(deviance explained-Wert, 1, lower.tail = F)  (allg: pchisq(deviance explained-Wert, df von Chiquadrat, lower.tail = F) )
## dispersions-check: residuen deviance/df, , 1 ist ok, >2 --> Überdispersion
summary(Datensatz.glm)

# ErgebnisDerGleichung <- ...
# exp(ErgebnisDerGleichung)

# signifikanter Effekt der Radioaktivität auf die Anzahl der Beine, neg. korrelliert, 6 Individuen ohne Beine, abzählen im Datensatz
# die Varianz innerhalb der Gruppe steigt mit dem Gruppendurchschnitt (ist so die Regel und siehe Box-Plot)
# p-Value erklärt vom Modell betreffend des Chisq-Test von der deviance (Abweichung):
# 2.2e-16
# geschätzte Anzahl Beine bei high-dose-treatment: 0.1 (entspricht dem exp(Intersept), exp(0.095319)=1.10001
# die Dispersion der Residuen ist gerade über 1, wenn es aber overdispersed wäre, quasi-Poisson-Verteilung probieren