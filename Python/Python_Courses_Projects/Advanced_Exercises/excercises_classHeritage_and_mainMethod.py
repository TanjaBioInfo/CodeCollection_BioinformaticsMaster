# 1: Create a Vehicle class with max_speed and mileage instance attributes, create an object and print their attributes

class Vehicle:
    # Klassenvariable: Diese Variable gehört zur Klasse und wird von allen Instanzen geteilt.
    vehicle_name = 'Vehicle'

    # Konstruktor: Die Methode __init__ ist der Konstruktor, der für jede Instanz aufgerufen wird,
    # wenn die Klasse erstellt wird. Hier werden Instanzvariablen definiert.
    def __init__(self, max_speed, mileage):
        # Instanzvariablen: Diese Variablen sind spezifisch für die jeweilige Instanz und nicht
        # zwischen Instanzen geteilt.
        self.max_speed = max_speed
        self.mileage = mileage


# Erstellen von Instanzen (Objekten) der Klasse vehicle
bus1 = Vehicle(240, 18)
print(bus1.max_speed, bus1.mileage)






# 2: Create a Vehicle class without any variables and methods
# Basisklasse: `Vehicle`
class Vehicle:
    vehicle_name = 'Vehicle'
    # Methode vehicle_info(): Diese Methode gibt an, dass sie zur Vehicle-Klasse gehört.
    # Da `Vehicle` die Basisklasse ist, wird diese Methode von allen Unterklassen (wie `Car`) vererbt.
    def vehicle_info(self):
        print('Inside Vehicle class')






# 3: Create a child class Bus that will inherit all of the variables and methods of the Vehicle class
# Implement __str__ to print all attributes of the vehicle
# Given
# Basisklasse `Vehicle`
class Vehicle:
    # Konstruktor, der die Attribute name, max_speed und mileage initialisiert
    def __init__(self, name, max_speed, mileage):
        self.name = name
        self.max_speed = max_speed
        self.mileage = mileage

    # Methode zur Bestimmung der Sitzplatzkapazität
    def seating_capacity(self, capacity):
        return f"The seating capacity of a {self.name} is {capacity} passengers"


# Kindklasse `Bus`, die von `Vehicle` erbt
class Bus(Vehicle):
    # Überschreiben der __str__ Methode, um eine lesbare Darstellung der Attribute zu geben
    def __str__(self):
        # Ausgabe der Attribute name, max_speed und mileage
        return f"Vehicle Name: {self.name} Speed: {self.max_speed} Mileage: {self.mileage}"

# Erstellen eines Bus-Objekts
bus = Bus("School Volvo", 180, 12)

# Ausgabe des Objekts, wobei die __str__ Methode aufgerufen wird
print(bus)

# Expected Output:
# Vehicle Name: School Volvo Speed: 180 Mileage: 12





# 4: Create a Bus class that inherits from the Vehicle class. Give the capacity argument of Bus.seating_capacity() a default value of 50.
# You need to use method overriding.
# Given
# Basisklasse `Vehicle`
class Vehicle:

    def __init__(self, name, max_speed, mileage):
        self.name = name
        self.max_speed = max_speed
        self.mileage = mileage

    # Methode seating_capacity, die die Sitzplatzkapazität zurückgibt
    def seating_capacity(self, capacity):
        return f"The seating capacity of a {self.name} is {capacity} passengers"


# Kindklasse `Bus`, die von `Vehicle` erbt und die seating_capacity-Methode überschreibt
class Bus(Vehicle):

    # Methode seating_capacity mit einem Standardwert für capacity
    def seating_capacity(self, capacity=50):
        return f"The seating capacity of a {self.name} is {capacity} passengers"


# Erstellen eines Bus-Objekts und Aufrufen der seating_capacity-Methode
bus = Bus("School Volvo", 180, 12)
print(bus.seating_capacity())

# Expected Output:
# The seating capacity of a bus is 50 passengers


# 4.1 Make the seating capacity a child specific instance attribute and modify the child seating_capacity method
# to take no argument, but to take the instance attribute
# Kindklasse `Bus`, die von `Vehicle` erbt
class Bus(Vehicle):

    # Konstruktor, der das Attribut seating_capacity spezifisch für die Bus-Klasse festlegt
    def __init__(self, name, max_speed, mileage, seating_capacity=50):
        # Aufruf des Konstruktors der Basisklasse
        super().__init__(name, max_speed, mileage)
        # Festlegen des spezifischen Attributs seating_capacity für die Bus-Instanz
        self.seating_capacity = seating_capacity

    # Methode seating_capacity ohne Argumente, die das spezifische Instanzattribut seating_capacity verwendet
    def seating_capacity(self):
        return f"The seating capacity of a {self.name} is {self.seating_capacity} passengers"

# Erstellen eines Bus-Objekts
bus = Bus("School Volvo", 180, 12)

# Ausgabe der Sitzplatzkapazität, wobei das spezifische Attribut verwendet wird
print(bus.seating_capacity())

# Der Fehler TypeError: 'int' object is not callable tritt auf,
# weil in deinem Code die Methode seating_capacity versehentlich als
# Instanzattribut überschrieben wurde. Das passiert, wenn seating_capacity
# sowohl als Methode als auch als Attribut in der gleichen Klasse definiert ist.




# 5: Define property that should have the same value for every class instance
# Define a class attribute ”color” with a default value white. I.e., Every Vehicle and every Car should be white.
# Given
class Vehicle:

    def __init__(self, name, max_speed, mileage):
        self.name = name
        self.max_speed = max_speed
        self.mileage = mileage


class Bus(Vehicle):
    pass


class Car(Vehicle):
    pass

# Basisklasse `Vehicle`
class Vehicle:
    color = "White"  # Klassenattribut, das für alle Instanzen der Klassen Vehicle, Bus und Car gilt

    def __init__(self, name, max_speed, mileage):
        self.name = name
        self.max_speed = max_speed
        self.mileage = mileage

    # Methode seating_capacity in der Basisklasse
    def seating_capacity(self, capacity):
        return f"The seating capacity of a {self.name} is {capacity} passengers"


# Kindklasse `Bus`, die von `Vehicle` erbt
class Bus(Vehicle):
    def __init__(self, name, max_speed, mileage, capacity=50):
        super().__init__(name, max_speed, mileage)
        self.capacity = capacity  # Spezifisches Attribut für Bus

    # Überschreibt die Methode seating_capacity, um den Standardwert 50 zu verwenden
    def seating_capacity(self):
        return f"The seating capacity of a {self.name} is {self.capacity} passengers"


# Kindklasse `Car`, die von `Vehicle` erbt
class Car(Vehicle):
    pass


# Erstellen eines `Bus`-Objekts
bus = Bus("School Volvo", 180, 12)
# Erstellen eines `Car`-Objekts
car = Car("Audi Q5", 240, 18)

# Ausgabe der Attribute des Bus-Objekts
print(f"Color: {bus.color}, Vehicle name: {bus.name}, Speed: {bus.max_speed}, Mileage: {bus.mileage}")
print(bus.seating_capacity())

# Ausgabe der Attribute des Car-Objekts
print(f"Color: {car.color}, Vehicle name: {car.name}, Speed: {car.max_speed}, Mileage: {car.mileage}")

# Expected Output:
# Color: White, Vehicle name: School Volvo, Speed: 180, Mileage: 12
# Color: White, Vehicle name: Audi Q5, Speed: 240, Mileage: 18






# 6: Create a Bus child class that inherits from the Vehicle class. The default fare charge of any vehicle is seating capacity * 100.
# If Vehicle is Bus instance, we need to add an extra 10% on full fare as a maintenance charge.
# So total fare for bus instance will become the final amount = total fare + 10% of the total fare.
# Note: The bus seating capacity is 50. so the final fare amount should be 5500. You need to override the fare() method of a Vehicle class in Bus class.
# Given
class Vehicle:
    def __init__(self, name, mileage, capacity):
        self.name = name
        self.mileage = mileage
        self.capacity = capacity

    def fare(self):
        return self.capacity * 100


class Bus(Vehicle):
    pass


School_bus = Bus("School Volvo", 12, 50)
print("Total Bus fare is:", School_bus.fare())

# Expected Output
# Total Bus fare is: 5500.0
