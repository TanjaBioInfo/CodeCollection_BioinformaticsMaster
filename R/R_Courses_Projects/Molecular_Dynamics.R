#############################################
###### Molecular Dynamics ###################
#############################################

# R preparations ---------------------------------------------------------------------------------
# Remove current working environment, load packages and set your working directory 
rm(list = ls())

if(!requireNamespace("pacman", quietly = T))   install.packages("pacman")
pacman::p_load("ChemmineR", "caret", "tidyverse")

# or 
if (!require("BiocManager", quietly = TRUE))   install.packages("BiocManager")
BiocManager::install("ChemmineR")

setwd("/Users/TR/Desktop/BIO 445, quantitative life science/12_for_students/12_OLAT_upload/")

# set seed for reproducibility
set.seed(6666) # can be any number

# Problem 1  Molecules in R -------------------------------------------------------------------------

## a) Load the information of tannin into R and plot. 
tannin <- read.SDFset("/Users/TR/Desktop/BIO 445, quantitative life science/12_for_students/12_OLAT_upload/Tannin.sdf")
plot(tannin[[1]])


## b) Your favorite molecule! 
serotonin <- read.SDFset("/Users/TR/Desktop/BIO 445, quantitative life science/12_for_students/12_OLAT_upload/Structure2D_COMPOUND_CID_5202.sdf")
plot(serotonin[[1]])


# ferritin_from_horse_spleen <- read.SDFset("/Users/TR/Desktop/BIO 445, quantitative life science/12_for_students/12_OLAT_upload/Structure2D_COMPOUND_CID_6419224.sdf")
# plot(ferritin_from_horse_spleen[[1]])


# Problem 2: Exploring potential candidates for the next drug  ---------------------------------------------
# In this exercise, we will consider HIV protease as a potential drug target.
# Quantitative structure activity relationship (QSAR) is a quantitative approach based on empirical data on
# chemical structure features to understand its biological activity (i.e. binding of a drug to its target). Look up
# this method on Wikipedia and try to understand QSAR well enough so you can summarize it in your own
# words.
# Zusammenfassung des Artikels zu Quantitative Structure–Activity Relationship (QSAR):
#   
#   QSAR ist eine mathematische Methode, die chemische Strukturen mit ihren biologischen 
# oder physikochemischen Eigenschaften in Beziehung setzt. Ziel ist es, 
# mithilfe von quantitativen Modellen vorherzusagen, wie sich bestimmte chemische 
# Strukturen verhalten, z. B. ihre Bindungsaffinität an ein Enzym wie HIV-Protease. 
# Diese Modelle basieren auf sogenannten Deskriptoren – numerischen Werten, 
# die strukturelle oder physikalische Eigenschaften einer chemischen Verbindung darstellen, 
# wie Molekulargewicht, Polarität, Anzahl der Wasserstoffbrücken usw.
# Ziel:
#   Die besten Wirkstoffkandidaten identifizieren, die am stärksten an die HIV-Protease binden, 
# gemessen durch den Ki-Wert (Inhibitionskonstante). Ein niedriger Ki-Wert bedeutet eine 
# starke Bindung und eine höhere Wahrscheinlichkeit, die Protease zu blockieren.
# Schritte im Kontext der Übung:
#   Feature-Auswahl: Es gibt viele Deskriptoren (z. B. physikalisch-chemische Eigenschaften), 
# aber nicht alle sind relevant. Wir müssen diejenigen identifizieren, die am stärksten mit 
# der Ki-Wert-Änderung korrelieren.
# Modelltraining: Mit maschinellen Lernverfahren (z. B. lineare Regression oder 
#                                                 Entscheidungsbäume) können wir ein 
# QSAR-Modell erstellen, das den Ki-Wert auf Basis der Deskriptoren vorhersagt.
# Validierung: Das Modell wird mit Cross-Validation überprüft, 
# um Überanpassung (Overfitting) zu vermeiden.
# Interpretation: Die wichtigsten Variablen werden analysiert, um zu verstehen, 
# welche molekularen Eigenschaften die Bindung an die HIV-Protease fördern.
# Nutzen der QSAR-Methode:
#   Ermöglicht eine kosten- und zeiteffiziente Vorauswahl von Molekülen vor aufwändigen 
# Laborexperimenten.
# Liefert Einblicke in strukturbiologische Zusammenhänge, die für die Optimierung von 
# Molekülen nützlich sind. 


# Daten (desc.csv) werden eingelesen und Duplikate behandelt.
# Features, die konstant sind, werden entfernt.
# Die Analyse fokussiert sich darauf, Deskriptoren zu finden, die eine 
# signifikante Korrelation mit niedrigen Ki-Werten aufweisen.
# Feature-Engineering: Konstant bleibende oder stark korrelierte Deskriptoren werden entfernt, 
# (wegen Overfitting) um die Modellleistung zu verbessern. Overfitting tritt auf, 
# wenn das Modell zu genau auf die Trainingsdaten abgestimmt ist und dabei zufällige 
# Schwankungen oder Rauschen lernt, die in neuen Daten nicht reproduzierbar sind.
# Lineare Regression wird mit ausgewählten Features durchgeführt.
# Die Daten werden in Trainings- und Testsets aufgeteilt.
# Ein Modell wird trainiert, die wichtigsten Variablen identifiziert, und eine Neubewertung mit ausgewählten Variablen durchgeführt.
# Performance wird evaluiert, und die Ergebnisse werden interpretiert.

## a) Read in and explore the data set: 
desc <- read.csv("/Users/TR/Desktop/BIO 445, quantitative life science/12_for_students/12_OLAT_upload/desc.csv")  # CSV-Datei mit Beschreibern

# Übersicht der Daten
print(head(desc))
print(str(desc))


## b) desc_unique: randomly delete duplicated IDs
## random select 1 experiment for each Monomer
# descUnique1 <- desc[?]
## b) Deduplizierung und Aggregation
# 1. Ein zufälliger Eintrag pro Monomer-ID
# b) Erstellung der Datensätze descUnique1 und descUnique2

# Hinweis: Die erste Spalte "BindingDB.MonomerID" enthält nicht-eindeutige IDs.
# Es gibt mehrere Einträge für dieselbe Verbindung mit verschiedenen Ki-Werten.
# Ziel: Erstellung zweier Datensätze.
# - descUnique1: Zufällige Auswahl eines Eintrags pro ID.
# - descUnique2: Durchschnittliche Ki-Werte für jede ID.

# 1. descUnique1: Zufällige Auswahl eines Eintrags pro Monomer-ID
set.seed(1234)  # Seed für Reproduzierbarkeit
descUnique1 <- desc[!duplicated(desc$BindingDB.MonomerID), ]

# 2. descUnique2: Durchschnittsbildung der Ki-Werte bei mehrfachen Messungen
# Alle anderen Features bleiben erhalten.
descUnique2 <- aggregate(desc[, -1], 
                         by = list(MonomerID = desc$BindingDB.MonomerID), 
                         FUN = mean)

# Ausgabe der erzeugten Datensätze für eine erste Überprüfung
print(head(descUnique1))  # Überprüft die Struktur von descUnique1
print(head(descUnique2))  # Überprüft die Struktur von descUnique2


## c) Remove features (columns) which are same for all substances
# Think about how you will extract features that are same for all substances
# Name the new dataframe as desc_unique
## c) Entfernen von konstanten Features
# Identifizieren von konstanten Spalten (nur ein eindeutiger Wert)
variable_features <- sapply(descUnique2, function(x) length(unique(x)) > 1)
desc_unique <- descUnique2[, variable_features]

# Überprüfen der Dimensionen nach dem Entfernen der konstanten Features
print(dim(desc_unique)) # [1]  613 1184

## d) Korrelation zwischen den Features analysieren
# Ziel: Korrelation von Features mit der Zielvariable `Ki_nM` und untereinander analysieren
# Extrahieren der numerischen Features
numerical_features <- desc_unique[ , sapply(desc_unique, is.numeric)]

# Korrelation zwischen 10 ausgewählten Features berechnen (einschließlich `Ki_nM`)
selected_features <- numerical_features[ , c("Ki_nM", colnames(numerical_features)[3:12])]  # Auswahl von 10 zusätzlichen Features

# Korrelation berechnen
cor_matrix <- cor(selected_features, use = "complete.obs")

# Visualisierung der Korrelationsmatrix als Heatmap
if (!requireNamespace("pheatmap", quietly = TRUE)) {
  install.packages("pheatmap")
}
library(pheatmap)


pheatmap(cor_matrix, 
         main = "Correlation Between Selected Features and Ki_nM", 
         color = colorRampPalette(c("blue", "white", "red"))(50))


## e) Lineare Regression zwischen Ki und Features
# Test eines linearen Modells mit allen numerischen Features (ohne ID und nAcid)
mod1 <- lm(Ki_nM ~ . - MonomerID - nAcid, data = desc_unique)

# Ergebnisse des Modells zusammenfassen
summary(mod1)
# Multiple R-squared:  0.9783,	Adjusted R-squared:  0.5985 
# F-statistic: 2.575 on 579 and 33 DF,  p-value: 0.0007178

# **Frage 1:** Was passiert, wenn alle Features einbezogen werden?
# Antwort: Die Schätzung der Modellparameter wird oft unzuverlässig, 
# wenn zu viele Features vorhanden sind. Dies liegt an Multikollinearität (R2 zu hoch).

# Optimierung: Analyse der 9 wichtigsten Features
# Top 9 Features auswählen
selected_features <- important_vars$Vars[1:9]
selected_data <- desc_unique %>% select(all_of(c("Ki_nM", selected_features)))

# PCA nur auf den 10 wichtigsten Features durchführen
pca_selected <- prcomp(selected_data[, -1], center = TRUE, scale. = TRUE)

# PCA-Ergebnisse in ein Dataframe umwandeln
pca_data <- as.data.frame(pca_selected$x)
colnames(pca_data)[1:2] <- c("PC1", "PC2")
pca_data$Feature <- rep(selected_features, length.out = nrow(pca_data))

# Visualisierung: PCA mit farbigen Punkten für Features und Legende
colors <- colorRampPalette(RColorBrewer::brewer.pal(9, "Set1"))(length(selected_features))

ggplot(pca_data, aes(x = PC1, y = PC2, color = Feature)) +
  geom_point(size = 2, alpha = 0.7) +
  scale_color_manual(values = colors) +
  labs(title = "PCA of 9 Most Important Features", x = "PC 1", y = "PC 2") +
  theme_minimal() +
  theme(legend.title = element_text(size = 10), legend.text = element_text(size = 8))

# **Erklärung des PCA-Plots:**
# - Der PCA-Plot zeigt die Verteilung der 10 wichtigsten Features entlang der ersten beiden Hauptkomponenten.
# - Die Punkte stellen die Projektion der Features in den reduzierten Raum dar.
# - Farben unterscheiden die Features, und die Legende zeigt deren Namen.
# - Ki_nM wird hier nicht direkt dargestellt, da PCA nur auf den Features basiert. Ein separater Zusammenhang könnte durch zusätzliche Regression analysiert werden.

# **Zusammenfassung:**
# PCA reduziert die Dimensionalität der Features und zeigt, welche Variablen zur Varianz beitragen.
# Eine deutliche Gruppierung oder Trennung kann relevante Muster in den Daten hervorheben.


# **Frage 2:** Was beschreibt ein sinnvolles Modell?
# Antwort: Ein Modell mit reduzierten Features (PCA oder Top-Features) vermeidet Overfitting.
# Hier zeigt der Plot die Struktur der wichtigsten Variablen im Kontext der Hauptkomponenten.
# Antwort: Ein sinnvolles Modell beschreibt die Beziehung zwischen Features und Ki_nM, 
# wobei die Features signifikante Erklärungsbeiträge liefern sollten. 
# Die Schätzungen sollten stabil sein und nicht unter Multikollinearität leiden (Overfitting).

# **Frage 3:** Was tun, wenn das Modell unzuverlässig ist?
# Antwort: Reduzieren der Dimensionalität (z. B. PCA) oder Auswahl der wichtigsten Features 
# basierend auf statistischen Kriterien oder Varianzreduktion (z. B. VarImp aus caret).


# ### **Zusammenfassung zur Kreuzvalidierung (Cross-Validation):**
# **Kreuzvalidierung** ist eine statistische Methode zur Bewertung der Leistung eines Modells, 
# indem die Daten wiederholt in **Trainings-** und **Testsets** aufgeteilt werden. 
# Ziel ist es, die **Generalität** und **Vorhersagekraft** des Modells auf neuen, 
# unbekannten Daten zu überprüfen.
#   ### **Wichtige Konzepte:**
#   1. **Überfitting vermeiden:**
#   - Ein Modell, das zu stark an die Trainingsdaten angepasst ist, 
#   kann auf neuen Daten schlecht abschneiden. Kreuzvalidierung hilft, 
#   dieses Problem zu erkennen und zu mindern.
# 
# 2. **Grundprinzip:**
#   - Die verfügbaren Daten werden in mehrere Teile (oder **"Folds"**) aufgeteilt.
# - Ein Teil der Daten wird zum **Training** des Modells verwendet, 
# während der andere Teil zur **Validierung** dient.
# - Dieser Vorgang wird mehrfach wiederholt, sodass jeder Teil der Daten einmal 
# als Testset verwendet wird.
# 
# ---
#   
#   ### **Arten der Kreuzvalidierung:**
#   
#   1. **K-Fold Cross-Validation:**
#   - Die Daten werden in **K gleich große Teile** (Folds) aufgeteilt.
# - Das Modell wird K-mal trainiert, wobei jedes Mal ein anderer Fold als Testset 
# verwendet wird.
# - Der Mittelwert der Ergebnisse aller K-Durchläufe gibt die Modellleistung an.
# 
# 2. **Leave-One-Out Cross-Validation (LOOCV):**
#   - Bei N Beobachtungen wird jedes Mal **eine Beobachtung** als Testdatensatz 
# und der Rest als Trainingsdatensatz verwendet.
# - LOOCV ist rechnerisch intensiv, liefert jedoch präzise Schätzungen.
# 
# 3. **Stratified K-Fold:**
#   - Ähnlich wie K-Fold, aber die Verteilung der Zielvariable bleibt in jedem Fold 
# gleich (wichtig bei unbalancierten Daten).
# 
# 4. **Repeated Cross-Validation:**
#   - K-Fold Cross-Validation wird mehrmals wiederholt, um robustere Ergebnisse 
# zu erhalten.
# 
# 5. **Monte-Carlo Cross-Validation:**
#   - Die Daten werden zufällig in Trainings- und Testsets aufgeteilt. 
# Dieser Vorgang wird mehrmals wiederholt.
# 
# ---
#   
#   ### **Nutzen der Kreuzvalidierung:**
#   
#   - **Leistungsbewertung:** Schätzt die Modellgüte realistisch ein, 
# ohne zusätzliche Testdaten zu benötigen.
# - **Modellvergleich:** Hilft beim Vergleich verschiedener Modelle 
# (z. B. Entscheidungsbaum vs. Random Forest).
# - **Hyperparameter-Tuning:** Ermöglicht die Wahl optimaler Modellparameter 
# durch wiederholte Validierung.


## f) Training- und Testdatensatz erstellen
# Aufteilen der Daten: 70% Training, 30% Test
set.seed(1234)  # Seed für Reproduzierbarkeit
train_indices <- sample(1:nrow(desc_unique), size = 0.7 * nrow(desc_unique))
training <- desc_unique[train_indices, ]
testing <- desc_unique[-train_indices, ]

# Quantile der Ki-Werte in beiden Sets vergleichen
train_quantiles <- quantile(training$Ki_nM, probs = seq(0, 1, 0.25))
test_quantiles <- quantile(testing$Ki_nM, probs = seq(0, 1, 0.25))
print("Quantile der Ki-Werte im Trainingsdatensatz:")
print(train_quantiles)
print("Quantile der Ki-Werte im Testdatensatz:")
print(test_quantiles)
# > print("Quantile der Ki-Werte im Trainingsdatensatz:")
# [1] "Quantile der Ki-Werte im Trainingsdatensatz:"
# > print(train_quantiles)
# 0%     25%     50%     75%    100% 
# 0.00014 0.11   0.6     1.7     3.7
# > print("Quantile der Ki-Werte im Testdatensatz:")
# [1] "Quantile der Ki-Werte im Testdatensatz:"
# > print(test_quantiles)
# 0%     25%     50%     75%    100% 
# 0.00021 0.0775 0.41   1.4    3.7


## g) Modelltraining mit Feature-Auswahl
# Kontrolle für Cross-Validation einstellen
fitControl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)

# Modelltraining mit rpart (Entscheidungsbaum)
fit1 <- train(Ki_nM ~ . - MonomerID - nAcid, 
              data = training, 
              method = "rpart", 
              trControl = fitControl)

# Ergebnisse des trainierten Modells anzeigen
print(fit1)
# CART 
# 
# 429 samples
# 1183 predictors
# 
# No pre-processing
# Resampling: Cross-Validated (10 fold, repeated 3 times) 
# Summary of sample sizes: 385, 385, 385, 386, 387, 386, ... 
# Resampling results across tuning parameters:
#   
#   cp          RMSE       Rsquared    MAE      
# 0.06909557  0.9686392  0.13226751  0.7641167
# 0.10170571  0.9817642  0.09191750  0.7959353
# 0.13189843  1.0052206  0.04453648  0.8333652
# 
# RMSE was used to select the optimal model using the smallest value.
# The final value used for the model was cp = 0.06909557.


## h) Wichtigkeit der Variablen analysieren
# Variable Importance aus dem Modell extrahieren
importance <- varImp(fit1)
print(importance)
# rpart variable importance
# 
# only 20 most important variables shown (out of 1181)
# 
# Overall
# SpMin1_Bhm   100.00
# GATS5c        57.63
# AATS8s        55.62
# GGI9          51.69
# GGI7          51.43
# nHeteroRing   50.72
# GATS8m        47.23
# nHBint7       44.92
# SHBint4       43.89
# ATSC2s         0.00
# SHdNH          0.00
# GATS2v         0.00
# minaaO         0.00
# MATS6v         0.00
# VR3_Dze        0.00
# ASP.3          0.00
# ATS1s          0.00
# nBondsD2       0.00
# AATS4m         0.00
# MATS4p         0.00

# Wichtige Variablen filtern
ImpMeasure <- data.frame(importance$importance)
ImpMeasure$Vars <- rownames(importance$importance)
important_vars <- ImpMeasure[order(-ImpMeasure$Overall), ][1:9, ]  # Top 9 Variablen
print("Wichtige Variablen:")
print(important_vars)
# [1] "Wichtige Variablen:"
# > print(important_vars)
#               Overall        Vars
# SpMin1_Bhm  100.00000  SpMin1_Bhm
# GATS5c       57.63176      GATS5c
# AATS8s       55.62388      AATS8s
# GGI9         51.68883        GGI9
# GGI7         51.43111        GGI7
# nHeteroRing  50.71830 nHeteroRing
# GATS8m       47.23082      GATS8m
# nHBint7      44.91659     nHBint7
# SHBint4      43.89267     SHBint4


## i) Modell mit den wichtigsten Variablen erneut trainieren
# selected_vars <- important_vars$Vars
# formula <- as.formula(paste("Ki_nM ~", paste(selected_vars, collapse = "+")))
# Top 9 Variablen zur Reduktion
selected_vars <- head(important_vars$Vars, 9)
formula <- as.formula(paste("Ki_nM ~", paste(selected_vars, collapse = "+")))

# Fehlende Werte entfernen
training_clean <- na.omit(training)

fit_rf <- train(formula, 
                data = training_clean, 
                method = "ranger", 
                trControl = trainControl(method = "cv", number = 10))
print(fit_rf)

# Random Forest 
# 
# 429 samples
# 9 predictor
# 
# No pre-processing
# Resampling: Cross-Validated (10 fold) 
# Summary of sample sizes: 386, 385, 387, 388, 385, 385, ... 
# Resampling results across tuning parameters:
#   
#   mtry  splitrule   RMSE       Rsquared   MAE      
# 2     variance    0.7737069  0.4288846  0.5940425
# 2     extratrees  0.7829495  0.4147142  0.6086198
# 5     variance    0.7815028  0.4169077  0.5935531
# 5     extratrees  0.7798041  0.4138935  0.5994978
# 9     variance    0.7894626  0.4038961  0.5984052
# 9     extratrees  0.7814454  0.4123820  0.5950545
# 
# Tuning parameter 'min.node.size' was held constant at a value of 5
# RMSE was used to select the optimal model using the smallest value.
# The final values used for the model were mtry = 2, splitrule = variance
# and min.node.size = 5.

## j) Modellleistung auf Testdatensatz bewerten
predictions <- predict(fit2, newdata = testing)
results <- postResample(predictions, testing$Ki_nM)
print("Modellleistung auf Testdaten:")
print(results)
# "Modellleistung auf Testdaten:"
#     RMSE  Rsquared       MAE 
# 1.0004205 0.1353010 0.8098168 
# RMSE (Root Mean Square Error): 1.0004
# Je kleiner der RMSE, desto besser die Vorhersagequalität.
# Ein R² von 0.1353 bedeutet, dass nur etwa 13,5 % der Varianz der Testdaten 
# durch die Prädiktoren (Features) erklärt werden.
# Ein niedriges R² deutet darauf hin, dass das Modell nicht besonders gut ist, 
# um die tatsächlichen Ki-Werte vorherzusagen.
# MAE (Mean Absolute Error): 0.8098
# Der MAE ist der durchschnittliche absolute Vorhersagefehler.
# Ein MAE von 0.8098 bedeutet, dass die Vorhersagen im Durchschnitt 
# um etwa 0.81 nM daneben liegen

## k) Interpretation der Ergebnisse
# Interpretation der Ergebnisse in Kommentaren
# - Kann das Modell Millionen Moleküle bewerten? 
#   Ein gut trainiertes Modell könnte helfen, vielversprechende Kandidaten vorherzusagen. Allerdings sollte
#   die Generalisierungsfähigkeit überprüft werden, bevor es auf neue Daten angewandt wird.
# - Feature-Reduktion und zusätzliche Daten könnten die Modellqualität weiter verbessern.
