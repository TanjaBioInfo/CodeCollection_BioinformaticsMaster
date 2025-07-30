#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Aug  1 14:06:03 2021

@author: TR
"""

### NP.RANDINT AND CALCULATIONS AND COMBINATIONS

#####################################################################################################################################################
# Liste aller Basentriplets sortiert ausdrucken, so dass eine Base zweimal aber nicht dreimal vorkommt. Zusätzlich das zweite Item der Liste ausdrucken.
bases=["T", "C", "G", "A"]
codon=[]
for b1 in bases:
    for b2 in bases:
        for b3 in bases:
            if b1==b2 or b2==b3 or b3==b1: # Reihenfolge egal, auch bez. untere Zeile
                if not (b1==b2 and b2==b3):  # nur if not(...) funktioniert, Klammern wichtig!, if(!= ...)geht nicht
                    codon.append(b1+b2+b3)  # merken: concatenation of a string --> +
codon=sorted(codon)
print(codon)
print(codon[1])
#####################################################################################################################################################
# factorial
def factorial(n):
    num=1
#   for i in range(1,n+1):
    for i in range(n):
        num*=n
        n=n-1
    return num
n=19
print(factorial(n))
# oder
n=19
def factorial(n):
    zahl=1
    for i in range(1,n+1):
        zahl*=i
    return zahl
print(factorial(n))
# oder
n=19
def factorial(n):
    fact=1
    for i in range(n, 0, -1):
        fact*=i
    return fact
print(factorial(n))
#####################################################################################################################################################
#  Zahlenfolgen von *4 +3
n = 4
for i in range(0, 3*n, 3):
    print(i, i+4)
# weniger elegant:
n=4
for zahl1 in range(n):
    zahl1*=3
    zahl2=zahl1+4
    print(zahl1, zahl2)
#####################################################################################################################################################
#  Zinsersparnis
years=12
Start=5000
Zinsfuss=0.02
Gewinn=1+Zinsfuss
for i in range (1, years+1):
    Start*=Gewinn
print(Start)
# Kurzversion:
n = 12
saving = 5000
for i in range(n):
    saving*=1.02
print(saving)   
#####################################################################################################################################################
#  Wie oft erschein eine bestimmte Zufallszahl
import numpy.random as rd
rd.seed(0)
rounds=300
occ=0
for round in range(rounds):
    number=rd.randint(1,16)
    if number==4:
        occ+=1
print(occ)
#####################################################################################################################################################
#  mögliche Zweier-Kombinationen und deren Anzahl
bases=['A','T','C','G']
counter=0
for b1 in bases:
    for b2 in bases:
        counter+=1
        print(b1+b2)
print("Anzahl der Kombinationen:", counter)
#####################################################################################################################################################
# Münzwurf, Kopf/Zahl zählen
import numpy as np
np.random.seed(0)
tries=20
heads=0
tails=0
for toss in range(tries):
    number=np.random.randint(1,3)
    if number==1:
        heads+=1
    else:
        tails+=1
print("Heads:", heads)
print("Tails:", tails)
#####################################################################################################################################################
# wann überschreitet Zufallsnummer die Schwelle
#while-Schleife:
import numpy as np 
np.random.seed(0)
def n_times_to_threshold(t, max_number):
    counter=0 
    sum=0
    while sum<=t:
        n=np.random.randint(1, max_number+1) # das muss immer in eine Schlaufe
        sum+=n
        counter+=1 
    else:
        return counter
#   return counter      geht auch anstelle else:...
k = n_times_to_threshold(43, 10)
print('The '+str(k)+'th number has brought the sum above the threshold!')

#for-Schleife:
import numpy as np 
np.random.seed(0)
def n_times_to_threshold(t, max_number):
    sum=0
    for i in range(1,t+2): # oder range(t+1), es muss eines mehr sein, weill zB nur Summe von 1ern = t, aber man will ja >t
        n=np.random.randint(1, max_number+1)
        sum+=n
        if sum>t:
            return(i) # oder (i+1)
k = n_times_to_threshold(43, 10)
print('The '+str(k)+'th number has brought the sum above the threshold!')
#####################################################################################################################################################
# pos./neg. Zahlen aus einer Liste ziehen
numbers=[5,-2,-3,0,4,1,-7,0,8]
posl=[]
negl=[]
for num in numbers:
    if num>0:
        posl.append(num)
    if num<0:
        negl.append(num)
print(posl)
print(negl)
#####################################################################################################################################################
# wann erschien das erste mal eine bestimmte Zufallszahl
import numpy.random as rd
rd.seed(4)
num=0
counter=0
while num!=12:
    num = rd.randint(1,13) # dieser Teil muss in die Schleife
    counter+=1
    print(num)
else:
    print("bei der", counter, "-ten Zahl kam 12")
#####################################################################################################################################################
#  wiederholte Wurfanzahl
import numpy.random as rd
rd.seed(0)
wiederholung=5
wuerfe=10
for rep in range(wiederholung):
    nsum=0  # so wichtig, dass das hier hin kommt, sonst werden die Summen zusammen gezählt
    for wurf in range(wuerfe):
        num = rd.randint(1,7)
        nsum+=num
    print(nsum)
#####################################################################################################################################################
#  codons sortiert ausdrucken, wobei die ersten zwei Basen nicht gleich sein dürfen
bases=['G','A','T','C'] # ist eine list, geht aber auch mit string
codons=[]
for b1 in bases:
    for b2 in bases:
        for b3 in bases:
            if b1!=b2:
                codons.append(b1+b2+b3)
                # sortcodons=codons.sort()
                # print(sortcodons)
                codons.sort()
print(codons[16])
# andere Version
bases="TAGC" # keine Kommas dazwischen, da es ein String ist
codons=[]
for b1 in bases:
    for b2 in bases:
        for b3 in bases:
            if b1!=b2:
                codon=b1+b2+b3 # string-concatenation
                codons.append(codon)
# codons=sorted(codons) # geht auch
codons.sort()
print(codons)
print(codons[16])
#####################################################################################################################################################
# 

#####################################################################################################################################################
#  

#####################################################################################################################################################
#  

#####################################################################################################################################################
#  

#####################################################################################################################################################
# 

#####################################################################################################################################################
#  