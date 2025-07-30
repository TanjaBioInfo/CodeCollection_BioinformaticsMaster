# Class, Exercises, and Solutions mit Erklärungen

"""
Dieses Dokument enthält eine Reihe von Übungen zu Klassen und Objekten in Python,
sowie die Lösungen mit umfassenden Erklärungen, um die Funktionalität und die
Reihenfolge der Ausführung zu verdeutlichen.
"""

# Exercise 1: Vehicle-Klasse mit Attributen max_speed und mileage
# --------------------------------------------------------------
"""
In dieser Übung wird eine `Vehicle`-Klasse erstellt, die zwei Instanzattribute `max_speed` 
und `mileage` besitzt. Nach der Instanzierung wird auf diese Attribute zugegriffen und 
ihre Werte ausgegeben.
"""

class Vehicle:
    # Konstruktor: Initialisiert die Instanz mit max_speed und mileage.
    def __init__(self, max_speed, mileage):
        self.max_speed = max_speed
        self.mileage = mileage

# Erstellen einer Instanz und Ausgabe der Attribute
modelX = Vehicle(240, 18)
print(modelX.max_speed, modelX.mileage)
# Output: 240 18


# Exercise 2: Vehicle-Klasse ohne Attribute und Methoden
# -----------------------------------------------------
"""
Hier wird eine leere `Vehicle`-Klasse erstellt. Solche leeren Klassen können als 
Basisklassen dienen, die später erweitert werden.
"""

class Vehicle:
    pass


# Exercise 3: Erstellen einer Bus-Kindklasse, die von Vehicle erbt
# ---------------------------------------------------------------
"""
In dieser Übung erbt die `Bus`-Klasse von der `Vehicle`-Basisklasse. Zusätzlich wird die 
`__str__`-Methode überschrieben, um eine lesbare Darstellung der Fahrzeugattribute zu bieten.
"""

class Vehicle:
    def __init__(self, name, max_speed, mileage):
        self.name = name
        self.max_speed = max_speed
        self.mileage = mileage

    def __str__(self):
        return f"Name: {self.name}, Max speed: {self.max_speed}, Mileage: {self.mileage}"

class Bus(Vehicle):
    pass

# Erstellen eines Bus-Objekts und Ausgabe mit der __str__ Methode
school_bus = Bus("School Volvo", 180, 12)
print(school_bus)
# Expected Output: Name: School Volvo, Max speed: 180, Mileage: 12


# Exercise 4: Überschreiben der seating_capacity Methode in der Bus-Klasse
# ----------------------------------------------------------------------
"""
Die `seating_capacity`-Methode wird hier in der `Bus`-Klasse überschrieben, um eine
Standardkapazität von 50 Passagieren festzulegen, falls kein anderes Argument übergeben wird.
"""

class Vehicle:
    def __init__(self, name, max_speed, mileage):
        self.name = name
        self.max_speed = max_speed
        self.mileage = mileage

    def seating_capacity(self, capacity):
        return f"The seating capacity of a {self.name} is {capacity} passengers"

class Bus(Vehicle):
    def seating_capacity(self, capacity=50):
        return super().seating_capacity(capacity)

school_bus = Bus("School Volvo", 180, 12)
print(school_bus.seating_capacity())
# Expected Output: The seating capacity of a School Volvo is 50 passengers


# Exercise 4.1: Spezifische Sitzplatzkapazität als Instanzattribut für Bus
# -----------------------------------------------------------------------
"""
Hier wird `seating_capacity` als spezifisches Attribut der `Bus`-Instanz festgelegt. 
Die `seating_capacity` Methode benötigt kein Argument mehr und verwendet das Attribut direkt.
"""

class Bus(Vehicle):
    def __init__(self, name, max_speed, mileage, seating_capacity=50):
        super().__init__(name, max_speed, mileage)
        self.seating_capacity = seating_capacity

    def seating_capacity(self):
        return f"The seating capacity of a {self.name} is {self.seating_capacity} passengers"

school_bus = Bus("School Volvo", 180, 12)
print(school_bus.seating_capacity())
# Expected Output: The seating capacity of a School Volvo is 50 passengers


# Exercise 5: Klassenattribut "color" für alle Instanzen
# ------------------------------------------------------
"""
Ein Klassenattribut `color` wird in der Basisklasse `Vehicle` festgelegt, das von allen Instanzen
und abgeleiteten Klassen geteilt wird. Jede Instanz von `Vehicle`, `Bus`, und `Car` hat die
Farbe "White".
"""

class Vehicle:
    color = "White"  # Klassenattribut für die Standardfarbe

    def __init__(self, name, max_speed, mileage):
        self.name = name
        self.max_speed = max_speed
        self.mileage = mileage

    def __str__(self):
        return f"Color: {self.color}, Vehicle name: {self.name}, Speed: {self.max_speed}, Mileage: {self.mileage}"

class Bus(Vehicle):
    pass

class Car(Vehicle):
    pass

# Erstellen und Ausgabe von Instanzen
bus = Bus("School Volvo", 180, 12)
car = Car("Audi Q5", 240, 18)
print(bus)  # Expected Output: Color: White, Vehicle name: School Volvo, Speed: 180, Mileage: 12
print(car)  # Expected Output: Color: White, Vehicle name: Audi Q5, Speed: 240, Mileage: 18


# Exercise 6: Berechnung der Fahrkosten für Bus mit Wartungsaufschlag
# --------------------------------------------------------------------
"""
Die `fare` Methode wird in der `Bus`-Klasse überschrieben. Wenn das Fahrzeug ein Bus ist, wird 
ein 10%-iger Wartungsaufschlag auf die Fahrkosten hinzugefügt. Die Kapazität beträgt standardmäßig 
50, sodass die endgültigen Fahrkosten 5500 sein sollten.
"""

class Vehicle:
    def __init__(self, name, mileage, capacity):
        self.name = name
        self.mileage = mileage
        self.capacity = capacity

    def fare(self):
        return self.capacity * 100

class Bus(Vehicle):
    def fare(self):
        # Zusätzlicher Wartungsaufschlag von 10%
        amount = super().fare() * 1.1
        return amount

School_bus = Bus("School Volvo", 12, 50)
print("Total Bus fare is:", School_bus.fare())
# Expected Output: Total Bus fare is: 5500.0
