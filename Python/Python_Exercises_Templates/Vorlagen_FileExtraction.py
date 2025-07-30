#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Aug  1 12:00:58 2021

@author: TR
"""

### FILE-EXTRACTION

#####################################################################################################################################################
#  Zeilenlänge auf File und jedes 2. Wort der Zeile ausdrucken
file=open("shakespeare.txt", "r")
text=file.readlines()  # Liste mit Zeilen-Items
file.close()
for lines in text:
   line=lines.strip().split()
   print("Length {:4d} and second word:".format(len(line)), line[1])
#####################################################################################################################################################
# aus einem Text-String mit einer Nummer, die int-Summe herausfinden
fyle = open("some_numbers.txt")
l = fyle.readlines() # gibt eine Liste aus
fyle.close()
summe = 0
for line in l: # die line ist jedoch ein string
    summe += int(line.strip()) # wichtig: man stripped die line (also string), nicht l (List)
print(summe)
####################################################################################################################################################
#  aus einem Text-File mit Nummern, die int-Summe jeder zweiten Zahl herausfinden
fyle=open("some_more_numbers.txt", "r")
ltextstring = fyle.readlines()
fyle.close()
summe = 0
for line in ltextstring:
#    print(line) printet alles einzelnen Strings untereinander
#    type(line)  ist ein stringtype
    secnum=line.strip().split()[1] # cave: sobald man .split() benutzt, wird eine list daraus
                                # eine list kann man nicht zu int-Zahl machen!!!!
#    type(secnum) # ist nun immer noch ein stringtype
    summe+=int(secnum)
#    type(summe) ist num eine int Zahl
print(summe)
#####################################################################################################################################################
#  verschiedene Importe
fyle=open("thompson.txt", "r")
l=fyle.readlines()
fyle.close()
print(l)

import matplotlib.pyplot as pl    # bei plots und images immer dieses Vorgehen
import matplotlib.image as img    # bei images immer dieses Vorgehen
h = img.imread('Haeckel.png')     # bei images immer dieses Vorgehen
pl.imshow(h)                      # bei images immer dieses Vorgehen
pl.show()                         # bei plots und images immer dieses Vorgehen

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image
a=np.array([[[0,0,0],[0,0,0],[0,0,0]],[[1,0,0],[0,1,0],[0,0,1]],\
           [[1,1,0],[1,0,1],[0,1,1]],[[1,1,1],[0.5,0.5,0.5],\
           [1,1,1]]])
matplotlib.image.imsave('dots.png', a)
# matplotlib.image.imread('dots.png', a)  das besser weg lassen, kommt eine Warn-Meldung
plt.imshow(a)
plt.show()
#####################################################################################################################################################
#  Text-File kopieren und überschreiben, write, später methode .writelines(), später str().strip("'[]")
file=open("crick.txt", "r")
l=file.readlines()
file.close()
print(l)
# ['It now seems certain \n', 'that the amino acid \n', 'sequence of any protein \n', 'is determined by the \n', 'sequence of bases in \n', 'some region of a \n', 'particular nucleic \n', 'acid molecule.']

fyle = open('crick.txt', 'r')            # read, später .readlines(), file=open geht auch, aber nicht vergessen "r" oder "w" in "" zu setzen
fyle_copy = open('crick_copy.txt', 'w')  # write, später methode .writelines(), später str().strip("'[]")
l_fyle = fyle.readlines()       # bezieht sich auf read
for l in l_fyle:                # es wird durch das Original ('txt', 'r') iteriert
    x=l.strip('\n')
    fyle_copy.writelines(x)  # bezieht sich auf write, neue Methode, hängt Listen von Strings aneinander, das ganze ist jedoch immer noch eine liste von Strings.
fyle.close()
fyle_copy.close()
# print(str(fyle_copy))
fyle = open('crick_copy.txt')                 
l_fyle = fyle.readlines()
print(str(l_fyle).strip("'[]"))  # bezieht sich auf write, neu: es ist ein String: alle ' und [] noch aus dem String entfernen, der noch '['']' enthält, 
                                 # aber keine Kommas entfernt. Wenn man noch die Kommas entfernt, erhält man dasselbe Resultat. 
fyle.close()
fyle_copy.close()   # korrekt, printed: It now seems certain that the amino acid sequence of any protein is determined by the sequence of bases in some region of a particular nucleic acid molecule.

#####################################################################################################################################################
# was aus einem Text-File isolieren (aus jeder Zeile)
fyle=open("darwin.txt", "r")                                                                                                # immer so anwenden
l=fyle.readlines()              # l ist eine Liste aus "Zeilen-Strings"                                                     # immer so anwenden
fyle.close()                                                                                                                # immer so anwenden
gesuchteLaenge=0                                                                                                            # immer so anwenden
for line in l:                  # jede Zeile (line) durch iterieren                                                         # immer so anwenden
    line=line.strip('')         # strip geht hier, weil die Zeilen ja Strings sind (["String-Item1", "String-Item2", ...])  # immer so anwenden
                                # term of Natural Selection. = ist die line
    linelist=line.split(" ")    # jede Zeile ist jetzt eine einzelne Liste ["String-Item1"], ["String-Item2"], ... = Worte  # immer so anwenden
                                # ['term', 'of', 'Natural', 'Selection.'] = ist die linelist
    word=linelist[2]            # man will immer das dritte Wort von jeder Zeile, das Wort ist = Natural
    # number=float(linelist[2])     # wenn man anstelle eines Wortes eine Zahl will
    gesuchteLaenge += len(word)
print("mean: ", gesuchteLaenge / len(l)) # len(l) ist die Zeilenanzahl
#####################################################################################################################################################
#  Abkürzung in der for-Schleife
fyle=open("darwin.txt", "r")                                                                                                # immer so anwenden
l=fyle.readlines()              # l ist eine Liste aus "Zeilen-Strings"                                                     # immer so anwenden
fyle.close()                                                                                                                # immer so anwenden
gesuchteLaenge=0                                                                                                            # immer so anwenden
for line in l:                  # jede Zeile (line) durch iterieren                                                         # immer so anwenden
    word=line.strip().split(" ")[2] # man will immer das dritte Wort von jeder Zeile
    # number=float(linelist[2])     # wenn man anstelle eines Wortes eine Zahl will
    gesuchteLaenge += len(word)
print("mean: ", gesuchteLaenge / len(l)) # len(l) ist die Zeilenanzahl
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
#################################################################################################################################################
# Text mit längster gemeinsamer Sequenz finden
def analyze_text(filename):
    fyle = open(filename)
    l_text = fyle.readlines()
    fyle.close()
    #make a list with all words from the text
    alphabet = 'abcdefghijklmnopqrstuvwxyz'   # ohne das geht es nicht, braucht es wenn man Wörter ohne Zeichen etc haben will
    text = ''
    for line in l_text:
        for char in line:
            if char.lower() in alphabet:
                text += char
            else:
                text += ' '
    l_words = text.split()
    #print(l_words)    
    #create a dictionary keyed by lowercase words, values are lists with total 
    #number and number starting with capital
    d_words = {}
    for word in l_words:
        if word.lower() not in d_words:         # if not in generiert eine (leere) Liste, hier für die Values
            d_words[word.lower()] = [0, 0]
        d_words[word.lower()][0] += 1           # dann ist [1, 0]
        if word.lower() != word:
            d_words[word.lower()][1] += 1       # dann ist [0, 1], dann ist es ein Wort, dass mit einem capital letter beginnt
    #print(d_words)
    #make a list of lists: position 0 contains a list with all words that have length 1, 
    #                      position 1  ,,                ,,             ,,            2, etc
    len_longest_word = 0
    for word in d_words:
        if len(word) > len_longest_word:
            len_longest_word = len(word)
    l_lengths_words=[]
    for i in range(len_longest_word):
        l_lengths_words.append([])
    for word in d_words:
        l_lengths_words[len(word)-1].append(word) # index = [len(word)-1]
    #print(l_lengths_words)    
    #find longest word that occurs more than once
    for i in range(len_longest_word):
        for word in l_lengths_words[i]:
            if d_words[word][0] > 1:
                longest_more_than_once = word   # wert wird immer weiter nach oben angepasst                
    #find longest word with capital
    not_found = True
    i = 1                                       # Zähler für die while-Schleife
    longest_with_capital = []
    while not_found and i<=len_longest_word:
        for word in l_lengths_words[-i]:
            if d_words[word][1] > 0:            # Wörter mit capital letter beginnend
                longest_with_capital.append(word)
                not_found = False
        i += 1                                  # while-Schleife braucht immer einen Zähler               
    return len(d_words), longest_more_than_once, longest_with_capital                
different, longest1, longest2 = analyze_text('beatles.txt') 
print('Number of different words:', different)
print('Longest word that occurs more than once:', longest1)
print('Longest word(s) that start(s) at least once with a capital letter: ', end = '')
for word in longest2:
    print(word, end = ' ')    
#####################################################################################################################################################
# File-Auszüge mit einer Liste kombinieren
taxa = ['domain', 'phylum', 'class', 'order', 'family', 'genus', 'species']

def lineage_analysis(taxa, filename):
    
    # read in text file
    fyle = open(filename)
    lines = fyle.readlines()  # Bsp. für lines[31] : [... 'genome_24 Bacteria;Firmicutes;Clostridia;Clostridiales\n' ...]
    fyle.close()
    
    # initialize ranks and lineages
    ranks = {}
    for rank in taxa:
        ranks[rank] = 0     # alles hat Value 0
        
    lineages = {}
    
    for line in lines:
        
        # prepare genome id and lineage from line strings             # allg. Tupelzuweisungen bei partition praktisch
        genome_id_part, _, lineage_part = line.strip().partition(' ') # Drei-Teilung (Mittelteil brauchen wir nicht)
        genome_id = int(genome_id_part.split('_')[1])                 # hier ist nur der 2. Teil [1] wichtig
        lineage = lineage_part.split(';')
        
        # fill in lineages, Dictionary wird gefüllt
        lineages[genome_id] = lineage       # lineage ist eine Liste
        
        # fill in ranks
        for i in range(len(lineage)):
            ranks[taxa[i]] += 1     # Value wird hoch gezählt
    
    return lineages, ranks

lineages, ranks = lineage_analysis(taxa, 'lineage.txt') # 2er-Tupel-Zuordnungen
print(lineages[31])     # ['Bacteria', 'Firmicutes', 'Clostridia', 'Clostridiales']
print(lineages[22])     # ['Bacteria']
print(lineages[3][-1])  # Eubacterium ramulus
print(ranks)            # {'domain': 100, 'phylum': 58, 'class': 58, 'order': 58, 'family': 27, 'genus': 14, 'species': 11}
#####################################################################################################################################################
# File-Auszüge mit einer Liste kombinieren
import numpy as np

# open file, read in the data
f = open('microbial_samples.txt')
lines = f.readlines()
f.close()

# # uncomment if you want to use only the subset
# subset = ['Oral 1 0 351 0 0 258 1608 0 0 0 0 0 0 0',\
# 'Gut 0 0 0 2 0 0 0 16 0 3974 0 0 153 676',\
# 'Skin 0 280 0 0 2 1 0 0 0 0 0 0 0 0']
# lines = subset

microbe_ids = ['S97-ac103', 'S97-ga105', 'S97-cy13', 'S97-ac137',\
    'S97-de22', 'S97-de227', 'S97-cy30', 'S97-fi362', 'S97-ga404',\
    'S97-fi47', 'S97-ac51', 'S97-ac769', 'S97-fi77', 'S97-ga86']
    
# create an array with the microbe counts, one row per sample; and an array with 
# the respective body sites
abundance_counts = []
sample_bodysites = []
for line in lines:
    fields = line.strip().split()
    sample_bodysites.append(fields[0])
    
    counts_one_sample = []
    for count in fields[1:]:
        counts_one_sample.append(int(count))
    abundance_counts.append(counts_one_sample)    

abundance_counts = np.array(abundance_counts)  
sample_bodysites = np.array(sample_bodysites)

# find the maximum abundance sum: which sample harbor the most microbes
max_abundance_sum = 0
for row in range(abundance_counts.shape[0]):
    abundance_sum = sum(abundance_counts[row,:])
    if max_abundance_sum < abundance_sum:
        max_abundance_sum = abundance_sum
        row_max = row
print('The sample with the most microbes,', max_abundance_sum, 'counts, comes from the', sample_bodysites[row_max])

# calculate the average microbe abundances per body sites
av_microbe_abundance_per_bodysite  = np.zeros((3, abundance_counts.shape[1]))

bodysites = ['Oral', 'Gut', 'Skin']
for i, bodysite in enumerate(bodysites):
    for i_microbe in range(abundance_counts.shape[1]):
        av_microbe_abundance_per_bodysite[i,i_microbe] = sum(abundance_counts[sample_bodysites == bodysite, i_microbe])/len(abundance_counts[sample_bodysites == bodysite, i_microbe])

# find the top 3 on average most abundant microbes for each body site
# check if some of the top microbes are shared between body sites. 
print('The top 3 on average most abundant microbes per body site:')

bodySitesPerTopRankedMicrobes = {} 
for i_bodysite in range(3):
    print(bodysites[i_bodysite]+': ', end = '')
    for rank in range(3):
        top_count = 0
        for i_microbe in range(abundance_counts.shape[1]):
            if av_microbe_abundance_per_bodysite[i_bodysite, i_microbe,] > top_count:
                top_count = av_microbe_abundance_per_bodysite[i_bodysite, i_microbe]
                top_microbe = microbe_ids[i_microbe]
                i_top = i_microbe
        print(top_microbe, top_count, end = ' ')
        if not top_microbe in bodySitesPerTopRankedMicrobes:
            bodySitesPerTopRankedMicrobes[top_microbe] = []
        bodySitesPerTopRankedMicrobes[top_microbe].append(bodysites[i_bodysite])
        
        av_microbe_abundance_per_bodysite[i_bodysite, i_top] = 0
    print()

for microbe in bodySitesPerTopRankedMicrobes:
    if len(bodySitesPerTopRankedMicrobes[microbe])>1:
        print(microbe, 'is among the most abundant microbes in ', end = '')
        for i in range(len(bodySitesPerTopRankedMicrobes[microbe])-1):
            print(bodySitesPerTopRankedMicrobes[microbe][i]+ ' and ', end = '')
        print(bodySitesPerTopRankedMicrobes[microbe][-1])
#####################################################################################################################################################
#  Aufg.4 aus 2020/21, Daten (zweites Elelment jeder Zeile) zu bestimmten Zeiten rauspicken, 2D Array, np.mean_liste nur vom ersten Array
import numpy as np
# open file and read in lines
f = open('fMRI_series.txt')
lines = f.readlines()
f.close()
# # alternative to keep only relevant data after timepoint 170s
# start = int(170/5)
# lines = lines[start:]

# extract relevant activity values and convert to floats
activities = []
for line in lines:
    t, value = line.strip().split()     # allg. Tupelzuweisungen praktisch
    value = float(value)
    if int(t) >= 170:
        activities.append(value)

# format data to 5x12 array structure
nr_cols = 12 # is fixed
nr_rows = int(len(activities)/nr_cols) # could vary, ohne int() ist es ein float-Wert

# fill values to numpy array
data = np.zeros((nr_rows, nr_cols))
counter = 0     # damit erspart man sich eine weitere Iterationsschleife (durch activities)
for row in range(nr_rows):
    for col in range(nr_cols):
        data[row, col] = activities[counter]
        counter += 1
print(np.mean(data, 0))

# # alternative with creating list first, then convert to numpy array
# data = []
# counter = 0
# for row in range(nr_rows):
#     data.append([])
#     for col in range(nr_cols):
#         data[row].append(activities[counter])
#         counter += 1
# data = np.array(data)
# print(np.mean(data, 0))    

# "Kurzversion"
import numpy as np
f=open('fMRI_series.txt')
l=f.readlines()
f.close()
# print(l)                  # [...,'280 13647.04881\n', ...]
lvalue=[]
for i, el in enumerate(l):
    time, value=el.strip().split()
    time=int(time)
    value=float(value)
    # if i>=34:                     # 170/5=34 , geht auch so 
    #     lvalue.append(value)      # geht auch so
    if time>=170:
        lvalue.append(value)
# print(lvalue)             # [13732.09268, 14008.70276, 13914.99414, ...]
col=int(60/5)               # entspricht den Zeitmessungen, immer gleich, geht auch einfach 12
row=int(len(lvalue)/col)   # entspricht Anzahl Stimulationen, welche variieren können, ohne int() ist es ein float-Wert
data=np.zeros((row,col))
counter=0
for irow in range(row):
    for icol in range(col):
#        for j in range(len(lvalue)):   #wichtig: das geht nicht!!, nur der counter geht
        data[irow,icol]=lvalue[counter]   
        counter+=1
print(np.mean(data, 0))

# Dea's Code:
import numpy as np              #somewhere in your program, before:   
file=open('fMRI_series.txt')
f=file.readlines()
file.close()
start=170/5
steps=60/5
shap=int((len(f)-start)/int(steps))     # ohne int() ist es ein float-Wert
data=np.zeros(shape=(shap,int(steps)))
for x in range(int((len(f)-start)/int(steps))):     # range(shap)
    for y in range(int(steps)):
        data[x,y]=float(f[int(start)][-int(steps):])  # -int(steps), weil es der Beginn der Steps darstelt
        start+=1        # so erspart man sich eine weitere Iterationsschleife
print(np.mean(data, 0))
#####################################################################################################################################################
# von Text zu Liste umändern
def text_to_list(my_text):
    file= open(my_text,'r')
    my_list= file.readlines()
    for i in range(len(my_list)):
        my_list[i]= my_list[i].split()
        my_list[i][0]=int(my_list[i][0])
        my_list[i][2]=float(my_list[i][2])
        file.close()        # erst in der Schleife close, nicht vorher
    return my_list
l_after= text_to_list('bif_after.txt')
print(l_after[36])
#####################################################################################################################################################
# von Text zu Dictionary umändern
def text_to_dictionary(my_file):
    file= open(my_file,'r')
    my_list= file.readlines()
    my_dictionary={}
    for i in range(len(my_list)):
        my_list[i]= my_list[i].split()
        my_list[i][0]=int(my_list[i][0])
        my_list[i][2]=float(my_list[i][2])
        ray= my_list[i][1]
        fish=my_list[i][0]
        value=my_list[i][2]
        if ray not in my_dictionary:
            my_dictionary[ray]= {fish:value}
        else:
            my_dictionary[ray][fish]=value
    file.close()
    return my_dictionary
d_before= text_to_dictionary('bif_before.txt')
d_after= text_to_dictionary('bif_after.txt')
print(d_after)
#####################################################################################################################################################
# plots (aussen), images (innen)
import matplotlib.pyplot as pl    # bei plots und images immer dieses Vorgehen
import matplotlib.image as img    # bei images immer dieses Vorgehen
h = img.imread('Haeckel.png')     # bei images immer dieses Vorgehen
pl.imshow(h)                      # bei images immer dieses Vorgehen
pl.show()                         # bei plots und images immer dieses Vorgehen

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image
a=np.array([[[0,0,0],[0,0,0],[0,0,0]],[[1,0,0],[0,1,0],[0,0,1]],\
           [[1,1,0],[1,0,1],[0,1,1]],[[1,1,1],[0.5,0.5,0.5],\
           [1,1,1]]])
matplotlib.image.imsave('dots.png', a)
# matplotlib.image.imread('dots.png', a)  das besser weg lassen, kommt eine Warn-Meldung
plt.imshow(a)
plt.show() 
#####################################################################################################################################################
#  image-smoothing
# smoothen eines img-Arrays (ar) für 9 Nachbarpixels
import matplotlib.pyplot as plt
import matplotlib.image as img
import numpy as np

def mean_9_pixels(ar):
    sar = 1*ar #sar: smoothened array
    sar[1:-1,1:-1,:]=(ar[1:-1,1:-1,:]+ar[0:-2,1:-1,:]\
    +ar[2:,1:-1,:]+ar[1:-1,0:-2,:]+ar[1:-1,2:,:]\
    +ar[:-2,:-2,:]+ar[2:,:-2,:]+ar[:-2,2:,:]+ar[2:,2:,:])/9
    return sar    

bug = img.imread('stinkbug.png')
sbug=mean_9_pixels(bug)
# print ('red boundary pixel 5,499:',sbug[5,499,0])       # 0.439
# print ('green, position 181,260:', sbug[181,260,1])     # 0.33
# print ('mean pixel value:',np.mean(sbug))               # 0.551118
plt.imshow(sbug)
plt.show()

# smoothen eines img-Arrays (bug) für vier Nachbarpixels
import matplotlib.pyplot as plt
import matplotlib.image as img
import numpy as np
bug = img.imread('stinkbug.png')
bug = bug[150:400,30:420]   # Bildausschnitt (y-Range kommt vor x-Range)
nsum = 0*bug  # Array mit gleicher Grösse wie bug (Bildausschnitt), aber alles voller Nullen. Soll die Summe aller Pixel darstellen.
nsum[1:-1,1:-1] = bug[2:,1:-1] + bug[:-2,1:-1] + bug[1:-1,2:] + bug[1:-1,:-2]
bug = (bug + nsum/4)/2
plt.imshow(bug)    
plt.show()
#####################################################################################################################################################
# how to make multiple panels inside a figure using matplotlib.pyplot.subplot() 
import matplotlib.pyplot as plt
plt.figure(1)         # first figure
plt.subplot(211)      # first subplot in first figure (2 rows, 1 column, 1st panel)
plt.plot([1, 2, 1])          
plt.subplot(212)      # the second subplot in the first figure, 2nd panel
plt.plot([3, 2, 1])
# how to make multiple figures using matplotlib.pyplot.figure()
plt.figure(2)         # a second figure
plt.plot([4, 5, 6])   # creates a subplot(111) by default
plt.show()
#####################################################################################################################################################
# smoothing a picture
import matplotlib.pyplot as pl
import matplotlib.image as img
import numpy as np
I = img.imread('stinkbug.png')
print('Image size:',I.shape) #print size Image
# smoothing part (padding with same):
H=I[0:-2,0:-2] + \
  I[0:-2,1:-1] + \
  I[0:-2,2:]   + \
  I[1:-1,0:-2] + \
  I[1:-1,2:]   + \
  I[2:,0:-2]   + \
  I[2:,1:-1]   + \
  I[2:,2:]     + \
  I[1:-1,1:-1]
H=H/9
S=1.0*I
S[1:-1,1:-1]=H;
pl.imshow(S)
pl.show()
# formatieren:
y=5
x=499
print('Image at position {:d},{:d} = {:6.3f}'.format(y,x,S[y,x,0]))

y=181
x=260
print('Image at position {:d},{:d} = {:6.2f}'.format(y,x,S[y,x,0]))

m=np.mean(S)
print('Mean pixel value = {:8.6f}'.format(m)) 


# andere Version:
import matplotlib.pyplot as plt
import matplotlib.image as img
import numpy as np
def mean_9_pixels(ar):
    sar = 1*ar #sar: smoothened array
    sar[1:-1,1:-1,:]=(ar[1:-1,1:-1,:]+ar[0:-2,1:-1,:]\
    +ar[2:,1:-1,:]+ar[1:-1,0:-2,:]+ar[1:-1,2:,:]\
    +ar[:-2,:-2,:]+ar[2:,:-2,:]+ar[:-2,2:,:]+ar[2:,2:,:])/9
    return sar    
bug = img.imread('stinkbug.png')
sbug=mean_9_pixels(bug)
print ('red boundary pixel 5,499:',sbug[5,499,0])
print ('green, position 181,260:', sbug[181,260,1])
print ('mean pixel value:',np.mean(sbug))
plt.imshow(sbug)
plt.show()    
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
