/*-----------------------------STUNTING----------------------------------------*/
/*Modul utama sampel 12-59 bulan										   	   */
/*																		       */
/*-----------------------------------------------------------------------------*/
clear 
capture log close 
set more off

/*---------file global - set tempat menyimpan file data-------------------------*/
global ifls4 "D:\UIS2KK\Tesis\IFLS\4"
global ifls5 "D:\UIS2KK\Tesis\IFLS\5\hh14_all_dta"
global main "D:\UIS2KK\Tesis\health outcomes\Run File 2\sampel 1259"
global logfiles "D:\UIS2KK\Tesis\health outcomes\Run File 2\sampel 1259"
capture log using "$logfiles\1.0.txt", text replace 
/*-----------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------*/

do "$main\trackingsampelfix.do"
do "$main\anthrowave4.do"
do "$main\anthrowave5.do"
do "$main\gabunganthro45.do"
do "$main\clean_anthro.do"
do "$main\balita_stunting.do"
do "$main\balita_stunting14.do"
do "$main\gabung_balita.do"
