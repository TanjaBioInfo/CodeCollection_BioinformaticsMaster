#
# BIO 394 - Python Programming Lab
# Object oriented programming
 

class Dog(object):
    
    def __init__(self, name, weight):
        # Pass weight as a second parameter to the constructor.
        self.weight = weight
        self.name = name

    def bark_name(self):
        print("Wuff ..I'm " + self.name)
    
    def bark_weight(self):
        # This method makes the dog print his weight.
        print("Wuff .. My weight is" + str(self.weight) + " kg")
    
    def eat(self, other_dog):
        if self.weight > other_dog.weight:
            print(self.name + " eats " + other_dog.weight)
        else:
            print(other_dog.name + " eats " + self.name)
      
    
# Create two dogs.
pluto = Dog("Pluto", 22)
lassie = Dog("Lassie", 84)

# 1) Let dogs bark their names.
pluto.bark_weight()
lassie.bark_weight()

# 2) One dog eats the other.
pluto.eat(lassie)

# 3) DogHouse class

class DogHouse(object):
    
    def __init__(self):
        # A list that will hold all dogs in the house.
        self.dogs = []
    
    def add_dog(self, dog):
        # Adds a dog to the house.
        self.dogs.append(dog)

    def bark_all(self):
        # Lets all dogs in the house bark their names.
        for dog in self.dogs:
            dog.bark_name()
    
# Create a dog house.
dog_house = DogHouse()

# Add lassie and pluto to the house.
dog_house.add_dog(lassie)
dog_house.add_dog(pluto)

# Add some ohter dogs.
dog_house.add_dog(Dog("Max", 22))
dog_house.add_dog(Dog("Buddy", 22))
dog_house.add_dog(Dog("Rocky", 22))

# Let all dogs bark their name.
dog_house.bark_all()
