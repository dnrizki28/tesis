/*-----------------------------STUNTING-----------------------------------------*/
/*Modul penelusuran sampel 12-59 bulan											*/
/*Berapa yang masih ada di ruta; Berapa yang hilang; Kemana yang hilang         */
/*------------------------------------------------------------------------------*/
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
keep hhid07 pid07 pidlink pidibu sex umur_bulan us04 us06 age
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
gen stunting=0
replace stunting=1 if _zlen<-2.0
keep hhid07 pid07 pidlink pidibu sex umur_bulan _zlen stunting us04 
tempfile buku_us
save "`buku_us'",replace
*******************************************************************************
gen haz=_zlen
*0 = normal, 1=moderate, 2=severe
gen severe_stunting=0
replace severe_stunting=1 if haz<-2&haz>-3
replace severe_stunting=2 if haz<=-3
gen age=floor(umur_bulan/12)
********************************************************************************
la var stunting "Status Nutrisi"
la def stunting 0 "Normal" 1 "Stunting"
la val stunting stunting

la var severe_stunting "Status Nutrisi"
la def severe_stunting 0 "Normal" 1 "Moderate Stunting" 2 "Severe Stunting"
la val severe_stunting severe_stunting

la var haz "Height for Age Z-Score"
********************************************************************************
drop _zlen
save "$main\anthrowave4",replace



