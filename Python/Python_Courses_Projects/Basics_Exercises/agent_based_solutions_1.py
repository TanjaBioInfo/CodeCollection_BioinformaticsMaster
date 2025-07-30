from world_visualizer import WorldVisualizer
from agent_based import Agent, World
import numpy


##################################################
# A diagonal walking agent
##################################################
class DiagonalWalker(Agent):

    colorCode = 2

    def __init__(self, x, y, world):
        Agent.__init__(self, x, y, world)
        # Memorize the last move (1 = north, 0 = east)
        self.lastMove = 1

    def update(self):
        if self.lastMove == 1:
            self.moveEast()
            self.lastMove = 0
        else:
            self.moveNorth()
            self.lastMove = 1


# Place diagonal walking agent on lattice
T = 100
L = 40

world = World(L)                        # Create the world (lattice)
agent = DiagonalWalker(0, 10, world)    # Create a new DiagonalWalker object (agent)
world.addAgent(agent)                   # Place agent on the lattice
vs = WorldVisualizer()                  # Visualize the lattice

# Update agent position for T time steps
for i in range(0, T):

    vs.draw(world)
    world.update()

##################################################
# A Random walking agent
##################################################
class RandomWalker(Agent):

    def update(self):
        randomNumber = numpy.random.randint(0, 4)
        if randomNumber == 0:
            self.moveSouth()
        elif randomNumber == 1:
            self.moveNorth()
        elif randomNumber == 2:
            self.moveEast()
        elif randomNumber == 3:
            self.moveWest()

T = 100
L = 20

world = World(L)                            # Create the world (lattice
vs = WorldVisualizer()                      # Visualize the lattice

for i in range(0, 10):
    agent = RandomWalker(10, 10, world)     # Create a new RandomWalker object (agent)
    world.addAgent(agent)                   # Place agent on the lattice


# Update agent position for T time steps
for i in range(0, T):

    vs.draw(world)
    world.update()


##################################################
# Random walker vs. Diagonal Walker
##################################################

T = 200
L = 10

world = World(L)
randomWalkerAgent = RandomWalker(0, 9, world)
diagonalWalkerAgent = DiagonalWalker(5, 5, world)

world.addAgent(randomWalkerAgent)
world.addAgent(diagonalWalkerAgent)
vs = WorldVisualizer()

# Update agent position for T time steps
for i in range(0, T):

    vs.draw(world)
    world.update()

    # Check agents are at the same position
    if randomWalkerAgent.x == diagonalWalkerAgent.x and randomWalkerAgent.y == diagonalWalkerAgent.y:
        print ("Cached after " + str(i) + " steps")
        exit()

