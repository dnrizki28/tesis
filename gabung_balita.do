/*-----------------------------STUNTING-----------------------------------------*/
/*Modul penelusuran sampel 12-59 bulan											*/
/*Berapa yang masih ada di ruta; Berapa yang hilang; Kemana yang hilang         */
/*------------------------------------------------------------------------------*/
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
rename imun_tdklengkap07 imun_tdklengkap
rename tidak_imun07 tidak_imun

append using "`balita_14'"
encode pidlink,gen(id)

save "$main\dataset.dta",replace
