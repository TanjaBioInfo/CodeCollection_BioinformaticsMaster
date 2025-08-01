# 1. a) Two key parameters describing the spread of an infection
# are the basic and the effective reproduction numbers, R0 and
# Re, which are defined as the number of secondary infections
# generated by an infected index case in the absence (R0) and presence (Re)
# of control interventions. 
# R0=transmission rate (beta)/recovery rate (gamma)
# R0>1 kein Ausbrach
# R0<1 Ausbrach
# If Re drops below unity, threashold, the epidemic eventually stops.
# R₀ zeigt das Potenzial einer Krankheit, sich ohne Eingreifen auszubreiten, 
# und ist eine wichtige Kennzahl, um die Gefahr eines Ausbruchs zu bewerten.
# Re hingegen zeigt, wie effektiv Maßnahmen (z. B. Quarantäne, Maskenpflicht 
# oder Impfungen) die Ausbreitung kontrollieren. Wenn es gelingt, 
# Re unter 1 zu bringen, wird die Epidemie eingedämmt.


# 1. b) siehe Graphik auf Pptx

# 1. c) Fixierte und zeitabhängige Parameter:
# Fixierte Parameter:
# sigma: Biologisch bedingte Übergangsrate von E zu I (z. B. Inkubationszeit).
# gamma: Biologisch bedingte Genesungs- oder Sterberate.
# f: Proportion der Infizierten, die sterben.
# 
# Zeitabhängige Parameter:
# beta: Variiert mit der Zeit basierend auf Kontrollmaßnahmen:
# Vor tau1
# Nach tau1
# Grund: Einführung von Interventionen wie Quarantäne oder Social Distancing reduziert die Übertragungsrate.
# tau0 und tau1: Zeitpunkte im Modell, die durch externe Ereignisse 
# (z. B. Berichtserstattungen oder Maßnahmen) festgelegt werden.
# Im SEIR-Modell beschreibt \(\beta\) die Übertragungsrate, 
# also wie leicht die Krankheit von einem infizierten auf einen anfälligen Menschen 
# übertragen wird. Vor der Einführung von Maßnahmen bleibt \(\beta\) konstant, 
# aber nach Beginn der Kontrollmaßnahmen (\(\tau_1\)) sinkt \(\beta\) allmählich ab. 
# Der Parameter \(k\) gibt an, wie schnell und effektiv diese Maßnahmen die Übertragungsrate 
# verringern – je höher \(k\), desto schneller wirkt die Kontrolle. 
# Durch diese Veränderung wird die Epidemie verlangsamt, da weniger anfällige Menschen 
# infiziert werden, was schließlich dazu führen kann, dass die Epidemie gestoppt wird. 
# Das Modell ermöglicht so eine Bewertung, wie stark und schnell Maßnahmen die Ausbreitung 
# der Krankheit beeinflussen.

# # 1. d)
# # Laden der Daten
# # Berechnung der Zeitabstände in Tagen
# ebola <- ebola[order(ebola$Date), ]  # Daten nach Datum sortieren
# ebola$Day_Difference <- c(NA, diff(ebola$Date))  # Unterschied zwischen aufeinanderfolgenden Daten
# # Parameter-Annäherung
# # Beispiel: Nehmen wir an, die Übertragungsrate beta über die Zeit folgt einem exponentiellen Abfall.
# # beta(t) = beta0 * exp(-k * t)
# # Wir benötigen hypothetische beta-Werte für Schätzungen oder setzen generische Annahmen.
# # Beispielwert für initiale Übertragungsrate beta0 (ersetzen mit realen Werten, falls verfügbar)
# beta0 <- 0.2  # Anfangswert der Infektionsrate
# # Hypothetische Beta-Werte berechnen (hier nur als Beispiel, ersetzen mit echten Daten)
# ebola$Beta <- beta0 * exp(-0.001 * cumsum(ebola$Day_Difference, na.rm = TRUE))
# # Schätzung des Abklingens von Beta und Berechnung von k
# # Für die Halbwertszeit: beta(t_half) = 0.5 * beta0
# # k = -ln(beta(t) / beta0) / t
# ebola$k <- -log(ebola$Beta / beta0) / cumsum(ebola$Day_Difference, na.rm = TRUE)
# # Halbwertszeit berechnen (ln(2) / k)
# average_k <- mean(ebola$k, na.rm = TRUE)  # Durchschnittswert für k
# half_life_days <- log(2) / average_k
# half_life_months <- half_life_days / 30.44
# # Ergebnisse anzeigen
# cat("Durchschnittlicher k-Wert:", average_k, "\n")
# cat("Halbwertszeit (Tage):", half_life_days, "\n")
# cat("Halbwertszeit (Monate):", half_life_months, "\n")
# # Optional: Exportieren der erweiterten Tabelle
# write.csv(ebola, "/Pfad/zur/erweiterten_Datentabelle.csv", row.names = FALSE)

# Libraries: load or install and load packages
if(!requireNamespace("pacman", quietly = T))   install.packages("pacman")
pacman::p_load("deSolve", "tidyverse")


# Read the data
ebola <- read.csv("/Users/TR/Desktop/BIO 445, quantitative life science/bio445_day03_24_emerging_epidemics_for_students/Ebola_outbreak_West_Africa_data.csv")
ebola$Date <- as.Date(ebola$Date,format = "%d %b %Y")
# Check date format! 

# Definition of the SEIR ODE model
# S: Susceptible (anfällige Personen, die infiziert werden können)
# E: Exposed (exponierte, aber noch nicht infektiöse Personen)
# I: Infected (infizierte und infektiöse Personen)
# R: Recovered (genesene Personen, die nicht mehr infektiös sind)
# D: Dead (Personen, die an der Krankheit gestorben sind)
# C: Cumulative cases (kumulative Gesamtzahl der Infektionsfälle)
SEIR <- function(t, x, parms) {
  with(as.list(c(parms,x)),{
    if(t < tau1) beta <- beta0
    else beta <- beta0*exp(-k*(t-tau1)) 
    # beta0 = per contact infection rate    
    #     k = decay induced by the control measures
    #  tau1 = time of introduction of control measures
    N <- S + E + I + R
    dS <- - beta*S*I/N
    dE <- beta*S*I/N - sigma*E
    dI <- sigma*E - gamma*I
    dR <- (1-f)*gamma*I
    dD <- f*gamma*I
    dC <- sigma*E
    der <- c(dS,dE,dI,dR,dD,dC)
    list(der)
  })
}

# # 1. e) 
# SEIR model with emigration on day zero
SEIR_with_emigration <- function(t, x, parms) {
  with(as.list(c(parms, x)), {
    if (t < tau1) beta <- beta0
    else beta <- beta0 * exp(-k * (t - tau1))
    # Adjust emigration rate
    emigration_rate <- parms["emigration_rate"]
    N <- S + E + I + R
    if(t>=0){
      dS <- - beta * S * I / N - emigration_rate * S
      dE <- beta * S * I / N - sigma * E- emigration_rate * E
    }else{
      dS <- - beta * S * I / N
      dE <- beta * S * I / N - sigma * E
    }
    dI <- sigma * E - gamma * I
    dR <- (1 - f) * gamma * I
    dD <- f * gamma * I
    dC <- sigma * E
    der <- c(dS, dE, dI, dR, dD, dC)
    list(der)
  })
}
# Simulate different emigration rates
simulate_emigration <- function(emigration_rate) {
  parms_with_emigration <- c(pars, emigration_rate = emigration_rate)
  simulation <- as.data.frame(ode(init, timepoints, SEIR_with_emigration, parms = parms_with_emigration))
  simulation$emigration_rate <- emigration_rate
  return(simulation)
}
# Emigration rates to test
emigration_rates <- c(0, 0.01)  # 0.1%, 1%, 3% per day
# Run simulations for each emigration rate
simulations <- lapply(emigration_rates, simulate_emigration)
# Combine simulations into one data frame
simulation_combined <- do.call(rbind, simulations)
# Plot results
library(ggplot2)
ggplot(simulation_combined, aes(x = time)) +
  geom_line(aes(y = C, color = as.factor(emigration_rate))) +
  labs(title = "can leave on day zero",
       x = "Time (days)",
       y = "Cumulative Cases",
       color = "Emigration Rate") +
  theme_classic()


# SEIR model with emigration after day 150
SEIR_with_emigration <- function(t, x, parms) {
  with(as.list(c(parms, x)), {
    if (t < tau1) beta <- beta0
    else beta <- beta0 * exp(-k * (t - tau1))
    # Adjust emigration rate
    emigration_rate <- parms["emigration_rate"]
    N <- S + E + I + R
    if(t>150){
      dS <- - beta * S * I / N - emigration_rate * S
      dE <- beta * S * I / N - sigma * E- emigration_rate * E
    }else{
      dS <- - beta * S * I / N
      dE <- beta * S * I / N - sigma * E
    }
    dI <- sigma * E - gamma * I
    dR <- (1 - f) * gamma * I
    dD <- f * gamma * I
    dC <- sigma * E
    der <- c(dS, dE, dI, dR, dD, dC)
    list(der)
  })
}
# Simulate different emigration rates
simulate_emigration <- function(emigration_rate) {
  parms_with_emigration <- c(pars, emigration_rate = emigration_rate)
  simulation <- as.data.frame(ode(init, timepoints, SEIR_with_emigration, parms = parms_with_emigration))
  simulation$emigration_rate <- emigration_rate
  return(simulation)
}
# Emigration rates to test
emigration_rates <- c(0, 0.01)  # 0.1%, 1%, 3% per day
# Run simulations for each emigration rate
simulations <- lapply(emigration_rates, simulate_emigration)
# Combine simulations into one data frame
simulation_combined <- do.call(rbind, simulations)
# Plot results
library(ggplot2)
ggplot(simulation_combined, aes(x = time)) +
  geom_line(aes(y = C, color = as.factor(emigration_rate))) +
  labs(title = "can leave after the first 150 days",
       x = "Time (days)",
       y = "Cumulative Cases",
       color = "Emigration Rate") +
  theme_classic()


# ..weiter im Code (vorgegeben) 
# Cost function to calculate the sum of squared residuals (SSR) of predicted vs observed data
cost <- function(free, fixed, init, data) {
  pars <- c(free, fixed)
  pars <- trans(pars)
  times <- c(0, data$times + pars["tau0"])
  simulation <- as.data.frame(ode(init, times, SEIR, parms = pars))
  simulation <- simulation[-1, ]
  cost <- sum((simulation$C - data$cases)^2 + (simulation$D - data$deaths)^2)
  return(cost)
}

# Parameter transformation
trans <- function(pars) {
  pars["beta0"] <- exp(pars["beta0"])
  pars["k"] <- exp(pars["k"])
  pars["f"] <- plogis(pars["f"])
  pars["tau0"] <- exp(pars["tau0"])
  pars["tau1"] <- exp(pars["tau1"])
  return(pars)
}


# Fit the model to the data

#####################################################
# GUINEA: Prepare the data and set the initial values
#####################################################
data <- na.omit(ebola[c("Date","Guinea_Cases","Guinea_Death")])
names(data) <- c("times","cases","deaths")
data$times <- as.Date(data$times,format = "%d %b %Y")

begin <- as.Date("2 Dec 2013", format="%d %b %Y") 
delay <- as.numeric(data$times[1] - begin)

data$times <- as.numeric(data$times - data$times[1])
N <- 1e6		
init <- c(S = N - 1, E = 0, I = 1, R = 0, D = 0, C = 1)
fixed <- c(tau0 = log(delay), tau1 = -Inf, sigma = 1/5.3, gamma = 1/5.61)
free <- c(beta0 = log(0.2), k = log(0.001), f = 0)

# Fit the model to the data
fit <- optim(free, cost, gr=NULL, fixed, init, data, method="Nelder-Mead", hessian=TRUE)

# Plot the best-fit model to the data
# back transform the parameteres:
pars <- trans(c(fit$par,fixed))
end <- as.Date("1 Sep 2014", format="%d %b %Y") 

months <- as.Date(c("1 Dec 2013", "1 Mar 2014", "1 Jun 2014", "1 Sep 2014"), format="%d %b %Y") 
timepoints <- seq(0,as.numeric(end - begin),1)

# here we run the model with the estimated parameters (in the "pars" vector)
simulation <- as.data.frame(ode(init, timepoints, SEIR, parms = pars))

# # here we run the modelSEIRlow with the estimated parameters (in the "pars" vector)
# simulationlow <- as.data.frame(ode(init, timepoints, SEIRlow, parms = pars))

# Plot the predicted cases
plot(x = timepoints, y = simulation$C, type="l", col="red", ylim=c(0,700), xlab='Time', 
     ylab="Cumulative number of cases",frame=FALSE,axes=FALSE,main="Guinea, ")
axis(1,months-begin,months)
axis(2)

#Hint: While plotting the observed cases, do not forget to account for the delay in reporting (tau0).

# Original plot
# simulation %>% 
#   ggplot(aes(x = time, y = C, color = "Cases")) + 
#   geom_line() + 
#   geom_line(aes(y = D, color = "Deaths")) +
#   geom_point(data = data, mapping = aes(x = times + pars["tau0"], y = cases, color = "Cases")) +
#   geom_point(data = data, mapping = aes(x = times + pars["tau0"], y = deaths, color = "Deaths")) +
#   labs(x="Time", y="Cumulative number of cases", color = "Legend") +
#   scale_color_manual(values = colors <- c("Cases" = "steelblue4", "Deaths" = "blue4")) +
#   theme_classic() +
#   scale_x_continuous(labels = months, breaks = as.numeric(months-begin))

# Original plot
simulation %>% 
  ggplot(aes(x = time, y = C, color = "Cases")) + 
  geom_line() + 
  geom_line(aes(y = D, color = "Deaths")) +
  geom_point(data = data, mapping = aes(x = times + pars["tau0"], y = cases, color = "Cases")) +
  geom_point(data = data, mapping = aes(x = times + pars["tau0"], y = deaths, color = "Deaths")) +
  labs(
    title = "Plot with given model parameters",  # Hinzugefügter Titel
    x = "Time", 
    y = "Cumulative number of cases", 
    color = "Legend"
  ) +
  scale_color_manual(values = colors <- c("Cases" = "steelblue4", "Deaths" = "blue4")) +
  theme_classic() +
  scale_x_continuous(labels = months, breaks = as.numeric(months - begin))

# # veränderter plot:
# simulationlow %>% 
#   ggplot(aes(x = time, y = C, color = "Cases")) + 
#   geom_line() + 
#   geom_line(aes(y = D, color = "Deaths")) +
#   geom_point(data = data, mapping = aes(x = times + pars["tau0"], y = cases, color = "Cases")) +
#   geom_point(data = data, mapping = aes(x = times + pars["tau0"], y = deaths, color = "Deaths")) +
#   labs(
#     title = "Plot with a low beta",  # Hinzugefügter Titel
#     x = "Time", 
#     y = "Cumulative number of cases", 
#     color = "Legend"
#   ) +
#   scale_color_manual(values = colors <- c("Cases" = "steelblue4", "Deaths" = "blue4")) +
#   theme_classic() +
#   scale_x_continuous(labels = months, breaks = as.numeric(months - begin))


# # mein SIR-Modell:
# sir_model <- function(t, state, parameters) {
#   with(as.list(c(state, parameters)), {
#     dS <- -beta * S * I
#     dI <- beta * S * I - gamma * I
#     dR <- gamma * I
#     list(c(dS, dI, dR))
#   })
# }
# 
# parameters <- c(beta = 0.3, gamma = 0.1)
# state <- c(S = 999, I = 1, R = 0)
# times <- seq(0, 100, by = 1)
# out <- ode(y = state, times = times, func = sir_model, parms = parameters)
# out <- as.data.frame(out)
# 
# ggplot(out, aes(x = time)) +
#   geom_line(aes(y = S, color = "Susceptible")) +
#   geom_line(aes(y = I, color = "Infected")) +
#   geom_line(aes(y = R, color = "Recovered")) +
#   labs(title = "SIR-Modell", y = "Population", x = "Zeit", color = "Kategorien") +
#   theme_minimal()


# Lösung mit Chat-GPT:
# Laden der erforderlichen Bibliotheken
library(ggplot2)
library(deSolve)

# Daten einlesen
data <- read.csv("/Users/TR/Desktop/BIO 445, quantitative life science/bio445_day03_24_emerging_epidemics_for_students/Ebola_outbreak_West_Africa_data.csv", stringsAsFactors = FALSE)

# Konvertierung der Date-Spalte ins richtige Format
data$Date <- as.Date(data$Date, format = "%d %b %Y")

# Entfernen von Zeilen mit NA-Werten in den relevanten Spalten
data <- data[complete.cases(data$Date, data$Total_Cases, data$Total_Death), ]

# Sicherstellen, dass Total_Cases und Total_Death numerisch sind
data$Total_Cases <- as.numeric(data$Total_Cases)
data$Total_Death <- as.numeric(data$Total_Death)

# Teil 1: Plotten der kumulativen Fälle und Todesfälle
ggplot(data, aes(x = Date)) +
  geom_line(aes(y = Total_Cases, color = "Total Cases")) +
  geom_line(aes(y = Total_Death, color = "Total Deaths")) +
  labs(title = "Ebola Cases and Deaths Over Time", x = "Date", y = "Count") +
  theme_minimal() +
  scale_color_manual(name = "Legend", values = c("Total Cases" = "blue", "Total Deaths" = "red"))

# Teil 2: Schätzung von R0 durch lineare Regression
subset_data <- subset(data, Date <= as.Date("2014-04-22"))
subset_data$ln_cases <- log(subset_data$Total_Cases)
model <- lm(ln_cases ~ Date, data = subset_data)
growth_rate <- coef(model)["Date"]

# Angenommene Werte aus der Literatur
incubation_period <- 11  # Inkubationszeit in Tagen
infectious_period <- 15  # Infektionsdauer in Tagen
R0 <- (1 + growth_rate * incubation_period) * (1 + growth_rate * infectious_period)

cat("Geschätztes R0 für Guinea:", R0, "\n")

# Teil 3
# Laden des Startskripts
source("/Users/TR/Desktop/BIO 445, quantitative life science/bio445_day03_24_emerging_epidemics_for_students/Ebola_starting_script_2024.R")

# Startwerte und Parameter
# Initialparameter definieren
init <- c(S = 1e6, E = 10, I = 5, R = 0)  # Startwerte
pars <- list(beta0 = 0.3, sigma = 1/5.2, gamma = 1/2.9, k = 0.1, N = 1e6, tau1 = 50)  # Modellparameter
timepoints <- seq(0, 100, by = 1)  # Zeitvektor

# SEIR-Modell mit Korrektur der Bedingung
SEIR <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    beta <- ifelse(time < tau1, beta0, beta0 * exp(-k * (time - tau1)))  # Vektorisierte Bedingung
    dS <- -beta * S * I / N
    dE <- beta * S * I / N - sigma * E
    dI <- sigma * E - gamma * I
    dR <- gamma * I
    return(list(c(dS, dE, dI, dR)))
  })
}

# Simulation des SEIR-Modells
simulation <- ode(y = init, times = timepoints, func = SEIR, parms = pars)
simulation <- as.data.frame(simulation)

# Ergebnisse des SEIR-Modells plotten
plot(simulation$time, simulation$I, type = "l", col = "red", xlab = "Time (days)",
     ylab = "Infected", main = "SEIR Model - Infected Over Time")

# Beispielparameter für Emigration
emigration_rates <- seq(0.01, 0.1, by = 0.01)

# Funktion zur Simulation mit Emigration
simulate_emigration <- function(rate) {
  pars$emigration_rate <- rate  # Emigrationsrate hinzufügen
  emigration_sim <- ode(y = init, times = timepoints, func = SEIR, parms = pars)
  return(as.data.frame(emigration_sim))
}

# Simulation mit verschiedenen Emigrationsraten
simulations <- lapply(emigration_rates, simulate_emigration)

# Beispielplot für eine Emigrationsrate
plot(simulations[[1]]$time, simulations[[1]]$I, type = "l", col = "blue", xlab = "Time (days)",
     ylab = "Infected", main = paste("SEIR with Emigration Rate =", emigration_rates[1]))

# Verzögerte Kontrolle (tau1 anpassen)
pars$tau1 <- 30  # Verzögerung auf 30 Tage setzen
delayed_simulation <- ode(y = init, times = timepoints, func = SEIR, parms = pars)
delayed_simulation <- as.data.frame(delayed_simulation)

# Vergleich von Standard- und verzögerter Simulation
plot(simulation$time, simulation$I, type = "l", col = "red", xlab = "Time (days)",
     ylab = "Infected", main = "Delayed vs Standard Control")
lines(delayed_simulation$time, delayed_simulation$I, col = "blue")
legend("topright", legend = c("Standard Control", "Delayed Control"),
       col = c("red", "blue"), lty = 1)

# Diagnoserate berücksichtigen
diagnosis_rate <- 0.8
simulation$I_diagnosed <- simulation$I * diagnosis_rate
simulation$I_undiagnosed <- simulation$I * (1 - diagnosis_rate)

# Plot der diagnostizierten und nicht diagnostizierten Fälle
plot(simulation$time, simulation$I_diagnosed, type = "l", col = "blue", xlab = "Time (days)",
     ylab = "Cases", main = "Diagnosed vs Undiagnosed Cases")
lines(simulation$time, simulation$I_undiagnosed, col = "red")
legend("topright", legend = c("Diagnosed", "Undiagnosed"), col = c("blue", "red"), lty = 1)

# Impfstoff hinzufügen
pars$vaccine_start_day <- 50
pars$vaccine_rate <- 0.05  # 5% pro Tag

vaccine_simulation <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    beta <- ifelse(time < tau1, beta0, beta0 * exp(-k * (time - tau1)))
    dS <- -beta * S * I / N - ifelse(time >= vaccine_start_day, vaccine_rate * S, 0)
    dE <- beta * S * I / N - sigma * E
    dI <- sigma * E - gamma * I
    dR <- gamma * I + ifelse(time >= vaccine_start_day, vaccine_rate * S, 0)
    return(list(c(dS, dE, dI, dR)))
  })
}

vaccine_sim <- ode(y = init, times = timepoints, func = vaccine_simulation, parms = pars)
vaccine_sim <- as.data.frame(vaccine_sim)

# Plot der Wirkung des Impfstoffs
plot(vaccine_sim$time, vaccine_sim$I, type = "l", col = "green", xlab = "Time (days)",
     ylab = "Infected", main = "Impact of Vaccination")


# Aufgabe 3. a)

# Initialparameter definieren
init <- c(S = 1e6, E = 10, I = 5, R = 0)  # Startwerte
pars <- list(beta0 = 0.3, sigma = 1/5.2, gamma = 1/2.9, k = 0.1, N = 1e6, tau1 = 50)  # Modellparameter
timepoints <- seq(0, 100, by = 1)  # Zeitvektor

# SEIR-Modell
SEIR <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    beta <- ifelse(time < tau1, beta0, beta0 * exp(-k * (time - tau1)))  # Bedingung für Beta
    dS <- -beta * S * I / N
    dE <- beta * S * I / N - sigma * E
    dI <- sigma * E - gamma * I
    dR <- gamma * I
    return(list(c(dS, dE, dI, dR)))
  })
}

# Aufgabe 3a: Simulation mit verzögerter Kontrolle (30 Tage Verzögerung)
pars$tau1 <- 30  # Verzögerung in Tagen
simulation_delay <- ode(y = init, times = timepoints, func = SEIR, parms = pars)
simulation_delay <- as.data.frame(simulation_delay)

# Plot der Ergebnisse
plot(simulation_delay$time, simulation_delay$I, type = "l", col = "blue", xlab = "Time (days)",
     ylab = "Infected", main = "SEIR Model with Delayed Control")

# Aufgabe 3b: Diagnoserate berücksichtigen
diagnosis_rate <- 0.8  # Anteil diagnostizierter Fälle
simulation <- ode(y = init, times = timepoints, func = SEIR, parms = pars)
simulation <- as.data.frame(simulation)
simulation$I_diagnosed <- simulation$I * diagnosis_rate
simulation$I_undiagnosed <- simulation$I * (1 - diagnosis_rate)

# Plot der diagnostizierten und nicht diagnostizierten Fälle
plot(simulation$time, simulation$I_diagnosed, type = "l", col = "blue", xlab = "Time (days)", 
     ylab = "Cases", main = "Diagnosed vs Undiagnosed Cases")
lines(simulation$time, simulation$I_undiagnosed, col = "red")
legend("topright", legend = c("Diagnosed", "Undiagnosed"), col = c("blue", "red"), lty = 1)

# Aufgabe 3c: Einfluss der Diagnoserate auf R0
diagnosis_rates <- c(0.75, 0.5)  # Beispieldiagnoseraten: 75% und 50%
R0_estimates <- sapply(diagnosis_rates, function(rate) {
  simulation$I_diagnosed <- simulation$I * rate
  simulation$I_undiagnosed <- simulation$I * (1 - rate)
  growth_rate <- pars$beta0 * rate / (pars$gamma + pars$sigma)  # Näherung
  R0 <- (1 + growth_rate * (1 / pars$sigma)) * (1 + growth_rate * (1 / pars$gamma))
  return(R0)
})

cat("R0 bei 75% Diagnoserate:", R0_estimates[1], "\n")
cat("R0 bei 50% Diagnoserate:", R0_estimates[2], "\n")

# Aufgabe 3d: Alternative Szenarien - Lineares Abklingen von Beta
SEIR_linear <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    beta <- ifelse(time < tau1, beta0, beta0 - k * (time - tau1))  # Lineares Abklingen
    beta <- ifelse(beta < 0, 0, beta)  # Sicherstellen, dass Beta nicht negativ wird
    dS <- -beta * S * I / N
    dE <- beta * S * I / N - sigma * E
    dI <- sigma * E - gamma * I
    dR <- gamma * I
    return(list(c(dS, dE, dI, dR)))
  })
}

simulation_linear <- ode(y = init, times = timepoints, func = SEIR_linear, parms = pars)
simulation_exponential <- ode(y = init, times = timepoints, func = SEIR, parms = pars)
simulation_linear <- as.data.frame(simulation_linear)
simulation_exponential <- as.data.frame(simulation_exponential)

# Plot der beiden Szenarien
plot(simulation_linear$time, simulation_linear$I, type = "l", col = "blue", xlab = "Time (days)", 
     ylab = "Infected", main = "Linear vs Exponential Decay of Beta")
lines(simulation_exponential$time, simulation_exponential$I, col = "red")
legend("topright", legend = c("Linear Decay", "Exponential Decay"), col = c("blue", "red"), lty = 1)

# Aufgabe 4: Hinzufügen eines Impfstoffs
vaccine_model <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    beta <- ifelse(time < tau1, beta0, beta0 * exp(-k * (time - tau1)))
    vaccine_effect <- ifelse(time >= parameters$vaccine_start_day, parameters$vaccine_rate * S, 0)
    dS <- -beta * S * I / N - vaccine_effect
    dE <- beta * S * I / N - sigma * E
    dI <- sigma * E - gamma * I
    dR <- gamma * I + vaccine_effect
    return(list(c(dS, dE, dI, dR)))
  })
}

pars$vaccine_start_day <- 50  # Impfstart an Tag 50
pars$vaccine_rate <- 0.05  # 5% der empfänglichen Bevölkerung pro Tag
simulation_vaccine <- ode(y = init, times = timepoints, func = vaccine_model, parms = pars)
simulation_vaccine <- as.data.frame(simulation_vaccine)

# Plot der Wirkung des Impfstoffs
plot(simulation_vaccine$time, simulation_vaccine$I, type = "l", col = "green", xlab = "Time (days)", 
     ylab = "Infected", main = "Impact of Vaccination")




# ### Antworten auf die Fragen aus der Aufgabenstellung:
# 
# #### **1. Model set-up**
# 
# **a. Unterschied zwischen R₀ und Re:**
#   - **R₀ (Basisreproduktionszahl):** Zeigt an, 
# wie viele sekundäre Infektionen ein infizierter Fall verursacht, 
# wenn keine Kontrollmaßnahmen vorhanden sind. Es ist ein Maß für 
# das Ausbruchspotenzial einer Epidemie.
# - **Re (effektive Reproduktionszahl):** Zeigt, 
# wie viele sekundäre Infektionen ein Fall verursacht, 
# wenn Kontrollmaßnahmen vorhanden sind. Wenn Re < 1 ist, 
# wird die Epidemie eingedämmt.
# 
# ---
#   
#   **b. Diagramm des Modells:**
#   - **Kompartimente/Variablen:** `S` (Susceptible), `E` (Exposed), 
# `I` (Infected), `R` (Recovered), `D` (Dead), `C` (Cumulative cases).
# 
# - **Parameter:** `beta` (Übertragungsrate), `gamma` (Genesungsrate), 
# `sigma` (Übergangsrate von E zu I), `f` (Sterberate), 
# `tau1` (Zeitpunkt der Einführung von Maßnahmen), `k` (Abklingrate von beta).
# 
# Das Diagramm zeigt Flüsse zwischen Kompartimenten, z. B. von `S` zu `E` 
# durch Infektion (`beta`) und von `E` zu `I` durch Fortschreiten der Infektion 
# (`sigma`).
# 
# ---
#   
#   **c. Zeitabhängige Parameter:**
#   - Fixierte Parameter: `sigma`, `gamma`, `f`.
# - Zeitabhängig: `beta` verändert sich basierend auf Maßnahmen. 
# Vor `tau1` ist `beta` konstant. Nach `tau1` sinkt es exponentiell mit der 
# Rate `k`.
# 
# ---
#   
#   **d. Halbwertszeit der Übertragungsrate:**
#   Die Halbwertszeit wird durch die Formel \(\text{T}_{\text{halb}} = \ln(2) / k\) berechnet:
#   - Für Guinea und Sierra Leone müssen Werte für `k` eingesetzt werden 
# (z. B. aus der Tabelle im Paper). Liberia hat aufgrund fehlender Maßnahmen 
# eine andere Dynamik.
# 
# ---
#   
#   **e. Anpassung des ODE-Systems für Emigration:**
#   - Hinzufügen eines Emigrationsbegriffs: 
#   \[
#     dS = -\beta \cdot S \cdot I / N - r \cdot S
#     \]
# wobei \( r \) die Emigrationsrate ist.
# 
# ---
#   
#   **f. Vereinfachende Annahmen:**
# - Homogene Durchmischung der Bevölkerung.
# - Konstante biologische Parameter (z. B. `gamma`).
# - Vernachlässigung von Variabilitäten wie geografische Unterschiede oder 
# saisonale Effekte.
# 
# ---
#   
#   #### **2. Estimating R₀ and exploring the model**
#   
#   **a. Daten laden und plotten:**
#   Die kumulative Anzahl der Fälle und Todesfälle für Guinea, 
# Sierra Leone und Liberia wird aus der CSV-Datei extrahiert und geplottet.
# 
# ---
#   
#   **b. R₀ schätzen:**
#   1. Beschränken Sie die Daten auf den ersten Monat (Startdatum: 22. März 2014).
# 2. Berechnen Sie \(\ln(\text{cases})\) und führen Sie eine lineare Regression durch.
# 3. Nutzen Sie die Formel:
#   \[
#     R₀ = (1 + \delta \cdot \text{incubation period}) \cdot (1 + \delta \cdot \text{infectious period})
#     \]
# um R₀ für Guinea zu berechnen.
# 
# ---
#   
#   **c. Modell für Guinea fitten:**
#   Nutzen Sie das Skript, um das Modell für Guinea anzupassen. 
# Berechnen Sie Parameter und deren 95 %-Konfidenzintervalle mit der Hesse-Matrix.
# 
# ---
#   
#   **d. Modell und reale Daten plotten:**
#   Plotten Sie Fälle und Todesfälle im Modell vs. reale Daten und vergleichen 
# Sie mit Abbildung 1 des Papers.
# 
# ---
#   
#   **e. Effektive Reproduktionszahl:**
#   Berechnen und plotten Sie Re über die Zeit:
#   \[
#     Re(t) = \beta(t) / \gamma
#     \]
# 
# ---
#   
#   **f. Inzidenz plotten:**
#   Nutzen Sie `diff()`, um tägliche Inzidenzen zu berechnen. 
# Plotten Sie Fälle und Todesfälle pro Tag. Ermitteln Sie das Datum mit der 
# höchsten Inzidenz.
# 
# ---
#   
#   **g. Verhinderte Fälle und Todesfälle:**
#   Simulieren Sie das Szenario ohne Kontrollmaßnahmen 
# (indem `k=0` gesetzt wird). Berechnen Sie die Differenz zu den realen 
# Daten bis zum 20. August.
# 
# ---
#   
#   #### **3. Exploring scenarios and re-estimating parameters**
#   
#   **a. Verzögerte Kontrollmaßnahmen (30 Tage):**
#   - Ändern Sie `tau1` um 30 Tage und simulieren Sie erneut.
# - Berechnen Sie die zusätzlichen Fälle und Todesfälle im Vergleich zum 
# ursprünglichen Szenario.
# 
# ---
#   
#   **b. Unentdeckte Fälle:**
#   - Modifizieren Sie das Modell, um eine Fraktion der Fälle nicht zu 
# diagnostizieren.
# - Schätzen Sie den Diagnoseratenparameter und plotten Sie die "wahren" 
# Fälle (diagnostizierte + nicht diagnostizierte).
# 
# ---
#   
#   **c. Einfluss der Diagnoserate auf R₀:**
#   - Reduzieren Sie die Diagnoserate auf 75 % und 50 %.
# - Berechnen Sie den Einfluss auf R₀ und erklären Sie die Ergebnisse.
# 
# ---
#   
#   **d. Alternatives Abklingen von Beta:**
#   - Ersetzen Sie das exponentielle Abklingen durch ein lineares Abklingen.
# - Vergleichen Sie die Modelle anhand des SSE und der Änderung von Re.
# 
# ---
#   
#   #### **4. Adding a vaccine**
#   
#   - Fügen Sie dem Modell eine Impfkomponente hinzu (5 % der anfälligen 
#     Bevölkerung pro Tag ab Tag 50).
# - Bestimmen Sie das Datum, an dem die Inzidenz auf 0 sinkt.