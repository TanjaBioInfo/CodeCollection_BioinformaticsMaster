######################################################################
### Problem 1 Waiting queue for einfach gut menu in Mensa UZH Irchel
###### als Beispiel für eine Simulation ##############################
######################################################################

# Pakete installieren und laden
install.packages("GillespieSSA")
install.packages("kaiser14pb", repos=NULL, type="source")
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

# # (b) Simulation von 50 Ereignissen und Berechnung der Warteschlangenlänge
# set.seed(42)  # Für reproduzierbare Ergebnisse
# dqueue <- c("R" = 1, "C" = -1, "M" = 1)
# events_sample <- sample(c("R", "C", "M"),
#                         size = 50,
#                         replace = TRUE,
#                         prob = c(prob_R, prob_C, prob_M))
# L_changes <- as.integer(dqueue[events_sample])
# L_50 <- sum(L_changes) + 25  # Initiale Warteschlangenlänge von 25
# print(L_50)  # Ergebnis: Länge der Warteschlange nach 50 Ereignissen

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

