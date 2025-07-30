#
# BIO 394 - Python Programming Lab
# Basics 2
#
# 1. Write a script that sorts a list of integer numbers in ascending order.
#
# The script sorts a list of 'n' integer numbers in ascending order. The algorithm uses
# the so-called 'Selection Sort' algorithm. There are many algorithms available to sort 
# lists. Selection Sort is not particularly efficient [O(n^2)] but a good example to get 
# used to the concept of lists.
# Have a look at the following website, where other (also more efficient) algorithms
# are described:
# https://betterexplained.com/articles/sorting-algorithms/
# 
# Selection Sort works as following:
# 
# (1) Set currentIndex = 0.
# 
# (2) Find in the list the smallest element between currentIndex
#     and the end of the list (excluding currentIndex).
# 
# (3. If the smallest element is samaller than the element at
#     currentIndex, swap the two elements.
# 
# (4) Increment currentIndex by 1.
# 
# (5) If currentIndex = len(list)-1 its done.
#     Otherwise proceed with (1).

import numpy as np

# Create a list of n random integers between 0 and m to test the algorithm.
n = 10
m = 40
toSort = np.random.randint(0, m, n)


currentIndex = 0    # Keeps track of the current position.
                    # This variable is the index of the element that needs to
                    # be swapped with the smallest element from the list.

while currentIndex < len(toSort):

    # Find the smallest element between currentIndex and n-1
    # Initialize the variable
    smallestElement = None

    for i in range(currentIndex, len(toSort)):

        # If the element at index i is smaller than 'smallestElement'
        # or 'smallestElement' is not yet set, remember the index and the
        # value of the smallest element.

        if smallestElement is None or toSort[i] < smallestElement:
            smallestElement = toSort[i]
            indexSmallestElemet = i

    # Switch smallest element with the element at 'currentIndex'
    tmp = toSort[indexSmallestElemet]
    toSort[indexSmallestElemet] = toSort[currentIndex]
    toSort[currentIndex] = tmp

    # Now all elements between 0 and currentIndex are sorted.
    # Increment currentIndex and proceed as long it is smaller than n
    currentIndex += 1

print(toSort)
