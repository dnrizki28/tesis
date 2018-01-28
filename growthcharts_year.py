# -*- coding: utf-8 -*-
"""
Created on Fri Jan 26 10:25:55 2018

@author: Asus
"""
#created by : Dina Rizkiani

# Graphical assessment of a child's development 
# according to the World Health Organization growth standards 

# -------------------------------------

# Import libraries
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
####################################################
# Plots
#plt.figure()

#inputline[9]=0 --> data wave 4
#inputline[9]=1 --> data wave 5
#inputline[9]=2 --> gabung wave 4 dan wave 5
#inputline[9]=3 --> by kohort kelahiran
if inputline[9] == '0':
    # Z Score Age vs length 
    col_arr = []
    n_stunting, n_normal = 0,0

    for c in charray[:,2]:
        if c == 1.0:
            col_arr.append('black')
            n_stunting = n_stunting + 1
        else:
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
    plt.scatter(list(charray[:,3]),list(charray[:,1]), c=col_arr, marker='o',s=3)
    #memberi penamaan garis standar deviasi (labelling)
    plt.text(alarray[96,0], alarray[96,1],'-3',fontsize=10)
    plt.text(alarray[96,0], alarray[96,2],'-2',fontsize=10)
    plt.text(alarray[96,0], alarray[96,3],'-1',fontsize=10)
    plt.text(alarray[96,0], alarray[96,5],'1',fontsize=10)
    plt.text(alarray[96,0], alarray[96,6],'2',fontsize=10)
    plt.text(alarray[96,0], alarray[96,7],'3',fontsize=10)

    #Edit LEGEND SETTING
    #L=plt.legend()
    #L.get_texts()[0].set_text('make it short')
    #plt.legend(loc='upper center', bbox_to_anchor=(0.5, 1.05), ncol=3,fancybox=True, shadow=True)
    #red_patch = mpatches.Patch(color='red', linestyle='--', label='The red data')
    #
    #plt.legend(handles=[red_patch])
    from matplotlib.lines import Line2D

    legend_elements = [Line2D([0], [0], linestyle='--',color='red',  label='Batas Stunting'),
                   Line2D([0], [0], color='green', linestyle='--', label='Batas Normal'),
                   Line2D([0], [0], marker='o', color='black', label='Stunting Individu : %d' % n_stunting , markersize=10),
                   Line2D([0], [0], marker='o', color='blue', label='Normal Individu : %d'% n_normal , markersize=10) ]
    plt.legend(handles=legend_elements, loc='upper left')

    plt.grid(True)
    plt.xlabel('age [years]')
    plt.ylabel('length [cm]')
    plt.xlim([0.5,8])
    plt.ylim([10,190])
    plt.xticks(np.arange(0,8,1))
    plt.yticks(np.arange(10,190,10))
    plt.figtext(0.01, 0.01, 'Source: IFLS 4', horizontalalignment='left')
elif inputline[9]=='1':
        # Z Score Age vs length 
    col_arr = []
    n_stunting, n_normal = 0,0

    for c in charray[:,6]:
        if c == 1.0:
            col_arr.append('black')
            n_stunting = n_stunting + 1
        else:
            col_arr.append('b')
            n_normal = n_normal + 1
            
    plt.title('8-14 tahun', loc='right')
    #plot dengan method plot        
    plt.plot(list(alarray[:,0]),list(alarray[:,1]),'r--')
    plt.plot(list(alarray[:,0]),list(alarray[:,2]),'r--')
    plt.plot(list(alarray[:,0]),list(alarray[:,3]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,4]),'k-')
    plt.plot(list(alarray[:,0]),list(alarray[:,5]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,6]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,7]),'g--')
    #plot dengan menggunakan scatter
    plt.scatter(list(charray[:,7]),list(charray[:,5]), c=col_arr, marker='o',s=6)
    #memberi penamaan garis standar deviasi (labelling)
    plt.text(alarray[180,0], alarray[180,1],'-3',fontsize=10)
    plt.text(alarray[180,0], alarray[180,2],'-2',fontsize=10)
    plt.text(alarray[180,0], alarray[180,3],'-1',fontsize=10)
    plt.text(alarray[180,0], alarray[180,5],'1',fontsize=10)
    plt.text(alarray[180,0], alarray[180,6],'2',fontsize=10)
    plt.text(alarray[180,0], alarray[180,7],'3',fontsize=10)

    #Edit LEGEND SETTING
    #L=plt.legend()
    #L.get_texts()[0].set_text('make it short')
    #plt.legend(loc='upper center', bbox_to_anchor=(0.5, 1.05), ncol=3,fancybox=True, shadow=True)
    #red_patch = mpatches.Patch(color='red', linestyle='--', label='The red data')
    #
    #plt.legend(handles=[red_patch])
    from matplotlib.lines import Line2D

    legend_elements = [Line2D([0], [0], linestyle='--',color='red',  label='Batas Stunting'),
                   Line2D([0], [0], color='green', linestyle='--', label='Batas Normal'),
                   Line2D([0], [0], marker='o', color='black', label='Stunting Individu : %d' % n_stunting , markersize=10),
                   Line2D([0], [0], marker='o', color='blue', label='Normal Individu : %d'% n_normal , markersize=10) ]
    plt.legend(handles=legend_elements, loc='upper left')

    plt.grid(True)
    plt.xlabel('age [months]')
    plt.ylabel('length [cm]')
    plt.xlim([7,15])
    plt.ylim([80,200])
    plt.xticks(np.arange(7,15,1))
    plt.yticks(np.arange(80,200,10))
    plt.figtext(0.01, 0.01, 'Source: IFLS 5', horizontalalignment='left')
elif inputline[9]=='2':
    col_arr = []
    n_stunting, n_normal = 0,0

    for c in charray[:,2]:
        if c == 1.0:
            col_arr.append('black')
            n_stunting = n_stunting + 1
        else:
            col_arr.append('b')
            n_normal = n_normal + 1
            
    col_arr2 = []
    n_stunting2, n_normal2 = 0,0

    for d in charray[:,6]:
        if d == 1.0:
            col_arr2.append('black')
            n_stunting2 = n_stunting2 + 1
        else:
            col_arr2.append('b')
            n_normal2 = n_normal2 + 1
            
    plt.title('1-7 years & 8-14 years', loc='right')
    #plot dengan method plot        
    plt.plot(list(alarray[:,0]),list(alarray[:,1]),'r--')
    plt.plot(list(alarray[:,0]),list(alarray[:,2]),'r--')
    plt.plot(list(alarray[:,0]),list(alarray[:,3]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,4]),'k-')
    plt.plot(list(alarray[:,0]),list(alarray[:,5]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,6]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,7]),'g--')
    #plot dengan menggunakan scatter
    plt.scatter(list(charray[:,3]),list(charray[:,1]), c=col_arr, marker='o',s=6)
    plt.scatter(list(charray[:,7]),list(charray[:,5]), c=col_arr2, marker='o',s=6)
    #memberi penamaan garis standar deviasi (labelling)
    plt.text(alarray[180,0], alarray[180,1],'-3',fontsize=10)
    plt.text(alarray[180,0], alarray[180,2],'-2',fontsize=10)
    plt.text(alarray[180,0], alarray[180,3],'-1',fontsize=10)
    plt.text(alarray[180,0], alarray[180,5],'1',fontsize=10)
    plt.text(alarray[180,0], alarray[180,6],'2',fontsize=10)
    plt.text(alarray[180,0], alarray[180,7],'3',fontsize=10)

    #Edit LEGEND SETTING
    #L=plt.legend()
    #L.get_texts()[0].set_text('make it short')
    #plt.legend(loc='upper center', bbox_to_anchor=(0.5, 1.05), ncol=3,fancybox=True, shadow=True)
    #red_patch = mpatches.Patch(color='red', linestyle='--', label='The red data')
    #
    #plt.legend(handles=[red_patch])
    from matplotlib.lines import Line2D

    legend_elements = [Line2D([0], [0], linestyle='--',color='red',  label='Batas Stunting'),
                   Line2D([0], [0], color='green', linestyle='--', label='Batas Normal'),
                   Line2D([0], [0], marker='o', color='black', label='Stunting Individu IFLS 4 & IFLS 5 : %d & %d' %(n_stunting,n_stunting2), markersize=10),
                   Line2D([0], [0], marker='o', color='blue', label='Normal Individu IFLS4 & IFLS5 : %d & %d' %(n_normal,n_normal2) , markersize=10) ]
    plt.legend(handles=legend_elements, loc='upper left')

    plt.grid(True)
    plt.xlabel('age [years]')
    plt.ylabel('length [cm]')
    plt.xlim([0,15])
    plt.ylim([0,200])
    plt.xticks(np.arange(0,15,1))
    plt.yticks(np.arange(0,200,10))
    plt.figtext(0.01, 0.01, 'Source: IFLS4 & IFLS 5', horizontalalignment='left')
elif inputline[9]=='3':
    col_arr = []
    n_stunting, n_normal,n_stunting2,n_normal2 = 0,0,0,0

    for c in charray[:,8]:
        if c == 2000.0:
            col_arr.append('black')
        elif c == 2001.0:
            col_arr.append('blue')
        elif c == 2002.0:
            col_arr.append('green')
        elif c == 2003.0:
            col_arr.append('yellow')
        elif c == 2004.0:
            col_arr.append('purple')
        elif c == 2005.0:
            col_arr.append('orange')
        elif c == 2006.0:
            col_arr.append('brown')
        else:
            col_arr.append('pink')
            
    for d in charray[:,2]:
        if d == 1.0:
            n_stunting = n_stunting + 1
        else:
            n_normal = n_normal + 1
    
    for e in charray[:,6]:
        if e == 1.0:
            n_stunting2 = n_stunting2 + 1
        else:
            n_normal2 = n_normal2 + 1
            
    plt.title('1-7 years & 8-14 years', loc='right')
    #plot dengan method plot        
    plt.plot(list(alarray[:,0]),list(alarray[:,1]),'r--')
    plt.plot(list(alarray[:,0]),list(alarray[:,2]),'r--')
    plt.plot(list(alarray[:,0]),list(alarray[:,3]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,4]),'k-')
    plt.plot(list(alarray[:,0]),list(alarray[:,5]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,6]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,7]),'g--')
    #plot dengan menggunakan scatter
    plt.scatter(list(charray[:,3]),list(charray[:,1]), c=col_arr, marker='o',s=3)
    plt.scatter(list(charray[:,7]),list(charray[:,5]), c=col_arr, marker='o',s=3)
    #memberi penamaan garis standar deviasi (labelling)
    plt.text(alarray[180,0], alarray[180,1],'-3',fontsize=10)
    plt.text(alarray[180,0], alarray[180,2],'-2',fontsize=10)
    plt.text(alarray[180,0], alarray[180,3],'-1',fontsize=10)
    plt.text(alarray[180,0], alarray[180,5],'1',fontsize=10)
    plt.text(alarray[180,0], alarray[180,6],'2',fontsize=10)
    plt.text(alarray[180,0], alarray[180,7],'3',fontsize=10)

    #Edit LEGEND SETTING
    #L=plt.legend()
    #L.get_texts()[0].set_text('make it short')
    #plt.legend(loc='upper center', bbox_to_anchor=(0.5, 1.05), ncol=3,fancybox=True, shadow=True)
    #red_patch = mpatches.Patch(color='red', linestyle='--', label='The red data')
    #
    #plt.legend(handles=[red_patch])
    from matplotlib.lines import Line2D

    legend_elements = [Line2D([0], [0], linestyle='--',color='red',  label='Batas Stunting'),
                   Line2D([0], [0], color='green', linestyle='--', label='Batas Normal'),
                   Line2D([0], [0], marker='o', color='black', label='Stunting Individu IFLS 4 & IFLS 5 : %d & %d' %(n_stunting,n_stunting2), markersize=10),
                   Line2D([0], [0], marker='o', color='blue', label='Normal Individu IFLS4 & IFLS5 : %d & %d' %(n_normal,n_normal2) , markersize=10) ]
    plt.legend(handles=legend_elements, loc='upper left')

    plt.grid(True)
    plt.xlabel('age [years]')
    plt.ylabel('length [cm]')
    plt.xlim([0,15])
    plt.ylim([0,200])
    plt.xticks(np.arange(0,15,1))
    plt.yticks(np.arange(0,200,10))
    plt.figtext(0.01, 0.01, 'Source: IFLS4 & IFLS 5', horizontalalignment='left')
else:
    
    col_arr = []
    n_stunting, n_normal,n_stunting2,n_normal2 = 0,0,0,0

    for c in charray[:,9]:
        if c == 0:
            col_arr.append('green')
        elif c == 1:
            col_arr.append('blue')
        elif c == 2:
            col_arr.append('black')
        else:
            col_arr.append('red')
            
    for d in charray[:,2]:
        if d == 1.0:
            n_stunting = n_stunting + 1
        else:
            n_normal = n_normal + 1
    
    for e in charray[:,6]:
        if e == 1.0:
            n_stunting2 = n_stunting2 + 1
        else:
            n_normal2 = n_normal2 + 1
            
    plt.title('1-7 years & 8-14 years', loc='right')
    #plot dengan method plot        
    plt.plot(list(alarray[:,0]),list(alarray[:,1]),'r--')
    plt.plot(list(alarray[:,0]),list(alarray[:,2]),'r--')
    plt.plot(list(alarray[:,0]),list(alarray[:,3]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,4]),'k-')
    plt.plot(list(alarray[:,0]),list(alarray[:,5]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,6]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,7]),'g--')
    #plot dengan menggunakan scatter
    plt.scatter(list(charray[:,3]),list(charray[:,1]), c=col_arr, marker='o',s=6)
    plt.scatter(list(charray[:,7]),list(charray[:,5]), c=col_arr, marker='o',s=6)
    #memberi penamaan garis standar deviasi (labelling)
    plt.text(alarray[180,0], alarray[180,1],'-3',fontsize=10)
    plt.text(alarray[180,0], alarray[180,2],'-2',fontsize=10)
    plt.text(alarray[180,0], alarray[180,3],'-1',fontsize=10)
    plt.text(alarray[180,0], alarray[180,5],'1',fontsize=10)
    plt.text(alarray[180,0], alarray[180,6],'2',fontsize=10)
    plt.text(alarray[180,0], alarray[180,7],'3',fontsize=10)

    #Edit LEGEND SETTING
    #L=plt.legend()
    #L.get_texts()[0].set_text('make it short')
    #plt.legend(loc='upper center', bbox_to_anchor=(0.5, 1.05), ncol=3,fancybox=True, shadow=True)
    #red_patch = mpatches.Patch(color='red', linestyle='--', label='The red data')
    #
    #plt.legend(handles=[red_patch])
    from matplotlib.lines import Line2D

    legend_elements = [Line2D([0], [0], linestyle='--',color='red',  label='Batas Stunting'),
                   Line2D([0], [0], color='green', linestyle='--', label='Batas Normal'),
                   Line2D([0], [0], marker='o', color='black', label='Stunting Individu IFLS 4 & IFLS 5 : %d & %d' %(n_stunting,n_stunting2), markersize=10),
                   Line2D([0], [0], marker='o', color='blue', label='Normal Individu IFLS4 & IFLS5 : %d & %d' %(n_normal,n_normal2) , markersize=10) ]
    plt.legend(handles=legend_elements, loc='upper left')

    plt.grid(True)
    plt.xlabel('age [years]')
    plt.ylabel('length [cm]')
    plt.xlim([0,15])
    plt.ylim([0,200])
    plt.xticks(np.arange(0,15,1))
    plt.yticks(np.arange(0,200,10))
    plt.figtext(0.01, 0.01, 'Source: IFLS4 & IFLS 5', horizontalalignment='left')
# Show & save graphs
plt.show()


plt.savefig(os.path.join(path,'growth.pdf'))
plt.savefig(os.path.join(path,'growth.png'))

# END +++