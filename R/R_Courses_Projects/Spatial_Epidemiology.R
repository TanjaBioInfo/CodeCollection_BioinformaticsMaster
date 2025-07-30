if (!require("foreign")) install.packages("foreign", dependencies = TRUE)
if (!require("raster")) install.packages("raster", dependencies = TRUE)
if (!require("sf")) install.packages("sf", dependencies = TRUE)
if (!require("rmapshaper")) install.packages("rmapshaper", dependencies = TRUE)
if (!require("pROC")) install.packages("pROC", dependencies = TRUE)
if (!require("RColorBrewer")) install.packages("RColorBrewer", dependencies = TRUE)
if (!require("mice")) install.packages("mice", dependencies = TRUE)
if (!require("glmnet")) install.packages("glmnet", dependencies = TRUE)
if (!require("dismo")) install.packages("dismo", dependencies = TRUE)
if (!require("randomForest")) install.packages("randomForest", dependencies = TRUE)
if (!require("SDMtune")) install.packages("SDMtune", dependencies = TRUE)
if (!require("mgcv")) install.packages("mgcv", dependencies = TRUE)
if (!require("usdm")) install.packages("usdm", dependencies = TRUE)

library(foreign)
library(raster)
library(sf)
library(rmapshaper)
library(pROC)
library(RColorBrewer)
library(mice)
library(glmnet)
library(dismo)
library(randomForest)
library(SDMtune)
library(mgcv)
library(usdm)

# Set working directory
setwd("/Users/TR/Desktop/BIO 445, quantitative life science/13_for_students/data")


# Aufgabe 1: Import von Ausbruchsdaten
################################################################################

# Import der Shapefile-Daten von Thailand (Administrative Ebene 2)
# Diese Datei enthält geografische Grenzen auf der zweiten administrativen Ebene.
myTHA_L2 <- st_read("/Users/TR/Desktop/BIO 445, quantitative life science/13_for_students/data/THA_adm2.shp")

# Import der H5N1-Ausbruchsdatentabelle (DBF-Datei)
# Diese Tabelle enthält Informationen über H5N1-Fälle, einschließlich ihrer geografischen Koordinaten.
myHPAITable <- read.dbf("/Users/TR/Desktop/BIO 445, quantitative life science/13_for_students/data/HPAI_tvb.dbf")

# Filtern der Fälle, die H5N1-positiv sind (RESULT == 1)
# Nur positive Testergebnisse werden für die weitere Analyse verwendet.
myHPAITablepos <- myHPAITable[myHPAITable$RESULT == 1, ]

# Konvertieren der Ausbruchsdaten in ein räumliches Objekt (Simple Features)
# XCOORD und YCOORD enthalten die geografischen Koordinaten der Ausbruchsfälle.
# CRS (Koordinatenreferenzsystem) wird automatisch erkannt, hier jedoch nicht spezifiziert.
myHPAI <- st_as_sf(myHPAITablepos, coords = c("XCOORD", "YCOORD"))
head(myHPAITable)  # Zeigt die ersten Zeilen der Tabelle für eine schnelle Überprüfung.

# Transformation des Koordinatensystems der administrativen Grenzen
# UTM Zone 47 (projizierte Koordinaten) wird verwendet, da sie für Thailand geeignet ist.
myTHA_L2_UTM47 <- st_transform(myTHA_L2, crs("+proj=utm +zone=47 +datum=WGS84"))

# Plotten der Karte von Thailand und der Ausbruchspunkte
# Die Verwaltungsgrenzen werden zuerst dargestellt, danach werden die H5N1-Fälle (rot) hinzugefügt.
# Margins anpassen
par(mar = c(5, 5, 5, 5))  # Beispiel: Größere Margins (unten, links, oben, rechts)
plot(st_geometry(myTHA_L2_UTM47), main = "Thailand and Break Out Points")
plot(st_geometry(myHPAI), add = TRUE, pch = 16, col = "red3")


# Aufgabe 1: Import von Ausbruchsdaten
################################################################################

# Import der Shapefile-Daten von Thailand (Administrative Ebene 2)
# Diese Datei enthält geografische Grenzen auf der zweiten administrativen Ebene.
myTHA_L2 <- st_read("/Users/TR/Desktop/BIO 445, quantitative life science/13_for_students/data/THA_adm2.shp")

# Import der H5N1-Ausbruchsdatentabelle (DBF-Datei)
# Diese Tabelle enthält Informationen über H5N1-Fälle, einschließlich ihrer geografischen Koordinaten.
myHPAITable <- read.dbf("/Users/TR/Desktop/BIO 445, quantitative life science/13_for_students/data/HPAI_tvb.dbf")

# Filtern der Fälle, die H5N1-positiv sind (RESULT == 1)
# Nur positive Testergebnisse werden für die weitere Analyse verwendet.
myHPAITablepos <- myHPAITable[myHPAITable$RESULT == 1, ]

# Konvertieren der Ausbruchsdaten in ein räumliches Objekt (Simple Features)
# XCOORD und YCOORD enthalten die geografischen Koordinaten der Ausbruchsfälle.
# CRS (Koordinatenreferenzsystem) wird automatisch erkannt, hier jedoch nicht spezifiziert.
myHPAI <- st_as_sf(myHPAITablepos, coords = c("XCOORD", "YCOORD"))
head(myHPAITable)  # Zeigt die ersten Zeilen der Tabelle für eine schnelle Überprüfung.

# Transformation des Koordinatensystems der administrativen Grenzen
# UTM Zone 47 (projizierte Koordinaten) wird verwendet, da sie für Thailand geeignet ist.
myTHA_L2_UTM47 <- st_transform(myTHA_L2, crs("+proj=utm +zone=47 +datum=WGS84"))

# Plotten der Karte von Thailand und der Ausbruchspunkte
# Die Verwaltungsgrenzen werden zuerst dargestellt, danach werden die H5N1-Fälle (rot) hinzugefügt.
par(mar = c(5, 5, 5, 5))  # Beispiel: Größere Margins (unten, links, oben, rechts)
plot(st_geometry(myTHA_L2_UTM47), main = "Thailand and Break Out Points")
plot(st_geometry(myHPAI), add = TRUE, pch = 16, col = "red3")

  
#   ### **Beantwortung der Fragen:**
#   
#   #### **1. Was können wir über die Clustering von H5N1-Fällen beobachten?**
#   - Die H5N1-Fälle zeigen eine deutliche räumliche Clusterbildung. 
# Das bedeutet, dass die Fälle nicht gleichmäßig über Thailand verteilt sind, 
# sondern sich auf bestimmte Gebiete konzentrieren.
# - Clusterbildung könnte auf lokale Faktoren hinweisen, wie z. B. hohe Tierdichte 
# (z. B. Geflügel), Nähe zu Wasserquellen oder Märkten sowie Umwelteinflüsse.
# 
# #### **2. Sollten wir mit einer Analyse für ganz Thailand fortfahren?**
# - **Nein, es ist nicht sinnvoll, ganz Thailand zu analysieren.**
#   - Die Clusterbildung deutet darauf hin, dass nur bestimmte Regionen von H5N1 betroffen sind. 
# Eine Analyse des gesamten Gebiets würde die Ergebnisse möglicherweise verzerren und 
# könnte viele irrelevante Daten einbeziehen.
# - Stattdessen sollten wir uns auf die betroffenen Regionen konzentrieren, 
# z. B. die Regionen mit nachgewiesenen H5N1-Fällen. 
# Dies ermöglicht eine gezieltere Untersuchung der Risikofaktoren und erhöht die 
# Präzision der Analyse.
# 
# ---
#   
#   ### **Empfehlung für das weitere Vorgehen:**
#   1. **Regionale Eingrenzung:** Identifizieren Sie die Provinzen oder Distrikte mit H5N1-Fällen und konzentrieren Sie die Analyse auf diese Regionen.
# 2. **Risikofaktoren:** Untersuchen Sie lokale Faktoren, die zur Clusterbildung beitragen könnten (z. B. Nähe zu Gewässern, Märkte, Tierdichte).
# 3. **Vergleich mit nicht-betroffenen Regionen:** Dies kann helfen, die Unterschiede zwischen betroffenen und nicht betroffenen Gebieten zu erkennen.



# Aufgabe 2: Importieren und Analysieren von Risikofaktoren, die mit H5N1 in der Zentralregion Thailands zusammenhängen
########################################################################################

# Importieren der Umwelt-Rasterdaten
dem_r <- raster("/Users/TR/Desktop/BIO 445, quantitative life science/13_for_students/data/srtm/") # Höhendaten
lake_r <- raster("/Users/TR/Desktop/BIO 445, quantitative life science/13_for_students/data/lake/") # Seen
lineden_r <- raster("/Users/TR/Desktop/BIO 445, quantitative life science/13_for_students/data/lineden/") # Straßendichte
ncrop_r <- raster("/Users/TR/Desktop/BIO 445, quantitative life science/13_for_students/data/ncrop/") # Anbauflächen
riverflood_r <- raster("/Users/TR/Desktop/BIO 445, quantitative life science/13_for_students/data/riverflood/") # Überschwemmungsbereiche
du_r <- raster("/Users/TR/Desktop/BIO 445, quantitative life science/13_for_students/data/du/") # Entendichte
ch_r <- raster("/Users/TR/Desktop/BIO 445, quantitative life science/13_for_students/data/ch/") # Hühnerdichte

# Hühnerdichte-Raster wird importiert (als Platzhalter initialisiert)
ch_r <- du_r

# Resampling der Hühnerdaten, um die Auflösung der Entendichte anzupassen
ch_r <- raster::resample(ch_r, du_r)

# Importieren der Marktstandorte aus einer CSV-Datei
XYdf <- read.csv("/Users/TR/Desktop/BIO 445, quantitative life science/13_for_students/data/markets_locations.csv")
XYMarket <- st_as_sf(XYdf, coords = c("X", "Y"), crs = 4326) # Erstellung eines räumlichen Objekts

# Transformation der Marktstandorte ins UTM-Koordinatensystem (Zone 47 für Thailand)
XYMarket_UTM <- st_transform(XYMarket, crs = "+proj=utm +zone=47 +datum=WGS84")

# Berechnung der Distanz zu den Märkten (in Kilometern)
dMarkets <- distanceFromPoints(dem_r, XYMarket_UTM) / 1000

# Erstellung einer Maske, um den gültigen Untersuchungsbereich zu definieren
myMask <- !is.na(dem_r)

# Kombination der Umweltfaktoren in einem Raster-Stack
myStack <- stack(dem_r, lake_r, lineden_r, ncrop_r, riverflood_r, du_r, ch_r, dMarkets) * myMask
names(myStack) <- c("dem", "lake", "rivden", "ncrop", "riverflood", "DuDn", "ChDn", "dMarkets")

# Überprüfung des Stacks durch Plotten
dev.off()  # Schließt den aktuellen Grafik-Device, um mögliche Konflikte zu vermeiden
plot(myStack)  # Darstellung des Raster-Stacks

# Auswahl von Ausbruchsorten, die innerhalb der Maske liegen
myHPAI_I <- raster::extract(myMask, myHPAI)
myHPAI_I_clean <- myHPAI[which(myHPAI_I == 1), ]

# Plotten der Maske und der gefilterten Ausbruchsorten
plot(myMask, col = c("white", "lightgrey"), main = "Break Out Points of H5N1", axes = FALSE, legend = FALSE, box = FALSE)
plot(st_geometry(myHPAI_I_clean), col = "red3", pch = 16, add = TRUE)

# Hinzufügen von Verwaltungsgrenzen als Hintergrund
myTHA_L1 <- st_read("/Users/TR/Desktop/BIO 445, quantitative life science/13_for_students/data/THA_adm1.shp") # Admin Level 1
myTHA_L1_UTM47 <- st_transform(myTHA_L1, crs(myTHA_L2_UTM47)) # Transformation ins UTM-Koordinatensystem

# Plotten der Verwaltungsgrenzen und Zentroiden
plot(st_geometry(myTHA_L2_UTM47), main = "Environmental Layers with Centroids")
plot(st_geometry(myCentroids_L2), add = TRUE, col = "blue", pch = 16)

# Berechnung der Zentroiden der Polygone (Admin Level 2)
suppressWarnings(myCentroids_L2 <- st_centroid(myTHA_L2_UTM47)) # Warnung unterdrücken
myCentroids_L2 <- st_point_on_surface(myTHA_L2_UTM47) # Sicherstellen, dass die Zentroiden innerhalb der Polygone liegen
IsIn_L2 <- raster::extract(myMask, myCentroids_L2) # Überprüfen, ob Zentroiden innerhalb der Maske liegen
myTHA_L2_UTM47_I <- myTHA_L2_UTM47[which(IsIn_L2 == 1), ]

# Wiederholung für Admin Level 1
myCentroids_L1 <- st_centroid(myTHA_L1_UTM47)
IsIn_L1 <- raster::extract(myMask, myCentroids_L1)
myTHA_L1_UTM47_I <- myTHA_L1_UTM47[which(IsIn_L1 == 1), ]

# Darstellung der gefilterten Verwaltungsgrenzen
plot(st_geometry(myTHA_L1_UTM47_I), add = TRUE, lwd = 3)
plot(st_geometry(myTHA_L2_UTM47_I), add = TRUE, lwd = 1)

# Für ästhetische Zwecke: Hinzufügen einer roten Maske
plot(myMask, col = c("red", NA), axes = FALSE, legend = FALSE, box = FALSE, add = TRUE)

# Umwandlung der Maske in Polygone und Vereinfachung der Darstellung
Poly_full <- rasterToPolygons(myMask, dissolve = TRUE, na.rm = TRUE)
Poly <- ms_simplify(Poly_full[2, ], keep = 0.005)
plot(Poly, add = TRUE, lwd = 3)



# Aufgabe 3: Präsenz/Abwesenheits-Modell mit logistischer Regression
################################################################################

# Extrahieren der Rasterwerte für die Ausbruchspunkte
outbreak_values <- raster::extract(myStack, myHPAI_I_clean)  # Werte an H5N1-Ausbruchsstellen
presence <- rep(1, nrow(outbreak_values))  # Präsenz-Daten (mit Wert 1 markiert)

# Generieren von Abwesenheitsdaten (Zufallspunkte in nicht betroffenen Bereichen)
set.seed(123)  # Für Reproduzierbarkeit
absence_points <- randomPoints(myMask, n = nrow(outbreak_values))  # Zufällige Punkte im Untersuchungsgebiet
absence_values <- raster::extract(myStack, absence_points)  # Werte an Abwesenheitspunkten
absence <- rep(0, nrow(absence_values))  # Abwesenheit-Daten (mit Wert 0 markiert)

# Kombinieren der Präsenz- und Abwesenheitsdaten zu einem Datensatz
data <- data.frame(rbind(outbreak_values, absence_values), presence = c(presence, absence))

# Fit eines logistischen Regressionsmodells
# Das Modell erklärt die Wahrscheinlichkeit eines H5N1-Ausbruchs basierend auf Umweltfaktoren.
risk_model <- glm(presence ~ ., data = data, family = binomial)  # Logistische Regression
summary(risk_model)  # Zusammenfassung des Modells
# Call:
#   glm(formula = presence ~ ., family = binomial, data = data)
# 
# Coefficients: (1 not defined because of singularities)
# Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -1.132e+00  2.194e-01  -5.158 2.49e-07 ***
#   dem         -4.295e-03  5.724e-04  -7.503 6.23e-14 ***
#   lake        -1.351e+01  2.440e+02  -0.055    0.956    
# rivden       1.455e+00  2.276e-01   6.392 1.63e-10 ***
#   ncrop        1.359e-01  1.148e-01   1.184    0.236    
# riverflood   1.768e-02  1.493e-01   0.118    0.906    
# DuDn         8.311e-01  6.793e-02  12.234  < 2e-16 ***
#   ChDn                NA         NA      NA       NA    
# dMarkets     7.026e-04  1.090e-03   0.645    0.519    
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 3654.5  on 2731  degrees of freedom
# Residual deviance: 2374.8  on 2724  degrees of freedom
# (624 observations deleted due to missingness)
# AIC: 2390.8
# 
# Number of Fisher Scoring iterations: 13


# Erstellen einer Risikokarte durch Vorhersage basierend auf dem Modell
risk_map <- predict(myStack, model = risk_model, type = "response")  # Wahrscheinlichkeiten vorhersagen
plot(risk_map, main = "H5N1 Risc Map", col = brewer.pal(9, "Reds"))  # Darstellung der Risikokarte

# Logistisches Regressionsmodell (Aufgabe 3)
# 
# Zweck: Das Modell berechnet die Wahrscheinlichkeit eines H5N1-Ausbruchs 
# basierend auf Umweltvariablen.
# Datensätze:
#   Präsenz: Werte an den bekannten H5N1-Ausbruchspunkten.
# Abwesenheit: Zufällige Punkte in Bereichen ohne Ausbrüche.
# Ergebnis: Eine Risikokarte mit Wahrscheinlichkeitswerten, die anzeigen, 
# wo ein H5N1-Ausbruch am wahrscheinlichsten ist




# Task 3, verbessert: Präsenz/Abwesenheits-Modell mit logistischer Regression
################################################################################

# Extrahieren der positiven H5N1-Fälle (RESULT == 1)
myHPAITablepos <- myHPAITable[myHPAITable$RESULT == 1, ]
myHPAIpos <- st_as_sf(myHPAITablepos, coords = c("XCOORD", "YCOORD"))  # Räumliches Objekt erstellen
myHPAI_Ipos <- raster::extract(myMask, myHPAIpos)  # Überprüfen, ob Punkte in der Maske liegen
myHPAI_I_pos_clean <- myHPAIpos[which(myHPAI_Ipos == 1), ]  # Nur gültige Punkte auswählen

# Extrahieren der negativen H5N1-Fälle (RESULT == 2)
myHPAITableneg <- myHPAITable[myHPAITable$RESULT == 2, ]
myHPAIneg <- st_as_sf(myHPAITableneg, coords = c("XCOORD", "YCOORD"))  # Räumliches Objekt erstellen
myHPAI_Ineg <- raster::extract(myMask, myHPAIneg)  # Überprüfen, ob Punkte in der Maske liegen
myHPAI_I_neg_clean <- myHPAIneg[which(myHPAI_Ineg == 1), ]  # Nur gültige Punkte auswählen

# Extrahieren der Rasterwerte für positive und negative Fälle
myDFpos <- as.data.frame(raster::extract(myStack, myHPAI_I_pos_clean))  # Positive Fälle
myDFneg <- as.data.frame(raster::extract(myStack, myHPAI_I_neg_clean))  # Negative Fälle

# Namen der Spalten angleichen
names(myDFpos) <- names(myDFneg) <- names(myStack)

# Hinzufügen der Antwortvariable
myDFpos$HasHPAI <- 1
myDFneg$HasHPAI <- 0

# Kombinieren der Daten
myDF <- rbind(myDFpos, myDFneg)

# Entfernen von Zeilen mit fehlenden Werten
noNADF <- myDF[complete.cases(myDF), ]

# Trainieren des Modells
myGLM <- glm(HasHPAI ~ dem + lake + rivden + ncrop + riverflood + DuDn + dMarkets, 
             data = noNADF, family = binomial)
summary(myGLM)  # Überprüfung der Signifikanz der Variablen

# Anwendung des Modells auf den Raster-Stack
RiskMap <- predict(myStack, model = myGLM, type = "response")

# Plotten der Risikokarte
Cols <- rev(brewer.pal(9, "RdYlGn"))
plot(RiskMap, col = Cols, main = "Risk Map for H5N1")




# Aufgabe 4: Modellbewertung mit ROC-Kurve, AUC und AIC
################################################################################

# Berechnung der AUC (Area Under the Curve)
# AUC misst die Trennschärfe des Modells zwischen Präsenz und Abwesenheit.
library(pROC)
nrow(data)  # Anzahl der Zeilen in data
length(fitted(risk_model))  # Länge der vorhergesagten Werte
data <- na.omit(data)  # Entfernt alle Zeilen mit NA-Werten
risk_model <- glm(presence ~ ., data = data, family = binomial)

roc_curve <- roc(data$presence, fitted(risk_model))  # ROC-Kurve erstellen
auc_value <- pROC::auc(roc_curve)  # AUC-Wert berechnen
cat("AUC-Wert des Modells:", round(auc_value, 3), "\n")
plot(roc_curve, main = paste("ROC Curve (AUC =", round(auc_value, 3), ")"))  # Plot der ROC-Kurve

# Interpretation:
#   AUC = 0.5: Modell ist nicht besser als Zufall.
# AUC > 0.7: Akzeptables Modell.
# AUC > 0.8: Gutes Modell.
# AUC > 0.9: Hervorragendes Modell.

# Berechnung des AIC (Akaike's Information Criterion), hier 0.868
# AIC misst die Modellgüte, wobei niedrigere Werte auf ein besseres Modell hinweisen.
aic_value <- AIC(risk_model)  # AIC-Wert berechnen
cat("AIC des Modells:", aic_value, "\n")
# Interpretation des AIC: AIC des Modells: 2390.824 
#   Der AIC bewertet die Modellgüte unter Berücksichtigung der Anzahl der Parameter.
# Niedrigere AIC-Werte zeigen ein besseres Modell an.
# Vergleichbar ist der AIC nur zwischen Modellen, die auf denselben Daten trainiert wurden.

# Relative Bedeutung der Variablen (Effektstärken)
# Die Koeffizienten des Modells zeigen die Stärke und Richtung des Einflusses der Variablen.
coefficients <- summary(risk_model)$coefficients
cat("Koeffizienten des Modells:\n")
print(coefficients)
#                  Estimate   Std. Error     z value     Pr(>|z|)
# (Intercept) -1.131902e+00 2.194397e-01 -5.15814492 2.494085e-07
# dem         -4.294862e-03 5.724094e-04 -7.50312993 6.231173e-14
# lake        -1.350894e+01 2.440058e+02 -0.05536318 9.558491e-01
# rivden       1.455145e+00 2.276409e-01  6.39227940 1.634309e-10
# ncrop        1.359252e-01 1.148174e-01  1.18383756 2.364774e-01
# riverflood   1.768296e-02 1.493471e-01  0.11840173 9.057494e-01
# DuDn         8.310888e-01 6.793494e-02 12.23359939 2.056211e-34
# dMarkets     7.026278e-04 1.090162e-03  0.64451716 5.192401e-01

# AUC (Area Under the Curve)
# 
# Definition: Misst, wie gut das Modell zwischen Präsenz- und Abwesenheitsdaten 
# unterscheidet.
# Wertbereich:
#   0.5: Modell ist nicht besser als Zufall.
# 1.0: Perfekte Trennung.
# Interpretation: Ein hoher AUC-Wert (z. B. >0.8) deutet auf ein gutes Modell hin.
# 
# AIC (Akaike’s Information Criterion)
# 
# Definition: Bewertet die Modellgüte unter Berücksichtigung der Anzahl der Parameter. 
# Ein niedriger AIC-Wert deutet auf ein besseres Modell hin. AIC des Modells: 2390.824 
# Vergleich: AIC kann zwischen mehreren Modellen verwendet werden, 
# um das beste Modell auszuwählen.
# 
# Variable Bedeutung (Koeffizienten)
# 
# Positive Koeffizienten: Erhöhen die Wahrscheinlichkeit eines H5N1-Ausbruchs 
# (z. B. hohe Tierdichte).
# Negative Koeffizienten: Reduzieren die Wahrscheinlichkeit 
# (z. B. größere Entfernung zu Märkten).

# Risikokarte: Zeigt die räumliche Verteilung der H5N1-Ausbruchsrisiken 
# basierend auf Umweltfaktoren.
# AUC: Bewertet die Genauigkeit des Modells.
# AIC: Gibt Hinweise auf die Modellgüte.
# Variable Bedeutung: Identifiziert die wichtigsten Umweltfaktoren, 
# die H5N1-Ausbrüche beeinflussen.



# Aufgabe 4, verbessert/ergänzt: Modellbewertung mit ROC-Kurve, AUC und AIC
################################################################################

# Entfernen von Zeilen mit fehlenden Werten
noNADF <- myDF[which(is.na(rowSums((myDF))) == FALSE), ]  # Entferne Zeilen mit NAs

# Logistisches Modell trainieren
risk_model <- glm(HasHPAI ~ dem + lake + rivden + ncrop + riverflood + DuDn + dMarkets, 
                  data = noNADF, family = binomial)

# Berechnung der AUC (Area Under the Curve) für das Modell
library(pROC)
predV <- predict(risk_model, type = "response", newdata = noNADF)  # Vorhersagen für die Daten
AUC_glm <- as.numeric(pROC::auc(response = noNADF$HasHPAI, predictor = predV))  # AUC-Wert berechnen
cat("AUC-Wert des Modells:", round(AUC_glm, 3), "\n")

# Plot der ROC-Kurve
plot(pROC::roc(response = noNADF$HasHPAI, predictor = predV), 
     main = paste("ROC Curve (AUC =", round(AUC_glm, 3), ")"))

# Berechnung des AIC (Akaike's Information Criterion)
AIC_glm <- AIC(risk_model)  # AIC-Wert berechnen
cat("AIC des Modells:", AIC_glm, "\n")
# AIC des Modells: 7951.417 

# Relative Bedeutung der Variablen (Effektstärken)
# Die Koeffizienten des Modells zeigen die Stärke und Richtung des Einflusses der Variablen.
coefficients <- summary(risk_model)$coefficients
cat("Koeffizienten des Modells:\n")
print(coefficients)
#                  Estimate   Std. Error      z value     Pr(>|z|)
# (Intercept) -2.335050e+00 1.290414e-01 -18.09535735 3.466881e-73
# dem         -4.092629e-03 5.711478e-04  -7.16562078 7.743485e-13
# lake        -1.102230e+01 1.414162e+02  -0.07794226 9.378740e-01
# rivden      -1.564410e-01 1.163976e-01  -1.34402272 1.789410e-01
# ncrop        1.788878e-01 5.166184e-02   3.46266687 5.348502e-04
# riverflood   3.007686e-02 7.220004e-02   0.41657675 6.769880e-01
# DuDn         5.143901e-01 3.764116e-02  13.66562679 1.628951e-42
# dMarkets    -7.409005e-05 6.317883e-04  -0.11727036 9.066458e-01

# Interpretation:
# - Positive Koeffizienten erhöhen die Wahrscheinlichkeit eines H5N1-Ausbruchs.
# - Negative Koeffizienten verringern die Wahrscheinlichkeit eines H5N1-Ausbruchs.
# - Signifikante Variablen (p-Wert < 0.05) sind wichtige Prädiktoren.

# Zusammenfassung der Modellbewertung:
# 1. AUC (Area Under the Curve):
#    - Misst die Trennschärfe zwischen Präsenz und Abwesenheit.
#    - Ein hoher AUC-Wert (> 0.8) deutet auf ein gutes Modell hin.
# 2. AIC (Akaike's Information Criterion):
#    - Bewertet die Modellgüte, wobei niedrigere Werte besser sind.
#    - Vergleichbar nur zwischen Modellen, die auf denselben Daten trainiert wurden.
# 3. Variable Bedeutung (Koeffizienten):
#    - Identifiziert die wichtigsten Umweltfaktoren, die H5N1-Ausbrüche beeinflussen.





# Task 5 (Datenimputation): Ersetzt fehlende Werte, um eine bessere Modellleistung 
# zu erzielen.
# Task 6 (Validierung): Vergleicht die Modellleistung auf einem unabhängigen 
# Validierungsdatensatz.
# Task 7 (Räumliche Kreuzvalidierung): Vermeidet Verzerrungen durch geografische 
# Nähe.
# Task 8 (VIF): Entfernt redundante Kovariaten für ein stabileres Modell.
# Task 9 (SSB): Prüft räumliche Unabhängigkeit von Trainings- und 
# Validierungspunkten.
# Task 10 (Modellvergleich): Vergleicht LASSO, BRT und GAM, um die beste 
# Modellierungsstrategie zu wählen.





# Aufgabe 5: Imputation fehlender Daten
#######################################################################
library(mice)

# Warum Imputation?
# Fehlende Werte können die Modellleistung beeinträchtigen, da nur vollständige Daten verwendet werden.
# Die Imputation ersetzt fehlende Werte basierend auf den vorhandenen Datenmustern.

# Imputation des Datensatzes
myDF_Imp = complete(mice(myDF, action = "all"))

# Trainieren des Modells auf dem imputierten Datensatz
glm_imp <- glm(HasHPAI ~ . , 
               data = myDF_Imp, family = binomial)

# Vergleich der Genauigkeit: Imputierter vs ursprünglicher Datensatz
# Vorhersagen für den imputierten Datensatz
predV_imp <- predict(glm_imp, type = "response", newdata = myDF_Imp)

# Berechnung der AUC für den imputierten Datensatz
AUC_glm_Imp <- pROC::auc(response = myDF_Imp$HasHPAI, predictor = predV_imp)
cat("AUC für den imputierten Datensatz:", round(AUC_glm_Imp, 3), "\n")
# AUC für den imputierten Datensatz: 0.729

# Optional: Vorhersagen für den ursprünglichen Datensatz (ohne Imputation)
glm_orig <- glm(HasHPAI ~ dem + lake + rivden + ncrop + riverflood + DuDn + dMarkets, 
                data = na.omit(myDF), family = binomial)
predV_orig <- predict(glm_orig, type = "response", newdata = na.omit(myDF))
AUC_glm_Orig <- pROC::auc(response = na.omit(myDF)$HasHPAI, predictor = predV_orig)
cat("AUC für den ursprünglichen Datensatz:", round(AUC_glm_Orig, 3), "\n")
# AUC für den ursprünglichen Datensatz: 0.729

# Interpretation der Ergebnisse:
# Ein höherer AUC-Wert im imputierten Datensatz zeigt, dass die Imputation die Modellleistung verbessern kann,
# da mehr Daten verwendet werden. Allerdings könnte die AUC aufgrund des Fehlens einer Kreuzvalidierung 
# überschätzt sein.

# Plot der ROC-Kurven
plot(pROC::roc(response = myDF_Imp$HasHPAI, predictor = predV_imp), col = "blue", 
     main = "ROC-Kurvenvergleich")
lines(pROC::roc(response = na.omit(myDF)$HasHPAI, predictor = predV_orig), col = "red")
legend("bottomright", legend = c("Imputiert", "Original"), col = c("blue", "red"), lwd = 2)



# Aufgabe 6: Validierungsgenauigkeit prüfen
################################################################################
# Training: Das Modell wird auf bekannten Daten trainiert. Diese Daten wurden "gesehen", 
# sodass das Modell die Muster in diesen Daten gut erkennt.
# Validierung: Bei der externen Validierung wird das Modell auf "unbekannte" Daten angewendet. 
# Hier zeigt sich, wie gut das Modell generalisiert und ob es auf neue Daten anwendbar ist.
# Ein Drop-off in der AUC zeigt, dass das Modell Schwierigkeiten hat, 
# die Muster auf die neuen Daten korrekt anzuwenden.
# Modelle können dazu neigen, sich zu stark an die Trainingsdaten anzupassen, 
# insbesondere bei komplexeren Modellen oder wenn es zu viele Prädiktoren gibt.
# Ein solches Modell funktioniert möglicherweise gut auf den Trainingsdaten (hohe AUC), 
# versagt jedoch bei neuen Daten (niedrigere AUC).
# Der Drop-off ist ein Hinweis auf Overfitting
# Kreuzvalidierung: Teste das Modell auf verschiedenen Teilmengen der Daten, um die Generalisierbarkeit zu bewerten.
# Feature-Engineering: Entferne redundante oder stark korrelierte Variablen, um ein stabileres Modell zu erstellen.
# Regularisierung: Verwende Techniken wie Ridge, LASSO oder Elastic Net, um Overfitting zu vermeiden.
# Ausreichend große Trainingsdaten: Sorge dafür, dass die Trainingsdaten repräsentativ für das gesamte Datenuniversum sind.


# Aufgabe 6: Validierungsgenauigkeit prüfen
###############################################################################
set.seed(123)

# Daten in Trainings- und Validierungssatz aufteilen (80% Training, 20% Validierung)
train_index <- sample(1:nrow(complete_data), 0.8 * nrow(complete_data))
train_data <- complete_data[train_index, ]
valid_data <- complete_data[-train_index, ]

# Modelltraining auf dem Trainingsdatensatz
train_model <- glm(presence ~ ., data = train_data, family = binomial)

# Vorhersagen für Trainings- und Validierungsdatensatz
train_predictions <- predict(train_model, train_data, type = "response")
valid_predictions <- predict(train_model, valid_data, type = "response")

# Sicherstellen, dass die Längen von Zielvariable und Vorhersagen übereinstimmen
stopifnot(length(train_data$presence) == length(train_predictions))
stopifnot(length(valid_data$presence) == length(valid_predictions))

# Berechnung der AUC für beide Datensätze
library(pROC)

# Berechnung der ROC und AUC
train_roc <- roc(response = train_data$presence, predictor = train_predictions)
valid_roc <- roc(response = valid_data$presence, predictor = valid_predictions)

# Berechnung der AUC
train_auc <- pROC::auc(train_roc) # Trainings-AUC: 0.867 
valid_auc <- pROC::auc(valid_roc) # Validierungs-AUC: 0.868 

# Vergleich der AUC-Werte
cat("Trainings-AUC:", round(train_auc, 3), "\n")
cat("Validierungs-AUC:", round(valid_auc, 3), "\n")

# direkter Vergleich, da zu wenig Werte für t-Test
auc_difference <- train_auc - valid_auc
cat("Differenz zwischen Trainings-AUC und Validierungs-AUC:", round(auc_difference, 3), "\n")
# Differenz zwischen Trainings-AUC und Validierungs-AUC: -0.001 


# Aufgabe 7: Räumliche Kreuzvalidierung
#################################################################################
library(raster)
library(pROC)

# Räumliche Ausdehnung definieren und in Falten aufteilen
extent_area <- extent(myMask)  # Bounding Box des Untersuchungsbereichs
coordinates <- st_coordinates(myHPAI_I_clean)  # Koordinaten der Ausbruchspunkte
spatial_folds <- kmeans(coordinates, centers = 5)$cluster  # Fünf räumliche Falten erstellen

# Training und Validierung räumlich aufteilen
for (fold in unique(spatial_folds)) {
  train_data <- complete_data[spatial_folds != fold, ]
  valid_data <- complete_data[spatial_folds == fold, ]
  
  # Sicherstellen, dass Zielvariable korrekt ist
  valid_data$presence <- as.numeric(valid_data$presence)
  
  # Modelltraining und Vorhersage
  spatial_model <- glm(presence ~ ., data = train_data, family = binomial)
  valid_predictions <- predict(spatial_model, valid_data, type = "response")
  
  # Sicherstellen, dass die Längen stimmen
  stopifnot(length(valid_data$presence) == length(valid_predictions))
  
  # AUC berechnen
  valid_roc <- pROC::roc(response = valid_data$presence, predictor = valid_predictions)
  valid_auc <- pROC::auc(valid_roc)
  
  # Ergebnis ausgeben
  cat("Fold:", fold, "AUC:", round(valid_auc, 3), "\n")
}



# Aufgabe 8: Kreuzkorrelation prüfen
###########################################################################
library(usdm)

# VIF (Variance Inflation Factor) analysieren und korrelierte Variablen entfernen
vif_result <- vifstep(complete_data[, -ncol(complete_data)])  # Präsenz-Variable ausschließen
reduced_data <- complete_data[, vif_result@results$Variables]  # Reduzierter Datensatz ohne korrelierte Variablen

cat("Reduzierte Variablen nach VIF-Analyse:\n")
print(names(reduced_data))
# "dem"        "lake"       "rivden"     "ncrop"      "riverflood" "ChDn"       "dMarkets" 

# Aufgabe 9: Räumliche Verzerrung (Spatial Sorting Bias) prüfen
###############################################################################
library(SDMtune)

# Koordinaten für Trainings- und Validierungspunkte extrahieren
train_coords <- st_coordinates(myHPAI_I_clean)
valid_coords <- st_coordinates(valid_data)

# Spatial Sorting Bias berechnen
ssb_result <- ssb(train = train_coords, test = valid_coords)
cat("Spatial Sorting Bias:", ssb_result$SSB, "\n")

# Interpretation
if (ssb_result$SSB < 0.5) {
  cat("SSB zeigt eine gute räumliche Unabhängigkeit zwischen Trainings- und Validierungsdaten an.\n")
} else {
  cat("SSB zeigt eine mögliche räumliche Abhängigkeit zwischen Trainings- und Validierungsdaten an.\n")
}




# Aufgabe 10: Modellvergleich
#############################################################################
# Aufgabe 10.1: LASSO
library(glmnet)
lasso_model <- cv.glmnet(as.matrix(complete_data[, -ncol(complete_data)]), 
                         complete_data$presence, 
                         family = "binomial")
lasso_predictions <- predict(lasso_model, 
                             as.matrix(complete_data[, -ncol(complete_data)]), 
                             type = "response")
lasso_roc <- roc(response = complete_data$presence, predictor = lasso_predictions)
lasso_auc <- auc(lasso_roc)

# Aufgabe 10.2: Boosted Regression Trees (BRT)
library(dismo)
brt_model <- gbm.step(data = complete_data, gbm.x = 1:(ncol(complete_data) - 1), gbm.y = ncol(complete_data))
brt_predictions <- predict(brt_model, complete_data)
brt_roc <- roc(response = complete_data$presence, predictor = brt_predictions)
brt_auc <- auc(brt_roc)

# Aufgabe 10.3: Generalized Additive Models (GAM)
library(mgcv)
gam_model <- gam(presence ~ s(dem) + s(lake) + s(rivden), data = complete_data, family = binomial)
gam_predictions <- predict(gam_model, complete_data, type = "response")
gam_roc <- roc(response = complete_data$presence, predictor = gam_predictions)
gam_auc <- auc(gam_roc)

# Modellvergleich
cat("LASSO AUC:", round(lasso_auc, 3), "\n")
cat("BRT AUC:", round(brt_auc, 3), "\n")
cat("GAM AUC:", round(gam_auc, 3), "\n")
