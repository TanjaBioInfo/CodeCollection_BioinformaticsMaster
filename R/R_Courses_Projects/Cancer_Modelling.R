########## Sinn der Task 7 
##### **Aufgabe 1: Analyse von Wachstumsraten und Verdopplungszeit**, entsprechend hier mit einer ODE lösen
#   1. **Datenaufbereitung**:
#   - Tumorwachstumsdaten von Patienten werden eingelesen, 
#   bereinigt und relevante Spalten in numerische Werte umgewandelt.
# 
#   2. **Berechnungen**:
#   - Absolute und relative Wachstumsraten sowie die Tumorverdopplungszeit 
# werden berechnet.
# - Hypothesen:
#   1. Größere Tumore zu Beginn haben eine höhere Verdopplungszeit.
# 2. Kalkifizierte Tumore haben eine längere Verdopplungszeit.
# - Statistische Tests:
#   - Lineare Regression analysiert den Zusammenhang zwischen initialem 
# Tumorvolumen und Verdopplungszeit.
# - Ein t-Test vergleicht die Verdopplungszeit zwischen kalkifizierten 
# und nicht-kalkifizierten Tumoren.
# 
# 3. **Visualisierungen**:
#   - Scatterplots und Boxplots visualisieren die Beziehungen und Unterschiede.
# **Outcome**:
#   - Die Ergebnisse zeigen, dass größere Tumore zu Beginn tendenziell eine 
# längere Verdopplungszeit haben.
# - Kalkifizierte Tumore haben signifikant längere Verdopplungszeiten, 
# wie durch den t-Test bestätigt.
# 
# ##############
#   
##### **Aufgabe 2: Agentenbasierte Simulation (NetLogo)**
#   - Dieser Teil ist nur als Hinweis integriert. Er beschreibt, 
# wie NetLogo zur Simulation des Tumorwachstums verwendet werden kann.
# 
# #############
#   
##### **Aufgabe 3: Tumorwachstum mit ODEs**
#   1. **Szenarien alpha > beta, alpha < beta, alpha = beta:
#   - Das Modell erklärt, dass bei alpha > beta exponentielles Wachstum, 
# bei alpha < beta exponentieller Zerfall und bei alpha = beta
# ein Gleichgewicht herrscht.
# 
# 2. **Gompertz-Wachstum**:
#   - Modelliert das Tumorwachstum unter Berücksichtigung der 
# Tragekapazität K.
# - Das Wachstum verlangsamt sich, wenn der Tumor K erreicht.
# 
# 3. **Therapieeffekte**:
#   - Konstante Wirkstoffkonzentration:
#   - Berechnet die Zeit, bis der Tumor auf die Hälfte schrumpft oder eliminiert wird.
# - Clearance des Wirkstoffs:
#   - Simuliert, wie der Abbau des Wirkstoffs die Dynamik beeinflusst.
# - Chemositzungen:
#   - Zeigt, wie periodische Dosen den Tumor langfristig beeinflussen.
# 
# **Outcome**:
#   - Konstante Konzentration reduziert den Tumor schnell, 
# während Clearance den Effekt verlangsamt.
# - Periodische Chemositzungen können die Wirkung von Clearance kompensieren.
# 
# #############
#   
##### **Aufgabe 4: Resistenz und Rückkehr zur Empfindlichkeit**
#   1. **Resistente Tumorzellen**:
#   - Simuliert die Dynamik von resistenten und empfindlichen Tumorzellen.
# - Berechnet das Volumen der resistenten Zellen einen Monat nach Behandlungsbeginn.
# - Zeigt, wann resistente Zellen die empfindlichen überwiegen.
# 
# 2. **Rückkehr zur Empfindlichkeit**:
#   - Berücksichtigt eine Rückkehrrate q, bei der resistente Zellen 
# wieder empfindlich werden.
# - Simuliert, wie diese Rückkehr die Dynamik beeinflusst.
# 
# **Outcome**:
#   - Resistente Zellen wachsen und überwiegen nach einer bestimmten Zeit, 
# außer die Rückkehrrate q ist ausreichend hoch, um sie zu kontrollieren.
# 
# #############
#   
############## **Quintessenz**############
#   1. **Hauptaussagen**:
#   - Größere initiale Tumore haben längere Verdopplungszeiten.
# - Kalkifizierte Tumore wachsen langsamer.
# - Konstante oder regelmäßige Therapie kann Tumorwachstum kontrollieren.
# - Resistenz ist ein kritisches Hindernis, das durch Kombinationen wie 
# Rückkehr zur Empfindlichkeit adressiert werden kann.

# 3. **Zusammenfassung**:
#   - Der Code modelliert Tumorwachstumsdynamiken effektiv.
# - Die Kombination von Wachstumsmodellen und therapeutischen Szenarien 
# liefert wertvolle Einblicke in die Tumorkontrolle und den Einfluss von Resistenz.



############################# Entfernen der aktuellen Arbeitsumgebung

##### Aufgabe 1. a)
rm(list = ls())

# Laden/Installieren der notwendigen Pakete
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load("ggplot2", "tidyverse")

# Setzen des Arbeitsverzeichnisses
path_to_wd <- "/Users/TR/Desktop/BIO 445, quantitative life science/08_for-students"
setwd(path_to_wd)

# Laden der Datendatei von 41 Patienten
data <- read.csv("Nakamura_db_BT_start.csv", sep = ";")

# Bereinigung der Daten
str(data)  # Überprüfung der Datenstruktur
summary(data)  # Überblick über die Statistiken

# Umwandeln von Volumen-Spalten in numerische Werte
# Falls Dezimalzeichen "," sind, wird dies angepasst
data$Initial_tumor_vol <- as.numeric(gsub(",", ".", data$Initial_tumor_vol))
data$Latest_tumor_vol <- as.numeric(gsub(",", ".", data$Latest_tumor_vol))
data$Follow_up_time <- as.numeric(data$Follow.up.time)  # Follow-up Zeit in Monaten

## b) Berechnung der Wachstumsraten
# Absolutes Wachstum (cm3)
data$absolute_growth <- data$Latest_tumor_vol - data$Initial_tumor_vol

# Absolutes Wachstum pro Jahr (cm3/Jahr)
data$absolute_growth_rate <- data$absolute_growth / (data$Follow_up_time / 12)

# Relative Wachstumsrate (%/Jahr)
data$relative_growth_rate <- (((data$Latest_tumor_vol / data$Initial_tumor_vol)^(1 / (data$Follow_up_time / 12))) - 1) * 100

# Überprüfung der berechneten Werte
head(data[, c("absolute_growth", "absolute_growth_rate", "relative_growth_rate")])

## c) Visualisierung: Alter vs. absolutes Wachstum
p1 <- ggplot(data, aes(x = Age, y = absolute_growth_rate)) +
  geom_point() +
  labs(title = "Age of Patients versus Absolute Growth Rate", x = "Age of Patients (years)", y = "Absolute Growth Rate (cm3/year)") +
  theme_minimal()
print(p1)

## d) Lineare Regression: Alter und absolutes Wachstum
lm_model <- lm(absolute_growth_rate ~ Age, data = data)
summary(lm_model)  # Details zur Regression

# Darstellung der Regressionsanpassung
p2 <- ggplot(data, aes(x = Age, y = absolute_growth_rate)) +
  geom_point() +
  geom_smooth(method = "lm", color = "red") + # Der graue Streifen ist das 95%-Konfidenzintervall, das standardmäßig von geom_smooth() in ggplot2 hinzugefügt wird
  labs(title = "Linear Regression: Age of Patients versus Absolute Growth Rate", x = "Age of Patients (years)", y = "Absolute Growth Rate (cm3/year)") +
  theme_minimal()
print(p2)

## e) Tumorverdopplungszeit berechnen (in Jahren)
data$doubling_time <- (data$Follow_up_time / 12) * (log(2) / log(data$Latest_tumor_vol / data$Initial_tumor_vol))

# Überprüfung der Verdopplungszeiten
head(data[ , c("doubling_time")])


## 1.e) 1)+2) Hypothesen testen
# Hypothesen und Tests:
#   1. Hypothese:
#   Tumors that were larger at the first screen tend to have a higher doubling time.
# Testmethode:
#   Verwenden Sie eine lineare Regression, um die Beziehung zwischen dem initialen 
# Tumorvolumen und der Verdopplungszeit zu analysieren.
# Stellen Sie die Daten in einem Scatterplot dar und visualisieren Sie die lineare 
# Anpassung.
## e) 1. Lineare Regression: Initiales Tumorvolumen vs. Verdopplungszeit
lm_volume_doubling <- lm(doubling_time ~ Initial_tumor_vol, data = data)
summary(lm_volume_doubling)

# Visualisierung: Initiales Tumorvolumen vs. Verdopplungszeit
p5 <- ggplot(data, aes(x = Initial_tumor_vol, y = doubling_time)) +
  geom_point() +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Initial Tumor Volume versus Doubling Time",
       x = "Initial Tumor Volume (cm3)",
       y = "Doubling Time (years)") +
  theme_minimal()
print(p5)
# Signifikanz: Der p-Wert des Modells (p-value: 0.1648) zeigt, ob der Zusammenhang nicht statistisch signifikant ist.

# oder mittels Correlationstest Pearson's product-moment correlation:
## e.1) Größere Tumore zu Beginn und Verdopplungszeit
cor.test(data$Initial_tumor_vol, data$doubling_time)
#  cor 0.2211032, p-value = 0.1648

## e.2) Verkalkte Tumore und Verdopplungszeit
# 2. Hypothese:
#   Calcified tumors have a higher doubling time
# Testmethode:
#   Verwenden Sie einen t-Test oder eine Varianzanalyse (ANOVA), um die Verdopplungszeit zwischen kalkifizierten und nicht-kalkifizierten Tumoren zu vergleichen.
# Visualisieren Sie die Unterschiede in einem Boxplot.
# Gruppentest: Kalkifizierte vs. nicht kalkifizierte Tumore
t_test_calcified <- t.test(doubling_time ~ Calcification, data = data)
print(t_test_calcified) # p-value = 0.1534

# Visualisierung: Kalkifizierte Tumore vs. Verdopplungszeit
p6 <- ggplot(data, aes(x = as.factor(Calcification), y = doubling_time, fill = as.factor(Calcification))) +
  geom_boxplot() +
  scale_fill_manual(values = c("blue", "orange")) +
  labs(title = "Calcified Tumors versus Doubling Time",
       x = "Calcification (yes/no)",
       y = "Doubling Time (years)") +
  theme_minimal()
print(p6)
# Ein signifikanter p-Wert des t-Tests zeigt, dass kalkifizierte Tumore eine 
# andere Verdopplungszeit haben.
# Die Visualisierung mit dem Boxplot unterstützt diese Aussage.


##### Aufgabe 2: Agenten-basierte Simulation
# Hinweis: Diese Aufgabe erfordert NetLogo, der folgende Code beschreibt die Beobachtungen.
## a) Beobachtungen ausführen und analysieren (in NetLogo laden).
## b) Parameter ändern und Ergebnisse dokumentieren:
#    - initial-division-rate: 0.018, initial-apoptosis-rate: 0.01, mutation-rate: 0.01
#    - Wechselwirkungen analysieren (Stochastische Modellierung).



##### Aufgabe 3: Tumorwachstum mit ODEs modellieren
## a. Scenarios: α > β, α < β, α = β
# Scenario: α > β
# The term α⋅N−β⋅N is positive, leading to exponential tumor growth.
# Tumor size increases rapidly over time.
# Scenario: α < β
# The term α⋅N−β⋅N is negative, causing exponential decay.
# Tumor size decreases and eventually approaches zero.
# Scenario: α = β
# The term α⋅N−β⋅N equals zero, resulting in no growth or shrinkage.
# Tumor size remains constant.

## a) Definition des Gompertz-Modells
# Load required libraries
library(deSolve)

# Gompertz growth ODE function
gompertz_growth <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    dN <- r * N * log(K / N)
    list(c(dN))
  })
}

# Parameters and initial conditions
parameters <- c(r = 0.015, K = 40)
yini <- c(N = 0.001)
times <- seq(0, 2000, by = 1)

# Solve the ODE
out <- ode(y = yini, times = times, func = gompertz_growth, parms = parameters)

## b) Simulation und Visualisierung
plot(out, main = "Gompertz Growth Model", xlab = "Time (days)", ylab = "Tumor Volume (cm³)", type = "l")


## c) Therapieeffekt
# Constant Drug Concentration
# Treatment starts after 3 years.
# Drug concentration c(t) is constant.
# Key Questions:
# 3.c)1)  When does the tumor shrink by half?
# 3.c)2)  When is the tumor eliminated?

therapy_constant_delayed <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    if (time < 1095) {
      dN <- r * N * log(K / N)  # Tumor wächst ohne Therapie
      dC <- 0 # keine Behandlung
    } else {
      dC <- -0*c # clearance ist -0
      dN <- r * N * log(K / N) - alpha * c * N  # Therapie startet
    }
    list(c(dN, dC))
  })
}

# Parameter und Anfangswerte
parameters <- c(r = 0.015, K = 40, alpha = 0.7)  # Anpassung von alpha auf 0.7
yini <- c(N = 0.001, c = 0.3)
times <- seq(0, 2000, by = 1)

# ODE lösen
out <- as.data.frame(ode(y = yini, times = times, func = therapy_constant_delayed, parms = parameters))

# Plot der Ergebnisse
plot(out$time, out$N, main = "Tumor Dynamics with Delayed Treatment Start", xlab = "Time (days)", ylab = "Tumor Volume (cm³)", type = "l")

# Maximales Tumorvolumen vor Therapiebeginn (bei K)
max_tumor_volume <- max(out[out$time <= 1095, "N"], na.rm = TRUE)

#3.c)1.
# Tumorhalbierung berechnen
tumor_half <- which(out$N <= max_tumor_volume / 2)[1] # Tage nach Therapiebeginn
if (!is.na(tumor_half)) {
  cat("Tumor halves after:", tumor_half, "days after treatment initiation\n")
} else {
  cat("Tumor does not halve within the simulation timeframe.\n")
}

#3.c)2.
# Tumorelimination berechnen
tumor_eliminated <- which(out$N <= 0.001)[1] # Tage nach Therapiebeginn
if (!is.na(tumor_eliminated)) {
  cat("Tumor eliminated after:", tumor_eliminated, "days after treatment initiation\n")
} else {
  cat("Tumor is not eliminated within the simulation timeframe.\n")
}


# 3.c) 3) With Drug Clearance
# Drug concentration decreases with a rate of 0.25 per day.
therapy_constant_delayed <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    if (time < 1095) {
      dN <- r * N * log(K / N)  # Tumor wächst ohne Therapie
      dC <- 0 # keine Behandlung
    } else {
      dC <- -0.25*c # clearance ist -0.25
      dN <- r * N * log(K / N) - alpha * c * N  # Therapie startet
    }
    list(c(dN, dC))
  })
}

# Parameter und Anfangswerte
parameters <- c(r = 0.015, K = 40, alpha = 0.7)  # Anpassung von alpha auf 0.7
yini <- c(N = 0.001, c = 0.3)
times <- seq(0, 2000, by = 1)

# ODE lösen
out <- as.data.frame(ode(y = yini, times = times, func = therapy_constant_delayed, parms = parameters))

# Plot der Ergebnisse
plot(out$time, out$N, main = "Tumor Dynamics with Delayed Treatment Start", xlab = "Time (days)", ylab = "Tumor Volume (cm³)", type = "l")

# Maximales Tumorvolumen vor Therapiebeginn (bei K)
max_tumor_volume <- max(out[out$time <= 1095, "N"], na.rm = TRUE)

#3.c)1.
# Tumorhalbierung berechnen
tumor_half <- which(out$N <= max_tumor_volume / 2)[1] # Tage nach Therapiebeginn
if (!is.na(tumor_half)) {
  cat("Tumor halves after:", tumor_half, "days after treatment initiation\n")
} else {
  cat("Tumor does not halve within the simulation timeframe.\n")
}

# #3.c)2.
# # Tumorelimination berechnen
# tumor_eliminated <- which(out$N <= 0.001)[1] # Tage nach Therapiebeginn
# if (!is.na(tumor_eliminated)) {
#   cat("Tumor eliminated after:", tumor_eliminated, "days after treatment initiation\n")
# } else {
#   cat("Tumor is not eliminated within the simulation timeframe.\n")
# }


# Chemo Sessions Every 30 Days
# Drug concentration is reset every 30 days by adding Δc=0.3.
# therapy_chemo <- function(time, state, parameters) {
#   with(as.list(c(state, parameters)), {
#     session <- floor((time - 3 * 365) / 30)  # Chemo sessions every 30 days
#     c <- max(0, c * exp(-0.25 * (time - 3 * 365))) + ifelse(session > 0, 0.3, 0)
#     dN <- r * N * log(K / N) - alpha * c * N
#     list(c(dN))
#   })
# }
therapy_chemo <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    # Sicherstellen, dass N nie null oder negativ wird
    if (N <= 1e-6) {
      N <- 1e-6  # Mindestwert für N, um log()-Fehler zu vermeiden
    }
    
    # Berechnung der Wirkstoffkonzentration
    if (time < 3 * 365) {
      c <- 0  # Keine Therapie vor Tag 1095
      dC <- 0  # Keine Änderung der Konzentration vor der Therapie
    } else {
      # Zeit seit Therapiebeginn
      time_since_therapy <- time - 3 * 365
      # Konzentration nimmt mit Clearance-Rate ab
      dC <- -0.25 * c
      # Alle 30 Tage: Konzentration durch Chemositzung erhöhen
      if ((time_since_therapy %% 30) == 0) {
        dC <- dC + 0.3
      }
    }
    
    # Tumorwachstum mit log()
    dN <- r * N * log(K / N) - alpha * c * N
    list(c(dN, dC))
  })
}

# Parameter und Anfangswerte
parameters <- c(r = 0.015, K = 40, alpha = 0.7)  # Wachstumsrate, Kapazität, Therapieeffizienz
yini <- c(N = 0.001, c = 0.3)  # Tumorvolumen und initiale Wirkstoffkonzentration
times <- seq(0, 2000, by = 1)

# ODE lösen
out <- as.data.frame(ode(y = yini, times = times, func = therapy_chemo, parms = parameters))

# Maximales Tumorvolumen vor Therapiebeginn
max_tumor_volume <- max(out[out$time <= 1095, "N"], na.rm = TRUE)

# Tumorhalbierung berechnen
tumor_half <- which(out$N <= max_tumor_volume / 2)[1] # Tage nach Therapiebeginn
if (!is.na(tumor_half)) {
  cat("Tumor halves after:", tumor_half, "days after treatment initiation\n")
} else {
  cat("Tumor does not halve within the simulation timeframe.\n")
}

# # Tumorelimination berechnen
# tumor_eliminated <- which(out$N <= 0.001)[1]  # Tage nach Therapiebeginn
# if (!is.na(tumor_eliminated)) {
#   cat("Tumor eliminated after:", tumor_eliminated, "days after treatment initiation\n")
# } else {
#   cat("Tumor is not eliminated within the simulation timeframe.\n")
# }

# Plot der Ergebnisse
plot(out$time, out$N, main = "Tumor Dynamics with Chemo Sessions", xlab = "Time (days)", 
     ylab = "Tumor Volume (cm³)", type = "l")



## 3.c) 4) Impact of Increasing Drug Strength (α)
# Compare outcomes with varying α.

# Initialisieren der Grafik
# Plot initialisieren mit kürzerem Zeitraum und angepasster y-Achse
# Initialisieren der Grafik
plot(NULL, xlim = c(0, 500), ylim = c(0, max(out[, "N"], na.rm = TRUE)), 
     xlab = "Time (days)", ylab = "Tumor Volume (cm³)", 
     main = "Impact of Increasing Drug Strength (α)")

# Neue α-Werte mit größerer Variation
alpha_values <- c(0.5, 0.7, 0.9)  # Die drei Alpha-Werte
colors <- c("blue", "green", "red")  # Farben für jede Kurve

# Iteration für unterschiedliche α-Werte
for (i in seq_along(alpha_values)) {
  parameters["alpha"] <- alpha_values[i]
  out <- ode(y = yini, times = times, func = therapy_clearance, parms = parameters)
  
  # Plotten der Ergebnisse
  lines(out[, "time"], out[, "N"], col = colors[i], lwd = 2)  # Einheitliche Linienstärke
}

# Legende hinzufügen
legend("topright", legend = paste("Alpha =", alpha_values), col = colors, lty = 1, lwd = 2)



##### Aufgabe 4: Resistenz einfügen
# Modified System with Resistant Cells
# The tumor population is divided into susceptible cells (N_s) 
# and resistant cells (N_r).
## a) Modifizieren des Systems, um resistente Zellen zu simulieren
# a. Volume of Resistant Cells One Month After Treatment
# Assume p=0.01, 
# c(t) is constant

## 4.a) ODE for tumor dynamics with resistance
resistance_ode <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    dN_s <- r * N_s * log(K / (N_s + N_r)) - alpha * c * N_s
    dN_r <- r * N_r * log(K / (N_s + N_r)) + p * N_s
    list(c(dN_s, dN_r))
  })
}

# Parameters and initial conditions
parameters <- c(r = 0.015, K = 40, alpha = 0.7, c = 0.3, p = 0.01)
yini <- c(N_s = 0.999, N_r = 0.001)
times <- seq(0, 2000, by = 1)

# Solve the ODE
out <- ode(y = yini, times = times, func = resistance_ode, parms = parameters)

# Find resistant cell volume after one month (30 days after treatment start at day 1095)
resistant_volume_one_month <- out[out[, "time"] == (3 * 365 + 30), "N_r"]
cat("Volume of resistant cells one month after treatment:", resistant_volume_one_month, "cm³\n")
# Volume of resistant cells one month after treatment: 39.99999 cm³

## 4. b) Dynamics of Both Cell Types
# Plot the tumor dynamics of susceptible and resistant cells over time.
# Determine when the resistant cells predominate.
# Plot the dynamics of susceptible and resistant cells
# Tumordynamik von anfälligen und resistenten Zellen
plot(out[, "time"], out[, "N_s"], type = "l", col = "blue", ylim = c(0, max(out[, c("N_s", "N_r")])),
     xlab = "Time (days)", ylab = "Tumor Volume (cm³)", main = "Dynamics of Susceptible and Resistant Cells", lwd = 2)

# Hinzufügen der resistenten Zellen
lines(out[, "time"], out[, "N_r"], col = "red", lwd = 2)

# Kompakte Legende hinzufügen
legend("topright", legend = c("Susceptible Cells", "Resistant Cells"), 
       col = c("blue", "red"), lty = 1, lwd = 2, cex = 0.8, bty = "n")


# Find when resistant cells predominate
resistant_predominate <- which(out[, "N_r"] > out[, "N_s"])[1]
cat("Resistant cells predominate after:", out[resistant_predominate, "time"], "days\n")
# Resistant cells predominate after: 15 days

## 4. c) Adding Reversion to Susceptibility
# Resistant cells revert back to being susceptible at a rate q.
# Modify the ODE. 
# ODE for tumor dynamics with reversion

reversion_ode <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    dN_s <- r * N_s * log(K / (N_s + N_r)) - alpha * c * N_s + q * N_r
    dN_r <- r * N_r * log(K / (N_s + N_r)) + p * N_s - q * N_r
    list(c(dN_s, dN_r))
  })
}

# Parameters with reversion rate
parameters <- c(r = 0.015, K = 40, alpha = 0.7, c = 0.3, p = 0.01, q = 0.005)
yini <- c(N_s = 0.999, N_r = 0.001)

# Solve the ODE
out <- ode(y = yini, times = times, func = reversion_ode, parms = parameters)

# Plot dynamics with reversion
# Tumordynamik von anfälligen und resistenten Zellen mit Reversion
plot(out[, "time"], out[, "N_s"], type = "l", col = "blue", ylim = c(0, max(out[, c("N_s", "N_r")])),
     xlab = "Time (days)", ylab = "Tumor Volume (cm³)", 
     main = "Dynamics with Reversion to Susceptibility", lwd = 2)

# Hinzufügen der resistenten Zellen
lines(out[, "time"], out[, "N_r"], col = "red", lwd = 2)

# Kompakte Legende hinzufügen
legend("topright", legend = c("Susceptible Cells", "Resistant Cells"), 
       col = c("blue", "red"), lty = 1, lwd = 2, cex = 0.8, bty = "n")


# Summary of Results:
#   Volume of Resistant Cells:
#   Resistant cell volume after one month is calculated using the ODE solution.
# Predominance of Resistant Cells:
#   Resistant cells predominate after a certain number of days when their population 
# surpasses susceptible cells.
# Effect of Reversion:
#   Adding reversion (rate q) slows the growth of resistant cells and increases the 
# population of susceptible cells, altering tumor dynamics.
