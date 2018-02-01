/*-----------------------------STUNTING-----------------------------------------*/
/*Modul append data balita 2007& 2014 				        					*/
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

use "$main\balita_stunting14.dta",clear
rename imun_lengkap14 imun_lengkap
rename imun_tdklengkap14 imun_tdklengkap
rename tidak_imun14 tidak_imun
rename pnol14 pnol
drop hhid14_9 maa0b maa0d maa04

tempfile balita_14
save "`balita_14'"

use "$main\balita_stunting07.dta",clear
drop ar16 ar17 
rename imun_lengkap07 imun_lengkap
rename imun_tdklengkap07 imun_tdklengkap
rename tidak_imun07 tidak_imun
rename pnol07 pnol

append using "`balita_14'"
encode pidlink,gen(id)

save "$main\dataset.dta",replace
