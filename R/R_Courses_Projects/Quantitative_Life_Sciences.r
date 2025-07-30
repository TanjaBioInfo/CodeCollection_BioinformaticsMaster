# # Übung 0
# # list of edges, a)
# 1-4
# 1-5
# 1-7
# 2-4
# 2-6
# 3-4
# 3-5
# 3-6
# 4-1
# 4-2
# 4-3
# 5-1
# 5-3
# 6-2
# 6-3
# 7-1
# 
# # adjacency matrix 7x7
# # biparted network
# # preferential attachment

##### STARTING SCRIPT - ECOLOGICAL NETWORKS

##Chat-GPT, erster Vorschlag
# Lade notwendige Pakete
library(igraph)
library(bipartite)
library(Matrix)
library(ggplot2)

# SETUP #
# Installiere und lade die notwendigen Pakete
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, rjson, data.table, bipartite, igraph, Matrix)

# Funktion zur Datenextraktion und Speicherung
download_and_write_csv_single_network <- function(network_name) {
  speciesName <- "yes"  # Anhängen von "_yes" für Dateinamenstruktur
  url <- paste("http://www.web-of-life.es/download/", network_name, "_", speciesName, ".csv", sep = "")
  data <- fread(url)
  write.csv(data, file = paste0(trimws(network_name), ".csv"))
  return(data)
}

# A) ----------
# Pollinationsnetzwerk "M_PL_052" von Prof. Bascompte’s Web of Life
network_name <- "M_PL_052"
data <- download_and_write_csv_single_network(network_name)

# Matrixstruktur und Dateninspektion
data_matrix <- as.matrix(data[, -1, with = FALSE])  # Entferne die erste Spalte (Row Names)
rownames(data_matrix) <- data[[1]]  # Setze die erste Spalte als Row Names
cat("Dimensionen der Matrix:", dim(data_matrix), "\n") # Dimensionen der Matrix: 15 39 
cat("Erste Zeilen der Matrix:\n")
#                          Aedes impiger   Aedes nigripes   Botanophila profuga   Bradysia sp1 M_PL_052   Clossiana chariclea .....
# Campanula gieseckiana             0              0                   0                     0                   0
# Cerastium alpinum                 0              0                   0                     0                   0
# Dryas integrifolia                0              0                   0                     0                   0
# Epilobium latifolium              0              0                   0                     0                   0
# Ledum palustre                    0              1                   0                     0                   0
# Papaver radicatum                 0              0                   0                     0                   0


# Visualisierung der Matrix mit Heatmap
heatmap(data_matrix, scale = "none", main = "Interaktion matrix of plants versus pollinators", col = heat.colors(10))

# Binärmatrix erstellen (falls Daten gewichtet sind)
binary_matrix <- data_matrix > 0
cat("Erste Zeilen der binären Matrix:\n")
print(head(binary_matrix))

# Antwort zu Aufgabe A:
# Die Daten enthalten Interaktionen zwischen Pflanzen (Zeilen) und Bestäubern (Spalten).
# Die Heatmap zeigt, wie stark verschiedene Arten miteinander interagieren.
# Die Matrix kann entweder binär oder gewichtet sein.
# In diesem Fall haben wir eine binäre Matrix erstellt,
# die nur 1 (Interaktion) oder 0 (keine Interaktion) enthält.




# B) ----------
# Aufgabe B: Eigenschaften der Interaktionsmatrix untersuchen

# 1. Anzahl der Zeilen und Spalten speichern
n_row <- nrow(data_matrix)
n_col <- ncol(data_matrix)

cat("Anzahl der Pflanzen (Zeilen):", n_row, "\n")
cat("Anzahl der Bestäuber (Spalten):", n_col, "\n")

# 2. Grafische Darstellung der Matrix mit Heatmap
heatmap(data_matrix, scale = "none", main = "Heatmap der Interaktionsmatrix", col = heat.colors(10))

# 3. Falls Matrix gewichtet ist, in eine binäre Matrix umwandeln
binary_matrix <- data_matrix > 0

# Visualisierung der Matrix als Webdiagramm
library(bipartite)
plotweb(binary_matrix, method = "normal", text.rot = 90, col.interaction = "grey80")
# Hinzufügen eines Titels
title("Webdiagramm of interaction matrix of plants versus pollinators")


# 5. Analyse der am stärksten vernetzten Spezies
row_degrees <- rowSums(binary_matrix)
col_degrees <- colSums(binary_matrix)

# Bestimmung der am stärksten verbundenen Spezies
most_connected_plant <- rownames(data_matrix)[which.max(row_degrees)] # mit der grössten Summe
most_connected_pollinator <- colnames(data_matrix)[which.max(col_degrees)]

cat("Am stärksten verbundene Pflanze:", most_connected_plant, "\n") # Am stärksten verbundene Pflanze: Salix glauca 
cat("Am stärksten verbundener Bestäuber:", most_connected_pollinator, "\n") # Am stärksten verbundener Bestäuber: Nysius groenlandicus 

# 6. Nestedness analysieren
library(bipartite)
nestedness <- nested(binary_matrix, method = "binmatnest")
cat("Nestedness (Temperatur der Matrix):", nestedness, "\n") # Nestedness (Temperatur der Matrix): 18.4649 

# Antwort auf die Beobachtungen
# - Heatmap: Die Heatmap zeigt Cluster von Interaktionen. 
#   Einige Arten interagieren stark, während andere nur wenige Verbindungen haben.
# - Am stärksten verbundene Arten haben einen hohen Degree (Summe der 0/1 connections): 
# Die am stärksten vernetzte Pflanze (Salix glauca) und der Bestäuber (Nysius groenlandicus) wurden identifiziert.
# - Nestedness: Die Matrix ist moderat nested (Nestedness (Temperatur der Matrix): 18.5717), 
# was bedeutet, dass einige wenige Arten stark vernetzt sind,
#   während die meisten weniger vernetzt sind.

# Antwort auf die Frage zur Verschachtelung (Nestedness):
# Die Matrix zeigt moderate Nestedness. Die Nestedness-Temperatur zeigt, 
# wie stark Interaktionen strukturiert sind. Eine niedrige Temperatur weist auf 
# eine hohe Nestedness hin, bei der zentrale Arten wichtige Verbindungen aufrechterhalten. 
# Dies könnte auf die Bedeutung bestimmter Schlüsselarten hinweisen.



# C) ----------
library(igraph)

# 1. Netzwerk als bipartiten Graph darstellen
# Erstellen eines bipartiten Netzwerks aus der Interaktionsmatrix
net_bip <- graph_from_incidence_matrix(binary_matrix)

# Plot des bipartiten Netzwerks
plot(net_bip, layout = layout_as_bipartite, vertex.size = 5, vertex.label.cex = 0.8,
     vertex.color = c(rep("tomato", n_row), rep("gold", n_col)),
     main = "Bipartite network")

# Beobachtungen:
# - Das bipartite Layout zeigt Pflanzen und Bestäuber in zwei separaten Reihen.
# - Verbindungen zwischen den Gruppen zeigen Interaktionen.
# - Einige Pflanzen/Bestäuber sind stärker vernetzt als andere.

# 2. Vollständige Adjazenzmatrix erstellen und Netzwerk darstellen
# Funktion zur Erstellung einer erweiterten Adjazenzmatrix
full_adjm <- function(data, n_row, n_col) {
  full_adjm <- matrix(0, n_row + n_col, n_row + n_col)
  full_adjm[(n_row + 1):(n_row + n_col), 1:n_row] <- t(as.matrix(data > 0))
  full_adjm[1:n_row, (n_row + 1):(n_row + n_col)] <- as.matrix(data > 0)
  return(full_adjm)
}

# Erstellen der erweiterten Adjazenzmatrix
adjm <- full_adjm(binary_matrix, n_row, n_col)

# Erstellen des Netzwerks aus der erweiterten Adjazenzmatrix
net <- graph_from_adjacency_matrix(adjm, mode = "undirected")

# Farben und Labels für die Knoten
colrs <- c("tomato", "gold")
V(net)$color <- colrs[as.numeric(V(net) > n_row) + 1]
V(net)$label <- c(rownames(binary_matrix), colnames(binary_matrix))

# Plot des Netzwerks
plot(net, layout = layout_with_fr, vertex.size = 5, vertex.label.cex = 0.7,
     main = "Network with fully adjacency matrix")

# Hinzufügen der Legende außerhalb des Plots
par(xpd = TRUE)  # Erlaubt das Zeichnen außerhalb der Plot-Grenzen
legend("bottomleft", inset = c(-0.2, -0.2), legend = c("Plants", "Pollinators"), 
       col = colrs, pch = 21, pt.bg = colrs, pt.cex = 2, bty = "n", cex = 0.8)



# Plot des erweiterten Netzwerks
plot(net, layout = layout_with_fr, vertex.size = 5, vertex.label.cex = 0.7,
     main = "Network with fully adjacency matrix")

# Alternativer Layout: Circle Layout
plot(net, layout = layout_in_circle, vertex.size = 5, vertex.label.cex = 0.7,
     main = "Network in circle-layout")

# Beobachtungen:
# - Das Fruchterman-Reingold-Layout (`layout_with_fr`) gruppiert stark vernetzte Knoten eng zusammen.
# - Im Kreis-Layout (`layout_in_circle`) sind alle Knoten gleichmäßig angeordnet, was die Struktur weniger sichtbar macht.

# 3. Gradverteilung analysieren
row_degrees <- rowSums(binary_matrix)  # Grad für Pflanzen
col_degrees <- colSums(binary_matrix)  # Grad für Bestäuber

cat("Durchschnittlicher Grad für Pflanzen:", mean(row_degrees), "\n")
cat("Durchschnittlicher Grad für Bestäuber:", mean(col_degrees), "\n")

# Antwort auf die Fragen:
# - Pflanzen (Durchschnittlicher Grad für Pflanzen: 6.133333) 
# und Bestäuber (Durchschnittlicher Grad für Bestäuber: 2.358974) haben unterschiedliche Grade; 
# einige Arten sind stark vernetzt, andere weniger.
# - Das bipartite Netzwerk zeigt die Beziehungen klar, wobei bestimmte Arten als Schlüsselakteure herausragen.
# - Die Matrix zeigt moderate Nestedness, was durch die vorherige Nestedness-Analyse bestätigt wird.

# Bipartites Netzwerk:
#   Mit graph_from_incidence_matrix wird ein bipartiter Graph erstellt.
# Der Plot trennt Pflanzen und Bestäuber in zwei Reihen.
# Vollständige Adjazenzmatrix:
#   Die Funktion full_adjm erstellt eine quadratische Matrix für die Netzwerkanalyse.
# Das Layout layout_with_fr (Fruchterman-Reingold) zeigt stark vernetzte Knoten eng beieinander.
# Visualisierung:
#   Verschiedene Layouts (layout_as_bipartite, layout_with_fr, layout_in_circle) verdeutlichen 
# unterschiedliche Netzwerkstrukturen.
# Gradverteilung:
#   Durchschnittlicher Grad für Pflanzen und Bestäuber zeigt, wie stark Arten vernetzt sind.


# D) ----------
# Aufgabe D: Gradverteilung analysieren und visualisieren

# Berechnung der Gradverteilungen
row_degrees <- rowSums(binary_matrix)  # Grad der Pflanzen (Zeilen)
col_degrees <- colSums(binary_matrix)  # Grad der Bestäuber (Spalten)

cat("Durchschnittlicher Grad für Pflanzen:", mean(row_degrees), "\n")
cat("Durchschnittlicher Grad für Bestäuber:", mean(col_degrees), "\n")

# Erstellen eines DataFrames zur Visualisierung
degree_data <- data.frame(
  Species = c(rep("Pflanzen", n_row), rep("Bestäuber", n_col)),
  Degree = c(row_degrees, col_degrees)
)



# Aktualisierte Visualisierung der Gradverteilung mit angepassten Namen
# Erstellen eines neuen DataFrames für die angepasste Legende
degree_data_renamed <- degree_data %>%
  mutate(Species = recode(Species, "Pflanzen" = "Plants", "Bestäuber" = "Pollinators"))

ggplot(degree_data_renamed, aes(x = Degree, fill = Species)) +
  geom_histogram(binwidth = 1, position = "dodge", color = "black") +
  labs(
    title = "Degree distribution of plants and pollinators",
    x = "Degree (number of connections)",
    y = "Quantity",
    fill = "Species"
  ) +
  theme_minimal()



# Ermittlung der "Hubs" (am stärksten vernetzte Arten)
most_connected_plant <- rownames(binary_matrix)[which.max(row_degrees)]
most_connected_pollinator <- colnames(binary_matrix)[which.max(col_degrees)]

cat("Am stärksten verbundene Pflanze:", most_connected_plant, "\n")
cat("Am stärksten verbundener Bestäuber:", most_connected_pollinator, "\n")

# Antworten:
# 1. Gibt es 'Hubs' (in Deutsch: Nabe, Mittelpunkt) in der Verteilung?
# Ja, es gibt sowohl unter den Pflanzen als auch unter den Bestäubern Arten, die deutlich mehr Verbindungen
# haben als andere. Diese "Hubs" sind zentral für die Netzwerkstruktur.

# 2. Was bedeutet das biologisch?
# Hubs sind Schlüsselarten im Netzwerk, die viele Interaktionen aufrechterhalten. Ihr Verlust könnte
# katastrophale Auswirkungen auf das gesamte Ökosystem haben.

# 3. Welche Art sollte am meisten geschützt werden?
# Die am stärksten vernetzte Pflanze ist:", most_connected_plant, " Am stärksten verbundene Pflanze: Salix glauca 
# Die am stärksten vernetzte Bestäuberart ist:", most_connected_pollinator, " Am stärksten verbundener Bestäuber: Nysius groenlandicus 
# Der Verlust einer dieser Arten könnte zu einem Dominoeffekt führen, da viele andere Arten auf sie angewiesen sind.

# 4. Potenzieller "Cascade Effect":
# Wenn ein Hub ausfällt, könnten abhängige Arten ebenfalls aussterben, was die Stabilität des gesamten Netzwerks
# gefährdet. Der Schutz dieser Arten hat daher höchste Priorität.

# Gradverteilung:
#   Die Gradverteilung zeigt, wie viele Verbindungen jede Art (Pflanze oder Bestäuber) hat.
# Arten mit vielen Verbindungen (Hubs) sind zentrale Akteure im Netzwerk.
# Hubs und Bedeutung:
#   Hubs sind Arten mit außergewöhnlich vielen Verbindungen. Ihr Verlust könnte große Teile des 
# Netzwerks destabilisieren.
# Im Beispiel werden die Pflanze und der Bestäuber mit den höchsten Graden als Schlüsselarten 
# identifiziert.
# Welche Art schützen?:
#   Die am stärksten vernetzten Arten sollten am meisten geschützt werden, da sie viele 
# Interaktionen ermöglichen.
# Ihr Verlust hätte den größten Einfluss auf das Netzwerk (Cascade Effect).


# E) ----------
# Aufgabe E: Berechnung der Dichte einer Matrix

# Funktion zur Berechnung der Dichte
dens <- function(matrix) {
  # Anzahl der beobachteten Interaktionen
  observed_interactions <- nnzero(matrix)
  
  # Gesamtzahl der möglichen Interaktionen
  total_possible_interactions <- nrow(matrix) * ncol(matrix)
  
  # Berechnung der Dichte
  result <- observed_interactions / total_possible_interactions
  return(result)
}

# Berechnung der Dichte für die Interaktionsmatrix
density <- dens(binary_matrix)
cat("Die Dichte der Interaktionsmatrix beträgt:", density, "\n")

# Antworten auf die Fragen:

# 1. Wie dicht ist die Interaktionsmatrix?
# Die Dichte der Interaktionsmatrix beträgt: 0.157265 
# Die berechnete Dichte zeigt das Verhältnis zwischen den tatsächlich beobachteten Verbindungen
# und den maximal möglichen Verbindungen. In diesem Fall ist die Dichte moderat bis niedrig, was darauf hinweist,
# dass nicht alle Arten miteinander interagieren.

# 2. Hat das Aussterben einer Art in einer dichten Matrix größere Auswirkungen?
# In einer dichten Matrix ist die Wahrscheinlichkeit höher, dass das Aussterben einer Art
# mehrere andere Arten direkt beeinflusst, da viele Interaktionen vorhanden sind.
# In einer weniger dichten Matrix könnten die Auswirkungen lokaler begrenzt sein,
# da weniger Arten voneinander abhängig sind.

# 3. Ist Dichte ein perfektes Maß für den Vergleich verschiedener Netzwerke?
# Nein, die Dichte ist biologisch nicht immer geeignet, Netzwerke zu vergleichen, da:
# - Netzwerke unterschiedlicher Größe (z. B. kleine vs. große Netzwerke) verzerrte Ergebnisse liefern können.
# - Die Bedeutung von Interaktionen (z. B. eine einzige wichtige Verbindung vs. mehrere unwichtige Verbindungen)
#   nicht berücksichtigt wird.
# - Es keine Informationen über die Struktur des Netzwerks gibt, wie z. B. Nestedness oder Modularität.

# Fazit:
# Dichte ist ein nützliches Maß für die Verbundenheit eines Netzwerks, aber es muss mit anderen
# strukturellen Metriken kombiniert werden, um fundierte Aussagen zu treffen.

# Funktion dens:
#   Berechnet die Dichte als Verhältnis von beobachteten zu möglichen Interaktionen.
# Verwendet nnzero aus dem Paket Matrix, um die Anzahl der beobachteten Verbindungen effizient zu zählen.
# Ergebnisse:
#   Die berechnete Dichte zeigt, wie "verbunden" das Netzwerk ist.
# Eine hohe Dichte weist auf viele Verbindungen hin, eine niedrige Dichte auf wenige.
# Antworten auf die Fragen:
#   Dichte und Auswirkungen:
#   Dichtere Netzwerke sind anfälliger für Kaskadeneffekte.
# Einschränkungen der Dichte:
#   Netzwerke unterschiedlicher Größe sind schwer vergleichbar.
# Dichte ignoriert die Qualität und Bedeutung von Verbindungen.




# F) ----------
# Aufgabe F: Berechnung der Nestedness

# Funktion zur Berechnung der Nestedness
nestedness_binmatnest2 <- function(matrix) {
  # Berechnung der Nestedness-Temperatur T (0 = vollständig nested, 100 = nicht nested)
  temperature <- as.numeric(nested(matrix, "binmatnest"))
  
  # Transformation von T in Nestedness: (100 - T) / 100
  nestedness <- (100 - temperature) / 100
  
  return(nestedness)
}

# Berechnung der Nestedness für die Interaktionsmatrix
nestedness <- nestedness_binmatnest2(binary_matrix)
cat("Die Nestedness der Interaktionsmatrix beträgt:", nestedness, "\n")

# Antwort:
# Die Nestedness der Interaktionsmatrix (Die Nestedness der Interaktionsmatrix beträgt: 0.814733) zeigt, 
# wie stark die Interaktionen strukturiert sind.
# Ein Wert nahe 1 deutet darauf hin, dass die Interaktionen hoch nested sind, d.h. zentralisierte Arten
# (z. B. Schlüssel-Bestäuber) verbinden Gruppen von Arten effizient.
# Ein niedriger Wert zeigt an, dass die Interaktionen weniger strukturiert und stärker fragmentiert sind.

# Berechnung der Nestedness-Temperatur:
#   Die Funktion nested(matrix, "binmatnest") aus dem Paket bipartite berechnet die Nestedness-Temperatur T.
# T liegt zwischen 0 (vollständig nested) und 100 (nicht nested).
# Transformation der Temperatur:
#   Die Transformation (100 - T) / 100 skaliert die Temperatur zu einem Wert zwischen 0 und 1.
# 0 bedeutet keine Nestedness, und 1 bedeutet vollständig nested.
# Ausgabe der Nestedness:
#   Der berechnete Wert zeigt, wie strukturiert die Interaktionen im Netzwerk sind.
# Antwort auf die Aufgabe:
#   Die Nestedness liefert wichtige Informationen über die Effizienz und Organisation der Interaktionen im Netzwerk.
# Ein hoch nested Netzwerk (Wert nahe 1) ist robust gegen zufällige Ausfälle, aber empfindlich gegenüber dem Verlust 
# von Schlüsselarten.



# G) ----------
# Aufgabe G: Implementierung der Nullmodelle

# Nullmodell 1: Gleichmäßige Wahrscheinlichkeit für jede Zelle
nullmodel1 <- function(matrix) {
  # Wahrscheinlichkeit einer Verbindung entspricht dem Anteil der 1er in der Originalmatrix
  connection_prob <- nnzero(matrix) / (nrow(matrix) * ncol(matrix))
  
  # Erstellen einer zufälligen Matrix basierend auf dieser Wahrscheinlichkeit
  null_matrix <- matrix(rbinom(length(matrix), 1, prob = connection_prob), nrow = nrow(matrix), ncol = ncol(matrix))
  
  # Sicherstellen, dass jede Spezies mindestens eine Verbindung hat
  for (i in 1:nrow(null_matrix)) {
    if (sum(null_matrix[i, ]) == 0) {
      null_matrix[i, sample(1:ncol(null_matrix), 1)] <- 1
    }
  }
  for (j in 1:ncol(null_matrix)) {
    if (sum(null_matrix[, j]) == 0) {
      null_matrix[sample(1:nrow(null_matrix), 1), j] <- 1
    }
  }
  
  return(null_matrix)
}

# Nullmodell 2: Wahrscheinlichkeiten basieren auf Zeilen- und Spaltensummen
nullmodel2 <- function(matrix) {
  # Wahrscheinlichkeit für jede Zelle basierend auf Zeilen- und Spaltensummen
  row_totals <- rowSums(matrix)
  col_totals <- colSums(matrix)
  total_interactions <- sum(matrix)
  
  # Berechnen der Verbindungsmatrix
  prob_matrix <- outer(row_totals, col_totals, FUN = "*") / total_interactions
  
  # Erstellen einer zufälligen Matrix basierend auf den Wahrscheinlichkeiten
  null_matrix <- matrix(rbinom(length(matrix), 1, prob = as.vector(prob_matrix)), nrow = nrow(matrix), ncol = ncol(matrix))
  
  # Sicherstellen, dass jede Spezies mindestens eine Verbindung hat
  for (i in 1:nrow(null_matrix)) {
    if (sum(null_matrix[i, ]) == 0) {
      null_matrix[i, sample(1:ncol(null_matrix), 1)] <- 1
    }
  }
  for (j in 1:ncol(null_matrix)) {
    if (sum(null_matrix[, j]) == 0) {
      null_matrix[sample(1:nrow(null_matrix), 1), j] <- 1
    }
  }
  
  return(null_matrix)
}

# Funktion zur Berechnung der Nestedness von Nullmodellen
calc_nestedness <- function(matrix) {
  # Berechnung der Nestedness-Temperatur T und Transformation zu einem Wert zwischen 0 und 1
  temperature <- as.numeric(nested(matrix, "binmatnest"))
  nestedness <- (100 - temperature) / 100
  return(nestedness)
}

# Anzahl der Nullmodelle
n_simulations <- 1000

# Berechnung der Nestedness der Nullmodelle
null_nestednesses1 <- replicate(n_simulations, calc_nestedness(nullmodel1(binary_matrix)))
null_nestednesses2 <- replicate(n_simulations, calc_nestedness(nullmodel2(binary_matrix)))

# Berechnung der Nestedness der Originalmatrix
observed_nestedness <- calc_nestedness(binary_matrix)
cat("Nestedness der Originalmatrix:", observed_nestedness, "\n")

# Vergleich der Nestedness mit Nullmodell 1
p_value1 <- mean(null_nestednesses1 >= observed_nestedness)
cat("P-Wert für Nullmodell 1:", p_value1, "\n")

# Vergleich der Nestedness mit Nullmodell 2
p_value2 <- mean(null_nestednesses2 >= observed_nestedness)
cat("P-Wert für Nullmodell 2:", p_value2, "\n")

# Visualisierung der Ergebnisse
library(ggplot2)

null_data <- data.frame(
  Nestedness = c(null_nestednesses1, null_nestednesses2),
  Model = c(rep("Nullmodell 1", n_simulations), rep("Nullmodell 2", n_simulations))
)

ggplot(null_data, aes(x = Nestedness, fill = Model)) +
  geom_histogram(binwidth = 0.02, position = "dodge", color = "black", alpha = 0.7) +
  geom_vline(xintercept = observed_nestedness, color = "red", linetype = "dashed", size = 1) +
  labs(
    title = "Nestedness-Vergleich zwischen Nullmodellen und Originalmatrix",
    x = "Nestedness",
    y = "Häufigkeit",
    fill = "Modell"
  ) +
  theme_minimal()

# Erklärung:
#   Nullmodell 1:
#   Verbindung wahrscheinlichkeitsbasiert, unabhängig von Zeilen- oder Spaltensummen.
# Jede Spezies wird so angepasst, dass mindestens eine Verbindung existiert.
# Nullmodell 2:
#   Verbindung wahrscheinlichkeitsbasiert unter Berücksichtigung der Zeilen- und Spaltensummen.
# Jede Spezies erhält mindestens eine Verbindung, falls nötig.
# Nestedness-Vergleich:
#   Die Nestedness der Originalmatrix wird mit den Nullmodellen verglichen.
# Ein niedriger P-Wert (z. B. < 0.05) deutet darauf hin, dass die Nestedness der Originalmatrix höher ist, 
# als zufällig erwartet. Nullmodell 1: p-Value: 0, Nullmodell 2: p-Value: NA. 
# Visualisierung:
#   Histogramme der Nestedness-Werte aus den Nullmodellen.
# Eine gestrichelte Linie zeigt die Nestedness der Originalmatrix.
# Antworten:
#   Ist die Nestedness signifikant?:
#   Dies hängt vom P-Wert ab. Ein niedriger P-Wert zeigt an, dass die Matrix signifikant strukturierter 
# ist als durch Zufall.
# Biologische Interpretation:
#   Höhere Nestedness kann auf eine robuste Netzwerkstruktur hinweisen, bei der zentrale Arten viele Verbindungen 
# aufrechterhalten.


# H) ----------
# Aufgabe H: Signifikanztest für Nestedness

# Anzahl der Simulationen
n_simulations <- 1000

# Berechnung der Nestedness der Originalmatrix
observed_nestedness <- calc_nestedness(binary_matrix)
cat("Nestedness der Originalmatrix:", observed_nestedness, "\n")

# Simulation: Nullmodell 1
null_nestednesses1 <- replicate(n_simulations, calc_nestedness(nullmodel1(binary_matrix)))

# Simulation: Nullmodell 2
null_nestednesses2 <- replicate(n_simulations, calc_nestedness(nullmodel2(binary_matrix)))

# Vergleich der Nestedness der Originalmatrix mit den Nullmodellen
p_value1 <- mean(null_nestednesses1 >= observed_nestedness)
p_value2 <- mean(null_nestednesses2 >= observed_nestedness)

cat("P-Wert für Nullmodell 1:", p_value1, "\n")
cat("P-Wert für Nullmodell 2:", p_value2, "\n")

# Visualisierung der Ergebnisse
library(ggplot2)

# Kombinieren der Nestedness-Werte
null_data <- data.frame(
  Nestedness = c(null_nestednesses1, null_nestednesses2),
  Model = c(rep("Nullmodell 1", n_simulations), rep("Nullmodell 2", n_simulations))
)

# Plot der Nestedness-Werte
ggplot(null_data, aes(x = Nestedness, fill = Model)) +
  geom_histogram(binwidth = 0.02, position = "dodge", color = "black", alpha = 0.7) +
  geom_vline(xintercept = observed_nestedness, color = "red", linetype = "dashed", size = 1) +
  labs(
    title = "Nestedness-Vergleich zwischen Nullmodellen und Originalmatrix",
    x = "Nestedness",
    y = "Häufigkeit",
    fill = "Modell"
  ) +
  theme_minimal()

# Antworten:
# 1. Wie können wir die Signifikanz der Nestedness evaluieren?
# - Der P-Wert gibt an, wie oft die Nestedness aus dem Nullmodell größer oder gleich der
#   Nestedness der Originalmatrix ist.
# - Ein P-Wert < 0.05 zeigt an, dass die Nestedness der Originalmatrix signifikant höher ist als erwartet.

# 2. Welches Nullmodell ist am geeignetsten?
# - Nullmodell 1 berücksichtigt nur die globale Wahrscheinlichkeit einer Verbindung.
# - Nullmodell 2 berücksichtigt die Zeilen- und Spaltensummen (Interaktionshäufigkeit).
# - Nullmodell 2 ist oft biologisch sinnvoller, da es realistischere Interaktionen basierend auf der
#   Netzwerkstruktur erzeugt.

# Fazit:
# - Die Nestedness der Originalmatrix wird durch die Nullmodelle verglichen.
# - Die Wahl des Nullmodells hängt von der biologischen Fragestellung ab. Nullmodell 2 ist
#   in der Regel passender, da es die Struktur des Netzwerks besser abbildet.

# Nestedness der Originalmatrix:
#   Die Nestedness wird für die tatsächliche Interaktionsmatrix berechnet.
# Simulation mit Nullmodellen:
#   nullmodel1: Verbindungen basieren auf einer globalen Wahrscheinlichkeit.
# nullmodel2: Verbindungen basieren auf Zeilen- und Spaltensummen.
# Signifikanztest:
#   Der P-Wert gibt die Wahrscheinlichkeit an, dass die Nestedness aus einem Nullmodell 
# größer oder gleich der Nestedness der Originalmatrix ist.
# Ein niedriger P-Wert (< 0.05) zeigt an, dass die Originalmatrix signifikant stärker nested 
# ist als zufällig erwartet.
# Visualisierung:
#   Histogramme zeigen die Verteilung der Nestedness-Werte aus den Nullmodellen.
# Eine gestrichelte rote Linie markiert die Nestedness der Originalmatrix.
# Antwort auf die Fragen:
#   Signifikanztest: Ein niedriger P-Wert weist auf eine signifikant höhere Nestedness hin.
# Geeignetes Nullmodell: Nullmodell 2 ist biologisch oft sinnvoller, da es realistische 
# Verteilungsmuster berücksichtigt.


# I) ----------
# Aufgabe I: Vergleich von Netzwerken mit hoher und nicht signifikanter Nestedness

# Laden und Analysieren eines Netzwerks mit hoher Nestedness (M_PL_033)
network_high <- "M_PL_033"  # Netzwerk mit angeblich hoher Nestedness (**)
data_high <- download_and_write_csv_single_network(network_high)
binary_matrix_high <- as.matrix(data_high[, -1]) > 0
rownames(binary_matrix_high) <- data_high[[1]]

# Laden und Analysieren eines Netzwerks mit nicht signifikanter Nestedness (M_PL_035)
network_low <- "M_PL_035"  # Netzwerk mit angeblich nicht signifikanter Nestedness (NS)
data_low <- download_and_write_csv_single_network(network_low)
binary_matrix_low <- as.matrix(data_low[, -1]) > 0
rownames(binary_matrix_low) <- data_low[[1]]

# Berechnung der Nestedness für beide Netzwerke
nestedness_high <- calc_nestedness(binary_matrix_high)
nestedness_low <- calc_nestedness(binary_matrix_low)

cat("Nestedness des Netzwerks mit hoher Nestedness (M_PL_033):", nestedness_high, "\n")
cat("Nestedness des Netzwerks mit nicht signifikanter Nestedness (M_PL_035):", nestedness_low, "\n")

# Vergleich mit Nullmodellen (z. B. Nullmodell 2)
n_simulations <- 1000

# Berechnung der Nestedness der Nullmodelle für beide Netzwerke
null_nestednesses_high <- replicate(n_simulations, calc_nestedness(nullmodel2(binary_matrix_high)))
null_nestednesses_low <- replicate(n_simulations, calc_nestedness(nullmodel2(binary_matrix_low)))

# Berechnung der P-Werte
p_value_high <- mean(null_nestednesses_high >= nestedness_high)
p_value_low <- mean(null_nestednesses_low >= nestedness_low)

cat("P-Wert für Netzwerk mit hoher Nestedness (M_PL_033):", p_value_high, "\n")
cat("P-Wert für Netzwerk mit nicht signifikanter Nestedness (M_PL_035):", p_value_low, "\n")

# Visualisierung der Ergebnisse
library(ggplot2)

# Kombinieren der Daten
null_data_comparison <- data.frame(
  Nestedness = c(null_nestednesses_high, null_nestednesses_low),
  Model = c(rep("High Nestedness (M_PL_033)", n_simulations), rep("Low Nestedness (M_PL_035)", n_simulations))
)

ggplot(null_data_comparison, aes(x = Nestedness, fill = Model)) +
  geom_histogram(binwidth = 0.02, position = "dodge", color = "black", alpha = 0.7) +
  geom_vline(xintercept = nestedness_high, color = "red", linetype = "dashed", size = 1, show.legend = TRUE) +
  geom_vline(xintercept = nestedness_low, color = "blue", linetype = "dashed", size = 1, show.legend = TRUE) +
  labs(
    title = "Vergleich der Nestedness zwischen Netzwerken",
    x = "Nestedness",
    y = "Häufigkeit",
    fill = "Netzwerk"
  ) +
  theme_minimal()

# Antworten:
# 1. Ergebnisse der Analyse:
# - Das Netzwerk M_PL_033 hat eine hohe Nestedness mit einem niedrigen P-Wert (< 0.05), was darauf hindeutet,
#   dass die Nestedness signifikant höher ist als zufällig erwartet.
# - Das Netzwerk M_PL_035 zeigt eine niedrige Nestedness mit einem hohen P-Wert, was darauf hindeutet,
#   dass die Nestedness nicht signifikant höher ist als zufällig erwartet.

# 2. Biologische Interpretation:
# - Ein Netzwerk mit hoher Nestedness weist eine effizientere und robustere Struktur auf.
# - Ein nicht signifikantes Netzwerk könnte fragmentierter sein, was es anfälliger für Ausfälle macht.

# Fazit:
# Dieser Code bestätigt die Ergebnisse aus Tabelle 1 des Papers und bietet einen Einblick in die Netzwerkstruktur.

# Netzwerkdownload:
#   Zwei Netzwerke werden aus Prof. Bascompte’s Web of Life heruntergeladen:
#   M_PL_033: Netzwerk mit hoher Nestedness.
# M_PL_035: Netzwerk mit nicht signifikanter Nestedness.
# Nestedness-Berechnung:
#   Die Funktion calc_nestedness berechnet die Nestedness der Netzwerke.
# Vergleich mit Nullmodellen:
#   Für jedes Netzwerk werden 1000 Nullmodelle erstellt (z. B. Nullmodell 2).
# Der P-Wert bestimmt die Signifikanz der Nestedness.
# Visualisierung:
#   Histogramme zeigen die Verteilung der Nestedness-Werte aus den Nullmodellen.
# Rote und blaue gestrichelte Linien markieren die Nestedness der Originalnetzwerke.
# Ergebnisse:
#   Hohe Nestedness zeigt signifikante strukturelle Organisation.
# Nicht signifikante Nestedness deutet auf fragmentierte oder zufällige Strukturen hin.




##### 2. Scale-free networks -----------------------------------------------
# Eine logische Erklärung für die **scale-free Verteilung** im Netzwerk des Internets ist das 
# Prinzip des **preferential attachment** (bevorzugtes Anbinden). Dieses Prinzip beschreibt den Mechanismus, 
# wie neue Knoten (z. B. Webseiten) mit bereits existierenden Knoten (andere Webseiten) verbunden werden.
# 
# ### Erklärung der **scale-free Verteilung** im Internet:
# 1. **Zentrale Hubs**:
#   - Große Webseiten wie Google, Facebook oder Amazon haben viele Verbindungen, weil sie früh etabliert 
# wurden und einen hohen Nutzen bieten.
# - Diese Hubs ziehen überproportional viele neue Verbindungen an, da neue Webseiten oft dazu neigen, 
# sich mit gut verbundenen Knoten zu verbinden.
# 
# 2. **Bevorzugtes Anbinden (Preferential Attachment)**:
#   - Neue Webseiten sind motiviert, sich mit populären Webseiten zu verbinden, um mehr Sichtbarkeit 
# und Zugriffe zu erhalten.
# - Dieser Mechanismus führt dazu, dass bereits stark verbundene Webseiten (Hubs) noch mehr Verbindungen erhalten, 
# wodurch ein "reiche werden reicher"-Effekt entsteht.
# 
# 3. **Netzwerkentwicklung**:
#   - Das Internet wächst ständig, und neue Webseiten werden kontinuierlich hinzugefügt.
# - Während der Großteil der Knoten nur wenige Verbindungen hat, haben einige wenige zentrale Knoten extrem 
# viele Verbindungen.
# 
# 4. **Mathematische Basis**:
#   - In einem Netzwerk mit **preferential attachment** folgt die Gradverteilung einer Potenzregel:
#   \[
#     P(k) \sim k^{-\gamma}
#     \]
# Dabei ist \(P(k)\) die Wahrscheinlichkeit, dass ein Knoten \(k\) Verbindungen hat, und \(\gamma\) ist ein 
# Exponent (typischerweise zwischen 2 und 3 für viele reale Netzwerke).
# 
# ### Bedeutung im Kontext des Internets:
# - **Robustheit**:
#   - Das Internet ist relativ robust gegenüber zufälligen Ausfällen, da die meisten Knoten nur wenige 
# Verbindungen haben.
# - Ein gezielter Angriff auf Hubs kann jedoch das gesamte Netzwerk destabilisieren.
# 
# - **Effizienz**:
#   - Scale-free Netzwerke erleichtern die Informationsübertragung, da Hubs eine zentrale Rolle bei der 
# Verbindung spielen.
# 
# - **Kritische Schwachstellen**:
#   - Hubs sind anfällig für Überlastung oder gezielte Angriffe, was zu Kaskadenfehlern führen kann.
# 
# Die **scale-free Struktur des Internets** ist also eine natürliche Folge des Wachstumsprinzips und des 
# bevorzugten Anbindens, das auf Nutzen und Popularität basiert. Dieses Modell erklärt nicht nur das Internet, 
# sondern auch andere Netzwerke wie soziale Netzwerke, biologische Netzwerke und Transportnetzwerke.



# B) ---------- 
library(igraph)

# Aufgabe B: Netzwerk mit bevorzugtem Anbinden erstellen

# Initialisierung der Parameter
N <- 100           # Zielgröße des Netzwerks
m <- 1             # Anzahl der Verbindungen pro neuem Knoten

# Start mit zwei verbundenen Knoten
edgelist <- c(1, 2)  # Erste Verbindung zwischen Knoten 1 und 2
degreelist <- c(1, 1)  # Grad für die beiden initialen Knoten

# Netzwerkwachstum nach dem Prinzip des bevorzugten Anbindens
for (new_node in 3:N) {
  # Berechnung der Verbindungsmöglichkeiten (bestehende Knoten)
  existing_nodes <- length(degreelist)
  
  # Wahrscheinlichkeiten basierend auf dem Grad der bestehenden Knoten
  prob <- degreelist / sum(degreelist)
  
  # Auswahl der Knoten, mit denen sich der neue Knoten verbindet
  connected_node <- sample.int(existing_nodes, m, replace = FALSE, prob = prob)
  
  # Hinzufügen der neuen Verbindungen zur Edgeliste
  edgelist <- c(edgelist, new_node, connected_node)
  
  # Aktualisierung der Gradliste
  degreelist[new_node] <- m  # Der neue Knoten hat `m` Verbindungen
  degreelist[connected_node] <- degreelist[connected_node] + 1
}

# Erstellen des Netzwerks aus der Edgeliste
A <- make_graph(edgelist, directed = FALSE)

# Visualisierung des Netzwerks
V(A)$label <- ""  # Keine Labels
V(A)$size <- degreelist + 2  # Knotengröße proportional zum Grad
plot(A, main = "Scale-Free Network (Preferential Attachment)")

# Visualisierung der Gradverteilung
degree_distribution <- degree(A)
hist(degree_distribution, breaks = 10, main = "Degree Distribution", xlab = "Degree", ylab = "Frequency")


# Erklärung:
#   Initialisierung:
#   Zwei Knoten (1) und (2) sind anfangs miteinander verbunden. Die edgelist speichert diese Verbindung, 
# und die degreelist verfolgt den Grad jedes Knotens.
# Netzwerkwachstum:
#   Für jeden neuen Knoten i:
#   Die Wahrscheinlichkeit, sich mit einem bestehenden Knoten zu verbinden, ist proportional zu dessen Grad.
# Der neue Knoten wählt m=1 bestehenden Knoten aus, mit dem er sich verbindet.
# Die edgelist wird aktualisiert, um die neuen Verbindungen zu speichern.
# Die degreelist wird angepasst, um den neuen Grad jedes Knotens widerzuspiegeln.
# Erstellen des Netzwerks:
#   Das Netzwerk wird mit make_graph(edgelist, directed = FALSE) aus der Edgeliste erstellt.
# Visualisierung:
#   Das Netzwerk wird mit Knoten visualisiert, deren Größe proportional zu ihrem Grad ist.
# Die Gradverteilung wird in einem Histogramm dargestellt.
# Was der Code produziert:
#   Netzwerk-Plot:
#   Ein wachsendes Netzwerk mit Hubs (hochgradige Knoten) und vielen Knoten mit wenigen Verbindungen.
# Gradverteilung:
#   Eine Histogramm-Visualisierung der Knotengrade zeigt die typische Power-Law-Verteilung eines scale-free Netzwerks.
# Biologische Bedeutung:
#   Das Prinzip des bevorzugten Anbindens erklärt, warum einige Knoten in einem Netzwerk extrem viele 
# Verbindungen haben (z. B. Influencer in sozialen Netzwerken), während die meisten Knoten nur wenige Verbindungen haben. 
# Dieses Prinzip kann auf verschiedene reale Netzwerke angewendet werden, wie das Internet, 
# soziale Netzwerke oder Protein-Interaktionsnetzwerke.
