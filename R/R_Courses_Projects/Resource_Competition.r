############ Antwort Aufgabe 1

# Diese Auszahlungsmatrix basiert auf dem klassischen Gefangenendilemma. Hier eine kurze Analyse:
#   
#   Biologischer Sinn der Tabelle:
#   Atmung bringt den höchsten gemeinsamen Nutzen (3/3), erfordert aber Vertrauen und Kooperation.
# Fermentation ist egoistisch; ein defektierender Spieler erzielt den Vorteil (5/0 oder 0/5), 
# wenn der andere kooperiert.
# Wenn beide defektieren, verlieren beide (1/1), da der gemeinsame Nutzen gering ist.
# Dies reflektiert realistische Konkurrenzsituationen in der Natur.
# Beste Strategie (rational betrachtet):
#   Aus individueller Sicht ist Fermentation (Defektieren) die dominante Strategie, 
# da sie unabhängig von der Wahl des Partners den besseren oder gleichen Ertrag liefert.
# Wenn dein Partner kooperiert: Defektieren bringt dir 5 statt 3.
# Wenn dein Partner defektiert: Defektieren bringt dir 1 statt 0.
# Allerdings führt dies, wenn beide diese Strategie wählen, zu einem suboptimalen Ergebnis 
# (1/1 statt 3/3).
# Realität der Ressourcenkonkurrenz:
#   In der Natur könnte dies durch Mechanismen wie gegenseitige Kontrolle oder langfristige 
# Kooperation ausgeglichen werden, um den gemeinsamen Nutzen zu maximieren.
# Empfehlung:
#   Defektieren (Fermentation) ist kurzfristig rational, aber langfristig schädlich für beide. 
# Kooperatives Verhalten (Atmung) könnte unter geeigneten Bedingungen bevorzugt werden.

############ Problem 2 ----
######## 2. A
# Strategiefunktion:
#   Ziel: höchsten Gewinn erzielen
#   Ihr schreibt jeweils eine Funktion, die basierend auf den vergangenen Aktionen (previous rounds)
# (eigen und die des Partners) entscheidet, 
# ob ihr in der nächsten Runde atmet (Cooperate) oder fermentiert (Defect).

# Importiere notwendige Bibliotheken
library(purrr)  # für map-Funktionen

############ Problem 2 ----
######## 2. A
# Auszahlungsmatrix-Funktion
payout <- function(action_p1, action_p2, payoutvector = c(5, 3, 1, 0)) {
  # Best (5) > Good (3) > Bad (1) > Worst (0)
  if (action_p1 & action_p2) return(c(payoutvector[2], payoutvector[2])) 
  if (action_p1 & !action_p2) return(c(payoutvector[4], payoutvector[1])) 
  if (!action_p1 & action_p2) return(c(payoutvector[1], payoutvector[4])) 
  if (!action_p1 & !action_p2) return(c(payoutvector[3], payoutvector[3]))
}

# Simulation für ein iteriertes 2-Spieler-Spiel
simulate_2P_PD <- function(strategy_p1, strategy_p2, N, payoutvector = c(5, 3, 1, 0)) {
  # Initialisiere Gesamtauszahlungen
  total_payout <- c(0, 0)
  past_actions_p1 <- c()
  past_actions_p2 <- c()
  
  for (i in 1:N) {
    # Spieler 1 und Spieler 2 wählen eine Aktion basierend auf ihrer Strategie
    action_p1 <- strategy_p1(past_actions_p1, past_actions_p2)
    action_p2 <- strategy_p2(past_actions_p2, past_actions_p1)
    
    # Berechne die Auszahlung der aktuellen Runde
    round_payout <- payout(action_p1, action_p2, payoutvector)
    
    # Aktualisiere die Gesamtauszahlungen
    total_payout <- total_payout + round_payout
    
    # Speichere die aktuellen Aktionen in den Listen der vergangenen Aktionen
    past_actions_p1 <- c(past_actions_p1, action_p1)
    past_actions_p2 <- c(past_actions_p2, action_p2)
  }
  return(total_payout)
}

######## 2. B
# Strategien definieren
strategy_always_cooperate <- function(ownpastactions, partnerpastactions) return(TRUE) # Immer kooperieren
strategy_always_defect <- function(ownpastactions, partnerpastactions) return(FALSE)  # Immer defectieren
strategy_tit_for_tat <- function(ownpastactions, partnerpastactions) {
  if (length(partnerpastactions) == 0) return(TRUE) # Erste Runde kooperieren
  return(partnerpastactions[length(partnerpastactions)]) # Imitiere den letzten Zug des Partners
}
strategy_forgiving_tit_for_tat <- function(ownpastactions, partnerpastactions) {
  if (length(partnerpastactions) == 0) return(TRUE) # Erste Runde: Kooperieren
  if (FALSE %in% tail(partnerpastactions, 1)) return(runif(1) > 0.2) # 80 % Wahrscheinlichkeit zu kooperieren
  return(TRUE)
}

######## 2. C
# Strategie-Testfunktion
check_strategy <- function(strategy1, N = 50, payoutvector = c(5, 3, 1, 0)) {
  # Drei Basisstrategien als Gegner
  strat_list <- list(
    function(own_past_actions, enemy_past_actions) return(TRUE),  # Immer kooperieren
    function(own_past_actions, enemy_past_actions) return(FALSE), # Immer defectieren
    function(own_past_actions, enemy_past_actions) return(runif(1) > 0.5) # Zufällig
  )
  
  # Spiele gegen jede Strategie aus strat_list
  res <- map(seq_along(strat_list), function(x) {
    simulate_2P_PD(strategy1, strat_list[[x]], N = N, payoutvector = payoutvector)
  })
  return(res)
}

######## Turnierfunktion
run_tournament <- function(list_of_strategies, strategy_names = NULL, n_rounds = 50, n_rep = 100, payoutvector = c(5, 3, 1, 0), PLAY_YOURSELF = FALSE) {
  # Initialisiere Matrix für die durchschnittlichen Auszahlungen
  n_strats <- length(list_of_strategies)
  av_payout_mat <- matrix(0, n_strats, n_strats)
  
  for (i in 1:(n_strats - 1 + PLAY_YOURSELF)) {
    for (j in (i + 1 - PLAY_YOURSELF):n_strats) {
      # Wiederhole das Spiel n_rep mal für jedes Strategiepaar
      total_payout <- lapply(1:n_rep, function(rep) {
        simulate_2P_PD(list_of_strategies[[i]], list_of_strategies[[j]], n_rounds, payoutvector)
      })
      total_payout <- do.call(rbind, total_payout)
      
      # Berechne den Mittelwert der Auszahlungen
      average_payout <- colMeans(total_payout)
      
      # Werte in die Auszahlungsmatrix eintragen
      av_payout_mat[i, j] <- average_payout[1]
      av_payout_mat[j, i] <- average_payout[2]
    }
  }
  
  # Optional: Strategie-Namen zuweisen
  if (!is.null(strategy_names)) {
    colnames(av_payout_mat) <- rownames(av_payout_mat) <- strategy_names
  }
  return(av_payout_mat)
}

######## Test des Turniers
# Strategienliste und Namen
default_strategies <- list(
  strategy_always_cooperate, 
  strategy_always_defect, 
  strategy_tit_for_tat, 
  strategy_forgiving_tit_for_tat
)
default_strategy_names <- c("Always Cooperate", "Always Defect", "Tit-for-Tat", "Forgiving Tit-for-Tat")

# Turnier ausführen
av_payout_mat <- run_tournament(default_strategies, default_strategy_names, n_rounds = 50, n_rep = 100)

# Ergebnisse visualisieren
heatmap(av_payout_mat, scale = "none", revC = TRUE, Rowv = NA, Colv = NA, margins = c(10, 10))

# Gesamterfolge berechnen
cat("Zeilensummen (Gesamterfolg pro Strategie):\n")
print(rowSums(av_payout_mat))

# Zeilensummen (Gesamterfolg pro Strategie):
# Always Cooperate         Always Defect           Tit-for-Tat Forgiving Tit-for-Tat 
#           300.00                515.24                349.00                309.69 


######## 2. D
# Strategie exportieren
# Speichere die Forgiving Tit-for-Tat Strategie in einer eigenen R-Skriptdatei
writeLines(
  deparse(body(strategy_forgiving_tit_for_tat)), 
  con = "forgiving_tit_for_tat.R"
)

######## 2. E
# Strategie erneut testen und optimieren
# Beispiel: Modifikation der Forgiving Tit-for-Tat Strategie
strategy_improved_forgiving <- function(ownpastactions, partnerpastactions) {
  if (length(partnerpastactions) == 0) return(TRUE) # Erste Runde: Kooperieren
  if (FALSE %in% tail(partnerpastactions, 2)) return(runif(1) > 0.3) # 70 % Wahrscheinlichkeit zu kooperieren
  return(TRUE)
}

# Modifizierte Strategie testen
check_strategy(strategy_improved_forgiving, N = 50)
# [[1]]
# [1] 150 150
# 
# [[2]]
# [1]  18 178
# 
# [[3]]
# [1] 102 157


######## 2. F
# Diskussion der besten Strategie aus Turnieren
# Ergebnisse aus zwei Turnieren vergleichen
cat("\nIst die beste Strategie aus dem ersten Turnier immer noch die beste?\n")
cat("\nSchlussfolgerung:\n")
cat("Die beste Strategie eines Turniers ist nicht notwendigerweise die beste aller Strategien.\n")
cat("\nWarum?\n")
cat("- Strategien sind oft kontextabhängig und funktionieren nur gegen bestimmte Gegner optimal.\n")
cat("- Gegnerverhalten und Paarungen beeinflussen das Ergebnis stark.\n")
cat("- Siehe Video: https://www.youtube.com/watch?v=BOvAbjfJ0x0\n")



########### tit-for-tat with forgiveness of 20% strategy and combined with 
# a grudge strategy up to an Threshold of 3 times in line of defects.
# Erweiterte Strategie: Tit-for-Tat mit Vergebung und grudge-Modus
strategy_tit_for_tat_with_grudge <- function(ownpastactions, partnerpastactions) {
  if (length(partnerpastactions) == 0) return(TRUE) # Erste Runde kooperieren
  
  # grudge-Modus: Wenn der Partner 3-mal hintereinander defectiert, defectiere
  if (length(partnerpastactions) >= 3 && all(tail(partnerpastactions, 3) == FALSE)) return(FALSE)
  
  # Tit-for-Tat mit Vergebung (80 % Kooperationswahrscheinlichkeit nach einem Defekt)
  if (FALSE %in% tail(partnerpastactions, 1)) return(runif(1) > 0.2)
  
  return(TRUE) # Standard: Kooperiere
}

# Neue Strategie in die Strategieliste aufnehmen
default_strategies <- c(default_strategies, list(strategy_tit_for_tat_with_grudge))
default_strategy_names <- c(default_strategy_names, "Tit-for-Tat with Grudge")

# Turnier ausführen mit der neuen Strategie
av_payout_mat <- run_tournament(default_strategies, default_strategy_names, n_rounds = 50, n_rep = 100)

# Ergebnisse visualisieren
heatmap(av_payout_mat, scale = "none", revC = TRUE, Rowv = NA, Colv = NA, margins = c(10, 10))

# Gesamterfolge berechnen
cat("Zeilensummen (Gesamterfolg pro Strategie):\n")
print(rowSums(av_payout_mat))
# Always Cooperate           Always Defect             Tit-for-Tat   Forgiving Tit-for-Tat 
#           450.00                  576.24                  499.00                  459.55 
# Tit-for-Tat with Grudge 
#                  497.39 


########### tit-for-tat with forgiveness of 20% strategy and combined with 
# a grudge strategy up to an Threshold of 2 times in line of defects.
# Erweiterte Strategie: Tit-for-Tat mit Vergebung und grudge-Modus
strategy_tit_for_tat_with_grudge <- function(ownpastactions, partnerpastactions) {
  if (length(partnerpastactions) == 0) return(TRUE) # Erste Runde kooperieren
  
  # grudge-Modus: Wenn der Partner 3-mal hintereinander defectiert, defectiere
  if (length(partnerpastactions) >= 2 && all(tail(partnerpastactions, 2) == FALSE)) return(FALSE)
  
  # Tit-for-Tat mit Vergebung (80 % Kooperationswahrscheinlichkeit nach einem Defekt)
  if (FALSE %in% tail(partnerpastactions, 1)) return(runif(1) > 0.2)
  
  return(TRUE) # Standard: Kooperiere
}

# Neue Strategie in die Strategieliste aufnehmen
default_strategies <- c(default_strategies, list(strategy_tit_for_tat_with_grudge))
default_strategy_names <- c(default_strategy_names, "Tit-for-Tat with Grudge")

# Turnier ausführen mit der neuen Strategie
av_payout_mat <- run_tournament(default_strategies, default_strategy_names, n_rounds = 50, n_rep = 100)

# Ergebnisse visualisieren
heatmap(av_payout_mat, scale = "none", revC = TRUE, Rowv = NA, Colv = NA, margins = c(10, 10))

# Gesamterfolge berechnen
cat("Zeilensummen (Gesamterfolg pro Strategie):\n")
print(rowSums(av_payout_mat))
# Always Cooperate           Always Defect             Tit-for-Tat   Forgiving Tit-for-Tat 
#           600.00                  631.28                  649.00                  610.06 
# Tit-for-Tat with Grudge 
#                  648.14 


########### tit-for-tat with forgiveness of 40% strategy and combined with 
# a grudge strategy up to an Threshold of 2 times in line of defects.
# Erweiterte Strategie: Tit-for-Tat mit Vergebung und grudge-Modus
strategy_tit_for_tat_with_grudge <- function(ownpastactions, partnerpastactions) {
  if (length(partnerpastactions) == 0) return(TRUE) # Erste Runde kooperieren
  
  # grudge-Modus: Wenn der Partner 3-mal hintereinander defectiert, defectiere
  if (length(partnerpastactions) >= 2 && all(tail(partnerpastactions, 2) == FALSE)) return(FALSE)
  
  # Tit-for-Tat mit Vergebung (60 % Kooperationswahrscheinlichkeit nach einem Defekt)
  if (FALSE %in% tail(partnerpastactions, 1)) return(runif(1) > 0.4)
  
  return(TRUE) # Standard: Kooperiere
}

# Neue Strategie in die Strategieliste aufnehmen
default_strategies <- c(default_strategies, list(strategy_tit_for_tat_with_grudge))
default_strategy_names <- c(default_strategy_names, "Tit-for-Tat with Grudge")

# Turnier ausführen mit der neuen Strategie
av_payout_mat <- run_tournament(default_strategies, default_strategy_names, n_rounds = 50, n_rep = 100)

# Ergebnisse visualisieren
heatmap(av_payout_mat, scale = "none", revC = TRUE, Rowv = NA, Colv = NA, margins = c(10, 10))

# Gesamterfolge berechnen
cat("Zeilensummen (Gesamterfolg pro Strategie):\n")
print(rowSums(av_payout_mat))
# Always Cooperate           Always Defect             Tit-for-Tat   Forgiving Tit-for-Tat 
#          1200.00                  863.08                 1249.00                 1209.27 
# Tit-for-Tat with Grudge 
#                 1248.37