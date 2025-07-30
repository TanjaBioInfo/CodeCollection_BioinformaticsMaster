# 1.  Write a small program where the user can enter a
# name and phone number until
# they enter "exit". Save the data in a dictionary and save it to
# a file using both
# the json and pickle module, use a variable to decide what library
# should do the serialization.
# Inspect the files afterwards.
# Let the user chose a mode at start of the program if they want to
# input data or
# search for phone numbers by name.
# 2.  Catch exceptions like searching for a name that is not in the
# phonebook
# 3.  (optional) Modify your program to use an object oriented
# approach for the data structure.
# Instead of using a dict to save your data use classes
# Example classes could be contact, name, phone number.
# Think of what attributes these classes might have

import json  # JSON-Modul zum Speichern von Daten in JSON-Format
import pickle  # Pickle-Modul zum Speichern von Daten im Binärformat


def main():
    # Definiere das Standard-Serialisierungsformat
    serializer_name = "json"  # Kann entweder "json" oder "pickle" sein
    # serializer_name = "pickle"  # Optional: Ändern Sie dies zu "pickle", um das Pickle-Modul zu verwenden

    # Wähle den Serializer und Dateimodus basierend auf serializer_name
    if serializer_name == "json":
        serializer = json  # Verwenden des JSON-Moduls für die Serialisierung
        file_mode_addition = ""  # Textmodus (Standard für JSON-Dateien)
    elif serializer_name == "pickle":
        serializer = pickle  # Verwenden des Pickle-Moduls für die Serialisierung
        file_mode_addition = "b"  # Binärmodus (erforderlich für Pickle-Dateien)
    else:
        # Fehlermeldung und Programm beenden, falls ein unbekannter Serializer gewählt wurde
        print("Selected unknown serializer. Exiting")
        return

    # Benutzer wählen, ob er Daten eingeben oder nach Telefonnummern suchen möchte
    mode = input("Enter 's' search mode and 'i' for input mode")

    if mode == "s":
        # Suchmodus: Lade vorhandenes Adressbuch und ermögliche Namenssuche
        # (Hinweis: Dateiendung bleibt .json, auch wenn Pickle verwendet wird, für einfaches Umschalten)
        with open(f"address_book.{serializer_name}", "r" + file_mode_addition) as file:
            address_book_dict = serializer.load(file)  # Lade das Adressbuch aus der Datei

        while True:
            name = input("Input name")  # Nach einem Namen fragen
            if name == "exit":
                break  # Programm beenden, wenn "exit" eingegeben wird
            try:
                # Ausgabe der Telefonnummer, wenn der Name im Adressbuch gefunden wird
                print(address_book_dict[name])
            except KeyError:
                # Falls der Name nicht existiert, wird eine Fehlermeldung ausgegeben
                print(f"The user {name} doesn't exist")

    elif mode == "i":
        # Eingabemodus: Benutzer können Namen und Telefonnummern eingeben
        name_number = {}  # Dictionary für Namen und Telefonnummern

        while True:
            name = input("Input name")  # Name eingeben
            if name == "exit":
                break  # Programm beenden, wenn "exit" eingegeben wird
            number = input("Input phone number")  # Telefonnummer eingeben
            name_number[name] = number  # Name und Nummer zum Dictionary hinzufügen

        # Speichere das Adressbuch in die Datei
        with open(f"address_book.{serializer_name}", "w" + file_mode_addition) as file:
            serializer.dump(name_number, file)  # Speichere das Dictionary im gewählten Format
        print(name_number)  # Zeigt das gespeicherte Adressbuch an

    else:
        # Fehlermeldung bei ungültiger Moduswahl
        print("Invalid mode selected, closing application")


# Hauptprogrammaufruf
if __name__ == '__main__':
    main()

