from datetime import datetime  # Importiert das datetime-Modul, um das aktuelle Datum und die Uhrzeit zu erhalten
import traceback  # Importiert das traceback-Modul, um detaillierte Fehlerausgaben (Stacktrace) zu ermöglichen

# Definiert eine benutzerdefinierte Logger-Klasse, um Lognachrichten mit Zeitstempel in eine Datei zu schreiben
class CustomLogger:
    def __init__(self, filename, mode="w"):
        # Initialisiert den Logger mit einem Dateinamen und einem Modus
        # filename: Der Name der Datei, in die die Log-Nachrichten geschrieben werden
        # mode: Der Dateimodus, "w" steht für Schreibmodus (überschreibt vorhandene Datei), "a" für Anfügemodus
        self.filename = filename
        self.mode = mode
        self.file = None  # Platzhalter für das Dateiobjekt, wird beim Öffnen der Datei zugewiesen

    def __enter__(self):
        # Diese Methode wird beim Eintritt in den `with`-Block aufgerufen
        # Sie öffnet die Datei im angegebenen Modus und gibt das Logger-Objekt zurück
        self.file = open(self.filename, self.mode)
        return self  # Gibt das Logger-Objekt zurück, um die Methoden innerhalb des `with`-Blocks verwenden zu können

    def __exit__(self, exc_type, exc_value, tb):
        # Diese Methode wird beim Verlassen des `with`-Blocks aufgerufen
        # exc_type: Der Typ der Ausnahme, falls eine aufgetreten ist
        # exc_value: Der Wert der Ausnahme
        # tb: Der Stacktrace der Ausnahme
        if exc_type:
            # Falls eine Ausnahme auftritt, gibt `traceback.print_exception` die Details des Fehlers aus
            traceback.print_exception(exc_type, exc_value, tb)
        # Schließt die Datei, um sicherzustellen, dass alle Daten korrekt geschrieben wurden
        self.file.close()

    def write(self, content):
        # Schreibt eine Nachricht mit einem Zeitstempel in die Log-Datei
        now = datetime.now()  # Holt das aktuelle Datum und die aktuelle Uhrzeit
        # Schreibt die Nachricht in die Datei im Format "Zeitstempel: Nachricht"
        self.file.write(f"{now}: " + content + "\n")


# Verwenden des CustomLogger mit einem `with`-Block
with CustomLogger("custom_logger.txt") as file:
    # Innerhalb des `with`-Blocks können wir die `write`-Methode des Loggers verwenden
    file.write("First line")   # Schreibt "First line" mit Zeitstempel in die Log-Datei
    file.write("Hallo world")  # Schreibt "Hallo world" mit Zeitstempel in die Log-Datei

# Beim Verlassen des `with`-Blocks wird die Datei automatisch geschlossen und
# ggf. auftretende Fehler werden mit einem Stacktrace ausgegeben.
# with CustomLogger("custom_logger.txt") as file:: Startet den with-Block, der die Datei custom_logger.txt öffnet.
# Innerhalb des Blocks können Logeinträge über file.write(...) geschrieben werden.
# Der with-Block stellt sicher, dass die Datei auch bei Fehlern ordnungsgemäß geschlossen wird.