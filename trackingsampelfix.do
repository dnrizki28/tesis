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
/*-----------------SAMPEL DI WAVE 4--------------------------------------------*/

use hhid07 ivwday1 ivwmth1 ivwyr1 using "$ifls4/bus1_0", clear
tempfile interview07
save 	"`interview07'", replace

use 	hhid07 pid07 pidlink ar07 ar08mth ar08yr ar16 ar17 ar01a ar02b ar09 ar11 ar10 ar01a ar13 using "$ifls4/bk_ar1", clear
drop if ar01a==0|ar01a==3
merge m:1 hhid07 using "`interview07'"
keep if _merge==3
drop _merge

bysort pidlink: gen dup=_N
drop if dup>1
drop dup
tempfile ar
save "`ar'", replace

*membuat variabel umur
*masih ada bulan dan tahun lahir yang nilainya missing,9998,9999
*melacak umur menggunakan ptrack
use hhid07 pid07 pidlink bth_day bth_year bth_mnth sex using "$ifls4/ptrack", clear
merge 1:1 pidlink using "`ar'"
keep if _merge==3
drop _merge

replace ar08yr=bth_year if ar08yr==9998|ar08yr==9999|mi(ar08yr)
replace ar08mth=bth_mnth if ar08mth==99|ar08mth==98|mi(ar08mth)
tempfile ar
save "`ar'", replace
drop if mi(ar08yr)|mi(ar08mth)

/*hitung umur dalam bulan*/
replace ivwyr1=2000+ivwyr1
gen umur_bulan =(12*(ivwyr1-ar08yr)+(ivwmth1-ar08mth))
replace umur_bulan=0 if umur_bulan<0
gen age=floor(umur_bulan/12)
gen neg_age = age*-1
gen tahun=2007

*memilih sampel balita yang tinggal bersama ibunya
keep if (umur_bulan>11&umur_bulan<85)

drop if ar11==51|ar11==52|ar11==98|ar11==99
rename ar11 pidibu07
rename ar10 pidayah07
keep sex hhid07 pid07 pidlink ar08mth ar08yr pidayah07 pidibu07 umur_bulan age neg_age tahun

/*-----------------------------------------------------------------------------*/
/*-----------------------------CEK KEBERADAAN IBU------------------------------*/
rename pid07 pidanak
rename pidibu07 pid07
merge m:1 hhid07 pid07 using "$ifls4/bk_ar1"
drop if _merge==2
drop _merge

ta ar01a,m
drop if ar01a==0|ar01a==3
rename pid07 pidibu07
rename pidanak pid07
keep sex hhid07 pid07 pidlink ar08mth ar08yr pidayah07 pidibu07 umur_bulan age neg_age tahun
tempfile sample_base
save "$main\sample_base",replace
/*-----------------------------------------------------------------------------*/

/*----------------------------AMBIL ID SAMPEL,ID RUTA 2007---------------------*/
use "$main\sample_base",replace
keep hhid07 pid07 pidlink
tempfile id_sampel07
save "$main\id_sampel07",replace

use "$main\sample_base",replace
keep hhid07
bysort hhid07:gen id=_N
drop if id>1
drop id
tempfile id_ruta07
save "$main\id_ruta07",replace
/*-----------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------*/
/*CEK YANG MENINGGAL DAN KELUAR DARI RUMAH TANGGA*/
use "$ifls5/ptrack", clear
bysort pidlink: gen id=cond(_N==1,0,_n)
* Temuan 1 : ada 6 baris yg pidlinknya duplikat (3 id ganda)
*            2 id pidlink sama, beda rumah tangga --> ambil salah satunya
*			 1 id duplikat ar01a_14==6 --> buang salah satu
drop if id>1
merge 1:1 pidlink using "$main\id_sampel07"
keep if _merge==3
drop _merge
tempfile trackingsampel
save "$main\trackingsampel.dta",replace
*simpan yang meninggal
keep if ar01a_14==0
tempfile deadsample
save "$main\deadsample.dta",replace
*simpan yang pindah
use "$main\trackingsampel.dta", clear
keep if ar01a_14==3
tempfile moveoutsample
save "$main\moveoutsample.dta",replace
*sampel yang tersedia 2007-2014, belum drop yang data tingginya tidak ada di 2014
use "$main\trackingsampel.dta", clear
drop if ar01a_14==3|ar01a_14==0
keep pidlink hhid14 pid14 hhid07 pid07
tempfile sampleunclean
save "$main\sampleunclean.dta",replace
/*-----------------------------------------------------------------------------*/
* Sampel yang tinggal dgn ibu di 2014
use "$ifls5/bk_ar1", clear
merge 1:1 hhid14 pidlink using "$main\sampleunclean.dta"
*matched smua
keep if _merge==3
*memilih sampel yang tinggal bersama ibu saja
drop if ar11==51|ar11==52|mi(ar11)
drop _merge
*CEK KEBERADAAN IBU DI 2014
keep pid07 hhid07 pidlink hhid14 pid14 ar11
rename pid14 pidanak
rename ar11 pid14

merge m:1 hhid14 pid14 using "$ifls5/bk_ar1"
keep if _merge==3
drop _merge
drop if ar01a==0|ar01a==3
rename pid14 pidibu14
rename pidanak pid14
tempfile sampleclean
save "$main\sampleclean.dta",replace

/*-----------------------AMBIL ID SAMPEL,ID RUTA 2007-2014---------------------*/
use "$main\sampleclean",replace
keep pidlink hhid14 pid14 hhid07 pid07
tempfile id_sampel0714
save "$main\id_sampel0714",replace

use "$main\sampleclean",replace
keep hhid07 hhid14
bysort hhid07:gen id=_N
drop if id>1
drop id
bysort hhid14:gen id=_N
drop if id>1
drop id
tempfile id_ruta0714
save "$main\id_ruta0714",replace
/*-----------------------------------------------------------------------------*/
