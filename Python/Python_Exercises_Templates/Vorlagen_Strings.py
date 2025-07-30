#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Aug  1 11:56:11 2021

@author: TR
"""

### STRINGS

#####################################################################################################################################################
# Zweier-Päärchen aus einem String ziehen
s="The air is blue"
l=[]
for i in range(0,len(s),2):
    zweier=s[i:i+2]
    l.append(zweier)
print(l)
#####################################################################################################################################################
#  drei Buchst. schreiben(gross), drei auslassen, für neuen String
s = 'pwueofaevndakenadlkjaewqpnxmmmsncebewapadjsnjefhlajlajhliwsqapozujd'
news=""
for i in range(0, len(s), 6):
    news+=s[i:i+3]
    News=news.upper()
print(News)
#####################################################################################################################################################
#  Partition, man will nur der mittleren Teil
s = 'jnvhe***vnekjasbvk###jdndhdqv'
snew = s.partition('***')[2].partition('###')[0] # so schreiben, oder einzeln untereinander
print(snew)
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
#  die längste gemeinsame Sequenz finden
# >P00846 RecName: Full=ATP synthase subunit a; AltName: Full=F-ATPase protein 6;
s1 = "MNENLFASFIAPTILGLPAAVLIILFPPLLIPTSKYLINNRLITTQQWLIKLTSKQMMTMHNTKGRTWSLML" + \
    "VSLIIFIATTNLLGLLPHSFTPTTQLSMNLAMAIPLWAGTVIMGFRSKIKNALAHFLPQGTPTPLIPMLVII" + \
    "ETISLLIQPMALAVRLTANITAGHLLMHLIGSATLAMSTINLPSTLIIFTILILLTILEIAVALIQAYVFTLLVSLYLHDNT"
# >P33507 RecName: Full=ATP synthase subunit a; AltName: Full=F-ATPase protein 6;
s2 = "MMTNLFSVFDPSTTILNLSLNWLSTFLGLLLIPFSFWLLPNRFQVVWNNILLTLHKEFKTLLGPSGHNGS" + \
    "TLMFISLFSLIMFNNFLGLFPYIFTSTSHLTLTLALAFPLWLSFMLYGWINHTQHMFAHLVPQGTPPVLMP" + \
    "FMVCIETISNVIRPGTLAVRLTANMIAGHLLLTLLGNTGPMTTNYIILSLILTTQIALLVLESAVAIIQSYVFAVLSTLYSSEVN"
# Version 1
def dictate(seq,W):
    dic = {}
    for i in range(len(seq)-W+1):
        section = seq[i:i+W]
        if section in dic:
            dic[section].append(i)
        else:
            dic[section] = [i]
    return dic
def common(a,b,W):
    one = dictate(a,W)
    two = dictate(b,W)
    matches = []
    for key in one:
        if (key in two) and (key not in matches):
            matches.append(key)
    return matches    
W = 1
while True:
    com = common(s1,s2,W)
    if len(com) == 0:
        break
    com_long=com
    W += 1
print(com_long)     # ['LAVRLTAN']      # List of a String

# Version 2
s1="..."
s2="..."    
l1 = len(s1)    # weil die strings unterschiedliche Längen haben können
l2 = len(s2)    # weil die strings unterschiedliche Längen haben können
if l1 < l2:     # weil die strings unterschiedliche Längen haben können
    short = s1  # weil die strings unterschiedliche Längen haben können
    long = s2   # weil die strings unterschiedliche Längen haben können
else:           # weil die strings unterschiedliche Längen haben können
    short = s2  # weil die strings unterschiedliche Längen haben können
    long = s1   # weil die strings unterschiedliche Längen haben können
# it starts with the longest fragment and continues with smaller ones until it
# finds a match
found_seq = 0
for width in range(len(short),0,-1):        #loop to generate fragments lengths, wird immer länger (vom Ende her)
    for pos in range(len(long)-width+1):    #loop for generating slices of a sequence, 
                                            # wird entsprechend immer kürzer, beginnt wo die Position der gemeinsamen Sequenz beginnt
        if long[pos:pos+width] in short:
            print (long[pos:pos+width])
            found_seq = 1
            break
    if found_seq == 1:
        break       # LAVRLTAN      # String
        
# meine Version:
max=1
for i in range(len(s1)):
    for j in range(len(s2)):
        if s1[i:i+max]==s2[j:j+max]:
            long=s1[i-1:i+max] # i-1 weil max erst danach um +1 erweitert wird? also muss "der Start vorverschoben" werden?
            max+=1
        else:
            max+=0
print(long)     # LAVRLTAN

# meine zweite Version:
varlen=1
for i in range(len(s1)):
    for j in range(len(s2)):
#        if s1[i:i+varlen] in s2:  geht nicht...?
        if s1[i:i+varlen]==s2[j:j+varlen]:
            varlen+=1
            longest=s1[i-1:i+varlen-1] # alles um 1 Index zurück verschoben
print(longest)    
#####################################################################################################################################################
# String anhand von Listennummern neu schreiben
text = 'tgovoyd vlwucqk'
news=""
numbers = [3, 9, 7, 0, 9, 5, 7, 8, 2, 8, 3, 6, 7, 0, 6]
for i in range(len(numbers)):
    if numbers[i]>5:
        news+=text[i]
print(news)
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
# Strings neu geornet und formatiert
s='3. Roger Federer, aged 38; 21. Stan Wawrinka, aged 34; '+\
    '113. Henri Laaksonen, aged 27'
listOfPlayers=s.strip().split(";")
# print(listOfWords)       # ['3. Roger Federer, aged 38', ' 21. Stan Wawrinka, aged 34', ' 113. Henri Laaksonen, aged 27']
for player in listOfPlayers:
    sublistPlayer=player.split() # player muss gesplittet werden, nicht die listOfPlayers
#    print(sublistPlayer) # ['3.', 'Roger', 'Federer,', 'aged', '38']
#                           ['21.', 'Stan', 'Wawrinka,', 'aged', '34']
#                           ['113.', 'Henri', 'Laaksonen,', 'aged', '27']
    ranking=int(sublistPlayer[0][:-1]) # es muss ein int (wegen Formatierung später) sein, das -1 lässt den Punkt weg
    prename=sublistPlayer[1]
    surname=sublistPlayer[2][:-1]
    age=sublistPlayer[4]
    n=15-(len(prename)+len(surname)) # 25-10=15, fixe Satzzeichen
    nSpace=n*" "  # variable Spacerlänge
    stringPlayer=("{:3d}: "+prename+" "+surname+nSpace+"("+age+")").format(ranking) # die () nicht vergessen!!!!
    print(stringPlayer)   
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
    print(('{:.<10} {:>6d} ' + filler2 + ' {:>10d} ' + filler3).format(name+' ', diameter, distance)) # die () nicht vergessen!!!!
#####################################################################################################################################################
# Nomen aus Text rausholen und deren Positionen im Text, alles fromatiert
poem='Wanderer tritt still herein - \
    Schmerz versteinert nun die Schwelle - \
    da erglaenzt in reiner Helle - \
    auf dem Tische Brot und Wein.'
# remove all special characters:
abc = "abcdefghijklmnopqrstuvwxyz"
letters = "" # leerer String
for char in poem: 
    if char.lower() in abc:
        letters += char
    else:
        letters += " " # man bekommt so einen String mit lauter Kleinbuchstaben und Leerschlägen 
                        # zwischen den Worten, ohne Sonderzeichen
# split the cleaned poem:
words = letters.split() # split() ist eine String-Methode, words ist jetzt eine Liste
# find words starting with a capital letter and print in the required format:
linelength = 20
numberlength = 3 # --> "{:3d}".format()
spaces = 1 # das was nach dem Hauptwort folgt, noch vor den Sternen
for i, word in enumerate(words): # words ist eine Liste
    if word[0].upper() == word[0]: # kein else..., [0] bezieht sich auf den ersten Buchstaben in den Wörtern. 
                                    # upper macht ja alle Buchstaben gross, aber wenn der erste Buchstabe mit Index 0
                                    # gross ist, wie der des Vergleichswortes: dann ist es ein Nomen. 
        stars = "*"*(linelength - numberlength - spaces - len(word))
        s = (word + " " + stars + "{:3d}").format(i+1) # i+1, da das erste Wort mit 1 und nicht mit 0 anfängt, die () nicht vergessen!!!!
#        # alternative formatting:
#        s = '{:*<17}{:3d}'.format(word+' ', i) # da 17+3=20 (totale Anzahl der Characters)
        print(s) # in der if-Schleife, da man für jedes Hauptwort den Ausdruck möchte
# Wanderer ********  1
# Schmerz *********  5
# Schwelle ********  9
# Helle *********** 14
# Tische ********** 17
# Brot ************ 18
# Wein ************ 20
#####################################################################################################################################################
# häufigstes Wort in einem String-Text mit (Dict.-)Liste der Wort-Positionen und geänderte Text-Kopie
hand_wash = 'You wash your hands properly by first wetting your hands under \
running water, soaping and rubbing your hands together until you get a lather. \
Rinse your hands thoroughly with running water. Dry the hands, with a clean towel, \
if possible a disposable paper towel or a cloth roller towel.'

# split string at spaces
wordList_raw = hand_wash.split()

# 1. clean the words: remove special characters and change capitals to lower letters
# 2. create dictionary with the cleaned word as key and its positions in the string as values. 

# abc = 'qwertyuiopasdfghjklzxcvbnm '   # warum einen Leerschlag? Alphabeth ist einfach die Tastatur durchgefahren
abc="abcdefghijklmnopqrstuvwxyz"

words_positions = {}    # Tipp: immer dic verwenden, wenn etwas einmalig / unterschiedlich vorkommen soll (key)
for i, word_raw in enumerate(wordList_raw):
    word = ''
    for char in word_raw:
        if char.lower() in abc:
            word+=char.lower()   # Buchstaben concatenated, so hat man nur reine Wörter, ohne Zahlen oder Satzzeichen.
            
    if not word in words_positions: # so beginnt man ein Dictionary
        words_positions[word] = []  # so beginnt man ein Dictionary
    words_positions[word].append(i) # so beginnt man ein Dictionary zu füllen
print('Number of different words:', len(words_positions))

# find the most abundant cleaned word
max_times = 0
for word in words_positions:   
    n_times = len(words_positions[word])
    if  n_times > max_times:
        max_times = n_times         # so zählt man max_times hoch
        most_common_word = word     # da die Bedingung für most common für das max_times-Wort erfüllt ist   
print('Most common word:', most_common_word) 
print('Its positions in the text:', words_positions[most_common_word])

# highlight the most common words and their preceding (vorangehend) words by capital letters 
wordList_highlighted = 1*wordList_raw
for position in words_positions[most_common_word]:
    wordList_highlighted[position] = wordList_highlighted[position].upper()     # most common word
    wordList_highlighted[position-1] = wordList_highlighted[position-1].upper() # preceding word
hand_wash_highlighted = ' '.join(wordList_highlighted)          # aus Listen wird ein String
print(hand_wash_highlighted)
# Number of different words: 33
# Most common word: hands
# Its positions in the text: [3, 9, 17, 26, 33]
# You wash YOUR HANDS properly by first wetting YOUR HANDS under running water, soaping and rubbing YOUR HANDS together until you get a lather. Rinse YOUR HANDS thoroughly with running water. Dry THE HANDS, with a clean towel, if possible a disposable paper towel or a cloth roller towel.
#####################################################################################################################################################
#  Aufg.6 aus 2020/21, Basenhäufigkeit, Wahrscheinlichkeit in einer Gensequenz und Ort
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
#  

#####################################################################################################################################################
# 

#####################################################################################################################################################
#  