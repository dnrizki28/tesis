# -*- coding: utf-8 -*-
#created by : Dina Rizkiani
"""
Spyder Editor

This is a temporary script file.
"""

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
chdata = 'wave4_boy1.csv'

# Gender (male or female)
childfile = open(os.path.join(path,chdata))
genderline = childfile.readline()

# Age, weight, height, head circumference
charray = np.genfromtxt(os.path.join(path,chdata), delimiter=',', dtype = None, skip_header=2)

if genderline[7] == 'f':
    # read girls' (0-2) WHO charts
    # Read age vs length WHO data
    aldata = 'gz_age_length2.csv'
    alarray = np.loadtxt(os.path.join(path,aldata), delimiter=',', skiprows=1)
    fig, ax = plt.subplots(facecolor='pink')
    if genderline[9] == '0':
        plt.title('Length For Age GIRLS', loc='left')
    else:
         plt.title('Height For Age GIRLS', loc='left')
else:
    aldata = 'bz_age_length2.csv'
    alarray = np.loadtxt(os.path.join(path,aldata), delimiter=',', skiprows=1)
    fig, ax = plt.subplots(facecolor='grey')
    if genderline[9] == '0':
       plt.title('Length For Age BOYS', loc='left')
    else:
       plt.title('Height For Age BOYS', loc='left')
####################################################
# Plots
#plt.figure()


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
if genderline[9] == '0':
    plt.title('0-24 months', loc='right')

    #plot dengan method plot        
    plt.plot(list(alarray[:,0]),list(alarray[:,1]),'r--')
    plt.plot(list(alarray[:,0]),list(alarray[:,2]),'r--')
    plt.plot(list(alarray[:,0]),list(alarray[:,3]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,4]),'k-')
    plt.plot(list(alarray[:,0]),list(alarray[:,5]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,6]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,7]),'g--')
    #plot dengan menggunakan scatter
    plt.scatter(list(charray[:,0]),list(charray[:,1]), c=col_arr, marker='o',s=6)
    #memberi penamaan garis standar deviasi (labelling)
    plt.text(alarray[24,0], alarray[24,1],'-3',fontsize=10)
    plt.text(alarray[24,0], alarray[24,2],'-2',fontsize=10)
    plt.text(alarray[24,0], alarray[24,3],'-1',fontsize=10)
    plt.text(alarray[24,0], alarray[24,5],'1',fontsize=10)
    plt.text(alarray[24,0], alarray[24,6],'2',fontsize=10)
    plt.text(alarray[24,0], alarray[24,7],'3',fontsize=10)

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
    plt.xlim([11,24])
    plt.ylim([40,110])
    plt.xticks(np.arange(11,24,1))
    plt.yticks(np.arange(10,180,10))
    plt.figtext(0.01, 0.01, 'Source: IFLS 4', horizontalalignment='left')
elif genderline[9]=='1':
    plt.title('24-84 months', loc='right')
    #plot dengan method plot        
    plt.plot(list(alarray[:,0]),list(alarray[:,1]),'r--')
    plt.plot(list(alarray[:,0]),list(alarray[:,2]),'r--')
    plt.plot(list(alarray[:,0]),list(alarray[:,3]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,4]),'k-')
    plt.plot(list(alarray[:,0]),list(alarray[:,5]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,6]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,7]),'g--')
    #plot dengan menggunakan scatter
    plt.scatter(list(charray[:,0]),list(charray[:,1]), c=col_arr, marker='o',s=6)
    #memberi penamaan garis standar deviasi (labelling)
    plt.text(alarray[85,0], alarray[85,1],'-3',fontsize=10)
    plt.text(alarray[85,0], alarray[85,2],'-2',fontsize=10)
    plt.text(alarray[85,0], alarray[85,3],'-1',fontsize=10)
    plt.text(alarray[85,0], alarray[85,5],'1',fontsize=10)
    plt.text(alarray[85,0], alarray[85,6],'2',fontsize=10)
    plt.text(alarray[85,0], alarray[85,7],'3',fontsize=10)

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
    plt.xlim([24,60])
    plt.ylim([70,190])
    plt.xticks(np.arange(23,86,2))
    plt.yticks(np.arange(10,190,10))
    plt.figtext(0.01, 0.01, 'Source: IFLS 4', horizontalalignment='left')
else:
    plt.title('80-180 months', loc='right')
    #plot dengan method plot        
    plt.plot(list(alarray[:,0]),list(alarray[:,1]),'r--')
    plt.plot(list(alarray[:,0]),list(alarray[:,2]),'r--')
    plt.plot(list(alarray[:,0]),list(alarray[:,3]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,4]),'k-')
    plt.plot(list(alarray[:,0]),list(alarray[:,5]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,6]),'g--')
    plt.plot(list(alarray[:,0]),list(alarray[:,7]),'g--')
    #plot dengan menggunakan scatter
    plt.scatter(list(charray[:,0]),list(charray[:,1]), c=col_arr, marker='o',s=6)
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
    plt.xlim([80,180])
    plt.ylim([60,200])
    plt.xticks(np.arange(80,180,2))
    plt.yticks(np.arange(60,200,10))
    plt.figtext(0.01, 0.01, 'Source: IFLS 5', horizontalalignment='left')
# Show & save graphs
plt.show()


plt.savefig(os.path.join(path,'growth.pdf'))
plt.savefig(os.path.join(path,'growth.png'))

# END +++