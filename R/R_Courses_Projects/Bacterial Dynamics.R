############################################################
#                     Aufgabenlösung                       #
#        Quantitative Life Sciences: Übungsblatt          #
############################################################

# Pakete installieren und laden
install.packages("GillespieSSA")
install.packages("/Users/TR/Desktop/BIO 445, quantitative life science/10_OLAT_upload/kaiser14pb_1.0.tar.gz", repos=NULL, type="source")
require(GillespieSSA)
require(kaiser14pb)

# Problem 1: Mensa Warteschlange
# Aufgabe 1(a): Ist die Münze fair?
# Die Wahrscheinlichkeit für "Kopf" wird geschätzt als 80/100 = 0.8.
# Simulation eines Münzwurfs mit dieser Wahrscheinlichkeit:
coin_sample <- sample(c("Kopf", "Zahl"),
                      size = 10e4,
                      replace = TRUE, # replace=TRUE (i.e. each item that gets picked is put
                                       # back into the pool before the next item is drawn)
                      prob = c(0.8, 0.2))
table(coin_sample)  # Ausgabe der Ergebnisse
# coin_sample
# Kopf  Zahl 
# 80041 19959 
# Die Münze ist nicht fair. 


# Aufgabe 1(b): Ereignis-Wahrscheinlichkeiten
# R (accompany): somebody already waiting in the queue becomes accompanied by a friend;
# C (give up): somebody waiting in the queue gives up and leaves;
# M (arrive): a hungry student comes to mensa and starts to patiently wait at the end of the queue.
# Ereignis-Wahrscheinlichkeiten berechnen basierend auf den Quoten R:C:M = 1:2:7
probabilities <- c(R = 1/10, C = 2/10, M = 7/10) # a)
events_sample <- sample(c("R", "C", "M"),
                        size = 50, # b)
                        replace = TRUE,
                        prob = probabilities)

# Veränderung der Warteschlangenlänge definieren
dqueue <- c("R"=1, "C"=-1, "M"=1) # For each event, calculate the change in the queue length (dqueue).
L_changes <- as.integer(dqueue[events_sample])
L_50 <- sum(L_changes) # To get the final queue
                        # length, sum up the changes using sum function in R.
print(L_50) # 28

# Aufgabe 1(c): Wiederholung der Simulation 1000-mal
L_50_sample <- replicate(1000, {
  events_sample <- sample(c("R", "C", "M"),
                          size = 50,
                          replace = TRUE,
                          prob = probabilities)
  L_changes <- as.integer(dqueue[events_sample])
  sum(L_changes)
})
probability_shorter <- mean(L_50_sample < 25) # weil um 12:00 25 Studis in der Schlage standen
print(probability_shorter) # 0.187, sind 18.7%


# Aufgabe 2: Warteschlangenlänge abhängig von Raten
# Aufgabe 2(a): Simulation der Warteschlange bei abhängigen Raten
queue_first <- function(L_0, rate_R, rate_C, rate_M, N_events) {
  cur_L <- L_0
  for (i in 1:N_events) {
    rate_total <- rate_R * cur_L + rate_C * cur_L + rate_M
    p_R <- (rate_R * cur_L) / rate_total
    p_C <- (rate_C * cur_L) / rate_total
    p_M <- rate_M / rate_total
    event <- sample(c("R", "C", "M"), size = 1, replace = TRUE, prob = c(p_R, p_C, p_M))
    cur_L <- cur_L + dqueue[event]
  }
  return(cur_L)
}

L_50 <- queue_first(L_0 = 25, rate_R = 1, rate_C = 2, rate_M = 7, N_events = 50)
print(L_50) #27

# Aufgabe 2(b): Wiederholung der Simulation 1000-mal
queue_lengths <- replicate(1000, queue_first(L_0 = 25, rate_R = 1, rate_C = 2, rate_M = 7, N_events = 50))
probability_shorter <- mean(queue_lengths < 25)
print(probability_shorter) # 0.901

# Aufgabe 2(c): Simulation mit zufälligen Zeitabständen
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
    cur_L <- cur_L + dqueue[event]
    queue <- rbind(queue, c("time" = cur_t, "L" = cur_L))
  }
  return(queue)
}

# Warteschlangen-Simulation und Visualisierung
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


######################### Aufgabe 2: Salmonellen-Dynamik im cecalen Lymphknoten

# Vorherige Variablen löschen, um Konflikte zu vermeiden
rm(list = ls())

# Notwendige Pakete laden
library(GillespieSSA)
library(kaiser14pb)

# migration : replication : clearance = μ : rL(t) : cL(t)
# The waiting times between the events are random:
#   τ ∼ Exp (1)/(μ + rL(t) + cL(t))

# Funktion zur Implementierung des Gillespie-Algorithmus
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
    cur_L <- cur_L + dqueue[event]
    queue <- rbind(queue, c("time" = cur_t, "L" = cur_L))
  }
  return(queue)
}

# Aufgabe 2.1 (a): 100 Trajektorien simulieren
trajectories <- replicate(100, Gillespie_MRC(L_0 = 0, rate_M = 100, rate_R = 2.5, rate_C = 1, T_final = 1), simplify = FALSE)

# Aufgabe 2.1 (b): Verteilung der Populationsgröße nach 1 Tag
gen_pop_size <- function(traj) {
  return(traj$L[which.max(traj$time <= 1)])
}
pop_size_distr <- unlist(lapply(trajectories, gen_pop_size))
hist(pop_size_distr, breaks = 20, main = "Populationsverteilung nach 1 Tag", xlab = "Population")

# Aufgabe 2(c): Durchschnittliche Populationsgröße
average_curve <- function(times, sample_trajectories) {
  at_time <- function(t, tr) {
    tr <- tr[order(tr$time), ]
    return(tr$L[max(which(tr$time <= t))])
  }
  results <- sapply(times, function(t) mean(sapply(sample_trajectories, at_time, t)))
  return(data.frame("time" = times, "average_L" = results))
}
times <- seq(0, 1, by = 0.01)
average <- average_curve(times, trajectories)
plot(average$time, average$average_L, type = "l", col = "red", lwd = 2, main = "Durchschnittskurve", xlab = "Zeit [Tage]", ylab = "Population")

# Aufgabe 3: Datenanalyse der Salmonellen
# Daten vorbereiten und Untergruppen erstellen
# (Hier müssen kaiser14pb spezifische Funktionen und Daten verwendet werden, z.B. fit.function.c0)

# Simulation der Kolonisierung für unterschiedliche Szenarien
sim_day_1_3 <- function(...) {
  # Ihre Implementierung basierend auf den bereitgestellten Skripten
}

# Ergebnisse für Kontroll- und Antibiotikabehandlungsgruppen simulieren

# Finaler Code ist modular für Flexibilität aufgebaut.
