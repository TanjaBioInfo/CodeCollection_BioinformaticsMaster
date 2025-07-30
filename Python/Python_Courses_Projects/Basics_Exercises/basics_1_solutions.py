#
# BIO 394 - Python Programming Lab
# Basics 1
#


# 1. Write a program that prints all integer numbers from 0 to 30 using a for loop.

print('\nExercice 1\n')

for i in range(0, 30):
    print(i)


# 2. Use a while loop to print all substrings of length 3 of the string 'GGGAAGGTC'.

print('\nExercice 2\n')

s = 'GGGAAGGTC'
i = 0
while i<len(s)-2:
    print(s[i:i + 3])
    i += 1


# 3. Extend the program from 2) to only print the substrings that start with a ’G’.

print('\nExercice 3\n')

s = 'GGGAAGGTC'
i = 0
while i < len(s) - 2:
    if s[i:i + 3][0] == 'G':
        print(s[i:i + 3])
    i += 1


# Write a program that prints the first n Fibonacci numbers. The n-th Fibonacci number is defined
# by the recurrence relation Fn = Fn−1 + Fn−2 , with seed values F0 = 0 and F1 = 1.

print('\nExercice 4\n')

n = 6
F_n1 = 0
F_n2 = 1

print(F_n1)

for i in range(1, n + 1):
    print(F_n2)
    temp = F_n1 + F_n2
    F_n1 = F_n2
    F_n2 = temp
