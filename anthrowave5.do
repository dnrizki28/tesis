/*-----------------------------STUNTING-----------------------------------------*/
/*Modul penelusuran sampel 12-59 bulan											*/
/*Berapa yang masih ada di ruta; Berapa yang hilang; Kemana yang hilang         */
/*------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------*/
use hhid14 pid14 pidlink using "$main\id_sampel0714"
merge 1:1 hhid14 pid14 using "$ifls5/bus_us"
keep if _merge==3
drop _merge
keep hhid14 pid14 pidlink us04 us06


merge 1:1 pidlink using "$main\sample_base"
keep if _merge==3
keep hhid14 pid14 pidlink sex us04 us06 ar08yr ar08mth
drop if us04==.
tempfile uswave5
save "`uswave5'"
*jumlah sampel : 4964

/*---------------------------HITUNG UMUR DALAM BULAN---------------------------*/
use "$ifls5/bus_time",clear
*ada data duplikat di bus_time
bysort hhid14 pid14 : gen id = cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:1 hhid14 pid14 using "`uswave5'"
*match semua
keep if _merge==3
drop _merge
*generate variabel umur
gen umur_bulan =(12*(ivwyr-ar08yr)+(ivwmth-ar08mth))
*replace umur_bulan=0 if umur_bulan<0
gen age=floor(umur_bulan/12)
gen neg_age = age*-1
keep pid14 hhid14 pidlink sex umur_bulan age us04 us06
tempfile data_umurjk14
save "`data_umurjk14'",replace
*jumlah sampel : 4964
/*-----------------------------------------------------------------------------*/
/*--------------------Hitung Z Score Balita------------------------------------*/
/* Indicate to the Stata compiler where the who2007_stata.ado file is
stored*/
adopath + "D:\UIS2KK\Tesis\health outcomes\who2007_stata"
/* generate the first three parameters reflib, datalib & datalab */
gen str60 reflib="D:\UIS2KK\Tesis\health outcomes\who2007_stata" 
lab var reflib "Directory of reference tables"
gen str60 datalib="D:\UIS2KK\Tesis\health outcomes\who2007_stata"
lab var datalib "Directory for datafiles"
gen str30 datalab="IFLS5"
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
use "D:\UIS2KK\Tesis\health outcomes\who2007_stata\IFLS5_z.dta"
gen stunting=0
replace stunting=1 if _zhfa<-2.0
gen haz=_zhfa
keep hhid14 pid14 pidlink sex umur_bulan haz stunting us04 age

gen severe_stunting=0
replace severe_stunting=1 if haz<-2&haz>-3
replace severe_stunting=2 if haz<=-3

tempfile anthro_5
save "`anthro_5'",replace
/*-----------------------------------------------------------------------------*/
********************************************************************************
la var stunting "Status Nutrisi"
la def stunting 0 "Normal" 1 "Stunting"
la val stunting stunting

la var severe_stunting "Status Nutrisi"
la def severe_stunting 0 "Normal" 1 "Moderate Stunting" 2 "Severe Stunting"
la val severe_stunting severe_stunting

la var haz "Height for Age Z-Score"
********************************************************************************
save "$main\anthrowave5",replace
