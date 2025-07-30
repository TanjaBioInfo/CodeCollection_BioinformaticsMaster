#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Aug  1 12:00:09 2021

@author: TR
"""

### ARRAYS

#####################################################################################################################################################
#  Arrays mit 0.1 addieren
# with slicing
import numpy as np
def add_to_array(ar):
    arnew = 1*ar
    arnew[1:-1, 1:-1] += 0.1 # man muss sich das wirklich als Bild vorstellen:[mitteler Zeile : Spalte
# Spalte 1 und 2 (von total 3)], das sind dann auch die Pixel, die nicht am Rand sind
    return arnew
a = np.array([[0.1, 0.4, 0.2, 0.5], [0.6, 0.7, 0.5, 0.3], [0.9, 0.2, 0.2, 0.8]])
#a = np.array([[0.13, 0.31, 0.49, 0.66, 0.63], [0.81, 0.26, 0.67, 0.31, 0.29], [0.89, 0.62, 0.34, 0.64, 0.52], [0.54, 0.48, 0.28, 0.52, 0.51]])
anew = add_to_array(a)
print(anew)
# [[0.1 0.4 0.2 0.5]
#  [0.6 0.8 0.6 0.3]
#  [0.9 0.2 0.2 0.8]]
print(np.sum(anew)) # sum in einem Array verlangt noch ein np davor

# with looping
import numpy as np
def add_to_array(ar):
    arnew = 1*ar
    h, w = arnew.shape # KEINE Klammer
    for y in range(1,h-1):
        for x in range(1,w-1):
            arnew[y, x] += 0.1
    return arnew
a = np.array([[0.1, 0.4, 0.2, 0.5], [0.6, 0.7, 0.5, 0.3], [0.9, 0.2, 0.2, 0.8]])
#a = np.array([[0.13, 0.31, 0.49, 0.66, 0.63], [0.81, 0.26, 0.67, 0.31, 0.29], [0.89, 0.62, 0.34, 0.64, 0.52], [0.54, 0.48, 0.28, 0.52, 0.51]])
anew = add_to_array(a)
print(np.sum(anew)) # sum in einem Array verlangt noch ein np davor, 5.6000000000000005
#####################################################################################################################################################
#  Arrays versetzt miteinander kombinieren
# with slicing
import numpy as np
a = np.array([[0.1, 0.3, 0.2, 0.5], [0.5, 0.5, 0.4, 0.3], [0.4, 0.1, 0.1, 0.1]])
# a = np.array([[0.13, 0.31, 0.49, 0.36, 0.43], [0.21, 0.46, 0.27, 0.31, 0.29], [0.09, 0.42, 0.34, 0.34, 0.42], [0.14, 0.48, 0.28, 0.42, 0.31]])
def shift_and_add(a):
    newa=a[:-1, :] + a[1:, :] # wenn newa keine [] hat, muss man es nicht zuerst def. (mit newa=1*a)
# es geht auch newa= a[:2, :] + a[1:, :], beim kleinen array,newa=a[:3, :] + a[1:, :] 
# beim grossen array, aber besser und allgemeiner ist: newa=a[:-1, :] + a[1:, :]
    return newa
anew = shift_and_add(a)
print(anew)
# [[0.6 0.8 0.6 0.8]
#  [0.9 0.6 0.5 0.4]]
print(np.sum(anew))  # sum in einem Array verlangt noch ein np davor, 5.199999999999999

# with looping
import numpy as np
a = np.array([[0.1, 0.3, 0.2, 0.5], [0.5, 0.5, 0.4, 0.3], [0.4, 0.1, 0.1, 0.1]])
def shift_and_add(a):
    height, wide = a.shape # KEINE Klammer
    newa = np.zeros(shape=(height-1, wide)) # doppelte Klammer
    for y in range(height-1):
        for x in range(wide):
            newa[y, x] = a[y, x] + a[y+1, x]
    return newa
anew = shift_and_add(a)
print(anew)
print(np.sum(anew))    # sum in einem Array verlangt noch ein np davor     

# auch slicing
import numpy as np
a = np.array([[0.1, 0.3, 0.2, 0.5], [0.5, 0.5, 0.4, 0.3], [0.4, 0.1, 0.1, 0.1]])
def shift_and_add(a):
    newa=np.zeros((int(len(a)-1), 4))
    # for zeile in range(len(a)-1):
    #     for spalte in range(zeile):
    newa[:1, :]=a[:1, :]+a[1, :]
    newa[1, :]=a[1, :]+a[-1, :]
    return newa
anew = shift_and_add(a)
print(anew)
#####################################################################################################################################################
# Aim: create the following array:
# [[ 0.  1.  0.  0.]
#  [ 0.  0.  2.  0.]
#  [ 0.  0.  0.  3.]]
import numpy as np
anew = np.zeros(shape=(3,4)) # doppelte Klammer  #1: create array with zeros, geht auch mit np.zeros([3,4]), es ist by default dtype=float.
for i in range(len(anew)):
    anew[i,i+1] = i + 1   #2: define non-zero values by replacing the points by code. Oder: anew[i][i+1]=i+1
                                # so bei zero-Array verändert, i bezieht sich auf die Zeilen.
print(anew)
#####################################################################################################################################################
#  Dilatation 3D-Array (erste und zweite / zweite und dritte Spalte->max-Wert, dritte belassen)
import numpy as np
im = np.array([[[0.6,0.5,0.7],[0.0,0.3,0.2],[0.7,0.5,0.1]],\
               [[0.4,0.8,0.7],[0.5,0.3,0.2],[0.6,0.5,0.3]],\
               [[0.7,0.7,0.6],[0.8,0.4,0.3],[0.4,0.8,0.3]]])
def special_dilation(im):
    im_new=1*im     # einfachste Lösung, ohne np.zeros(())
    for i in range(len(im)): # bezieht sich auf alle drei Blöcke (3D-Array)
        for j in range(len(im[i])-1): # bez. auf Zeile (3D-Array), weil man nur die ersten zwei der total drei Zeilen des newa manipulieren will
            for k in range(len(im[j+1])):  # es geht auch in range(3):
                im_new[i,j,k]=max(im[i,j,k],im[i,j+1,k]) # so merken: max(a[] , a[])
    return (im_new)   
im_new = special_dilation(im)
print (im_new)
print (np.sum(im_new))
# [[[ 0.6  0.5  0.7]
#   [ 0.7  0.5  0.2]
#   [ 0.7  0.5  0.1]]

#  [[ 0.5  0.8  0.7]
#   [ 0.6  0.5  0.3]
#   [ 0.6  0.5  0.3]]

#  [[ 0.8  0.7  0.6]
#   [ 0.8  0.8  0.3]
#   [ 0.4  0.8  0.3]]]
# 14.800000000000002
#####################################################################################################################################################
# zwei arrays "verschoben zusammen zählen", slicing (einfacher als for-Schleife)
import numpy as np
a1=np.array([5,8,2,3,6])
a2=np.array([9,4,6,12,5])
newa=1*a1 # newa=np.zeros((len(a1)), dtype=int) geht auch, danach vielleicht eher mit for i in range(len(a1)-1) weiter machen
newa[:-1]=a1[:-1]+a2[1:]
newa[-1]=a1[-1]+a2[0]
print(newa)
#####################################################################################################################################################
# von 3D-Array (b,z,s) durch eine Rechen-OP zu 2D-Array (z,s), 
# wobei über die zweite Achse (z) addiert wird, also diese entfällt (b,z,s)->(b,s)
# Slicing (direkt und einfach)
import numpy as np
a = np.array([[[0.4, 2.8, 0.6, 0.1], [1.4, 3.2, 0.8, 6.5]], 
              [[2.7, 3.4, 1.7, 0.2], [9.2, 2.8, 3.6, 6.6]], 
              [[5.2, 4.8, 8.6, 9.1], [2.7, 4.3, 1.1, 2.9]]])
def sums(a):
    b,z,s=a.shape
    newa=np.zeros((b,s))
    newa[:,:]=a[:,0,:]+a[:,1,:]
    return newa
sums_array = sums(a)
print(sums_array)  
# [[ 1.8  6.   1.4  6.6]
#  [11.9  6.2  5.3  6.8]
#  [ 7.9  9.1  9.7 12. ]]  
# single loop
import numpy as np
a = np.array([[[0.4, 2.8, 0.6, 0.1], [1.4, 3.2, 0.8, 6.5]], 
    [[2.7, 3.4, 1.7, 0.2], [9.2, 2.8, 3.6, 6.6]], 
    [[5.2, 4.8, 8.6, 9.1], [2.7, 4.3, 1.1, 2.9]]])
def sums(a):
    sums_array = a[:,0,:]               # (3,2,4)=a.shape, nicht umgekehrt herum schreiben
    for i in range(1, a.shape[1]):      # range(1,2)? würde nur range 1 sein?
        sums_array += a[:,i,:]
    return(sums_array)
sums_array = sums(a)
print(sums_array)
# double loop
import numpy as np
a=np.array([[[]]])
def sums(a):
    d1, d2, d3 = a.shape  #KEINE Klammer  # (3,2,4)=a.shape, nicht umgekehrt herum schreiben, sonst ist d1,d2,d3 nicht definiert
    new_array = np.zeros((d1,d3)) # doppelte Klammer  # so verlangt es die Aufgabe, shape=(3,4), beachte dei doppelte Klammer
    for i in range(d1):
        for j in range(d3):
            new_array[i,j] = sum(a[i,:,j]) # so darf man sum verwenden, sonst in Prüfung verboten (hier: np.sum verboten)
    return new_array
sums_array = sums(a)
print(sums_array)
# triple loop
import numpy as np
a=np.array([[[]]])
def sums(a):
    d1, d2, d3 = a.shape               # (3,2,4)=a.shape, nicht umgekehrt herum schreiben
    new_array = np.zeros((d1,d3))      # so verlangt es die Aufgabe, shape=(3,4), beachte dei doppelte Klammer
    for i in range(d1):
        for j in range(d2):
            for k in range(d3):
                new_array[i,k] += a[i,j,k] # Arrays darf man in einer []-Klammer schreiben <-> ListsOfLists
    return new_array
sums_array = sums(a)
print(sums_array)
#####################################################################################################################################################
#  von der for-Schleife zur Slice-Form bei einem Array
import numpy as np
def La(prot):
    N = len(prot)
    dprot = np.zeros(N)
#    for i in range(1,N-1):
#        dprot[i] = -2*prot[i] + prot[i-1] + prot[i+1]
    dprot[1:N-1]=-2*prot[1:N-1]+prot[:N-2]+prot[2:N]
    dprot[0] = -prot[0] + prot[1]
    dprot[-1] = -prot[-1] + prot[-2]
    return dprot 
N = 20
np.random.seed(0)
a = np.zeros(N) + 1 + 0.3 * np.random.rand(N)
print(La(a))
#####################################################################################################################################################
# kombiniere zwei 2D-Arrays
import numpy as np
raw = np.array([[6, 5, 2, 5, 7, 6, 1, 11, 13, 3, 1, 1, 5],
                [4, 6, 56, 69, 51, 21, 3, 63, 59, 69, 7, 3, 2],
                [0, 60, 71, 62, 56, 76, 3, 60, 23, 45, 60, 2, 5],
                [10, 68, 64, 60, 56, 66, 12, 69, 19, 21, 62, 30, 7],
                [7, 63, 59, 59, 67, 74, 15, 64, 20, 23, 27, 72, 6],
                [3, 14, 75, 72, 59, 71, 16, 56, 43, 25, 23, 62, 11],
                [2, 10, 31, 65, 74, 28, 14, 11, 60, 68, 65, 18, 3],
                [5, 7, 3, 6, 9, 4, 11, 3, 4, 10, 5, 5, 1]])
segmented = np.array([[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	0, 0], 
                      [0, 0, 30, 30, 30, 0, 0, 38, 38, 38, 0, 0, 0],
                      [0, 30, 30, 30, 30, 30, 0, 38, 38, 38, 38, 0, 0],
                      [0, 30, 30, 30, 30, 30, 0, 38, 38, 38, 38, 0, 0],
                      [0, 30, 30, 30, 30, 30, 0, 38, 38, 38, 38, 38, 0],
                      [0, 0, 30, 30, 30, 30, 0, 38, 38, 38, 38, 38, 0],
                      [0, 0, 0, 30, 30, 0, 0, 0, 38, 38, 38, 0, 0],
                      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]])
# create list with cell ids
cells = []
for i in range(segmented.shape[0]):     # universeller Zugang zu Zeilen, merken!!!!!
    for j in range(segmented.shape[1]): # universeller Zugang zu Spalten, merken!!!!!
        if segmented[i,j] > 0:
            if not segmented[i,j] in cells:
                cells.append(segmented[i,j])
# determine for each cell pixel the number of neighboring background pixels
bg_counts = 0*segmented
for i in range(segmented.shape[0]):
    for j in range(segmented.shape[1]):
        if segmented[i,j] > 0:            
            neighboring_pixels = [segmented[i-1,j], segmented[i+1,j], \
                                  segmented[i,j-1], segmented[i,j+1]]      # generell für Nachbarpixel
            for p in neighboring_pixels:
                if p == 0:
                    bg_counts[i,j] += 1
# create numpy arrays of the same dimensions as the input array but 
# with cell ids only at the cell boundaries (boundary) or inside the cell (inside)
boundary = 1*segmented
boundary[bg_counts == 0] = 0
inside = segmented-boundary
# calculate all measures for each cell and print the results in the requested order:
# cell number, cell area, mean intensity of cell boundary, mean intensity of cell inside, 
# ratio of mean inside / mean boundary, cell circumference
for cell in cells:  
    cell_area = len(segmented[segmented == cell])   # innerhalb des Index ein == Vergleich...?
    inside_area = len(inside[inside == cell])
    boundary_area = len(boundary[boundary == cell])    
    mean_inside = sum(raw[inside == cell])/inside_area
    mean_boundary = sum(raw[boundary == cell])/boundary_area    
    circumference = sum(bg_counts[segmented == cell])    
    print(cell, cell_area, mean_boundary, mean_inside, mean_inside/mean_boundary, circumference)
# 30 24 66.76923076923077 62.27272727272727 0.9326560536237956 22
# 38 24 63.5 26.9 0.42362204724409447 22
#####################################################################################################################################################
# aus 3D-Array ein 2D-Array (mit min.Werten) machen
import numpy as np
im = np.array(
[[[0.7, 0.4, 0.2], [0.5, 0.8, 0.8], [0.1, 0.9, 0.2], [0.3, 0.4, 0.5]], 
[[0.7, 0.3, 0.2], [0.4, 0.4, 0.8], [0.1, 0.8, 0.3], [0.9, 0.9, 0.3]]]) 
zeile, spalte, RGB = im.shape # wichtig: nach shape KEINE (), sonst geht die Tupelzuweisung nicht
newa=np.zeros((zeile, spalte)) # wichtig: DOPPELTE Klammern ((..))
min=1
for i_zeile in range(zeile): # ohne len(), man will den index
    for i_spalte in range(spalte): # ohne len(), man will den Index
        # min=1     besser wenn es hier steht?
        for i_RGB in im[i_zeile, i_spalte]: # man will den Wert, die indices der oberen for-schleife verwenden, [] verwenden
            if i_RGB<min:
                min=i_RGB
        newa[i_zeile, i_spalte]=min # nur =min, ist wie Zuweisung zu einem Wert/value
print(newa)
#####################################################################################################################################################
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
#  

#####################################################################################################################################################
# 

#####################################################################################################################################################
#  