#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Aug  1 11:57:52 2021

@author: TR
"""

### LISTS

#####################################################################################################################################################
#  ab einem gewissen Listenwort drucken
lys = ['hi', 'sunny', 'strange', 'start', 'well', 'happy', 'start', 'done']
flag = False
for word in lys:
    if word == 'start' :
        flag = True
    if flag :
        print(word)
#####################################################################################################################################################
#  maximaler Wert in einer Liste mit Zahlen herausfinden
lys = [3746453728292834648473, 37363536774847463524, 857575656454534436353, 9958585746363588374, 3635252424253636371423, 37362626262514425262, 83737362625252242425, 38373736225252425253]
max=0
for num in lys:
    if num>max:
        max=num
print(max)
#####################################################################################################################################################
#  wie oft kommt eine bestimmte Zahl in einer Liste von Nummern vor
lys = [0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0 ,1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0 ,0 ,0, 0, 1, 0, 1, 1, 0, 0, 1, 0]
counter=0
for num in lys:
    if not num==0:
        counter=0
    if num==0:
        counter+=1
    print(counter, end=" ") # so kommt alles auf dieselbe Zeile inkl Spacer dazwischen
#####################################################################################################################################################
#  zwei Listen miteinander multiplizieren und die Summe der neuen Liste
lys1 = [9, 12, 45, 12, 398, 24, 76, 21, 11, 12, 198, 87, 876, 34]
lys2 = [187, 23, 435, 761, 73, 3, 4, 987, 32, 46, 98, 107, 45, 1]
lys3 = [0]* len(lys1) # es muss eine Null in der [0] haben
for num in range(len(lys1)):
    lys3[num]=lys1[num]*lys2[num] # allg. diese Lösung elegant, wenn sich alle Listen auf dasselbe i beziehen
print(lys3)
print(sum(lys3))
#####################################################################################################################################################
#  gemischte Listenkombinationen (Add. und Multipl.)
lys1 = [7, 5, 43, 7, 90, 4, 6, 49, 2]
lys2 = [5, 46, 8, 20, 57, 9, 8, 2, 3]
lys3 = [0]*len(lys1)
for i in range(4):
    lys3[i]=lys1[i]+lys2[i]
for i in range(4,len(lys1)): #nicht len(lys1)+1, da sonst out of range, da so die Anzahl der Elemente ja stimmen
    lys3[i]=lys1[i]*lys2[i]
print(lys3)
print(sum(lys3))

lys1 = [7, 5, 43, 7, 90, 4, 6, 49, 2]
lys2 = [5, 46, 8, 20, 57, 9, 8, 2, 3]
lys3=[0]*len(lys1)
for i in range(len(lys1)):
    if i<4: # aufpassen mit Index versus Anzahl!!, allg. diese Lösung elegant, wenn sich alle Listen auf dasselbe i beziehen
        lys3[i]=lys1[i]+lys2[i]
    else:
        lys3[i]=lys1[i]*lys2[i]
print(lys3)
print(sum(lys3))
#####################################################################################################################################################
#  Funktion, um Listenelementen einen Wert zu addieren
def add_list(l, n):
    newl=[]
    for i in range(len(l)):
        newl.append(l[i]+n)
    return newl
l1 = [9, 4, 1]
l2 = [9, 8, 3, 1]
n1=3
n2=5
print(add_list(l1, n1))
print(add_list(l2, n2))
#####################################################################################################################################################
#  verschiedene Arten Indices und Werte einer Liste zu printen
lys = ['apple', 'grape', 'strawberry', 'pear']
for i, fruit in enumerate (lys):
    print(i, fruit)

lys = ['apple', 'grape', 'strawberry', 'pear']
i=0
for fruit in lys:
    print(i, fruit)
    i+=1

lys = ['apple', 'grape', 'strawberry', 'pear']
for i in range(len(lys)):
    print(i, lys[i])
#####################################################################################################################################################
# Art index und Wert von Sublisten zu printen
lys = [['apple', 'grape', 'strawberry'], ['hi', 'hello'], ['garden', 'flower', 'grass']]
counter=0
for i in range(len(lys)):
    for j in range(len(lys[i])):
        print(counter, lys[i][j])
        counter+=1
#####################################################################################################################################################
# neue Liste mit Summe der Quadratzahlen von den alten Listenzahlen der ListofList machen
l=[[5], [6,1], [3,4,2,2,1]]
sq=0
sum=0
newlist=len(l)*[]
for i, el1 in enumerate(l):     # enumerate() nicht vergessen!!
    for j, el2 in enumerate(el1):
        sq=el2**2
        sum+=sq                 # sum=sq+sq funktioniert nicht, nur sum+=sq (sum=sum+sq), ... eigentlich logisch
#       newlist[i]=sum          # geht auch so, aber nur wenn newlist[0,0,0] ist, also newlist=len(l)*[0] gemacht wird
    newlist.append(sum)         # wichtig bei append: die leere Liste muss auch leer sein, keine Nullen wie bei Array.
    sq=0                        # wichtig!, wenn das nicht gemacht wird gibt es [25, 62, 96]
    sum=0
print(newlist)   
# [25, 37, 34]   
#####################################################################################################################################################
# was ist in Listen gemeinsam
l1 = ['pear', 'apple', 'strawberry', 'apple']
l2 = ['grape', 'apple', 'melon', 'strawberry', 'orange']
common = []
for fruit in l1:                           # loop mit for... if... if... 
    if fruit in l2:                 # somit ist die Bedingung erfüllt, dass die Frucht in l1 und l2 ist
        if not fruit in common:            # ohne diese Zeile erscheint nur 'apple' in der common-list
            common.append(fruit)
print(common) # ['apple', 'strawberry']
#####################################################################################################################################################
# Funktion für eine Listen-Umkehr
lys=[129, 'ball', [4,6], 'beach']
def reverse_list(l):
    revl=[]
    for i in range(1, len(l)+1): # es geht nicht mit nur len(l), merken!!! da rückwärts gezählt wird
        revl.append(l[-i])
    return revl
print(reverse_list(lys))
#####################################################################################################################################################
# aus Gen-String Codon-Listen raus ziehen
s="TCGATAATTTCTGACATGGCGTCAATGGTACTCGCGGAG"
lcodon=[]
startcodon=False                # wichtig, dass Name für boolean sich vom Namen für das Codon unterscheidet, sonst direkt s[i:i+3]
for i in range (0, len(s), 3):  # wichtig dass es 0 bis len(s) ist, sonst alles verschoben
    scodon=s[i:i+3]
    if scodon=="ATG":
        startcodon=True
    if startcodon:
        lcodon.append(scodon)   # sonst direkt s[i:i+3] anstelle scodon
print(lcodon)    
#####################################################################################################################################################
# Min/Max aus Listen
lys1=[35,4,12,6,4,27,4,3]
lys2=[1,43,2,3,85,34]
def minMax(l):
    min=99
    max=0
    for num in l:
        if num<min:
            min=num
        if num>max:
            max=num
    return min, max
print(minMax(lys1)) # (3, 35)
print(minMax(lys2)) # (1, 85)
#####################################################################################################################################################
#  Nummern einer Liste zu einem formatierten String umschreiben
l = [234, 1, 13]
for el in l:
    print(("{:05d}").format(el), end="")
# 002340000100013

l = [234, 1, 13]
s = ''
for i in range(len(l)):
    s += '{:05d}'.format(l[i])
print(s)
#####################################################################################################################################################
# Sublisten neu ordnen
rectors=[["Hengartner", "Jarren", "Fischer", "Weder"], ["Michael", "Ottfried", "Andreas", "Hans"], [2014, 2013, 2008, 2000]]
# newRectorList.deepcopy(rectors)
newRectorList=[]
for i in range(1, len(rectors[0])+1):   # 1 bis len+1, weil man danach zurück zählt
    newRectorList.append([rectors[1][-i], rectors[0][-i], rectors[2][-i]]) # ganze ListOfLists mit Indexzugriff als append
    # append() kann nur ein Argument aufnehmen, daher in eine Liste setzen. Wir wolle eh ListOfList.
print(newRectorList) # [['Hans', 'Weder', 2000], ['Andreas', 'Fischer', 2008], ['Ottfried', 'Jarren', 2013], ['Michael', 'Hengartner', 2014]]
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
# Subliste mit einer neuen Liste ergänzen
rectors=[["Weder", "Fischer", "Jarren", "Hengartner"],["Hans", "Andreas", "Ottfried", "Michael"], [2000, 2008, 2013, 2014]]
newrector=["Schaeppmann", "Michael", 2020]
for i in range(len(newrector)):
    rectors[i].append(newrector[i])
print(rectors)
#####################################################################################################################################################
# Funktion für Summenlimit von Listenelementen
groceries=[2.50, 5.95, 0.6, 19.95, 3.20, 1.50] # ist die bestehende Liste
limit=30                                       # ist der Input
def affordable(l, n):
    sum=0
    for num in l:
        sum+=num
    if sum<=n: # indended
        return True # das muss man auch noch zuerst wissen, dass man das darf
    else:
        return False # es muss return True / False heissen, print(=)True geht nicht
    return          # einfach nur return
# andere Lösung:
    # print=False  
    # sum=0
    # for i,el in enumerate(l):
    #     sum+=el
    #     if sum<=n:
    #         print=True
    #     if print:
    #         return          # nur return, return print gibt das falsche Ergebnis aus (weil es einfach das erste printet)           
if affordable(groceries, limit): 
    print("You can afford it!")
else:
    print("Sorry, too expensive...") 
#####################################################################################################################################################
# Sublist neu ordnen und als formatierter String printen
planets = [['Earth', 12742, 149598262], ['Jupiter', 139822, 778340821], \
           ['Mars', 6779, 227943824], ['Mercury', 4878, 57909227], \
           ['Neptune', 49244, 4498396441], ['Saturn', 116464, 1426666422], \
           ['Uranus', 50724, 2870658186], ['Venus', 12104, 108209475]]
# sort the planets according to their distance from the sun
    # first restructure the planet sublists to have the distance first
    # then sort the restructured planet list
sorted_planets = []
for planet in planets:
    name, diameter, distance = planet
    sorted_planets.append([distance, name, diameter]) 
sorted_planets.sort()
# print the sorted planets in the requested format
# define filler sentences for first line
filler2 = 'km in diameter'
filler3 = 'km away from the sun'
for line, planet in enumerate(sorted_planets):
    distance, name, diameter = planet  
    # define filler sentences for remaining lines
    if line > 0:
        filler2 = len(filler2)*'.'
        filler3 = len(filler3)*'.'        
    print(('{:.<10} {:>6d} ' + filler2 + ' {:>10d} ' + filler3).format(name+' ', diameter, distance)) 
#####################################################################################################################################################
# Wahrsch'keiten von Basensequenzen in einem Genabschnitt
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
        dic[position][base] = 0     # dict in dict ist vert.[0:8], horiz.[Basen], Feld von 9x4 mit Nullen gefüllt
# count occurencies of bases at each position in motifs
for motif in functional_motifs:
    for position, base in enumerate(motif):
        dic[position][base] += 1    # Feld wird mit +=1 gefüllt (danach erst % ausrechnen)
# calculate freuqencies of occurencies
for position in dic:
    for base in dic[position]:
        dic[position][base] = dic[position][base]/nr_motifs     # % ausrechnen
print(dic)
# find potential binding sites in sequence query with scores above cutoff
scores = []
for i in range(len(query) - l_motif + 1): # minus, damit man nicht mit i+motif über den range hinaus geht
    motif = query[i:i+l_motif]
    score = 0
    for j, base in enumerate(motif):
        score += dic[j][base]    
    if int(score*10) > int(cutoff*10):  # besser mit int vergleichen, deshalb *10
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
###################################################################################################################################################
# AS auflisten und eindeutigem Kurz-Code zuweisen
aminoacids = ['alanine', 'cysteine', 'aspartic acid', 'glutamic acid', \
              'phenylalanine', 'glycine', 'histidine', 'isoleucine', \
              'lysine', 'leucine', 'methionine', 'asparagine', \
              'proline', 'glutamine', 'arginine', 'serine', \
              'threonine', 'valine', 'tryptophan', 'tyrosine'] 

abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'  # gleich Grossbuchstaben machen
abc_l = list(abc)   # Liste machen, weil später .remove() und .pop() nur bei Listen geht
# group the amino acids according to their first letter
aa_groups = {}  # immer dict machen, wenn man Auflistung ohne Wiederholung (keys) machen will
for aa in aminoacids:
    # capitalize first letter
    first = aa[0].upper()
    aa = first + aa[1:]
    if not first in aa_groups:
        aa_groups[first] = []
    aa_groups[first].append(aa)
# create one letter code using the 3 rules
one_letter_code = {}
remaining_aa = []
for first in aa_groups:
    # rule 1
    if len(aa_groups[first]) == 1:
        one_letter_code[first] = aa_groups[first][0]
        abc_l.remove(first) # remove the already used letters
    else: # rule 2
        # rule 2a
        shortest = aa_groups[first][0]  # so ist shortest automatisch das erste Element in der dict-Liste, Referenz, weil man danach vergleicht
        for aa in aa_groups[first]:
            if len(aa) < len(shortest):
                shortest = aa
        one_letter_code[first] = shortest
        abc_l.remove(first) # remove the already used letters
        # set up list for rule 2b
        for aa in aa_groups[first]:
            if not aa == shortest:
                remaining_aa.append(aa)
# rule 2b
remaining_aa.sort()
for aa in remaining_aa:
    one_letter_code[abc_l.pop(0)] = aa  # Element [0] des abc kann nur noch ein übrig gebliebener (+nächster) Buchstabe sein
# print in the requested format
for letter in abc:
    if letter in one_letter_code:
        print(letter, one_letter_code[letter])
    else: 
        print(letter, '---')
#####################################################################################################################################################
#

#####################################################################################################################################################
#  

#####################################################################################################################################################
# 

#####################################################################################################################################################
#  