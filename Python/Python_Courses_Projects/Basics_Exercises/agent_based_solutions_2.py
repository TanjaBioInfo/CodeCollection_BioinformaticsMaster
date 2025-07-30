#
# BIO 394 - Python Programming Lab
# Agent Based Simulations II
#

from agent_based import Agent, World
from world_visualizer import WorldVisualizer
import numpy
import matplotlib.pyplot as plt


class ThreeSpeciesWorld(World):
    """
    Extends the World class by some methods (e.g. remove agent) needed
    for a world of three competing species.
    """

    def getOtherAgentsOnSameField(self, agent):
        """
        Given an agent, the method returns a list of all  agents
        in the world that currently live on the same field as agent
        (same x and y coordinates). The agent give as parameter is not
        included in the list.

        :param agent:
        :return:
        """

        agentsAtLocation = []   # Will hold the other agents
        for otherAgent in self.agents:  # Loop through all agents

            if agent == otherAgent: # Skip if other agent is the same as agent
                continue

            if otherAgent.x == agent.x and otherAgent.y == agent.y:
                # Add other agent to list if at same coordinates
                agentsAtLocation.append(otherAgent)

        # Return list of agents at same filed
        return agentsAtLocation

    def removeAgent(self, agent):
        """
        Deletes the given agent from the agents list.
        :param agent:
        :return:
        """
        del self.agents[self.agents.index(agent)]

    def getSpeciesCount(self):
        """
        Counts the agent by species type.
        :return:
        """
        numA = 0
        numB = 0
        numC = 0
        for agent in self.agents:
            if agent.colorCode == 1:
                numA += 1

            if agent.colorCode == 2:
                numB += 1

            if agent.colorCode == 3:
                numC += 1

        return numA, numB, numC


class RandomWalker(Agent):

    def randomMove(self):
        """
        With equal probability move in one of the four
        directions (N, E, S, W)
        :return:
        """
        randomNumber = numpy.random.randint(0, 4)
        if randomNumber == 0:
            self.moveSouth()
        elif randomNumber == 1:
            self.moveNorth()
        elif randomNumber == 2:
            self.moveEast()
        elif randomNumber == 3:
            self.moveWest()

    def update(self):

        # Do a random move
        self.randomMove()

        # Find potential interaction partners
        otherAgents = self.world.getOtherAgentsOnSameField(self)

        # If there is one or more other agents on the same field
        if len(otherAgents) > 0:
            # Select random interaction partner (index of list)
            rand = numpy.random.randint(0, len(otherAgents))

            # Call interact method (the implementation of the class
            # of "self" will determine who survives)
            self.interact(otherAgents[rand])

    def die(self):
        """
        Lets the agent die by removing it from the agent list.

        :return:
        """
        self.world.removeAgent(self)

    def reproduce(self):
        pass

    def interact(self, otherAgent):
        pass

#
# For each species there is a sub class. All there sub classes extend
# the RandomWalker and implement the reproduce and interact method.
#
# reproduce(self) will result in a new agent of the same class (species) placed
# at the current position of the parent.
#
# interact(self, otherAgent) implements the interaction according to the rules:
#
# A beats B
# B beats C
# C beats A
#
# An agent that is beaten dies. An agent that beats another one reproduces.
#
class A(RandomWalker):

    colorCode = 1

    def reproduce(self):
        self.world.addAgent(A(self.x, self.y, self.world))

    def interact(self, otherAgent):

        if otherAgent.colorCode == B.colorCode:
            otherAgent.die()
            self.reproduce()

        if otherAgent.colorCode == C.colorCode:
            otherAgent.reproduce()
            self.die()


class B(RandomWalker):

    colorCode = 2

    def reproduce(self):
        self.world.addAgent(B(self.x, self.y, self.world))

    def interact(self, otherAgent):

        if otherAgent.colorCode == C.colorCode:
            otherAgent.die()
            self.reproduce()

        if otherAgent.colorCode == A.colorCode:
            otherAgent.reproduce()
            self.die()


class C(RandomWalker):

    colorCode = 3

    def reproduce(self):
        self.world.addAgent(C(self.x, self.y, self.world))

    def interact(self, otherAgent):

        if otherAgent.colorCode == A.colorCode:
            otherAgent.die()
            self.reproduce()

        if otherAgent.colorCode == B.colorCode:
            otherAgent.reproduce()
            self.die()


# Create the world
L = 30
# Number of agents per species
N = 20
world = ThreeSpeciesWorld(L)

# Number of time steps to simulate
T = range(0, 70000)

# Lists to store the number of agents per species
A_t = []
B_t = []
C_t = []

# Add N agents per species at random location
for i in range(0, N):
    x = numpy.random.randint(0, world.L, 3)
    y = numpy.random.randint(0, world.L, 3)
    world.addAgent(A(x[0], y[0], world))
    world.addAgent(C(x[1], y[1], world))
    world.addAgent(B(x[2], y[2], world))


#
# Uncomment the following line to visualize the world.
# Note: Makes the simulation slow
#
vs = WorldVisualizer()

# Run simulation
for t in T:

    # Update the world
    world.update()

    # Redraws the world ever 500 iterations
    if t % 500 == 0:
        pass
        # Uncomment to update the visual representation of the world
        vs.draw(world)

    # Get the number of agents per species and store it in corresponding list
    numA, numB, numC = world.getSpeciesCount()

    A_t.append(numA)
    B_t.append(numB)
    C_t.append(numC)


# Plot the number of agents over time
plt.ioff()
fig, ax = plt.subplots(nrows=1, ncols=1, sharex=False, sharey=False, squeeze=False)
sA = ax[0,0].plot(T, A_t, "-b", label='Species A')
sB = ax[0,0].plot(T, B_t, "-r", label='Species B')
sC = ax[0,0].plot(T, C_t, "-g", label='Species C')
ax[0,0].legend()
ax[0,0].set_ylim((0, max(max(A_t), max(B_t))+20))
plt.show()


