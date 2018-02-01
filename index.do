/*-----------------------------STUNTING-----------------------------------------*/
/*Modul penelusuran sampel di 2014 												*/
/*Berapa yang masih ada di ruta; Berapa yang hilang; Kemana yang hilang         */
/*------------------------------------------------------------------------------*/
clear 
capture log close 
set more off

/*---------file global - set tempat menyimpan file data-------------------------*/
global ifls3 "D:\UIS2KK\Tesis\IFLS\3"
global ifls4 "D:\UIS2KK\Tesis\IFLS\4"
global ifls5 "D:\UIS2KK\Tesis\IFLS\5\hh14_all_dta"
global main "D:\UIS2KK\Tesis\health outcomes\Run File 2\sampel 1296"
global logfiles "D:\UIS2KK\Tesis\health outcomes\Run File 2\sampel 1296"
capture log using "$logfiles\1.0.txt", text replace 
/*-----------------------------------------------------------------------------*/

do "$main\trackingsampelfix.do"
do "$main\anthrowave4.do"
do "$main\anthrowave5.do"
do "$main\gabunganthro45.do"
do "$main\balita_stunting.do"
do "$main\balita_stunting14.do"
do "$main\gabung_balita.do"
