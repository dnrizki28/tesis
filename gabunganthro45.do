/*-----------------------------STUNTING-----------------------------------------*/
/*Modul penelusuran sampel 12-59 bulan											*/
/*Berapa yang masih ada di ruta; Berapa yang hilang; Kemana yang hilang         */
/*------------------------------------------------------------------------------*/
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

*buang sampel yang tinggi 2007>2014
drop if us04_07>us04_14
drop if (us04_07<40|us04_14<40)
drop if us04_07==.|us04_14==.


save "$main\anthrowave45.dta",replace

