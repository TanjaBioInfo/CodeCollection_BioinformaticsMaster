#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Aug  1 11:58:57 2021

@author: TR
"""

### DICTIONARIES

#####################################################################################################################################################
#  Durchschnittszeit aus einem Dict. ziehen, anhand Angaben aus einer Liste
marathon = {'Sarah': 3.89, 'Ron': 4.21, 'Louis': 3.62, 'Linda': 4.69, 'Marion': 5.20, 'Jack': 4.79, 'Mary': 3.34}
women = ['Marion', 'Linda', 'Sarah', 'Mary']
time=[] # muss man hier schon definieren, sonst Fehlermeldung
for woman in women:
    # if woman not in marathon: # das alles kann...
    #     time=[]               # ... man weg lassen
    # else:
    time.append(marathon[woman])
    meantime=sum(time)/len(women)
print(meantime)
#####################################################################################################################################################
#  Key und Value in einem Dict. vertauschen
ages = {'Sarah': 23, 'Ron': 25, 'Louis': 23, 'Linda': 28, 'Marion': 21, 'Jack': 23, 'Mary': 25}
newd={}
for name in ages:
    age=ages[name]
    if age not in newd:
        newd[age]=[]
#    else: # das weg lassen und stattdessen nächste Zeile mit einem Einzug weniger
    newd[age].append(name) # einmal unindented
print(newd)
#####################################################################################################################################################
# s = 'abcdefghijk'
# Aim: create, based on s, the following dictionary:
# {'ab': 'cd', 'ef': 'gh', 'ij': 'k'}
s = 'abcdefghijk'
dnew = {}   #1: define an empty dictionary
for i in range(0, len(s), 4):
    dnew [s[i:i+2]] = s[i+2:i+4]   #2: add key-value pairs to dnew, so bei 
                                    # Dictionnary ansetzen/anhängen
print(dnew)
#####################################################################################################################################################
# was ist in Dict. gemeinsam
d1 = {'pear': [0], 'apple': [1, 3], 'strawberry': [2]}
d2 = {'grape': [0], 'apple': [1], 'melon': [2], 'strawberry': [3], 'orange': [4]}
common = []
for fruit in d1:
    if fruit in d2:
        if fruit not in common:
            common.append(fruit)
print(common) # ['apple', 'strawberry']
#####################################################################################################################################################
# Dict. für Sublist-Zähler
lys=[[6,9,2], [3,2], [8,2,1,8,5], [6,8,12]]
d={}
for sublist in sorted(lys): # schon hier die lys sortieren: (sorted(lys)), es sortiert die Keys, statt sublist geht auch lys[i], aber wegen range geht sorted dann nicht mehr
    if not len(sublist) in d:
        d[len(sublist)]=[]
    d[len(sublist)].append(sublist)
# d[len(sublist)].sort() # .sort() ist eine Listenmethode, es sortiert die Listen(Values), geht auch
# d[len(sublist)]=sorted(d[len(sublist)])  # geht auch
print(d)
#####################################################################################################################################################
# Dict. für Wurf-Zahl-Zählungen
import numpy as np
np.random.seed(0)
n=9 #sind die Values/Würfe
d={}
for zahl in range(1,7): # weil so in der Aufgabe verlangt, sind alle Keys, jede Zahl, wichtig: hier schon zahl (key) benennen
    d[zahl]=[]          # zahl (key) immer gleich benennen, oder zumindest innerhalb einer Schleife immer gleich benennen
for wuerfe in range(1, n+1):
    zahl=np.random.randint(1,7) # sind die Keys, die vorkommen, nicht jede Zahl, aber man darf wieder zahl als Variale verwenden, zahl (key) immer gleich benennen
    d[zahl].append(wuerfe)         # zahl (key) immer gleich benennen innerhalb der Schleife
print(d)
# es geht auch mit unterschiedlichen dict-Keys, wenn der key numerisch ist:
import numpy as np
np.random.seed(0)
n=9
d={}
for key in range(1,7):
    d[key]=[]           # aber innerhalb eine Schleife immer gleiche Nomenklatur
for j in range(n):
    num=np.random.randint(1,7)
    d[num].append(j+1)  # aber innerhalb eine Schleife immer gleiche Nomenklatur
print(d)
#####################################################################################################################################################
# aus Text-File Text-Elemente raus ziehen und als Dict. ordnen
f=open("microbe_identifiers.txt")
line=f.readlines()[0]
f.close()
# geht nicht, wäre:
# S97-cy101 S97-cy10339 S97-ga15914 S97-fi20693 S97-ga2201 S97-de32927 S97-ac375 S97-ac47381 S97-ac517 /
# S97-de522 S97-cy57 S97-fi7767 S97-de7777 S97-ac8603
# s97- ist das prefix(wollen wir nicht), dann taxon ID(value), letterletter(key)+intNr
d={}
iden=line.strip().split() # das muss man hier noch vor der Schleife kreieren
for identifiers in iden: # in iden macht jetzt Sinn
    key=iden[4:6] # Präfix [:4] brauchen wir gar nicht
    value=iden[4:] # universeller als [4:9]
  # key=value[:2]     ginge ab hier, wenn es unter value=... steht
    if not key in d: # es heisst if not key ..., nicht if key not in...
        d[key]=[]
    d[key].append(value)
print(d)
#####################################################################################################################################################
# String-Elemente werden anhand eines Dict. in Listen gezählt/Indices aufgelistet
rna = 'AUGUUCGAA'
d={}
for i in range(len(rna)):
    if not rna[i] in d:
        d[rna[i]]=[]
    d[rna[i]].append(i)
print(d)
# man will für jede Base einen Key+leere Liste, dann auffüllen
rna = 'AUGUUCGAA'
bases="AUGC"
d={}
for base in bases:
    if not base in d:
        d[base]=[]
for i, base in enumerate(rna):
    if base in d:
        d[base].append(i)
print(d)
#####################################################################################################################################################
#  Aufg.6 aus 2020/21, Titel noch machen
functional_motifs = ['GAGGTAAAC','TCCGTAAGT','AAGGTTGGA','ACAGTCAGT',\
        'TAGGTCATT','TAGGTACTG','ATGGTAACT','CAGGTATAC','TGTGTGAGT','AAGGTAAGT']

query = 'ACTCAGCCCCAGCGGAGGTGAAGGACGTCCTTCCCCAGGAGCCGGTGAGAAGCGCAGTCGGGGGCACGG'\
        'GGATGAGCTCAGGGGCCTCTAGAAAGATGTAGCTGGGACCTCGGGAAGCCCTGGCCTCCAGGTAGTCTC'\
        'AGGAGAGCTACTCAGGGTCGGGCTTGGGGAGAGGAGGAGCGGGGGTGAGGCCAGCAGCA'
        
l_motif = len(functional_motifs[0])
nr_motifs = len(functional_motifs)
cutoff = 4.4
# create profile matrix as dictionary with positions as keys and dictionaries as values. 
# These inner dictionaries have bases as keys and frequencies as values. 
# initialize dictionary
bases = 'ATCG'
dic = {}
for position in range(l_motif):
    dic[position] = {}
    for base in bases:
        dic[position][base] = 0
# count occurencies of bases at each position in motifs
for motif in functional_motifs:
    for position, base in enumerate(motif):
        dic[position][base] += 1
# calculate freuqencies of occurencies
for position in dic:
    for base in dic[position]:
        dic[position][base] = dic[position][base]/nr_motifs
print(dic)
# find potential binding sites in sequence query with scores above cutoff
scores = []
for i in range(len(query) - l_motif + 1):
    motif = query[i:i+l_motif]
    score = 0
    for j, base in enumerate(motif):
        score += dic[j][base]   
    if int(score*10) > int(cutoff*10):
        print('position '+str(i)+': '+motif+', '+str(score))
# generate hypothetical ideal motiv
ideal = ''
for position in range(l_motif):
    best_frequency = 0
    best_base = 'A'
    for base in dic[position]:
        if dic[position][base] > best_frequency:
            best_frequency = dic[position][base]
            best_base = base            
    ideal += best_base        
print(ideal)        
#####################################################################################################################################################
# Geschwindigkeit eine Dict-Suche(Key unabhänging der Länge, Value abh. der Länge) verglichen mit Suche in Listen
import numpy.random as rd
import time
# Zufallsliste von Buchstabenstring:
def random_list(length):
    alphabet = 'abcdefghijklmnopqrstuvwxyz'
    l = []
    for i in range(length):
        s = ''
        for j in range(5):
            s += alphabet[rd.randint(0,24)]
        l.append(s)
    return l # Liste von zufälligen Buchstabenfolgen

rd.seed(0)
l1 = random_list(10000)
l2 = random_list(10000)

time1 = time.time()
common = []
for fruit in l1:
    if fruit in l2:
        if fruit not in common:
            common.append(fruit)
time2 = time.time()
print(common) # Bsp: ['wdijk', 'jgirf', 'jserw', 'iqthh', 'alhst', 'otepm', 'pwqwh', 'pxsos', 'woess', 'qxlux']
print('time spent on list part:', time2 - time1)
# dictionary:
d1 = {'pear': [0], 'apple': [1, 3], 'strawberry': [2]}
d2 = {'grape': [0], 'apple': [1], 'melon': [2], 'strawberry': [3], 
      'orange': [4]}

common = []
for fruit in d1:
    if fruit in d2:
        if fruit not in common:
            common.append(fruit)
print(common) # Bsp: ['apple', 'strawberry']
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