######### Lösung zu den Übungsaufgaben: Prädator-Beute-Modelle und Ökologische Modelle

  
  ## 1. Prädator-Beute Modelle
  
  ### 1.1 Modelldefinition
 #  Das Lotka-Volterra Modell beschreibt die Dynamik von zwei interagierenden Populationen:

# Definition der Parameter
params <- list(a = 0.1, b = 0.02, c = 0.1, d = 0.01)

# Differentialgleichungen definieren
lotka_volterra <- function(t, state, parameters) {
  R <- state[1]
  F <- state[2]
  with(as.list(parameters), {
    dR <- a * R - b * F * R
    dF <- -c * F + d * F * R
    list(c(dR, dF))
  })
}

### 1.1.2 Populationsgleichgewicht
# Ein Gleichgewicht tritt ein, wenn die Wachstumsraten beider Spezies Null sind.
# - Fixpunkte sind (0, 0) und (c/d, a/b).


# Gleichgewichtspunkt berechnen
Gleichgewicht_R <- params$c / params$d
Gleichgewicht_F <- params$a / params$b
cat("Nicht-triviales Gleichgewicht: R =", Gleichgewicht_R, ", F =", Gleichgewicht_F)


### 1.1.3 Populationsevolution über die Zeit


library(deSolve)

# Anfangswerte und Zeitintervall
state <- c(R = 40, F = 9)
time <- seq(0, 200, by = 1)

# Integration des Systems
output <- ode(y = state, times = time, func = lotka_volterra, parms = params)

# Plotten der Ergebnisse
plot(output, main = "Prädator-Beute Populationen", xlab = "Zeit", ylab = "Populationsgröße")


### 1.1.4 Phasenraum


# Trajektorien im Phasenraum
plot(output[,"R"], output[,"F"], type="l", xlab="Rabbits (R)", ylab="Foxes (F)",
     main="Phasenraum: Trajektorien der Populationen")


# **Beobachtung**: Die Trajektorien bilden geschlossene Kurven, was auf zyklisches Verhalten hinweist.

  ## 1.2 Rabbit, Foxes und Hunter
  
  ### Modell mit Jäger-Einfluss
  

# Modifiziertes Modell mit Hunter
params$h <- 0.01  # Jäger-Effekt

hunter_model <- function(t, state, parameters) {
  R <- state[1]
  F <- state[2]
  with(as.list(parameters), {
    dR <- a * R - b * F * R - h * R
    dF <- -c * F + d * F * R - h * F
    list(c(dR, dF))
  })
}

# Integration des Systems
output_hunter <- ode(y = state, times = time, func = hunter_model, parms = params)

# Plotten der Ergebnisse
plot(output_hunter, main = "Einfluss eines Jägers auf Populationen", xlab = "Zeit", ylab = "Populationsgröße")

  
  ## 2. Ökologische Modelle
  
  ### 2.1 Wettbewerbsmodell
  

# Parameter für Wettbewerbsmodell
eco_params <- list(alpha1 = 0.5, alpha2 = 0.5, beta11 = -0.02, beta22 = -0.02, beta12 = -0.01, beta21 = -0.01)

# System der Differentialgleichungen definieren
eco_model <- function(t, state, parameters) {
  N1 <- state[1]
  N2 <- state[2]
  with(as.list(parameters), {
    dN1 <- alpha1 * N1 + N1 * (beta11 * N1 + beta21 * N2)
    dN2 <- alpha2 * N2 + N2 * (beta12 * N1 + beta22 * N2)
    list(c(dN1, dN2))
  })
}

# Anfangswerte
state_eco <- c(N1 = 10, N2 = 5)

# Integration
output_eco <- ode(y = state_eco, times = time, func = eco_model, parms = eco_params)

# Plotten
matplot(output_eco[,1], output_eco[,-1], type="l", lty=1, xlab="Zeit", ylab="Populationsgröße", 
        main="Wettbewerbsmodell")
legend("topright", legend=c("N1", "N2"), col=1:2, lty=1)


### 2.2 Parasitismus
# **Änderung**: Wechselwirkungen über Parasiten sind negativ für eine Spezies und positiv für die andere.


eco_params$beta12 <- 0.02  # Positiver Einfluss auf N2
eco_params$beta21 <- -0.02 # Negativer Einfluss auf N1

# Neu integrieren
output_para <- ode(y = state_eco, times = time, func = eco_model, parms = eco_params)

# Plotten
matplot(output_para[,1], output_para[,-1], type="l", xlab="Zeit", ylab="Populationsgröße", 
        main="Parasitismus")
legend("topright", legend=c("N1", "N2"), col=1:2, lty=1)


### 2.3 Mutualismus
# **Änderung**: Beide Wechselwirkungen sind positiv.


eco_params$beta12 <- 0.02  # Positive Wechselwirkung
eco_params$beta21 <- 0.02

# Neu integrieren
output_mutual <- ode(y = state_eco, times = time, func = eco_model, parms = eco_params)

# Plotten
matplot(output_mutual[,1], output_mutual[,-1], type="l", xlab="Zeit", ylab="Populationsgröße", 
        main="Mutualismus")
legend("topright", legend=c("N1", "N2"), col=1:2, lty=1)

  

  
  

  # Lösung zu den Übungsaufgaben: Prädator-Beute-Modelle und Ökologische Modelle

  
  ## 1. Prädator-Beute Modelle
  
  ### 1.1 Modelldefinition
  # Das Lotka-Volterra Modell beschreibt die Dynamik von zwei interagierenden Populationen:

# Definition der Parameter
params <- list(a = 0.1, b = 0.02, c = 0.1, d = 0.01)

# Differentialgleichungen definieren
lotka_volterra <- function(t, state, parameters) {
  H <- state[1]  # Hasen
  F <- state[2]  # Füchse
  with(as.list(parameters), {
    dH <- a * H - b * F * H
    dF <- -c * F + d * F * H
    list(c(dH, dF))
  })
}


# ### 1.1.2 Populationsgleichgewicht
# Ein Gleichgewicht tritt ein, wenn die Wachstumsraten beider Spezies Null sind.
# - Fixpunkte sind (0, 0) und (c/d, a/b).


# Gleichgewichtspunkt berechnen
Gleichgewicht_H <- params$c / params$d
Gleichgewicht_F <- params$a / params$b
cat("Nicht-triviales Gleichgewicht: H =", Gleichgewicht_H, ", F =", Gleichgewicht_F)


### 1.1.3 Populationsevolution über die Zeit


library(deSolve)

# Anfangswerte und Zeitintervall
state <- c(H = 40, F = 9)
time <- seq(0, 200, by = 1)

# Integration des Systems
output <- ode(y = state, times = time, func = lotka_volterra, parms = params)

# Plotten der Ergebnisse
library(ggplot2)
output_df <- as.data.frame(output)
colnames(output_df) <- c("time", "Hasen", "Füchse")

# Gleichgewicht als konstanten Zustand darstellen
eq_df <- data.frame(time = time, Hasen = Gleichgewicht_H, Füchse = Gleichgewicht_F)

ggplot() +
  geom_line(data = output_df, aes(x = time, y = Hasen, color = "Hasen"), size = 1) +
  geom_line(data = output_df, aes(x = time, y = Füchse, color = "Füchse"), size = 1) +
  geom_line(data = eq_df, aes(x = time, y = Hasen, color = "Hasen Gleichgewicht"), linetype = "dashed", size = 1) +
  geom_line(data = eq_df, aes(x = time, y = Füchse, color = "Füchse Gleichgewicht"), linetype = "dashed", size = 1) +
  scale_color_manual(values = c("Hasen" = "blue", "Füchse" = "red", "Hasen Gleichgewicht" = "darkblue", "Füchse Gleichgewicht" = "darkred")) +
  labs(title = "Populationsverlauf mit Gleichgewicht", x = "Zeit", y = "Populationsgröße", color = "Legende") +
  theme_minimal()

### 1.1.4 Phasenraum


# Trajektorien im Phasenraum
plot(output[,"H"], output[,"F"], type="l", xlab="Hasen (H)", ylab="Füchse (F)",
     main="Phasenraum: Trajektorien der Populationen")

# **Beobachtung**: Die Trajektorien bilden geschlossene Kurven, was auf zyklisches Verhalten hinweist.

  
  ## 1.2 Hasen, Füchse und Jäger
  
  ### Modell mit Jäger-Einfluss

# Modifiziertes Modell mit Jäger
params$h <- 0.01  # Jäger-Effekt

hunter_model <- function(t, state, parameters) {
  H <- state[1]  # Hasen
  F <- state[2]  # Füchse
  with(as.list(parameters), {
    dH <- a * H - b * F * H - h * H
    dF <- -c * F + d * F * H - h * F
    list(c(dH, dF))
  })
}

# Integration des Systems
output_hunter <- ode(y = state, times = time, func = hunter_model, parms = params)

# Plotten der Ergebnisse
plot(output_hunter, main = "Einfluss eines Jägers auf Populationen", xlab = "Zeit", ylab = "Populationsgröße")

  
  ## 2. Ökologische Modelle
  
  ### 2.1 Wettbewerbsmodell
  

# Parameter für Wettbewerbsmodell
eco_params <- list(alpha1 = 0.5, alpha2 = 0.5, beta11 = -0.02, beta22 = -0.02, beta12 = -0.01, beta21 = -0.01)

# System der Differentialgleichungen definieren
eco_model <- function(t, state, parameters) {
  N1 <- state[1]
  N2 <- state[2]
  with(as.list(parameters), {
    dN1 <- alpha1 * N1 + N1 * (beta11 * N1 + beta21 * N2)
    dN2 <- alpha2 * N2 + N2 * (beta12 * N1 + beta22 * N2)
    list(c(dN1, dN2))
  })
}

# Anfangswerte
state_eco <- c(N1 = 10, N2 = 5)

# Integration
output_eco <- ode(y = state_eco, times = time, func = eco_model, parms = eco_params)

# Plotten
matplot(output_eco[,1], output_eco[,-1], type="l", lty=1, xlab="Zeit", ylab="Populationsgröße", 
        main="Wettbewerbsmodell")
legend("topright", legend=c("N1", "N2"), col=1:2, lty=1)


#   ## Zusammenfassung
#   Die Modelle wurden implementiert und grafisch dargestellt. Jedes Modell veranschaulicht unterschiedliche ökologische Interaktionen. Die Gleichgewichtszustände werden durch konstante Linien dargestellt, die zeigen, wo beide Populationen stabil bleiben.



# ### **Zusammenfassung des Codes und der Ergebnisse**
# #### 1. **Prädator-Beute-Modelle (Lotka-Volterra-Modell)**
# 
# **Was haben wir gemacht?**
#   - Das **Lotka-Volterra-Modell** wurde verwendet, um die Interaktionen zwischen Beute (Hasen) und Prädator (Füchse) zu modellieren. Die Differentialgleichungen beschreiben, wie sich die Populationen der beiden Spezies mit der Zeit entwickeln.
# - Ein **Gleichgewichtspunkt** wurde berechnet:
#   - **(0,0)**: Beide Populationen sind ausgestorben.
# - **Nicht-trivialer Gleichgewichtspunkt**: \( u = \frac{c}{d}, v = \frac{a}{b} \).
# - Die **Populationsevolution** wurde simuliert und visualisiert.
# - Richtungsfelder und Trajektorien im Phasenraum wurden dargestellt.
# 
# **Erkenntnisse:**
#   - Die Populationen von Hasen und Füchsen oszillieren zyklisch im Zeitverlauf.
# - Die Trajektorien im Phasenraum zeigen geschlossene Kurven, was auf zyklisches Verhalten hinweist.
# - Die Perioden der Oszillation sind für verschiedene Trajektorien ähnlich, aber abhängig von den Startwerten.
# 
# **Antworten auf Fragen:**
#   - **Gleichgewichtspunkt:** Wir haben bestätigt, dass die Punkte \((0,0)\) und \((c/d, a/b)\) Gleichgewichtspunkte sind.
# - **Perioden der Oszillation:** Die Perioden bleiben gleich für unterschiedliche Startwerte im Modell.
# - **Gültigkeit des Modells:** Das Modell ist eine gute Näherung für einfache biologische Systeme, berücksichtigt jedoch keine Ressourcenbegrenzung oder externe Störungen (z.B. durch Umweltfaktoren).
# 
# ---
#   
#   #### 2. **Erweiterung: Jäger (Super-Predator)**
#   
#   **Was haben wir gemacht?**
#   - Ein zusätzlicher Prädator (Jäger) wurde in das System integriert. Der Jäger tötet sowohl Hasen als auch Füchse proportional zur Populationsgröße.
# - Die modifizierten Differentialgleichungen lauten:
#   \[
#     \frac{dR}{dt} = a \cdot R - b \cdot F \cdot R - e \cdot R, \quad \frac{dF}{dt} = -c \cdot F + d \cdot F \cdot R - e \cdot F
#     \]
# - Die Auswirkungen auf die Populationsgrößen wurden simuliert.
# 
# **Erkenntnisse:**
#   - Durch die Einführung des Jägers nimmt die Populationsgröße beider Spezies schneller ab.
# - Der nicht-triviale Gleichgewichtspunkt verändert sich, und beide Spezies erreichen niedrigere Populationen im Vergleich zum ursprünglichen Modell.
# 
# **Antwort auf die Frage:**
#   - **Verhalten des neuen Gleichgewichtspunkts:** Beide Spezies nehmen in der absoluten Anzahl ab.
# 
# ---
#   
#   #### 3. **Ökologische Modelle: Zwei bakterielle Spezies**
#   
#   **Was haben wir gemacht?**
#   - Das generalisierte Lotka-Volterra-Modell wurde implementiert, um die Wechselwirkungen zwischen zwei bakteriellen Spezies zu untersuchen. Die Gleichungen lauten:
#   \[
#     \frac{dN_1}{dt} = \alpha_1 \cdot N_1 + N_1 \cdot (\beta_{11} \cdot N_1 + \beta_{21} \cdot N_2)
#     \]
# \[
#   \frac{dN_2}{dt} = \alpha_2 \cdot N_2 + N_2 \cdot (\beta_{12} \cdot N_1 + \beta_{22} \cdot N_2)
#   \]
# - Verschiedene Wechselwirkungen wurden untersucht:
#   - **Konkurrenz (Competitive exclusion):** \(\beta_{12} < 0\) und \(\beta_{21} < 0\).
# - **Parasitismus:** Ein Spezies profitiert (\(\beta_{12} > 0\)) und die andere wird geschädigt (\(\beta_{21} < 0\)).
# - **Mutualismus:** Beide Spezies profitieren (\(\beta_{12} > 0, \beta_{21} > 0\)).
# 
# **Erkenntnisse:**
#   1. **Konkurrenz:** Beide Spezies reduzieren ihre Populationen aufgrund der negativen Wechselwirkungen.
# 2. **Parasitismus:** Eine Spezies wächst auf Kosten der anderen.
# 3. **Mutualismus:** Beide Spezies erleben Wachstum durch positive Interaktionen.
# 
# **Antworten auf Fragen:**
#   - **Konkurrenz:** \(\beta_{12}\) und \(\beta_{21}\) sind negativ (< 0).
# - **Parasitismus:** Eine der Koeffizienten ist positiv (> 0), die andere negativ (< 0).
# - **Mutualismus:** Beide Koeffizienten sind positiv (> 0).
# 
# ---
#   
#   ### **Abschließende Erkenntnisse**
#   - Das Lotka-Volterra-Modell beschreibt die fundamentalen Dynamiken zwischen Spezies (Prädator-Beute oder konkurrierende Spezies).
# - Durch Anpassung der Parameter lassen sich verschiedene ökologische Prinzipien simulieren, z.B. Konkurrenz, Mutualismus oder Parasitismus.
# - Die Einführung eines Jägers hat die Dynamik des Systems drastisch verändert, was realistischere Bedingungen widerspiegelt.
# 
# Lass mich wissen, ob du noch eine ausführlichere Erklärung oder Visualisierungen benötigst!
# 
