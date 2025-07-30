## Beispielcode für binary / binomial data:

rbinom(n,size,probability)
dbinom(x,size,probability)

# Generate one binary variable, 0/1 with P(y=1)=0.5
rbinom(1,1,0.5)

# 10 binary variables, 0/1 each with P(y=1)=0.3
rbinom(10,1,0.3)

# 10000 binary variables, 0/1 each with P(y=1)=0.3. Sum over all of them and calculate the average, which should again be close to 0.3:
sum(rbinom(10000,1,0.3))/10000

########################################################################################

# Generate one binomial variable with 10 trials and p=0.5
rbinom(1,10,0.5)

# Generate 50 binomial variables with 10 trials and p=0.5
rbinom(50,10,0.5)

#######################################################################################
e <- 2.71828

deviance_explained_Wert <- ...
pchisq(deviance_explained_Wert, 1, lower.tail = F)  # (allg: pchisq(deviance_explained_Wert, df von Chiquadrat, lower.tail = F) )

####################################################################################

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
Datensatz.glm <- glm(Vy ~ Vx, data=Datensatz, family=binomial)  # by default ein logistic-link (log())
# andere glm's: glm.nb()  negativ binomial Regression bei binary Daten
Anzahl_Vy <- nrow(Datensatz)
Anzahl_Vy
ones <- filter(Datensatz, survive == 1)
# Anzahl merken, hier sind es 112 "1"'s
Anzahl_Vy_encoded_as_1 <- 112
# Datensatz$Anzahl_Vy_encoded_as_0 <- Datensatz$Anzahl_Vy - Datensatz$Anzahl_Vy_encoded_as_1
Anzahl_Vy_encoded_as_0 <- 240-112
Anzahl_Vy_encoded_as_0 # 128 "0"'s
success_failure_Datensatz.glm <- glm(cbind(Anzahl_Vy_encoded_as_1, Anzahl_Vy_encoded_as_0) ~ treatment, data=Datensatz, family=binomial)   # geht nicht
# nur bei aggregated data (=binomial)!!
# bei non-aggregated data Plotting (evtl. mit cdplot() versuchen) und Dispersionsanalyse nicht sinnvoll
autoplot(success_failure_Datensatz.glm)
anova(success_failure_Datensatz.glm
anova(success_failure_Datensatz.glm, test="Chisq")
# oder:
# pchisq(deviance explained-Wert, 1, lower.tail = F)  (allg: pchisq(deviance explained-Wert, df von Chiquadrat, lower.tail = F) )
## dispersions-check: residuen deviance/df, , 1 ist ok, >2 --> Überdispersion
summary(success_failure_Datensatz.glm)
summary(success_failure_Datensatz.glm)$coef
# log(odds_ratio) = Beta1

############################################################################## binary Daten Beispiel

rm(list=ls())
library (dplyr)
library (ggplot2)
library (ggfortify)
Datensatz <- read.csv("/Users/TR/Desktop/RStudio_Datenanalyse_2022/Master_Datasets/Datensatz.csv")
glimpse(Datensatz)
n <- 13
# success ist coded als "1"
# failures ist coded als "0"
# Anzahl dead bestimmen mit: 
dead <- xtabs(Vy ~ Vx1 + Vx2, Datensatz)
# sonst:
xtabs(Vy ~ Vx1 + Vx2, Datensatz)
# und Anzahl der toten merken (hier 12):
dead <- 12
Vy <- mutate(Vy, successes=dead,
                       failures=n-dead)
Vy <- mutate(Vy, proportion_success=successes/n)
ggplot(Vy, aes(x=Vx1, y=proportion_success, colour=Vx2)) +
  geom_point() #+
# geom_smooth()
m1 <- lm(proportion_success ~ Vx1 * Vx2, Vy)
autoplot(m1)
anova(m1)
## We can even make a version of the graph with the fitted lines.
ggplot(Vy, aes(x=Vx1, y=proportion_success, colour=Vx2)) +
  geom_point() +
  geom_smooth(method="lm")
# # Making and interpreting the binomial
# Then we make the general linear model with binomial distribution family:
m1 <-glm(cbind(successes, failures) ~ Vx1 * Vx2,
         data = Vy, family = "binomial")
autoplot(m1)
anova(m1, test="Chisq")
m2 <-glm(cbind(successes, failures) ~ Vx1 + Vx2,
         data = Vy, family = "binomial")
anova(m1, m2, test="Chisq")
summary(m1)
summary(m1)$deviance / summary(m1)$df.residual

############################################################################ treatment_and_life1, aus Probieren_8
# Vy: Todesrate reduzieren? nach einem Jahr: tot (0) / lebend (1) binary 
#     --> binomial data, nicht-aggregiert (jede Reihe/Beob. steht für eine Maus)
# Vx1: vier Behandlungen: A (Ref. / Kontrollgruppe), B, C, D
# Vx2: Sex (female (Ref.) / male)

#### Lösungen:
# Wahrscheinlichkeit für ein Männchen in der Controll-Gruppe A zu überleben: 0.533
# Die Behandlung B scheint nicht sehr effektiv zu sein, und D hat keinen Haupteffekt bezüglich der Interaktion.
# Aber es besteht ein starker Zusammenhang bezüglich derInteraktion von Behandlung und Geschlecht. 
# Die Behandlung C scheint bei Weibchen einen gegenteiligen Effekt zu haben, verglichen mit den Männchen.
# der amount of deviance, der accounted ist für die Interaktion von Behandlung und Gecshlecht ist 28
# bei nicht-aggregierten Daten kann man nicht auf Über- oder Unterdispersion testen, 
# aber hier ist der Dispersionsfaktor weniger als 1.3. 
# und man muss auch nicht die Residuals auf Normalverteilung checken. 

######################### GLM systolic blood pressure mit diseased~SBP+smoking, binomial, not aggregated:
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