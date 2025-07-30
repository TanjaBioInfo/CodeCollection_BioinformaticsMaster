# Basisklasse: `Vehicle`
class Vehicle:
    # Methode vehicle_info(): Diese Methode gibt an, dass sie zur Vehicle-Klasse gehört.
    # Da `Vehicle` die Basisklasse ist, wird diese Methode von allen Unterklassen (wie `Car`) vererbt.
    def vehicle_info(self):
        print('Inside Vehicle class')


# Kindklasse: `Car` erbt von `Vehicle`
class Car(Vehicle):
    # Methode car_info(): Diese Methode ist spezifisch für `Car` und gehört nicht zur Basisklasse `Vehicle`.
    # Das bedeutet, dass sie nur in Instanzen von `Car` und nicht in `Vehicle` verfügbar ist.
    def car_info(self):
        print('Inside Car class')


# Erstellen eines Objekts von Car: `car` ist eine Instanz der Klasse `Car`.
car = Car()

# Zugriff auf die vehicle_info()-Methode von Vehicle über das `car`-Objekt:
# Da `Car` die Methode `vehicle_info()` von `Vehicle` erbt, kann `car` sie aufrufen.
car.vehicle_info()  # Ausgabe: 'Inside Vehicle class'

# Zugriff auf die car_info()-Methode von Car über das `car`-Objekt:
# Dies ist eine Methode, die nur in `Car` definiert ist.
car.car_info()  # Ausgabe: 'Inside Car class'

# Ausgabe des Typs von `car`: `type()` zeigt, dass `car` ein `Car`-Objekt ist.
print(type(car))  # Ausgabe: <class '__main__.Car'>

# Erstellen eines Objekts von Vehicle: `v` ist eine Instanz der Klasse `Vehicle`.
v = Vehicle()

# Ausgabe des Typs von `v`: `type()` zeigt, dass `v` ein `Vehicle`-Objekt ist.
print(type(v))  # Ausgabe: <class '__main__.Vehicle'>
