############################################################
#############                                  #############
#############  Bacterial Dynamics within Host  #############
#############                                  #############
############################################################

######################################################################
### Problem 1 Waiting queue for einfach gut menu in Mensa UZH Irchel
######################################################################

# Pakete installieren und laden
install.packages("GillespieSSA")
install.packages("/Users/TR/Desktop/BIO 445, quantitative life science/10_OLAT_upload/kaiser14pb_1.0.tar.gz", repos=NULL, type="source")
require(GillespieSSA)
require(kaiser14pb)

### Aufgabe 1: Unfaire Münze ###
# (a) Wahrscheinlichkeit von "Kopf" schätzen
prob_head <- 80 / 100  # 80 von 100 Würfen sind "Kopf"
print(prob_head)  # Ergebnis: 0.8

# (b) Simulation von 104 Münzwürfen mit der geschätzten Wahrscheinlichkeit
coin_sample <- sample(c("Head", "Tail"),
                      size = 104,
                      replace = TRUE,
                      prob = c(prob_head, 1 - prob_head))
result_table <- table(coin_sample)
print(result_table)  # Ausgabe der simulierten Ergebnisse

### Aufgabe 2: Konstante Ereignisraten ###
# (a) Wahrscheinlichkeiten der Ereignisse R, C und M
rate_R <- 1
rate_C <- 2
rate_M <- 7
rate_total <- rate_R + rate_C + rate_M
prob_R <- rate_R / rate_total
prob_C <- rate_C / rate_total
prob_M <- rate_M / rate_total
print(c(prob_R, prob_C, prob_M))  # Ergebnis: Wahrscheinlichkeiten für R, C und M

# (b) Simulation von 50 Ereignissen und Berechnung der Warteschlangenlänge
set.seed(42)  # Für reproduzierbare Ergebnisse
dqueue <- c("R" = 1, "C" = -1, "M" = 1)
events_sample <- sample(c("R", "C", "M"),
                        size = 50,
                        replace = TRUE,
                        prob = c(prob_R, prob_C, prob_M))
L_changes <- as.integer(dqueue[events_sample])
L_50 <- sum(L_changes) + 25  # Initiale Warteschlangenlänge von 25
print(L_50)  # Ergebnis: Länge der Warteschlange nach 50 Ereignissen

# (c) Wiederholung der Simulation 1000-mal
L_50_sample <- replicate(1000, {
  events_sample <- sample(c("R", "C", "M"),
                          size = 50,
                          replace = TRUE,
                          prob = c(prob_R, prob_C, prob_M))
  L_changes <- as.integer(dqueue[events_sample])
  sum(L_changes) + 25
})
prob_shorter <- mean(L_50_sample < 25)
print(prob_shorter)  # Ergebnis: Wahrscheinlichkeit, dass Warteschlange kürzer als 25 ist

### Aufgabe 3: Warteschlangenlänge abhängig von Raten ###
# (a) Simulation der Warteschlange für 50 Ereignisse
queue_first <- function(L_0, rate_R, rate_C, rate_M, N_events) {
  cur_L <- L_0
  for (i in 1:N_events) {
    rate_total <- rate_R * cur_L + rate_C * cur_L + rate_M
    prob_R <- (rate_R * cur_L) / rate_total
    prob_C <- (rate_C * cur_L) / rate_total
    prob_M <- rate_M / rate_total
    event <- sample(c("R", "C", "M"), size = 1, replace = TRUE, prob = c(prob_R, prob_C, prob_M))
    cur_L <- cur_L + dqueue[event]
  }
  return(cur_L)
}
L_50 <- queue_first(L_0 = 25, rate_R = 1, rate_C = 2, rate_M = 7, N_events = 50)
print(L_50)  # Ergebnis: Warteschlangenlänge nach 50 Ereignissen

# (b) Wiederholung der Simulation 1000-mal
queue_lengths <- replicate(1000, queue_first(L_0 = 25, rate_R = 1, rate_C = 2, rate_M = 7, N_events = 50))
prob_shorter <- mean(queue_lengths < 25)
print(prob_shorter)  # Ergebnis: Wahrscheinlichkeit für kürzere Warteschlange

### Aufgabe 4: Simulation mit zufälligen Zeitabständen ###
Gillespie_MRC <- function(L_0, rate_M, rate_R, rate_C, T_final) {
  queue <- data.frame("time" = 0, "L" = L_0)
  cur_L <- L_0
  cur_t <- 0
  while (cur_t < T_final) {
    rate_total <- rate_R * cur_L + rate_C * cur_L + rate_M
    prob_R <- (rate_R * cur_L) / rate_total
    prob_C <- (rate_C * cur_L) / rate_total
    prob_M <- rate_M / rate_total
    tau <- rexp(1, rate = rate_total)
    cur_t <- cur_t + tau
    event <- sample(c("R", "C", "M"), size = 1, replace = TRUE, prob = c(prob_R, prob_C, prob_M))
    cur_L <- cur_L + dqueue[event]
    queue <- rbind(queue, c("time" = cur_t, "L" = cur_L))
  }
  return(queue)
}

queue_sim <- Gillespie_MRC(L_0 = 25, rate_M = 7, rate_R = 1, rate_C = 2, T_final = 5)
plot(queue_sim$time, queue_sim$L, type = "s", xlab = "Zeit [min]", ylab = "Warteschlangenlänge", main = "Warteschlangenlänge zwischen 12:00 und 12:05")

queue_lengths_at_12.05 <- replicate(1000, {
  sim <- Gillespie_MRC(L_0 = 25, rate_M = 7, rate_R = 1, rate_C = 2, T_final = 5)
  if (tail(sim$time, 1) >= 5) {
    tail(sim$L, 1)
  } else {
    NA
  }
})
prob_shorter_at_12.05 <- mean(queue_lengths_at_12.05 < 25, na.rm = TRUE)
print(prob_shorter_at_12.05)  # Ergebnis: Wahrscheinlichkeit für kürzere Warteschlange um 12:05



######################### Aufgabe 2: Salmonellen-Dynamik im cecalen Lymphknoten #################

# Hauptziel:
#   
#   Der R-Code simuliert und analysiert die Kolonisierungsdynamik von Salmonella Typhimurium 
# im cecalen Lymphknoten nach der Infektion von Mäusen. Gleichzeitig werden experimentelle 
# Daten genutzt, um die zugrunde liegenden Mechanismen (Migration, Replikation und Clearance) 
# mathematisch zu modellieren.
# 
# Was wurde gemacht?
#   Mathematische Modellierung:
#   Implementierung des Gillespie-Algorithmus zur Simulation von Populationsdynamiken mit 
# stochastischen Ereignissen (Migration, Replikation, Clearance).
# Berechnung der Populationsgrößen zu bestimmten Zeitpunkten (z. B. nach 1 Tag).
# Datenanalyse und Visualisierung:
#   Simulation von Trajektorien für die Salmonellenpopulation im Lymphknoten.
# Darstellung der Verteilung der Populationsgrößen nach 1 Tag als Histogramm.
# Berechnung und Plotten der durchschnittlichen Populationsdynamik über die Zeit.
# Vergleich mit einer deterministischen ODE-Lösung, um die Konsistenz zwischen stochastischen 
# und deterministischen Ansätzen zu prüfen.
# Integration experimenteller Daten:
#   Verknüpfung der Simulationen mit experimentellen Daten (WITS-Zahlen).
# Visualisierung von WITS-Zahlen aus dem Experiment mit zusätzlichen Markierungen (Start und 
#                                                           Ende der Antibiotikabehandlung).
# Schätzung der Kolonisierungsparameter aus experimentellen Daten mit Funktionen aus dem 
# kaiser14pb-Paket.

# Vorherige Variablen löschen, um Konflikte zu vermeiden, aber nicht die Funktionen, 
# weil wir gewisse Sachen weiter verwenden sollen
rm(list = ls())

# Pakete installieren und laden
install.packages("GillespieSSA")
install.packages("/Users/TR/Desktop/BIO 445, quantitative life science/10_OLAT_upload/kaiser14pb_1.0.tar.gz", repos=NULL, type="source")
require(GillespieSSA)
require(kaiser14pb)

# Notwendige Pakete laden
library(GillespieSSA)
library(kaiser14pb)

# Funktion zur Implementierung des Gillespie-Algorithmus
L_0 <- 0
rate_M <- 100
rate_R <- 2.5
rate_C <- 1
Gillespie_MRC <- function(L_0, rate_M, rate_R, rate_C, T_final) {
  queue <- data.frame("time"=0, "L"=L_0)
  cur_L <- L_0
  cur_t <- 0
  while (cur_t < T_final) {
    rate_total <- rate_R * cur_L + rate_C * cur_L + rate_M
    p_R <- (rate_R * cur_L) / rate_total
    p_C <- (rate_C * cur_L) / rate_total
    p_M <- rate_M / rate_total
    tau <- rexp(1, rate = rate_total)
    cur_t <- cur_t + tau
    event <- sample(c("R", "C", "M"), size = 1, replace = TRUE, prob = c(p_R, p_C, p_M))
    cur_L <- cur_L + c("R"=1, "C"=-1, "M"=1)[event]
    queue <- rbind(queue, c("time" = cur_t, "L" = cur_L))
  }
  return(queue)
}

# Funktion zur Extraktion der Populationsgröße bei t = 1
pop_size <- function(traj) {
  if (is.data.frame(traj) && any(traj$time <= 1)) {
    traj <- traj[order(traj$time), ]  # Sicherstellen, dass die Zeit aufsteigend sortiert ist
    return(traj$L[max(which(traj$time <= 1))])  # Populationsgröße bei t = 1
  } else {
    return(NA)  # Ungültige Daten ignorieren
  }
}

# Verteilung der Populationsgröße nach 1 Tag
pop_size_distr <- unlist(lapply(sample_trajectories, pop_size))

# Überprüfung auf gültige Werte
if (any(is.na(pop_size_distr))) {
  warning("Einige Trajektorien enthalten ungültige Werte.")
}

# Plot des Histogramms
hist(pop_size_distr, breaks = 20, main = "Population Distribution after 1 Day", xlab = "Population", col = "gray")

# (b.iii) Simulationstrajektorien plotten
plot_trajectories <- function(sample_trajectories, main="Simulated bacteria population sizes", xlim=c(0,1)) {
  # the maximal population size
  max_pop <- max(unlist(lapply(sample_trajectories, FUN=function(df) max(df$L))))
  
  # maximal time
  max_time <- max(unlist(lapply(sample_trajectories, FUN=function(df) max(df$time))))
  
  # transparent black color
  trans_black <- rgb(red=0, green=0, blue=0, alpha=30, maxColorValue=255)
  
  # empty plot
  plot(xlim, c(0,max_pop), type="n", 
       ylab="Population size", xlab="Time p.i. [hours]",
       xaxt="n", main=main)
  axis(side=1, at=seq(from=0, to=xlim[2], by=1/6), labels=seq(from=0, to=xlim[2]*24, by=4))
  pl <- lapply(sample_trajectories, FUN=function(df) lines(df, col=trans_black, type="s"))
  
  return(NULL)
}
plot_trajectories(trajectories)

# (b.iv) Durchschnittskurve berechnen und hinzufügen
average_curve <- function(times, sample_trajectories) {
  times <- sort(times)
  
  # evaluate each trajectory on times
  at_t <- function(t, tr) {
    tr <- tr[order(tr$time),]
    if (t > max(tr$time)) {
      val <- NA
    }
    else {
      val <- tr$L[max(which(tr$time<=t))]
    }
    return(c("L"=val))
  }
  
  new_traj <- lapply(sample_trajectories, 
                     FUN=function(tr) do.call(rbind, lapply(times, 
                                                            FUN=function(t) at_t(t, tr))))
  
  mat_traj <- do.call(cbind, new_traj)
  aver_traj <- apply(mat_traj, MARGIN=1, FUN=mean, na.rm=TRUE)
  aver_traj <- data.frame("time"=times, "L"=aver_traj)
  return(aver_traj)
}

# Berechnung der Durchschnittskurve
times <- seq(0, 1, by = 0.01)
average <- average_curve(times, trajectories)

# Erster Plot: Simulationstrajektorien
plot_trajectories(trajectories, main="Trajectories and Average")

# Durchschnittskurve über den ersten Plot legen
lines(average$time, average$L, type="l", col="red", lwd=2)

# Hinzufügen einer Legende
legend("topleft", legend=c("Trajectories", "Average"), 
       col=c("black", "red"), lty=c(1, 1), lwd=c(1, 2), cex=0.6) # Verkleinern der Legende


# 2.* Deterministische ODE-Lösung hinzufügen
mu <- 100
r <- 2.5
c <- 1
L_deterministic <- function(t) {
  (mu * (exp((r - c) * t) - 1)) / (r - c)
}
lines(times, L_deterministic(times), col="blue", lwd=2)

# 3.* Wahrscheinlichkeit, dass der cecale Lymphknoten nicht kolonisiert wird
first_migration <- function(traj) {
  return(traj$time[which(traj$L > 0)[1]])
}
migration_times <- unlist(lapply(trajectories, first_migration))
prob_not_colonized <- mean(migration_times > (1 / 48), na.rm = TRUE)
print(prob_not_colonized)  # Ergebnis: Wahrscheinlichkeit für keine Kolonisierung innerhalb der ersten 30 Minuten

# 4. Vergleich der durchschnittlichen Kurven bei Änderung der Raten
trajectories_alt <- replicate(100, Gillespie_MRC(L_0 = 0, rate_M = 100, rate_R = 4.5, rate_C = 3, T_final = 1), simplify = FALSE)
average_alt <- average_curve(times, trajectories_alt)
lines(average_alt$time, average_alt$L, col="green", lwd=2)
legend("topleft", legend=c("Standard", "Alternative", "Deterministic"), col=c("red", "green", "blue"), lwd=2, cex=0.6)


############## Aufgabe 3 ######################################
# **Problem 3: Schätzung der Parameter der Kolonisierungsdynamik aus experimentellen Daten**
#   Dieses Problem beschreibt, wie mathematische Modellierung und experimentelle Methoden 
# kombiniert werden können, um die Dynamik der Kolonisation von Bakterien in den Lymphknoten 
# nach einer *Salmonella Typhimurium*-Infektion in Mäusen zu untersuchen.
# ### Methode:
# - **Tagging von Bakterien:** Kurze DNA-Abschnitte und Antibiotika-Resistenzmarker werden in 
# eine nicht-kodierende Region des bakteriellen Genoms eingefügt. Diese Marker können später 
# mit Hilfe von Echtzeit-PCR (rtqPCR) und spezifischen Primern nachgewiesen werden.
# - **Analyse der Markerverteilung:** Änderungen in der Häufigkeit dieser DNA-Tags zwischen 
# zwei Zeitpunkten ermöglichen die Schätzung von Parametern, die die Populationsdynamik beschreiben.
# ### Experiment:
# 1. **Infektionsmodell:**
#   - Mäuse werden mit einem Standard-Streptomycin-Vorbehandlungsprotokoll infiziert.
# - Die Infektion erfolgt mit einer Mischung aus 7 markierten *S. Typhimurium* Stämmen (WITS) 
# und einem Überschuss unmarkierter Bakterien (20- bis 100-fach).
# 2. **Antibiotikabehandlung:**
#   - Am 1. Tag nach der Infektion (p.i.) wird die Behandlung mit Ciprofloxacin gestartet.
# - Diese Behandlung dauert zwischen 2 und 8 Tagen.
# 3. **Analyse der Ergebnisse:**
#   - Am Ende des Experiments werden die Mäuse getötet.
# - Die Anzahl der WITS in den Lymphknoten wird mit rtqPCR quantifiziert.
# ### Ziel:
# Mit dieser Methode sollen die Kolonisierungsparameter (z. B. Wachstum und Absterberaten) im 
# Lymphknoten geschätzt werden, sowohl vor als auch nach Beginn der Antibiotikabehandlung.

# Notwendige Pakete laden
library(kaiser14pb)

# Schritt 1: Datenuntersuchung
# (a) Anzahl der Maus-Genotyp-Behandlungs-Kombinationen bestimmen
# Einzigartige Kombinationen der Maus-Typen anzeigen
mouse_combinations <- unique(kaiser14pb.data$mouse.type)
print(mouse_combinations)  # Zeigt die Genotyp-Behandlungs-Kombinationen
# [1] wt       wt+Cipro wt+PBS  
# Levels:   wt wt+Cipro wt+PBS

# (b) Daten visualisieren: Plot der Anzahl der WITS gegen die Tage nach der Infektion (p.i.)
# Streudiagramm erstellen
plot(kaiser14pb.data$day, kaiser14pb.data$number, 
     col = kaiser14pb.data$mouse.type,  # Unterschiedliche Farben für Maus-Typen
     cex = 0.75,  # Punktgröße
     xlab = "Days after Infection",  # Beschriftung der x-Achse
     ylab = "Number of WITS",  # Beschriftung der y-Achse
     main = "WITS-Data after Infection",  # Titel des Plots
     xlim = c(0, max(kaiser14pb.data$day)),  # x-Achsen-Bereich
     ylim = c(0, max(kaiser14pb.data$number)))  # y-Achsen-Bereich

# # WITS-Zahl an Tag 0 hinzufügen (angenommen: 7 WITS an Tag 0)
# points(x = 0, y = 7, col = "gray", cex = 0.75)

# Vertikale gestrichelte Linie für den Beginn der Antibiotikabehandlung (Tag 1)
abline(v = 1, lty = 2, col = "blue")  # Linie hinzufügen (lty = 2 für gestrichelt)

# Vertikale gestrichelte Linie für das Ende der Antibiotikabehandlung (Tag 8)
abline(v = 8, lty = 2, col = "red")  # Linie hinzufügen (lty = 2 für gestrichelt)

# Legende zum Plot hinzufügen
legend("topright", 
       legend = c(levels(kaiser14pb.data$mouse.type), 
                  "Start of Antibiotic Treatment", 
                  "End of Antibiotic Treatment"),  # Beschriftung
       col = c(unique(kaiser14pb.data$mouse.type), "blue", "red"),  # Farben
       lty = c(rep(NA, length(unique(kaiser14pb.data$mouse.type))), 2, 2),  # Linienstil
       pch = c(rep(1, length(unique(kaiser14pb.data$mouse.type))), NA, NA),  # Punkttypen
       cex = 0.4)  # Legendentextgröße

# (c) Daten in Untergruppen aufteilen:
# (i) Wildtyp-Mäuse (wt)
wt_data <- subset(kaiser14pb.data, mouse.type == "wt")

# (ii*) Wildtyp-Mäuse mit Ciprofloxacin-Behandlung (wt+Cipro)
wtCipro_data <- subset(kaiser14pb.data, mouse.type == "wt+Cipro")

# (iii*) Kontrollgruppe der Wildtyp-Mäuse (wt+PBS)
wtPBS_data <- subset(kaiser14pb.data, mouse.type == "wt+PBS")

# Schritt 2: Behandlungsfreie Kolonisierungsdynamik
# (a) Schätzung der Parameter mit der Funktion fit.function.c0
# Beobachtete WITS-Zahlen an Tag 1 hinzufügen
# Funktion zur Implementierung des Gillespie-Algorithmus
Gillespie_MRC <- function(L_0, rate_M, rate_R, rate_C, T_final) {
  # Initialisierung der Warteschlange
  queue <- data.frame("time" = 0, "L" = L_0)
  cur_L <- L_0
  cur_t <- 0
  
  # Simulation starten
  while (cur_t < T_final) {
    # Gesamt-Ereignisrate berechnen
    rate_total <- rate_R * cur_L + rate_C * cur_L + rate_M
    if (is.na(rate_total) || rate_total <= 0) {
      stop(paste("Ungültiger rate_total-Wert:", rate_total, 
                 "cur_L:", cur_L, 
                 "rate_M:", rate_M, 
                 "rate_R:", rate_R, 
                 "rate_C:", rate_C))
    }
    
    # Wahrscheinlichkeiten der Ereignisse berechnen
    p_R <- (rate_R * cur_L) / rate_total
    p_C <- (rate_C * cur_L) / rate_total
    p_M <- rate_M / rate_total
    
    # Zeit bis zum nächsten Ereignis
    tau <- rexp(1, rate = rate_total)
    cur_t <- cur_t + tau
    
    # Ereignis auswählen
    event <- sample(c("R", "C", "M"), size = 1, replace = TRUE, prob = c(p_R, p_C, p_M))
    
    # Populationsgröße aktualisieren (keine negativen Werte)
    cur_L <- max(0, cur_L + c("R" = 1, "C" = -1, "M" = 1)[event])
    
    # Ergebnisse zur Warteschlange hinzufügen
    queue <- rbind(queue, c("time" = cur_t, "L" = cur_L))
    
    # Abbruch, wenn Population 0 erreicht
    if (cur_L == 0) break
  }
  
  return(queue)
}


# (a) Schätzung der Parameter mit fit.function.c0
# Filtern der Daten auf Tag 1
data_day_1 <- subset(data, day == 1)

# Schätzung der Parameter
mle_1 <- fit.function.c0(data = data_day_1)  # Ohne 'day' Argument
print(mle_1)  # Ergebnisse ausgeben

# (b) Simulation von 100 Trajektorien und Plot
set.seed(42)  # Reproduzierbarkeit

# Standardwerte für fehlende Parameter setzen
rate_M <- ifelse(is.na(mle_1$pars["muG"]), 0, mle_1$pars["muG"])
rate_R <- ifelse(is.na(mle_1$pars["r"]), 0, mle_1$pars["r"])
rate_C <- ifelse(is.na(mle_1$pars["c"]), 0, mle_1$pars["c"])

# Simulation ausführen
trajectories <- replicate(100, Gillespie_MRC(L_0 = 0,  
                                             rate_M = rate_M,  
                                             rate_R = rate_R,  
                                             rate_C = rate_C,  
                                             T_final = 1),  
                          simplify = FALSE)

# Trajektorien plotten
plot_trajectories <- function(sample_trajectories, main="Simulierte WITS-Trajektorien", xlim=c(0,1)) {
  max_pop <- max(unlist(lapply(sample_trajectories, FUN=function(df) max(df$L))))
  plot(xlim, c(0, max_pop), type="n", 
       ylab="Population", xlab="Zeit (Tage)", main=main)
  invisible(lapply(sample_trajectories, function(df) lines(df$time, df$L, col=rgb(0, 0, 0, alpha=0.2), type="s")))
}

# Trajektorien plotten
plot_trajectories(trajectories)

# Beobachtete WITS-Zahlen an Tag 1 hinzufügen
x_coords <- rep(1, length(data$number))  # x-Koordinaten erstellen
points(x = x_coords, y = data$number, col = "red", pch = 16)  # Punkte plotten


# Kompakte Implementierung der mle_PBS_3- und mle_Cipro_3-Funktionen
mle_PBS_Cipro <- function(data, mle_at_1, type="PBS") {
  pgf <- function(parms, t = 3, s) {
    t <- t - 1
    with(as.list(parms), {
      s0 <- ((r * s - c) * exp(c * t - r * t) - c * s + c)/((r * s - c) * exp(c * t - r * t) - r * s + r)
      if (type == "PBS") {
        gs <- pgf.salmonella(parms = c(r = as.numeric(mle_at_1$pars["r"]), 
                                       c = 0, 
                                       muG = as.numeric(mle_at_1$pars["muG"])), t = 1, s0)                                                
        fs <- ((r - c)/(r * s * (1 - exp((r - c) * t)) + r * exp((r - c) * t) - c))^(muG/r)
        return(gs * fs)
      } else {
        return(pgf.salmonella(parms = c(r = as.numeric(mle_at_1$pars["r"]), 
                                        c = 0, 
                                        muG = as.numeric(mle_at_1$pars["muG"])), t = 1, s0))
      }
    })
  }
  if (type == "PBS") {
    return(fit.function.pbs(data = data, pgf = pgf, output.sd = T))
  } else {
    return(fit.function.muG0(data = data, pgf = pgf, output.sd = T))
  }
}

# Simulation von Trajektorien zwischen Tag 1 und 3
sim_day_1_3 <- function(L_0=0, rate_M_1, rate_R_1, rate_C_1, T_final_1=1, rate_M_2, rate_R_2, rate_C_2, T_final_2=3) {
  traj_1 <- Gillespie_MRC(L_0=L_0, rate_M=rate_M_1, rate_R=rate_R_1, rate_C=rate_C_1, T_final=T_final_1)
  ind <- max(which(traj_1$time <= T_final_1))
  L_1 <- traj_1$L[ind]
  traj_2 <- Gillespie_MRC(L_0=L_1, rate_M=rate_M_2, rate_R=rate_R_2, rate_C=rate_C_2, T_final=(T_final_2 - T_final_1))
  traj_2$time <- traj_2$time + T_final_1
  return(rbind(traj_1[1:ind,], traj_2))
}

