# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

# Graphical assessment of a child's development 
# according to the World Health Organization growth standards 

# Repository & documentation:
# http://github.com/dqsis/child-growth-charts
# -------------------------------------

# Import libraries
import os
from sys import exit
#import library 3rd numpy dan matplotlib pastikan install dulu
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

# I/O files path
path = 'data/'

# Read child's data (user input)
chdata = 'child4.csv'

# Gender (male or female)
childfile = open(os.path.join(path,chdata))
genderline = childfile.readline()

# Age, weight, height, head circumference
charray = np.genfromtxt(os.path.join(path,chdata), delimiter=',', dtype = None, skip_header=2)

if genderline[7] == 'f':
    # read girls' (0-2) WHO charts
    # Read age vs length WHO data
    aldata = 'gz_age_length.csv'
    alarray = np.loadtxt(os.path.join(path,aldata), delimiter=',', skiprows=1)
else:
    print('no data available for boys yet')
    exit()

############################ BANTUAN SAJA : BACA ##################
# COBA PRINT DULU SALAH SATU ARRAY DATANYA : print awarray 
print "==================== SEKILAS NUMPY NDARRAY DAN MATRIX ====================================== "
print "*) Ada 2 Jenis format yaitu : 1. Array/N-Dimensional Array (ndarray)"
print "                              2. numpy Matrix" 
print "*) Format keduanya pada dasarnya adalah array[] semua index dimulai dari 0."
print "*) Tetapi sedikit berbeda dengan array biasa (tampilan antar [] tidak ada koma, lihat contoh dibawah!)"
print "*) Format tampilan Keduanya Saat di print SAMA."
print "*) numpy Matrix adalah turunan dari ndArray sehingga cara aksesnya di keduanya sama."
print "*) Kalau perbedaan format 1 dan 2, pada objek numpy matrix bisa dilakukan proses2x OPERASI MATRIX,"
print "   Misalnya perkalian, inverse, Transpose, dsb. Sedangkan ndarray tidak bisa (KECUALI di python versi 3.5 ke atas !!!)"
print "   https://stackoverflow.com/questions/4151128/what-are-the-differences-between-numpy-arrays-and-matrices-which-one-should-i-u \n"
print "====================== ARRAY BIASA ========================================================= "
print "BERIKUT ini adalah FORMAT TAMPILAN Array 2 Dimensi biasa (Bukan dari Numpy) :" 
array_biasa = [[1,2,3,4] , [5,6,7,8]]
print array_biasa
print "CARA AKSES : Kalau mau akses item dengan nilai 2  maka caranya array_biasa[0][1] : "
print array_biasa[0][1]
print "============================================================================================ "

print "====================== NDARRAY DAN NUMPY MATRIX ============================================ "
print "Sedangkan Dalam script ini menggunakan np.loadtxt yang akan mengembalikan format ndArray berikut adalah FORMAT TAMPILAN hasil print dr awarray : "
print "Ini data Age vs Weight yang di load dalam menggunakan library numpy dalam format numpy :"
#print awarray
print "\n CARA AKSES : Ada 2 Cara yaitu POSISI ITEM menggunakan method item.(Baris,Kolom) => awarray.item( (2,3) ) = \n"
#print awarray.item( (2,3) )
print "\n Atau , dengan INDEX ITEM dimana indeks item ke- 0 dimulai dari kiri atas sampai ke kanan bawah adalah index item ke-n (terakhir)"
print "Misal ndarray/matriks: awarray [B x K] = [24 x 10] , maka utk item ke 11 dari ndarray/matriks trsbt = 3.1611 (lihat hasil print awarray diatas!) = \n" 
#print awarray.item(11)
print "============================================================================================ "

####################################################
# Plots
#plt.figure()

fig, ax = plt.subplots(facecolor='pink')
plt.title('Length For Age GIRLS', loc='left')
plt.title('0-24 months', loc='right')

# Z Score Age vs length 
col_arr = []
n_cebol, n_normal = 0,0

for c in charray[:,2]:
    if c == 1.0:
        col_arr.append('y')
        n_cebol = n_cebol + 1
    else:
        col_arr.append('b')
        n_normal = n_normal + 1

#INI BAWAH JANGAN DIHAPUS 
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

legend_elements = [Line2D([0], [0], linestyle='--',color='red',  label='Batas Cebol'),
                   Line2D([0], [0], color='green', linestyle='--', label='Batas Normal'),
                   Line2D([0], [0], marker='o', color='yellow', label='Cebol Individu : %d' % n_cebol , markersize=10),
                   Line2D([0], [0], marker='o', color='blue', label='Normal Individu : %d'% n_normal , markersize=10) ]
plt.legend(handles=legend_elements, loc='upper left')

plt.grid(True)
plt.xlabel('age [months]')
plt.ylabel('length [cm]')
plt.xlim([11,25])
plt.ylim([40,110])
plt.xticks(np.arange(0,25,1))


# Show & save graphs
plt.show()

plt.savefig(os.path.join(path,'growth.pdf'))
plt.savefig(os.path.join(path,'growth.png'))

# END +++