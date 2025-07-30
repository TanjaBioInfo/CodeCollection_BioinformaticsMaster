import operator
import time
from log_handling import setup_logger, close_log_handlers

# Make a simple calculator, where the user is repeatedly asked to enter numbers and operands and the calulator
# returns  the result,
# until the user enters 'exit'. The calculator should also log all the data inputted and any exceptions which might
# happen  e.g. DivisonByZero, NotANumber
# and still continue to function even though an exception happened
# Catch at least 3 specific exceptions and log a sensible message
# Allow the user to use the last result by typing "last" instead of a number as an input
# You can use following dictionary to retrieve operators and use the operator like so operator.add(x, y)

# Einfacher Rechner mit Fehlerprotokollierung

# Dieses Notebook enthält einen einfachen Rechner,
# der den Benutzer wiederholt nach Zahlen und Operatoren fragt und das Ergebnis zurückgibt.
# Der Benutzer kann "exit" eingeben, um das Programm zu beenden.
# Der Rechner protokolliert alle Eingaben sowie mögliche Ausnahmen
# (z. B. `ZeroDivisionError`, `ValueError`, `KeyError`) und funktioniert weiterhin auch nach einer Ausnahme.

import operator
import logging
import time

# Lösung vom Kurs:
#
# Dictionary mit Operatoren und zugehörigen Funktionen
ops = {
    "+": operator.add,
    "-": operator.sub,
    "*": operator.mul,
    "**": operator.pow,
    "/": operator.truediv,
    "%": operator.mod,
}

## Setup Logger für Fehlerprotokollierung
# Ein Logger hilft uns, Fehler und Benutzeraktionen in einer Datei festzuhalten.
# Dies ist besonders nützlich, um zu verfolgen, welche Berechnungen und Fehler aufgetreten sind.

# Write your solution below
def main():
    log = setup_logger("calculator.log")
    log.info("Welcome to the simple python calculator")
    log.info("Enter exit at any time to exit the calculator")
    log.info("Type last to use the last result instead of an operand")
    while True:
        try:
            # Sleep a bit to let the welcome message and the result message reach the outputstream first
            time.sleep(0.1)
            x = input("Enter a first operand")
            if x == "exit":
                break
            elif x == "last":
                x = result
            else:
                x = float(x)
            inputed_operator = input(f"Enter an operator. Valid options are {list(ops.keys())}")
            if inputed_operator == "exit":
                break
            operation = ops[inputed_operator]
            y = input("Enter a second operand")
            if y == "exit":
                break
            elif y == "last":
                y = result
            else:
                y = float(y)
            result = operation(x, y)
            log.info(f"{x} {inputed_operator} {y} = {result}")
        except ValueError as e:
            log.debug(e)
            log.warning("Couldn't convert input to number")
        except KeyError as e:
            log.warning("Didn't recognize operator")
        except ZeroDivisionError:
            log.warning("Can't divide by zero")
        except NameError as e:
            log.warning("Calculator just started and doesn't have a last result")
        except Exception as e:
            log.exception("An unexpected exception happened. Stacktrace follows")
    log.info("Shutting down python calculator")
    close_log_handlers(log)

if __name__ == '__main__':
    main()






# Lösung von Chat-GPT:

import operator
import logging
import time

# Dictionary mit Operatoren und zugehörigen Funktionen
ops = {
    "+": operator.add,
    "-": operator.sub,
    "*": operator.mul,
    "**": operator.pow,
    "/": operator.truediv,
    "%": operator.mod,
}

## Setup Logger für Fehlerprotokollierung
# Ein Logger hilft uns, Fehler und Benutzeraktionen in einer Datei festzuhalten.
# Dies ist besonders nützlich, um zu verfolgen, welche Berechnungen und Fehler aufgetreten sind.

def setup_logger(log_file):
    # Erstellt einen Logger, der Daten in eine Datei schreibt
    logger = logging.getLogger("calculator")
    logger.setLevel(logging.DEBUG)
    handler = logging.FileHandler(log_file)
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    return logger

def close_log_handlers(logger):
    # Schließt alle Logger-Handler, um sicherzustellen, dass die Datei korrekt geschlossen wird
    for handler in logger.handlers:
        handler.close()
        logger.removeHandler(handler)
## Hauptfunktion `main()`
# Die Hauptfunktion des Rechners enthält die Benutzerinteraktion,
# das Einlesen der Operanden und des Operators und die Berechnung des Ergebnisses.
# Sie enthält ebenfalls die Fehlerbehandlung für verschiedene spezifische Ausnahmen.
def main():
    log = setup_logger("calculator.log")  # Protokollierung starten
    log.info("Willkommen beim einfachen Python-Rechner")
    log.info("Geben Sie 'exit' ein, um den Rechner zu beenden.")
    log.info("Geben Sie 'last' ein, um das letzte Ergebnis als Operand zu verwenden.")

    result = 0  # Initialer Wert für das Ergebnis

    while True:
        try:
            time.sleep(0.1)  # Kurze Pause, um Konsolenausgaben geordnet darzustellen

            # Ersten Operand einlesen
            x = input("Geben Sie den ersten Operanden ein: ")
            if x == "exit":
                break
            elif x == "last":
                x = result
            else:
                x = float(x)  # Konvertiere Eingabe zu Float für Berechnung

            # Operator einlesen
            inputed_operator = input(f"Geben Sie einen Operator ein (mögliche Optionen: {list(ops.keys())}): ")
            if inputed_operator == "exit":
                break
            operation = ops[inputed_operator]  # Hole die Operatorfunktion aus dem Dictionary

            # Zweiten Operand einlesen
            y = input("Geben Sie den zweiten Operanden ein: ")
            if y == "exit":
                break
            elif y == "last":
                y = result
            else:
                y = float(y)  # Konvertiere Eingabe zu Float für Berechnung

            # Berechnung ausführen
            result = operation(x, y)
            log.info(f"{x} {inputed_operator} {y} = {result}")  # Ergebnis protokollieren
            print(f"Ergebnis: {result}")

        except ValueError as e:
            log.warning("Konnte Eingabe nicht in eine Zahl umwandeln. Bitte erneut versuchen.")
        except KeyError:
            log.warning("Unbekannter Operator. Bitte einen gültigen Operator eingeben.")
        except ZeroDivisionError:
            log.warning("Teilung durch Null ist nicht erlaubt.")
        except NameError:
            log.warning("Kein vorheriges Ergebnis vorhanden. Starten Sie den Rechner zuerst.")
        except Exception as e:
            log.exception("Ein unerwarteter Fehler ist aufgetreten. Stacktrace folgt.")

    log.info("Rechner wird heruntergefahren.")
    close_log_handlers(log)

## Ausführung der Hauptfunktion
# Hier führen wir die `main()`-Funktion aus. Der Benutzer kann den Rechner verwenden,
# und alle Eingaben sowie Ausnahmen werden im Log protokolliert.

if __name__ == '__main__':
    main()

## Fehlerbehandlung und Protokollierung
# In diesem Abschnitt wird die Fehlerbehandlung erläutert:
# - `ValueError`: Wird abgefangen, wenn die Eingabe nicht in eine Zahl umgewandelt werden kann.
#       Eine Warnung wird protokolliert.
# - `KeyError`: Tritt auf, wenn der eingegebene Operator ungültig ist. Eine Warnung wird ausgegeben.
# - `ZeroDivisionError`: Dieser Fehler tritt auf, wenn eine Division durch Null versucht wird.
#       Der Rechner gibt eine Warnung aus und setzt die Berechnung fort.
# - `NameError`: Wird ausgelöst, wenn der Benutzer das Schlüsselwort "last" verwendet,
#       bevor ein Ergebnis gespeichert wurde. Eine Warnung wird ausgegeben.
# - `Exception`: Alle anderen, unerwarteten Fehler werden abgefangen,
#       und der vollständige Stacktrace wird im Log festgehalten.
# Durch diese Fehlerbehandlung kann der Rechner auch nach einem Fehler weiterarbeiten.

#
# In deinem Code gibt es zwei Dinge zu beachten: **Logging Level** und **Name des Logs** innerhalb des Try-Except-Blocks. Hier ist eine vereinfachte Erklärung für beide Aspekte sowie die allgemeine Verwendung und Bedeutung von Logging in Python.
#
# ### 1. Logging Level vs. Log Name im Code
#
# - **Logging Level**: Dies gibt die Wichtigkeit oder Dringlichkeit einer Log-Nachricht an. Die Levels reichen von **DEBUG** (niedrigste Wichtigkeit) bis **CRITICAL** (höchste Wichtigkeit). Diese Levels helfen dabei zu entscheiden, welche Nachrichten im Log auftauchen sollen, je nach dem Level, das gesetzt ist. Im Code oben sind die wichtigsten Logging Levels `debug`, `warning`, und `exception`.
#
# - **Name des Logs**: Innerhalb der `try-except`-Blöcke ist `log` einfach der Name des Loggers, den wir vorher mit `setup_logger` erstellt haben. Das Level der einzelnen Log-Nachrichten (`debug`, `warning`, `exception`) bestimmt, wie wichtig diese Nachrichten sind und ob sie abhängig vom eingestellten Level ausgegeben werden sollen.
#
# ### Logging Levels in deinem Code
#
# 1. **DEBUG (`log.debug(e)`)**:
#    - Wird verwendet, um sehr detaillierte Informationen zu protokollieren, die normalerweise nur zur Fehleranalyse notwendig sind.
#    - Im Code `log.debug(e)` wird der Fehler (z.B. ein `ValueError`) protokolliert, aber auf dem niedrigsten Level, sodass diese Nachricht nur auftaucht, wenn der Logger auf `DEBUG` eingestellt ist.
#
# 2. **WARNING (`log.warning(...)`)**:
#    - `WARNING` zeigt an, dass ein Problem aufgetreten ist, das nicht kritisch ist, aber möglicherweise eine unerwartete Situation darstellt.
#    - Im Code wird `warning` für Fehler verwendet, die man beheben kann und die das Programm nicht abstürzen lassen (z.B. unbekannter Operator oder Teilung durch Null). Diese Art von Meldungen taucht auf, selbst wenn der Logger nicht auf `DEBUG` gesetzt ist.
#
# 3. **EXCEPTION (`log.exception(...)`)**:
#    - `EXCEPTION` ist eine spezielle Form des `ERROR`-Levels, die bei unerwarteten Fehlern verwendet wird. Sie protokolliert den Fehler und gibt auch den Stacktrace an, was hilft, die genaue Ursache des Problems zu verstehen.
#    - Hier wird `log.exception("An unexpected exception happened. Stacktrace follows")` für unerwartete Fehler verwendet, sodass die gesamte Fehlermeldung und der Trace gespeichert werden, um später analysiert zu werden.
#
# ### Warum Logging verwenden und wie?
#
# Logging hilft dabei, wichtige Informationen über den Status und die Fehler deines Programms festzuhalten, ohne den Programmfluss zu unterbrechen, und gibt dir später nützliche Einblicke in das Verhalten des Programms. Es gibt verschiedene Levels, die abhängig von der Situation genutzt werden sollten:
#
# 1. **DEBUG**: Für detaillierte Informationen, die zur Diagnose oder Fehlersuche verwendet werden.
#    - Beispiel: Protokollierung von Variablenwerten oder Zwischenresultaten während der Entwicklung.
#
# 2. **INFO**: Für allgemeine Informationen über den Ablauf des Programms.
#    - Beispiel: `log.info("Calculator started")`, um zu dokumentieren, dass der Rechner gestartet wurde.
#
# 3. **WARNING**: Für unerwartete Ereignisse, die keinen unmittelbaren Fehler auslösen, aber auffällig sind.
#    - Beispiel: `log.warning("Invalid input detected")`, wenn der Benutzer etwas Falsches eingibt, das trotzdem verarbeitet werden kann.
#
# 4. **ERROR**: Für Fehler, die das Programmverhalten beeinträchtigen, aber nicht zum Absturz führen.
#    - Beispiel: `log.error("File not found")`, wenn eine notwendige Datei fehlt, aber das Programm trotzdem weiterlaufen kann.
#
# 5. **CRITICAL**: Für schwerwiegende Fehler, die normalerweise den Abbruch des Programms verursachen.
#    - Beispiel: `log.critical("System failure")`, wenn ein kritischer Fehler auftritt, der eine unmittelbare Reaktion erfordert.
#
# ### Wann welches Level verwenden?
#
# - **DEBUG**: Nutze es für alles, was du zur Fehleranalyse oder detaillierten Nachverfolgung brauchst. In der Produktion wird es oft deaktiviert.
# - **INFO**: Nutze es, um den normalen Verlauf zu dokumentieren, z.B. Programmstart oder wichtige Schritte.
# - **WARNING**: Nutze es, wenn etwas schiefgeht, aber das Programm ohne Anpassung weiterlaufen kann.
# - **ERROR**: Nutze es für Fehler, die das Programmverhalten beeinflussen, jedoch eine Fehlerbehandlung haben.
# - **CRITICAL**: Nutze es nur für Fehler, bei denen das Programm sofort gestoppt oder drastische Maßnahmen ergriffen werden müssen.
#
# Durch richtig eingesetztes Logging kannst du das Programmverhalten effizient überwachen und bei Problemen einfach diagnostizieren.