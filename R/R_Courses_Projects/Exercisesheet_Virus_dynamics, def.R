# Viral Dynamics

# 1. b) Numerische Lösung

setwd("/Users/TR/Desktop/BIO 445, quantitative life science/01_BIO445_students_virus_dynamics")

# Bibliothek für numerische Lösung von Differentialgleichungen
library(deSolve)

# Definition des TI-Modells als Funktion
TI.model <- function(t, x, parms) {
  T <- x[1]  # Zielzellen (Target Cells)
  I <- x[2]  # Infizierte Zellen
  with(as.list(parms), {
    dT <- lambda - deltaT * T - beta * T * I
    dI <- beta * T * I - deltaI * I
    list(c(dT, dI))
  })
}

# Parameter festlegen
parms <- c(
  lambda = 1000, 
  deltaT = 0.05, 
  deltaI = log(2) / 1.39, 
  beta = 5 / (1000 / 0.05 / (log(2) / 1.39))
)

# Anfangswerte festlegen
xstart <- c(T = parms["lambda"] / parms["deltaT"], I = 1)

# Zeitpunkte für die Simulation
times <- seq(0, 100, length.out = 500)

# Numerische Lösung
out_TI <- as.data.frame(rk4(y = xstart, times = times, func = TI.model, parms = parms))
colnames(out_TI) <- c("time", "Ta", "I")

# Plot der Ergebnisse
plot(out_TI$time, out_TI$Ta, type = "l", col = "blue", xlab = "Zeit", ylab = "Zellpopulation", main = "Virusdynamik")
lines(out_TI$time, out_TI$I, col = "red")
legend("topright", legend = c("Zielzellen", "Infizierte Zellen"), col = c("blue", "red"), lty = 1)

# 1. c) Manuelle numerische Lösung
dt <- 0.1
T <- parms["lambda"] / parms["deltaT"]
I <- 1
output_manual <- data.frame(t = 0, T = T, I = I)

# Iterative Lösung
for (k in 1:2000) {
  t <- output_manual[nrow(output_manual), "t"]
  T <- output_manual[nrow(output_manual), "T"]
  I <- output_manual[nrow(output_manual), "I"]
  
  dT <- (parms["lambda"] - parms["deltaT"] * T - parms["beta"] * T * I) * dt
  dI <- (parms["beta"] * T * I - parms["deltaI"] * I) * dt
  
  T_new <- T + dT
  I_new <- I + dI
  t_new <- t + dt
  
  output_manual <- rbind(output_manual, c(t = t_new, T = T_new, I = I_new))
}

# Plot der Ergebnisse
plot(output_manual$t, output_manual$T, type = "l", col = "blue", xlab = "Zeit (Tage)", ylab = "Zellpopulation", main = "Manuelle Lösung TI model")
lines(output_manual$t, output_manual$I, col = "red")
legend("topright", legend = c("Zielzellen", "Infizierte Zellen"), col = c("blue", "red"), lty = 1, cex = 0.8)


# 1. d) TIV-Modell mit Drugtreatment

# Bibliothek für numerische Lösung von Differentialgleichungen
library(deSolve)
# Bibliothek laden
library(deSolve)

# Definition des TIV-Modells
TIV.model <- function(t, x, parms) {
  T <- x[1]  # Zielzellen
  I <- x[2]  # Infizierte Zellen
  V <- x[3]  # Viruslast
  with(as.list(parms), {
    dT <- lambda - deltaT * T - beta * T * V
    dI <- beta * T * V - deltaI * I
    dV <- p * I - deltaV * V
    list(c(dT, dI, dV))
  })
}

# Parameter für das TIV-Modell
parms_TIV <- c(
  lambda = 1000,          # Produktionsrate der Zielzellen
  deltaT = 0.05,          # Sterberate der Zielzellen
  deltaI = log(2) / 2,    # Sterberate der infizierten Zellen (Halbwertszeit = 2 Tage)
  deltaV = log(2) / 1,    # Sterberate der Viruspartikel (Halbwertszeit = 1 Tag)
  beta = 0.00005,         # Infektionsrate (kleinere Werte für stabilere Dynamik)
  p = 2                   # Produktionsrate der Viruspartikel (angepasst, um die Virenlast zu begrenzen)
)

# Anfangswerte für die Simulation
xstart_TIV <- c(
  T = parms_TIV["lambda"] / parms_TIV["deltaT"], # Zielzellen im Gleichgewicht
  I = 1,                                        # Anfangsinfizierte Zellen
  V = 10                                        # Anfangsviruslast
)

# Zeitpunkte für die Simulation ohne Behandlung
times <- seq(0, 100, length.out = 500)

# Simulation ohne Behandlung
out_TIV <- as.data.frame(rk4(xstart_TIV, times, TIV.model, parms_TIV))
colnames(out_TIV) <- c("time", "T.lambda", "I", "V")

# Drug-Behandlung nach 100 Tagen
parms_TIV_treatment <- parms_TIV
parms_TIV_treatment["beta"] <- 0  # Virusinfektiösität wird durch Therapie eliminiert

# Zeitpunkte für die Simulation mit Behandlung
times_treatment <- seq(100, 200, length.out = 500)

# Anfangswerte für die Behandlung
xstart_TIV_treatment <- as.numeric(out_TIV[nrow(out_TIV), c("T.lambda", "I", "V")])

# Simulation der Therapie
out_TIV_treatment <- as.data.frame(rk4(xstart_TIV_treatment, times_treatment, TIV.model, parms_TIV_treatment))
colnames(out_TIV_treatment) <- c("time", "T.lambda", "I", "V")

# Ergebnisse kombinieren
out_TIV_combined <- rbind(out_TIV, out_TIV_treatment)

# Plot der Ergebnisse
plot(out_TIV_combined$time, out_TIV_combined$T.lambda, type = "l", col = "blue",
     xlab = "Zeit (Tage)", ylab = "Population", main = "TIV-Modell mit Behandlung", ylim = c(0, 25000))
lines(out_TIV_combined$time, out_TIV_combined$I, col = "red")
lines(out_TIV_combined$time, out_TIV_combined$V, col = "green")
abline(v = 100, lty = 2, col = "black")  # Behandlungsbeginn
legend("topright", legend = c("Zielzellen (T)", "Infizierte Zellen (I)", "Viruslast (V)", "Behandlungsbeginn"),
       col = c("blue", "red", "green", "black"), lty = c(1, 1, 1, 2), cex = 0.8, box.lwd = 0, bg = "transparent")


# TI-Modell mit Behandlung nach 100 Tagen
parms_TI_treatment <- parms
parms_TI_treatment["beta"] <- 0
xstart_TI_treatment <- as.numeric(out_TI[nrow(out_TI), c("Ta", "I")])
out_TI_treatment <- as.data.frame(rk4(xstart_TI_treatment, times_treatment, TI.model, parms_TI_treatment))
colnames(out_TI_treatment) <- c("time", "Ta", "I")
out_TI_combined <- rbind(out_TI, out_TI_treatment)

# Plot der Ergebnisse
plot(out_TI_combined$time, out_TI_combined$Ta, type = "l", col = "blue",
     xlab = "Zeit (Tage)", ylab = "Population", main = "TI-Modell mit Behandlung", ylim = c(0, 25000))
lines(out_TI_combined$time, out_TI_combined$I, col = "red")
abline(v = 100, lty = 2, col = "black")
legend("topright", legend = c("Zielzellen (T)", "Infizierte Zellen (I)", "Behandlungsbeginn"),
       col = c("blue", "red", "black"), lty = c(1, 1, 2), cex = 0.8)


# 2.
# # 2. a)
# Biologische Plausibilität der zwei Szenarien und Unterscheidbarkeit in der chronischen Phase ohne Behandlung:
#   
# - **Langsame Turnover-Rate (infizierte Zellen überleben lange, niedrige Nachkommenrate):
#   - Biologisch weniger plausibel, da HIV bekannt ist für seine hohe Replikationsrate und die schnelle 
# Produktion neuer Virionen.
#   - In der chronischen Phase (unbehandelt) zeigt das Immunsystem oft eine kontinuierliche Aktivierung und 
# Erschöpfung, was auf einen schnellen Zellumsatz hinweist.
#   - Eine langsame Turnover-Rate würde zu einer langsamen Abnahme der Viruslast führen, was nicht mit den 
# klinischen Beobachtungen übereinstimmt.
# 
# - **Schnelle Turnover-Rate (infizierte Zellen sterben schnell, hohe Nachkommenrate):
#   - Dies entspricht dem derzeitigen biologischen Verständnis von HIV, das auf eine hohe Dynamik in der 
# Virusproduktion und -zerstörung hinweist.
#   - Die kurze Halbwertszeit freier Viren (ca. 6 Stunden) und infizierter CD4+-Zellen (1-2 Tage) stützt die 
# Hypothese eines schnellen Turnovers.
#   - In der unbehandelten chronischen Phase wird ein Gleichgewicht zwischen Virusproduktion und Immunsystem erreicht, 
# was ebenfalls für einen schnellen Turnover spricht.
# 
# Daher lässt sich basierend auf den bisherigen Daten der chronischen Phase in der Regel das Szenario eines 
# schnellen Turnovers bevorzugen.
# 
# 
# 
# # 2. b) 
# Bestimmung der Turnover-Rate durch Viruslast-Abfall unter wirksamer Therapie:
#   
#   Wenn die Behandlung vollständig wirksam ist (d.h. \( \beta \) wird auf 0 reduziert und es entstehen keine 
#   neuen Infektionen), beschreibt das Modell den exponentiellen Abfall der Viruslast. 
# Dies lässt sich in zwei Phasen unterteilen:
#   
#   1. **Erste Phase (freier Virusabfall):
#   - Nach Beginn der Therapie sinkt die Konzentration freier Viren mit der Halbwertszeit freier Viren 
# (\( T_{1/2} = \ln(2) / c \)), wobei \( c \) die Clearance-Rate der Viren ist.
# 
#   2. **Zweite Phase (Abfall infizierter Zellen):
#   - Sobald die freien Viren abgebaut sind, wird der Abfall der Viruslast durch die Lebensdauer der 
#   infizierten Zellen bestimmt (\( T_{1/2} = \ln(2) / \delta \)), wobei \( \delta \) 
#   die Todesrate infizierter Zellen ist.
# 
# Durch die Anpassung des Modells an die beobachtete Viruslastreduktion in Patienten lassen sich die Parameter 
# \( c \) und \( \delta \) schätzen, die die Turnover-Rate des Virus bestimmen.



# 2. c) Fit der Daten und Berechnung der Halbwertszeit

# Daten einlesen
dataVirusload <- read.csv("/Users/TR/Desktop/BIO 445, quantitative life science/01_BIO445_students_virus_dynamics/virusLoadOnTreatment.csv")
str(dataVirusload)  # Überprüft die Struktur des Datensatzes
head(dataVirusload) # Zeigt die ersten Zeilen an

# Extrahieren der relevanten Spalten
time <- dataVirusload$time  # Zeit
vV <- dataVirusload$V       # Viruslast

# Funktion zur Berechnung der Summe der quadratischen Abweichungen (SSQ)
getSSQ <- function(parm) {
  # Extrahiere die Parameter
  I0 <- parm[1]
  deltaI <- parm[2]
  
  # Vorhergesagte Viruslast mit der exponentiellen Gleichung
  yPredicted <- I0 * exp(-deltaI * time)
  
  # Berechnung der quadratischen Abweichungen
  squaredDifference <- (yPredicted - vV)^2
  
  # Summe der quadratischen Abweichungen
  ssq <- sum(squaredDifference, na.rm = TRUE)
  return(ssq)
}

# Erste Schätzungen für die Parameter
start_params <- c(I0 = max(vV, na.rm = TRUE), deltaI = 0.1)

# Optimierung der SSQ
fit <- optim(start_params, getSSQ, method = "L-BFGS-B", 
             lower = c(0, 0), upper = c(Inf, Inf))

# Ergebnisse extrahieren
I0_fit <- fit$par[1]
deltaI_fit <- fit$par[2]

# Berechnung der Halbwertszeit
half_life <- log(2) / deltaI_fit

# Ergebnisse plotten
plot(time, vV, main = "Virusverfall",
     xlab = "Zeit (Tage)", ylab = "Viruslast", pch = 16, col = "black")
curve(I0_fit * exp(-deltaI_fit * x), from = min(time), to = max(time), add = TRUE, col = "red")
legend("topright", legend = c("Daten", "Fit"), col = c("black", "red"), 
       pch = c(16, NA), lty = c(NA, 1), cex = 0.8)

# Ergebnisse ausgeben
cat("Geschätzte Anfangsviruslast (I0):", round(I0_fit, 4), "\n")
cat("Geschätzte Sterblichkeitsrate (deltaI):", round(deltaI_fit, 4), "\n")
cat("Halbwertszeit der infizierten Zellen:", round(half_life, 2), "Tage\n")

# Erweiterte Funktion zur Berechnung der SSQ
getSSQ_extended <- function(parm) {
  # Parameter extrahieren
  p <- parm[1]
  deltaI <- parm[2]
  deltaV <- parm[3]
  I0 <- parm[4]
  V0 <- parm[5]
  
  # Vorhergesagte Viruslast mit der erweiterten Formel
  V_predicted <- (p * I0 / (deltaV * deltaI)) * exp(-deltaI * time) +
    (V0 - (p * I0 / (deltaV * deltaI))) * exp(-deltaV * time)
  
  # Quadratische Abweichungen
  squaredDifference <- (V_predicted - vV)^2
  
  # Summe der quadratischen Abweichungen
  ssq <- sum(squaredDifference, na.rm = TRUE)
  return(ssq)
}

# Erste Schätzungen für die Parameter
start_params_extended <- c(
  p = 100, 
  deltaI = 0.1, 
  deltaV = 0.1, 
  I0 = max(vV, na.rm = TRUE), 
  V0 = max(vV, na.rm = TRUE)
)

# Optimierung der erweiterten Parameter
fit_extended <- optim(start_params_extended, getSSQ_extended, method = "L-BFGS-B", 
                      lower = c(0, 0, 0, 0, 0), upper = c(Inf, Inf, Inf, Inf, Inf))

# Ergebnisse extrahieren
p_fit <- fit_extended$par[1]
deltaI_fit <- fit_extended$par[2]
deltaV_fit <- fit_extended$par[3]
I0_fit <- fit_extended$par[4]
V0_fit <- fit_extended$par[5]

# Halbwertszeiten berechnen
half_life_I <- log(2) / deltaI_fit
half_life_V <- log(2) / deltaV_fit

# Ergebnisse ausgeben
cat("Geschätzte Parameter:\n")
cat("Produktionsrate (p):", round(p_fit, 4), "\n")
cat("Sterblichkeitsrate infizierter Zellen (deltaI):", round(deltaI_fit, 4), "\n")
cat("Sterblichkeitsrate freier Viren (deltaV):", round(deltaV_fit, 4), "\n")
cat("Anfangszahl infizierter Zellen (I0):", round(I0_fit, 4), "\n")
cat("Anfangszahl freier Viren (V0):", round(V0_fit, 4), "\n")
cat("Halbwertszeit infizierter Zellen:", round(half_life_I, 2), "Tage\n")
cat("Halbwertszeit freier Viren:", round(half_life_V, 2), "Tage\n")

# Plot der Originaldaten
plot(time, vV, main = "Anpassung der erweiterten Viruslastdaten",
     xlab = "Zeit (Tage)", ylab = "Viruslast", pch = 16, col = "black")

# Plot der angepassten Kurve
curve((p_fit * I0_fit / (deltaV_fit * deltaI_fit)) * exp(-deltaI_fit * x) +
        (V0_fit - (p_fit * I0_fit / (deltaV_fit * deltaI_fit))) * exp(-deltaV_fit * x), 
      from = min(time), to = max(time), add = TRUE, col = "red")

legend("topright", legend = c("Daten", "Erweiterter Fit"), col = c("black", "red"), 
       pch = c(16, NA), lty = c(NA, 1), cex = 0.8)


# 2. d) 
# Antwort zur Frage mit lm():
# Direkte Anpassung mit lm() nicht möglich: Die Funktion V(t) enthält zwei exponentielle Komponenten, 
# was die Anwendung von lm() ohne Transformation schwierig macht.
# Separater Fit der Komponenten:
# Jede der beiden Komponenten könnte durch Log-Transformation linearisiert und separat angepasst werden.
# Dies erfordert jedoch zusätzliche Annahmen über die Dominanz einer der Komponenten in verschiedenen Zeitbereichen.
# Fazit:
# Die Aufgabe wird durch Optimierung der erweiterten Formel mit optim() gelöst.
# lm() kann nur in einem vereinfachten Kontext oder für einzelne Komponenten verwendet werden.
# Der kombinierte Fit liefert die Sterblichkeitsraten, die Produktionsrate (p) sowie die Anfangswerte (I(0),V(0)).