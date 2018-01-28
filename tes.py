# -*- coding: utf-8 -*-
"""
Created on Sat Jan 27 23:57:44 2018

@author: Asus
"""

import os
#from sys import exit
#import library 3rd numpy dan matplotlib pastikan install dulu
import numpy as np
import matplotlib.pyplot as plt
#import matplotlib.patches as mpatches

# I/O files path
path = 'data/'

# Read child's data (user input)
chdata = 'dataanthroboy.csv'

# Gender (male or female)
childfile = open(os.path.join(path,chdata))
inputline = childfile.readline()

# Age, weight, height, head circumference
charray = np.genfromtxt(os.path.join(path,chdata), delimiter=',', dtype = None, skip_header=2)
if inputline[7] == 'f':
    # read girls' (0-2) WHO charts
    # Read age vs length WHO data
    aldata = 'gz_age_length2_year.csv'
    alarray = np.loadtxt(os.path.join(path,aldata), delimiter=',', skiprows=1)
    fig, ax = plt.subplots(facecolor='pink')
    plt.title('Length\Height For Age GIRLS', loc='left')
else:
    aldata = 'bz_age_length2_year.csv'
    alarray = np.loadtxt(os.path.join(path,aldata), delimiter=',', skiprows=1)
    fig, ax = plt.subplots(facecolor='grey')
    plt.title('Length\Height For Age BOYS', loc='left')


ida = 0
lida = []
for row in charray:
    lrow = list(row)
    if lrow[9] == 0:
        lida.append(ida)
    ida +=1
normal=np.zeros([len(lida),10])

for i,val in zip(range(len(lida)),lida):
    normal[i]=charray[val]
    
idb = 0
lidb = []
for row in charray:
    lrow = list(row)
    if lrow[9] == 1:
        lidb.append(idb)
    idb +=1
#for val in lida:
#    print(a[val])
movein=np.zeros([len(lidb),10])

for i,val in zip(range(len(lidb)),lidb):
    movein[i]=charray[val]

idc = 0
lidc = []
for row in charray:
    lrow = list(row)
    if lrow[9] == 2:
        lidc.append(idc)
    idc +=1
#for val in lida:
#    print(a[val])
moveout=np.zeros([len(lidc),10])

for i,val in zip(range(len(lidc)),lidc):
    moveout[i]=charray[val]

idd = 0
lidd = []
for row in charray:
    lrow = list(row)
    if lrow[9] == 3:
        lidd.append(idd)
    idd +=1
#for val in lida:
#    print(a[val])
persistent=np.zeros([len(lidd),10])

for i,val in zip(range(len(lidd)),lidd):
    persistent[i]=charray[val]

#normal
plt.subplot(2,2,1)
col_arr = []
n_stunting, n_normal = 0,0
for c in normal[:,2]:
        col_arr.append('b')
        n_normal = n_normal + 1
        
plt.title('1-7 year', loc='right')
    #plot dengan method plot        
plt.plot(list(alarray[:,0]),list(alarray[:,1]),'r--')
plt.plot(list(alarray[:,0]),list(alarray[:,2]),'r--')
plt.plot(list(alarray[:,0]),list(alarray[:,3]),'g--')
plt.plot(list(alarray[:,0]),list(alarray[:,4]),'k-')
plt.plot(list(alarray[:,0]),list(alarray[:,5]),'g--')
plt.plot(list(alarray[:,0]),list(alarray[:,6]),'g--')
plt.plot(list(alarray[:,0]),list(alarray[:,7]),'g--')
    #plot dengan menggunakan scatter
plt.scatter(list(normal[:,3]),list(normal[:,1]), c=col_arr, marker='o',s=3)
plt.scatter(list(normal[:,7]),list(normal[:,5]), c=col_arr, marker='o',s=3) 
  #memberi penamaan garis standar deviasi (labelling)
plt.text(alarray[96,0], alarray[96,1],'-3',fontsize=10)
plt.text(alarray[96,0], alarray[96,2],'-2',fontsize=10)
plt.text(alarray[96,0], alarray[96,3],'-1',fontsize=10)
plt.text(alarray[96,0], alarray[96,5],'1',fontsize=10)
plt.text(alarray[96,0], alarray[96,6],'2',fontsize=10)
plt.text(alarray[96,0], alarray[96,7],'3',fontsize=10)
from matplotlib.lines import Line2D

legend_elements = [Line2D([0], [0], linestyle='--',color='red',  label='Batas Stunting'),
                   Line2D([0], [0], color='green', linestyle='--', label='Batas Normal'),
                   Line2D([0], [0], marker='o', color='black', label='Stunting Individu IFLS 4 & IFLS 5 : %d' %(n_stunting), markersize=2),
                   Line2D([0], [0], marker='o', color='blue', label='Normal Individu IFLS4 & IFLS5 : %d ' %(n_normal) , markersize=2) ]
plt.legend(handles=legend_elements, loc='upper left')

plt.grid(True)
plt.xlabel('age [years]')
plt.ylabel('length [cm]')
plt.xlim([0,15])
plt.ylim([0,200])
plt.xticks(np.arange(0,15,1))
plt.yticks(np.arange(0,200,10))
plt.figtext(0.01, 0.01, 'Source: IFLS4 & IFLS 5', horizontalalignment='left')

#movein
plt.subplot(2,2,2)
col_arr2,col_arr3 = [],[]
n_stunting, n_normal = 0,0
for c in movein[:,2]:
    if c == 1.0:
       col_arr2.append('black')
       n_stunting = n_stunting + 1
    else:
       col_arr2.append('b')
       n_normal = n_normal + 1
for d in movein[:,6]:
    if d == 1.0:
       col_arr3.append('black')
       n_stunting = n_stunting + 1
    else:
       col_arr3.append('b')
       n_normal = n_normal + 1 
       
plt.title('1-7 year', loc='right')
    #plot dengan method plot        
plt.plot(list(alarray[:,0]),list(alarray[:,1]),'r--')
plt.plot(list(alarray[:,0]),list(alarray[:,2]),'r--')
plt.plot(list(alarray[:,0]),list(alarray[:,3]),'g--')
plt.plot(list(alarray[:,0]),list(alarray[:,4]),'k-')
plt.plot(list(alarray[:,0]),list(alarray[:,5]),'g--')
plt.plot(list(alarray[:,0]),list(alarray[:,6]),'g--')
plt.plot(list(alarray[:,0]),list(alarray[:,7]),'g--')
    #plot dengan menggunakan scatter
plt.scatter(list(movein[:,3]),list(movein[:,1]), c=col_arr2, marker='o',s=3)
plt.scatter(list(movein[:,7]),list(movein[:,5]), c=col_arr3, marker='o',s=3) 
  #memberi penamaan garis standar deviasi (labelling)
plt.text(alarray[96,0], alarray[96,1],'-3',fontsize=10)
plt.text(alarray[96,0], alarray[96,2],'-2',fontsize=10)
plt.text(alarray[96,0], alarray[96,3],'-1',fontsize=10)
plt.text(alarray[96,0], alarray[96,5],'1',fontsize=10)
plt.text(alarray[96,0], alarray[96,6],'2',fontsize=10)
plt.text(alarray[96,0], alarray[96,7],'3',fontsize=10)
from matplotlib.lines import Line2D

legend_elements = [Line2D([0], [0], linestyle='--',color='red',  label='Batas Stunting'),
                   Line2D([0], [0], color='green', linestyle='--', label='Batas Normal'),
                   Line2D([0], [0], marker='o', color='black', label='Stunting Individu IFLS 4 & IFLS 5 : %d' %(n_stunting), markersize=2),
                   Line2D([0], [0], marker='o', color='blue', label='Normal Individu IFLS4 & IFLS5 : %d ' %(n_normal) , markersize=2) ]
plt.legend(handles=legend_elements, loc='upper left')

plt.grid(True)
plt.xlabel('age [years]')
plt.ylabel('length [cm]')
plt.xlim([0,15])
plt.ylim([0,200])
plt.xticks(np.arange(0,15,1))
plt.yticks(np.arange(0,200,10))
plt.figtext(0.01, 0.01, 'Source: IFLS4 & IFLS 5', horizontalalignment='left')
plt.show()