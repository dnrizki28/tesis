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

use "$main\balita_stunting07.dta"
foreach var of varlist _all {
rename `var' `var'_07
}
rename pid07_07 pid07
rename hhid07_07 hhid07 
rename pidlink_07 pidlink
tempfile anthro07
save "`anthro07'"

merge 1:1 pidlink using "$main\anthrowave45lengkap"
drop _merge
tempfile data1
save "`data1'"

use "$main\balita_stunting14.dta"
foreach var of varlist _all {
rename `var' `var'_14
}
rename pid14_14 pid14
rename hhid14_14 hhid14 
rename pidlink_14 pidlink

merge 1:1 pidlink using "`data1'"
keep if _merge==3
drop _merge

save "$main\anthrowave45lengkap.dta",replace
