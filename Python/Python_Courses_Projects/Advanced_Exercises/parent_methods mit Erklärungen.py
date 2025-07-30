class Parent:
    # Methode foo() in der Elternklasse: Diese Methode wird vererbt und ist in allen Instanzen
    # von Parent und seinen Unterklassen verfügbar, sofern sie nicht überschrieben wird.
    def foo(self):
        return "foo"

    # Methode name() in der Elternklasse: Auch diese Methode wird vererbt, aber sie wird in der
    # Unterklasse `Child` überschrieben, sodass `Child` seine eigene Version dieser Methode hat.
    def name(self):
        return "Parent"


# Die Klasse Child erbt von Parent. Sie erbt alle Methoden und Attribute von Parent,
# außer wenn sie in Child neu definiert werden.
class Child(Parent):

    # Konstruktor __init__: Initialisiert die Instanzvariablen `a` und `b` speziell für `Child`.
    # Der Konstruktor von `Parent` wird hier nicht aufgerufen, weil `Parent` keinen eigenen Konstruktor hat.
    def __init__(self, a, b):
        self.a = a
        self.b = b

    # Methode name(): Diese Methode überschreibt die `name()`-Methode von Parent.
    # Wenn `name()` auf einer `Child`-Instanz aufgerufen wird, wird die hier definierte Methode verwendet.
    def name(self):
        return "Child"

    # Methode parent_name(): Hier wird `super()` genutzt, um auf die `name()`-Methode der Elternklasse
    # zuzugreifen, auch wenn sie in `Child` überschrieben wurde. `super()` ruft die `name()`-Methode
    # von `Parent` auf.
    def parent_name(self):
        return super().name()

    # Methode __str__: Diese Methode gibt eine lesbare Darstellung der Instanz zurück,
    # die ausgegeben wird, wenn `print(c)` aufgerufen wird.
    def __str__(self):
        return f"a: {self.a}, b: {self.b}"


# Erstellen einer Instanz von Child und Initialisieren der Variablen `a` und `b`
c = Child(42, "Hallo world")

# Aufruf von foo(): Da `foo()` nur in Parent definiert ist und nicht in Child überschrieben wurde,
# kann sie direkt von `c` genutzt werden.
print(c.foo())  # Ausgabe: 'foo'

# Aufruf von name(): Da `name()` in Child überschrieben wurde, wird die `name()`-Methode von Child genutzt.
print(c.name())  # Ausgabe: 'Child'

# Aufruf von parent_name(): Diese Methode nutzt `super()` und ruft daher die `name()`-Methode
# der Elternklasse Parent auf, obwohl sie in Child überschrieben wurde.
print(c.parent_name())  # Ausgabe: 'Parent'

# Ausgabe der Instanz c: Dank der __str__()-Methode gibt `print(c)` eine benutzerdefinierte
# Darstellung der Instanz zurück.
print(c)  # Ausgabe: 'a: 42, b: Hallo world'
