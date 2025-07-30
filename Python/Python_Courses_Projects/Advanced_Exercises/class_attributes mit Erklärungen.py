class Student:
    # Klassenvariable: Diese Variable gehört zur Klasse und wird von allen Instanzen geteilt.
    school_name = 'ABC School'

    # Konstruktor: Die Methode __init__ ist der Konstruktor, der für jede Instanz aufgerufen wird,
    # wenn die Klasse erstellt wird. Hier werden Instanzvariablen definiert.
    def __init__(self, name, age):
        # Instanzvariablen: Diese Variablen sind spezifisch für die jeweilige Instanz und nicht
        # zwischen Instanzen geteilt.
        self.name = name
        self.age = age


# Erstellen von Instanzen (Objekten) der Klasse Student
s1 = Student("Harry", 12)
s2 = Student("Jessa", 14)

# Zugriff auf die Klassenvariable über die Instanz
# Obwohl `school_name` eine Klassenvariable ist, kann sie auch über eine Instanz
# aufgerufen werden, und wird für alle Instanzen gleich sein, solange sie nicht überschrieben wird.
print(s1.school_name)  # Ausgabe: 'ABC School'
print(s2.school_name)  # Ausgabe: 'ABC School'

# Zugriff auf Instanzvariablen: Diese sind spezifisch für `s1`.
print('Student:', s1.name, s1.age)  # Ausgabe: 'Student: Harry 12'

# Zugriff auf die Klassenvariable direkt über die Klasse: Dies ist der empfohlene Weg,
# da es deutlicher macht, dass es sich um eine Klassenvariable handelt.
print('School name:', Student.school_name)  # Ausgabe: 'ABC School'

# Ändern von Instanzvariablen: Diese Änderung betrifft nur `s1`, nicht `s2`.
s1.name = 'Jessa'
s1.age = 14
print('Student:', s1.name, s1.age)  # Ausgabe: 'Student: Jessa 14'

# Ändern der Klassenvariable: Hier wird die Klassenvariable direkt über die Klasse
# geändert, wodurch alle Instanzen betroffen sind, die diese Variable nutzen.
Student.school_name = 'XYZ School'
print('School name:', Student.school_name)  # Ausgabe: 'XYZ School'
print(s1.school_name)  # Ausgabe: 'XYZ School', auch s1 nutzt die geänderte Klassenvariable
print(s2.school_name)  # Ausgabe: 'XYZ School', ebenso für s2

# Anmerkungen zur Vererbung:
# - Hätten wir eine Unterklasse, würde sie die Klassenvariablen und Methoden der Elternklasse erben.
# - Wenn eine Unterklasse dieselbe Methode oder Variable neu definiert, wird die Version der Elternklasse
#   überschrieben ("overridden").