# Dieser Code zeigt, wie man Vererbung verwendet,
# um eine Basisklasse (Vehicle) zu erweitern und
# zusätzliche Funktionalität in einer abgeleiteten Klasse (Bus)
# hinzuzufügen.

# Die Klasse Vehicle ist eine Basisklasse,
# die ein Fahrzeug mit zwei Attributen, name und color,
# definiert.
# Der Konstruktor __init__ wird verwendet,
# um die Attribute beim Erstellen eines Vehicle-Objekts zu initialisieren.

class Vehicle:
    def __init__(self, name, color):
        self.name = name  # Initialisiert den Namen des Fahrzeugs
        self.color = color  # Initialisiert die Farbe des Fahrzeugs



# Die Klasse Bus erbt von der Basisklasse Vehicle und erweitert
# diese um ein zusätzliches Attribut seats,
# das die Anzahl der Sitze speichert.
# super().__init__(name, color) ruft den Konstruktor
# der Vehicle-Klasse auf, um die Attribute name und color
# zu initialisieren.
# self.seats = seats fügt das spezifische Attribut seats zur
# Klasse Bus hinzu.

class Bus(Vehicle):
    def __init__(self, name, color, seats):
        super().__init__(name, color)  # Ruft den Konstruktor der Basisklasse `Vehicle` auf,
        # ohne dass die child class den parent überschreiben kann, was sonst der Fall ist
        # (zuerst wird child ausgeführt, und wenn man es im child nicht findet wird parent ausgeführt),
        # aber mit super() wird von anfang an parent ausgeführt.
        self.seats = seats  # Initialisiert die Anzahl der Sitze im Bus



# Ein Objekt b der Klasse Bus wird erstellt.
# Es bekommt den Namen "Kirby", die Farbe "blue" und 50 Sitzplätze.
# print(b.name, b.color, b.seats) gibt die Attribute name,
# color und seats des Bus-Objekts aus. Die Ausgabe wäre:
# Kirby blue 50.

b = Bus("Kirby", "blue", 50)  # Erzeugt ein Bus-Objekt mit Name "Kirby",
# Farbe "blue" und 50 Sitzen
print(b.name, b.color, b.seats)  # Gibt die Attribute des Bus-Objekts aus
