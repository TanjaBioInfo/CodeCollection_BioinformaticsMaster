
### Metagenomics and NGS
### 10.12.24


# Remove current working environment
rm(list = ls())


# Set path to wd
path_to_wd <- "/Users/TR/Desktop/BIO 445, quantitative life science/07_forstudents"
setwd(path_to_wd)



# Install the following packages if not already installed

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install()
BiocManager::install("dada2")
BiocManager::install("phyloseq")
BiocManager::install("ShortRead")
BiocManager::install("DECIPHER")
BiocManager::install("ggtree")
BiocManager::install("ggtreeExtra")
install.packages("tidyverse")
install.packages("ggnewscale")
install.packages("phangorn")


# Load the required packages
library(ShortRead)
library(dada2)
library(phyloseq)
library(tidyverse)
library(DECIPHER)
library(phangorn)
library(ggtree)
library(ggtreeExtra)
library(ggnewscale)



#################################################################
###################### Problem 1: NGS data ######################
#################################################################

#######
##1.1##
#######

##sequence paths
path_to_files <- "/Users/TR/Desktop/BIO 445, quantitative life science/07_forstudents/06_course_download/fastqs"
list.files(path_to_files) ### you should be able to see your files
> list.files(path_to_files) ### you should be able to see your files
# [1] "JG-6916007_S11_L001_R1_001.fastq.gz" "JG-6916007_S11_L001_R2_001.fastq.gz"
# [3] "JG-6916021_S36_L001_R1_001.fastq.gz" "JG-6916021_S36_L001_R2_001.fastq.gz"
# [5] "JG-6916024_S39_L001_R1_001.fastq.gz" "JG-6916024_S39_L001_R2_001.fastq.gz"
# [7] "JG-6916026_S41_L001_R1_001.fastq.gz" "JG-6916026_S41_L001_R2_001.fastq.gz"
# [9] "JG-6916641_S6_L001_R1_001.fastq.gz"  "JG-6916641_S6_L001_R2_001.fastq.gz" 
# [11] "JG-6917482_S13_L001_R1_001.fastq.gz" "JG-6917482_S13_L001_R2_001.fastq.gz"
# [13] "JG-6917490_S22_L001_R1_001.fastq.gz" "JG-6917490_S22_L001_R2_001.fastq.gz"
# [15] "JG-6917492_S14_L001_R1_001.fastq.gz" "JG-6917492_S14_L001_R2_001.fastq.gz"


#######
##1.2##
#######

##Read fastq
# Korrektes Zusammenfügen des Pfads
fastq_files <- list.files(path_to_files, pattern = "\\.fastq.gz$", full.names = TRUE)
fastq <- readFastq(fastq_files[1])  # Erste Datei einlesen
list.files(path_to_files, pattern = "\\.fastq.gz$", full.names = TRUE)
fastq <- readFastq(file.path(path_to_files, basename(fastq_files[1])))

#######
##1.3##
#######

##Look at reads
fastq@sread
# Hier sehen Sie eine Teilmenge aller gespeicherten „Reads“, 
# d. h. Sequenzen von Nukleotiden, die das Ergebnis der NGS-Sequenzierung sind.  
# Im Gegensatz zu einer FASTA-Datei, in der nur Sequenzen gespeichert werden, 
# speichern FASTQ-Dateien zusätzlich die Qualität jeder Position jedes Reads (Q-Score).

##Look at quality
fastq@quality@quality
# Die Qualitätswerte (Scores) sind in ASCII-Zeichen codiert, 
# d. h., jedes Zeichen repräsentiert eine Zahl, von 33 (!) bis 73 (I). 
# Dies entspricht einem Q-Score von Q0 
# (0 % Genauigkeit der Basenposition) bis Q40 (99,99 % 
#     Genauigkeit der Basenposition).  
# 
# **4. Vorwärts- und Rückwärtsreads**  
#   Wie Sie vielleicht bemerkt haben, hat jede heruntergeladene 
# Datei zwei Versionen: „R1“ und „R2“. Diese sind gepaarte Reads, 
# wobei R2 die komplementäre Sequenz von R1 ist. 
# Sie werden auch oft als Vorwärts- und Rückwärtsreads bezeichnet.

##############################################################################################
###################### Problem 2: Extracting microbiom from all samples ######################
##############################################################################################

#######
##2.1##
#######
#######
## Vorbereitung
#######

# 1. Pakete installieren und laden
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install(c("dada2", "phyloseq"))
install.packages("tidyverse")

library(dada2)
library(phyloseq)
library(tidyverse)

# 2. Datenpfade definieren
path_to_files <- "/Users/TR/Desktop/BIO 445, quantitative life science/07_forstudents/06_course_download/fastqs"
list.files(path_to_files) ### you should be able to see your files
list.files(path_to_files) ### you should be able to see your files
##Read fastq
# Korrektes Zusammenfügen des Pfads
fastq_files <- list.files(path_to_files, pattern = "\\.fastq.gz$", full.names = TRUE)
fastq <- readFastq(fastq_files[1])  # Erste Datei einlesen
# Daten in einem DataFrame speichern
fastq_df <- data.frame(
  sequence = as.character(fastq@sread),
  quality = as.character(fastq@quality@quality)
)

# DataFrame anzeigen
View(fastq_df)
# Zeigt eine Zusammenfassung des FastQ-Objekts
summary(fastq)

# meta_data_path <- "/Pfad/zu/Ihren/Metadaten.csv"  # Geben Sie den Pfad zu Ihrer Metadatendatei an

#######
## 2.1 ##
#######

# Vorwärts- und Rückwärtsreads sortieren

# Definieren des Pfads zu den FastQ-Dateien
path_to_files <- "/Users/TR/Desktop/BIO 445, quantitative life science/07_forstudents/06_course_download/fastqs"

# Vorwärtsreads (R1) sortieren
fnFs <- sort(list.files(path_to_files, pattern = "R1_001.fastq.gz$", full.names = TRUE))

# Rückwärtsreads (R2) sortieren
fnRs <- sort(list.files(path_to_files, pattern = "R2_001.fastq.gz$", full.names = TRUE))

# Sample-Namen extrahieren (Bereinigung der Namensgebung)
sample_names <- gsub("JG-JG-", "JG-", fnFs)  # Entfernt doppelte "JG-JG-"
sample_names <- sapply(strsplit(sample_names, "-"), `[`, 2)  # Nimmt den Teil nach dem ersten Bindestrich
sample_names <- sapply(strsplit(sample_names, "_"), `[`, 1)  # Entfernt alles nach dem ersten Unterstrich

# Ergebnisse überprüfen
cat("Vorwärtsreads:\n", fnFs, "\n")
cat("Rückwärtsreads:\n", fnRs, "\n")
cat("Sample-Namen:\n", sample_names, "\n")


#######
## 2.2 ##
#######

# Metadaten einlesen
#######
## 2.2 ##
#######

# Definieren Sie den Pfad zu den Metadaten
meta_data_path <- "/Users/TR/Desktop/BIO 445, quantitative life science/07_forstudents/06_course_download/meta_tb.csv"

# Metadaten einlesen
meta_dat <- read.csv(meta_data_path)

# Zeigen Sie die ersten Zeilen der Metadaten an, um die Struktur zu überprüfen
head(meta_dat)

# # Formatieren der Sample-Namen (falls erforderlich, anpassen)
# # Beispiel: Spalte `Lab.ID` enthält die IDs der Samples
# meta_dat$Lab.ID <- gsub("JG-JG-", "JG-", meta_dat$Lab.ID)  # Entfernt doppelte "JG-JG-"
# meta_dat$Lab.ID <- sapply(strsplit(meta_dat$Lab.ID, "-"), `[`, 2)  # Nimmt den Teil nach dem ersten Bindestrich
# 
# # Überprüfen Sie die Metadaten nach der Formatierung
# head(meta_dat)


#######
## 2.3 ##
#######

#######
## 3 ##
#######

# Pfad für gefilterte Dateien erstellen
# Fügen Sie das "filtered"-Verzeichnis zum bestehenden Pfad hinzu
path_to_files_fil <- file.path(path_to_files, "filtered")

# Überprüfen, ob das Verzeichnis existiert; falls nicht, erstellen
if (!dir.exists(path_to_files_fil)) {
  dir.create(path_to_files_fil)
  cat("Das Verzeichnis 'filtered' wurde erstellt.\n")
} else {
  cat("Das Verzeichnis 'filtered' existiert bereits.\n")
}

# Gefilterte Pfade für Vorwärts-Reads (R1)
filtFs <- file.path(path_to_files_fil, paste0(sample_names, "_F_filt.fastq.gz"))
names(filtFs) <- sample_names  # Zuordnung von Sample-Namen zu den Pfaden

# Gefilterte Pfade für Rückwärts-Reads (R2)
filtRs <- file.path(path_to_files_fil, paste0(sample_names, "_R_filt.fastq.gz"))
names(filtRs) <- sample_names  # Zuordnung von Sample-Namen zu den Pfaden

# Überprüfung der Pfade
cat("Gefilterte Pfade für Vorwärts-Reads:\n", filtFs, "\n")
cat("Gefilterte Pfade für Rückwärts-Reads:\n", filtRs, "\n")


# # Gefilterte Dateipfade definieren
# path_to_files_fil <- file.path(fastq_path, "filtered")
# 
# filtFs <- file.path(path_to_files_fil, paste0(sample_names, "_F_filt.fastq.gz"))
# names(filtFs) <- sample_names
# 
# filtRs <- file.path(path_to_files_fil, paste0(sample_names, "_R_filt.fastq.gz"))
# names(filtRs) <- sample_names

#######
## 2.4 ##
#######
#######
## Auswahl von 4 Lab.IDs pro TB-Gruppe ##
#######

# Überprüfen der Struktur der Metadaten, um die Spalte mit der TB-Gruppierung zu identifizieren
str(meta_dat)

# Annahme: Die Spalte mit der Gruppierung heißt "TB_Group" (passen Sie den Namen an Ihre Daten an)
# Gruppieren der Metadaten nach "TB_Group" und Auswahl von 4 IDs pro TB-Gruppe
tb_group_ids <- meta_dat %>%
  group_by(TB) %>%  # Gruppieren nach der TB-Gruppe
  slice_head(n = 4) %>%   # Wählen Sie die ersten 4 IDs jeder Gruppe
  pull(Lab.ID)            # Extrahieren Sie die Lab.IDs

# Ausgabe der ausgewählten IDs
cat("Ausgewählte Lab.IDs pro TB-Gruppe:\n", tb_group_ids, "\n")

# andere Lösung:
# Subset der Samples auswählen
#######
## Subset der Reads basierend auf ausgewählten IDs ##
#######

# Filtern der Metadaten für die ausgewählten IDs
metadata_use <- meta_dat %>% filter(Lab.ID %in% tb_group_ids)

# Reads filtern
fnFs <- fnFs[names(filtFs) %in% metadata_use$Lab.ID]
filtFs <- filtFs[names(filtFs) %in% metadata_use$Lab.ID]
fnRs <- fnRs[names(filtRs) %in% metadata_use$Lab.ID]
filtRs <- filtRs[names(filtRs) %in% metadata_use$Lab.ID]

# Überprüfen der Ergebnisse
cat("Gefilterte Vorwärts-Reads:\n", fnFs, "\n")
cat("Gefilterte Rückwärts-Reads:\n", fnRs, "\n")
cat("Gefilterte Metadaten:\n")
print(metadata_use)

#######
## 2.5 ##
#######

# Qualitätsprofile der Reads visualisieren


library(dada2)

# Qualitätsprofile der Vorwärts-Reads (R1)
cat("Qualitätsprofil der Vorwärts-Reads (R1):\n")
plotQualityProfile(fnFs)

# Qualitätsprofile der Rückwärts-Reads (R2)
cat("Qualitätsprofil der Rückwärts-Reads (R2):\n")
plotQualityProfile(fnRs)


#######
## 2.6 ##
#######

# Reads filtern und trimmen
# out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs,
#                      truncLen = c(240, 200),  # Truncate basierend auf Qualitätsprofilen
#                      maxN = 0, maxEE = c(2, 2), truncQ = 2,
#                      rm.phix = TRUE, compress = TRUE, multithread = TRUE)
# head(out)

#######
## 6. Reinigung der FastQ-Dateien ##
#######

# Definition der Parameter basierend auf den Qualitätsprofilen
# Passen Sie die Werte basierend auf den Ergebnissen von plotQualityProfile() an
truncLen <- c(240, 200)  # Vorwärts und Rückwärts, basierend auf Qualitätsprofil
truncQ <- 2  # Truncate bei Q-Scores <= 2
maxN <- 0  # Keine undefinierten Basen erlauben
maxEE <- c(2, 2)  # Maximal 2 erwartete Fehler pro Read
rm.phix <- TRUE  # PhiX-Kontaminanten entfernen

# FastQ-Dateien filtern und trimmen
out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs,
                     truncLen = truncLen,
                     maxN = maxN,
                     maxEE = maxEE,
                     truncQ = truncQ,
                     rm.phix = rm.phix,
                     compress = TRUE,  # Ergebnisse komprimieren
                     multithread = TRUE)  # Parallelverarbeitung nutzen

# Ergebnisse anzeigen
cat("Gefilterte Reads:\n")
head(out)
#                                     reads.in reads.out
# JG-6916007_S11_L001_R1_001.fastq.gz    81984     53008
# JG-6917482_S13_L001_R1_001.fastq.gz     9835      6622
# JG-6917490_S22_L001_R1_001.fastq.gz    38680     20500
# JG-6917492_S14_L001_R1_001.fastq.gz    27384     19011

# Speichern der gefilterten Reads, falls erforderlich
write.csv(out, file = file.path(path_to_files_fil, "filtered_reads_summary.csv"))

# Ergebnisse interpretieren:
#   Ausgabe von out:
#   Zeigt eine Zusammenfassung der Reads vor und nach der Filterung.
# Enthält Spalten wie reads.in (eingehende Reads) und reads.out (gefilterte Reads).
# Anpassung der Parameter:
#   Falls zu viele Reads entfernt werden, passen Sie die Parameter 
# (truncLen, maxEE, truncQ) an.
# Beispielsweise können Sie truncLen verkürzen oder maxEE erhöhen, 
# um mehr Reads zu behalten.

#######
## 2.7 ##
#######


# Fehlerberechnung für die Rückwärtsreads
cat("Fehlerberechnung für Rückwärtsreads (R2):\n")
errR <- learnErrors(filtRs, multithread = TRUE)

# Fehlerberechnung für die Vorwärtsreads
cat("Fehlerberechnung für Vorwärtsreads (R1):\n")
errF <- learnErrors(filtFs, multithread = TRUE)

# Fehlerprofile der Rückwärtsreads visualisieren
cat("Visualisierung der Fehler für Rückwärtsreads (R2):\n")
plotErrors(errR, nominalQ = TRUE)

# Fehlerprofile der Vorwärtsreads visualisieren
cat("Visualisierung der Fehler für Vorwärtsreads (R1):\n")
plotErrors(errF, nominalQ = TRUE)

# bessere Plot wegen den Nullwerten:
plotErrors(errR, nominalQ = TRUE) +
  scale_y_continuous(trans = scales::pseudo_log_trans(base = 10))
# Fehlerprofile auf Null-Werte überprüfen
errR_data <- as.data.frame(errR)
errF_data <- as.data.frame(errF)

# Ersetzen von Null-Werten durch einen kleinen Wert (z. B. 1e-6)
errR_data[errR_data == 0] <- 1e-6
errF_data[errF_data == 0] <- 1e-6
# Überprüfen der minimalen Werte in den Fehlerdaten
min(errR_data)
min(errF_data)
plotErrors(errR, nominalQ = TRUE) +
  scale_y_continuous(trans = scales::pseudo_log_trans(base = 10))

plotErrors(errF, nominalQ = TRUE) +
  scale_y_continuous(trans = scales::pseudo_log_trans(base = 10))

# Die Daten zeigen, dass die Fehlerberechnung erfolgreich ist, 
# da das modellierte Fehlerprofil (rote Linie) die beobachteten 
# Fehlerhäufigkeiten (schwarze Punkte) gut widerspiegelt.
# Schlüsselbeobachtungen:
#   Hohe Q-Scores:
#   Für hohe Konsensus-Qualitätswerte (>20) sind die Fehlerfrequenzen 
# extrem niedrig, was zeigt, dass Ihre Daten in diesen Bereichen zuverlässig sind.
# Erhöhte Fehler bei niedrigen Q-Scores:
#   Wie erwartet, steigt die Fehlerfrequenz bei niedrigeren Q-Scores an, 
# insbesondere unterhalb eines Q-Scores von 10.
# Spezifische Basenübergänge:
#   Übergänge wie A2C, G2A oder ähnliche scheinen in einigen Fällen 
# höhere Fehler aufzuweisen. Dies kann auf spezifische Sequenzierungsfehler 
# hinweisen, die durch das Modell korrekt identifiziert werden.
# Die scheinbar hohe Fehlerrate bei identischen Basenübergängen (A2A, C2C, etc.) 
# ist oft auf technische Limitierungen in der Sequenzierung oder Modellierung 
# zurückzuführen. Eine sorgfältige Anpassung der Filterparameter und eine 
# Analyse der Rohdaten können helfen, die Ursache zu klären und die 
# Datenqualität zu verbessern.

#######
## 2.8 ##
#######


# DADA2-Analyse der Rückwärtsreads
cat("DADA2-Analyse der Rückwärtsreads (R2):\n")
dadaRs <- dada(filtRs, err = errR, multithread = TRUE)

# DADA2-Analyse der Vorwärtsreads
cat("DADA2-Analyse der Vorwärtsreads (R1):\n")
dadaFs <- dada(filtFs, err = errF, multithread = TRUE)

# Überprüfen der Ergebnisse
cat("DADA2-Ergebnisse für Rückwärtsreads:\n")
print(dadaRs)

cat("DADA2-Ergebnisse für Vorwärtsreads:\n")
print(dadaFs)


#######
## 2.9 ##
#######


# 1. Zusammenführen von Vorwärts- und Rückwärtsreads
cat("Kombinieren der Vorwärts- und Rückwärtsreads:\n")
mergers <- mergePairs(dadaFs, filtFs, dadaRs, filtRs, verbose = TRUE)

# 2. Sequenztabelle erstellen
cat("Erstellen der Sequenztabelle:\n")
seqtab <- makeSequenceTable(mergers)

# Überprüfen der Sequenztabelle
cat("Dimension der Sequenztabelle (Samples x Sequenzen):\n")
print(dim(seqtab))
cat("Sequenztabelle-Vorschau:\n")
print(seqtab[1:5, 1:5])  # Zeigt die ersten 5 Samples und Sequenzen

# 3. Entfernen von chimären Sequenzen
cat("Entfernen von chimären Sequenzen:\n")
seqtab.nochim <- removeBimeraDenovo(seqtab, method = "consensus", multithread = TRUE, verbose = TRUE)

# Überprüfen der Sequenztabelle nach Chimärenentfernung
cat("Dimension der Sequenztabelle nach Chimärenentfernung:\n")
print(dim(seqtab.nochim))
cat("Prozentuale Reduktion der Sequenzen durch Chimärenentfernung:\n")
cat(round(100 * (1 - sum(seqtab.nochim) / sum(seqtab)), 2), "%\n")

# Optional: Ergebnisse speichern
write.csv(seqtab.nochim, file = file.path(path_to_files_fil, "seqtab_nochim.csv"))


#######
## Abschluss ##
#######

# Speichern Sie die gefilterten Sequenzen und Ergebnisse für die nächste Analyse.
saveRDS(seqtab.nochim, file = file.path(path_to_files_fil, "seqtab_nochim.rds"))



#########################################################################################
###################### Problem 3: Analysis of extracted microbiome ######################
#########################################################################################

#######
##3.1##
#######

taxa <- assignTaxonomy(seqtab.nochim, paste0(path_to_files, "silva_nr99_v138.1_train_set.fa"), multithread=TRUE,tryRC=TRUE)

taxa <- addSpecies(taxa, paste0(path_to_files, "silva_species_assignment_v138.1.fa"))



######################################################################################################
###################### Problem 4: Analysis of microbiome abundance by TB status ######################
######################################################################################################

#######
##4.1##
#######

##Get sample names as subject id
subject  <-  rownames(seqtab.nochim)

##Filter meta data to relevant samples
meta_dat = meta_dat %>% filter(Lab.ID %in% subject)

##Order metadata to match order in Sequence data.
meta_dat = meta_dat[match(subject, meta_dat$Lab.ID),]

##Add TB status
tb <- meta_dat$TB

##Generate new data frame with patient id and TB status
meta_new <- data.frame(Subject=subject, tbstatus=tb)

##Add ids as rownames
rownames(meta_new) <-  rownames(seqtab.nochim)

##TB status as factor
meta_new$tbstatus = as.factor(meta_new$tbstatus)

##Build combined data with meta data, sequence data, and taxonomic data
finaldata <- phyloseq(otu_table(seqtab.nochim, taxa_are_rows=FALSE), 
            sample_data(meta_new), 
            tax_table(taxa))

#######
##4.2##
#######

##top xxx taxa
topxx <- names(sort(taxa_sums(finaldata), decreasing=TRUE))[1:??]
topxx = topxx[!is.na(topxx)]
finaldata.topxx <- transform_sample_counts(finaldata, function(OTU) OTU/sum(OTU))
finaldata.topxx <- prune_taxa(topxx, finaldata.topxx)
plot_bar(finaldata.topxx, fill="Order") + facet_wrap(~tbstatus, scales="free_x")

#######
##4.3##
#######

plot_richness(finaldata, x="tbstatus", measures=c(??)
estimate_richness()
wilcox.test()

#######
##4.4##
####### 

##Specific taxonomy
taxa_of_interest = c(??)
taxa_level = "Order"
spec_taxa = rownames(finaldata@tax_table[grep(taxa_of_interest,finaldata@tax_table[,taxa_level]),])
spec_taxa = spec_taxa[!is.na(spec_taxa)]
finaldata.spec_taxa <- transform_sample_counts(finaldata, function(OTU) OTU/sum(OTU))
finaldata.spec_taxa <- prune_taxa(spec_taxa, finaldata.spec_taxa)
plot_bar(finaldata.spec_taxa, fill="Order") + facet_wrap(~tbstatus, scales="free_x")

######################################################################################################
###################### Problem 5: Data visualisation via phylogeny ###################################
######################################################################################################

#######
##5.1##
#######

##Phylogenetics
finaldata = transform_sample_counts(finaldata, function(OTU) OTU/sum(OTU))
finaldata_melt <- psmelt(finaldata) %>% filter(!is.na(Order)) %>% filter(Abundance > 0.001)
  #group_by(Phylum,Class,Order,Family,Genus) %>% mutate(n = sum(Abundance > 0)) %>% filter(n > 1)
finaldata_melt$Sample = paste0("pat_",as.factor(finaldata_melt$Sample))

#######
##5.2##
#######

##Build phylogenetic tree
##Extract sequences
sequences<-getSequences(unique(finaldata_melt$OTU))

##Sequence name same as sequence to match later
names(sequences)<-sequences

#Alignment of sequences
alignment <- AlignSeqs(DNAStringSet(sequences), anchor=NA)
phang.align <- phyDat(as(alignment, "matrix"), type="DNA")

##dist.ml tries different variants of genetic distance measures and
##takes the best fitting to the actual data
dm <- dist.ml(phang.align)

## Neighbor joining is used for the tree construction
treeNJ <- NJ(dm) 


#######
##5.3##
#######

##Tree figure
p <- ggtree(treeNJ, layout="fan", open.angle=15)

p <- p %<+% finaldata_melt 

p <- p + new_scale_fill() + new_scale_color() +
  geom_fruit(geom=geom_tile,
             mapping=aes(y=OTU, x=Phylum, fill=Phylum),
             offset = 0.04,size = 10) +
  scale_fill_hue() +
  new_scale_fill() + new_scale_color() +
  geom_fruit(geom=geom_tile,
             mapping=aes(y=OTU, x=tbstatus, fill=Abundance),
              offset = 0.04,size = 0.02) +
  scale_fill_viridis_c() + labs(fill="TBstatus/Abundance") +
  new_scale_fill() + new_scale_color() +
  geom_fruit(geom=geom_tile,
             mapping=aes(y=OTU, x=Sample, fill=Sample),
              offset = 0.1,size = 0.02) +  
  scale_fill_manual(values=c("#FFC125","#7B68EE",
                               "#800080","#D15FEE",
                               "#EE6A50","#006400","#800000",
                               "#B0171F"))

p <- p +  geom_treescale(fontsize=2, linesize=1, x=1, y=1) + 
          theme(legend.position=c(1.1, 0.5),
          legend.background=element_rect(fill=NA),
          legend.spacing.y = unit(0.1, "cm"),
  )
p

