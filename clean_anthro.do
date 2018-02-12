/*-----------------------------STUNTING-----------------------------------------*/
/*Modul clean data anthro wave 4 wave 5											*/
/*																		        */
/*------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------*/
*membuang observasi yang tidak ada datanya di wave 5
use pidlink using "$main\anthrowave45.dta"
merge 1:1 pidlink using "$main\anthrowave4.dta"
keep if _merge==3
drop _merge
save "$main\anthrowave4.dta",replace

*membuang observasi yang tidak ada datanya di wave 4
use pidlink using "$main\anthrowave45.dta"
merge 1:1 pidlink using "$main\anthrowave5.dta"
keep if _merge==3
drop _merge
save "$main\anthrowave5.dta",replace

