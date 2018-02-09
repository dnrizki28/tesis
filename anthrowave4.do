/*-----------------------------STUNTING-----------------------------------------*/
/*Modul hitung antropometri di 2007 											*/
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
/*---------------------------ANTROPOMETRI 2007---------------------------------*/

use hhid07 pid07 pidlink using "$main\id_sampel0714",clear
merge 1:1 hhid07 pid07 using "$ifls4/bus1_2"
*65 sampel tidak menjawab bus1_1 dan bus1_2"
keep if _merge==3
drop _merge
tempfile tinggi
save "`tinggi'",replace

merge 1:1 hhid07 pid07 using "$ifls4/bus1_1"
keep if _merge==3 
*matched semua
drop _merge
tempfile tinggiberat
save "`tinggiberat'",replace

merge 1:1 hhid07 pid07 using "$main\sample_base"
keep if _merge==3
drop _merge
*matched semua
keep hhid07 pid07 pidlink pidibu sex umur_bulan us04 us06
drop if mi(us04)
tempfile data_anthro
save "`data_anthro'", replace

/*--------------------Hitung Z Score Balita------------------------------------*/
/* Indicate to the Stata compiler where the igrowup_standard.ado file is
stored*/
adopath + "D:\UIS2KK\Tesis\health outcomes\igrowup_stata"
/* generate the first three parameters reflib, datalib & datalab */
gen str60 reflib="D:\UIS2KK\Tesis\health outcomes\igrowup_stata" 
lab var reflib "Directory of reference tables"
gen str60 datalib="D:\UIS2KK\Tesis\health outcomes\igrowup_stata"
lab var datalib "Directory for datafiles"
gen str30 datalab="IFLS4"
lab var datalab "Working file"
/* check the variable for "sex" 1 = male, 2=female */
replace sex=2 if sex==3
/* define your ageunit */
gen str6 ageunit="months"   /* or gen ageunit="days" */
lab var ageunit "months"
/* check the variable for "measure"*/
/*  NOTE: if not available, please create as [gen str1 measure=" "]*/
gen str1 measure=" "
gen str1 oedema="n"
gen sw=1
igrowup_restricted reflib datalib datalab sex umur_bulan ageunit us06 us04 measure oedema sw
/*ambil hasil igrowup stata*/

use "D:\UIS2KK\Tesis\health outcomes\igrowup_stata\IFLS4_z_rc.dta"
drop if umur_bulan>60
gen stunting=0
replace stunting=1 if _zlen<-2.0
keep hhid07 pid07 pidlink pidibu sex umur_bulan _zlen stunting us04 
tempfile buku_us
save "`buku_us'",replace
*******************************************************************************

use "`data_anthro'"
drop if umur_bulan<61
/* Indicate to the Stata compiler where the who2007_stata.ado file is
stored*/
adopath + "D:\UIS2KK\Tesis\health outcomes\who2007_stata"
/* generate the first three parameters reflib, datalib & datalab */
gen str60 reflib="D:\UIS2KK\Tesis\health outcomes\who2007_stata" 
lab var reflib "Directory of reference tables"
gen str60 datalib="D:\UIS2KK\Tesis\health outcomes\who2007_stata"
lab var datalib "Directory for datafiles"
gen str30 datalab="IFLS4"
lab var datalab "Working file"
/* check the variable for "sex" 1 = male, 2=female */
replace sex=2 if sex==3
/* define your ageunit */
gen str6 ageunit="months"   /* or gen ageunit="days" */
lab var ageunit "months"
/* check the variable for "measure"*/
/*  NOTE: if not available, please create as [gen str1 measure=" "]*/
gen str1 oedema="n"
gen sw=1
who2007 reflib datalib datalab sex umur_bulan ageunit us06 us04 oedema sw  

use "D:\UIS2KK\Tesis\health outcomes\who2007_stata\IFLS4_z.dta"
gen stunting=0
replace stunting=1 if _zhfa<-2.0
*keep hhid14 pid14 pidlink pidibu sex umur_bulan _zhfa stunting
tempfile buku_us2
save "`buku_us2'",replace

append using "`buku_us'"
tempfile anthro_4
save "`anthro_4'"
********************************************************************************

keep pid07 hhid07 pidlink us04 sex umur_bulan stunting _zlen _zhfa
gen haz=_zlen
replace haz=_zhfa if _zlen==.

*0 = normal, 1=moderate, 2=severe
gen severe_stunting=0
replace severe_stunting=1 if haz<-2&haz>-3
replace severe_stunting=2 if haz<=-3

gen age=floor(umur_bulan/12)

drop _zlen _zhfa
save "$main\anthrowave4",replace



