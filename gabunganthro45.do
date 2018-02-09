/*-----------------------------STUNTING-----------------------------------------*/
/*Modul gabung 2 data antho 2014 dan 2007										*/
/*																		        */
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

use "$main\anthrowave4.dta"
foreach var of varlist _all {
rename `var' `var'_07
}
rename pid07_07 pid07
rename hhid07_07 hhid07 
rename pidlink_07 pidlink
tempfile anthro07
save "`anthro07'"

use "$main\anthrowave5.dta"
foreach var of varlist _all {
rename `var' `var'_14
}
rename pid14_14 pid14
rename hhid14_14 hhid14 
rename pidlink_14 pidlink

merge 1:1 pidlink using "`anthro07'"
keep if _merge==3
drop _merge

*koding normal,persistent,move in,move out
*0 = normal, 1=move in, 2=move out, 3=persistent
gen status_stunting=0
replace status_stunting=1 if stunting_07==0&stunting_14==1
replace status_stunting=2 if stunting_07==1&stunting_14==0
replace status_stunting=3 if stunting_07==1&stunting_14==1

save "$main\anthrowave45.dta",replace

