/*-----------------------------STUNTING-----------------------------------------*/
/*Modul pembentukan variabel sampel yang di 2014 								*/
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


********************************************************************************
/*------------------DIETARY DIVERSITY SCORE 2014-------------------------------*/
use pidlink pid14 hhid14 using "$main\anthrowave45.dta"
merge 1:m pidlink using "$ifls5\b5_fma1.dta"
drop if _merge==2
drop _merge
*missing data=4, matched = 4.413 sampel

*membentuk variabel frekuensi makan dari fma01, 11 missing
*makan=1 --> frekuensi makan 3 kali sehari, makan=0 frekuensi makan <3 kali sehari/tidak tahu 

gen makan=fma01
replace makan=0 if fma01>1&fma01!=.
keep pidlink pid14 hhid14 makan fma01

merge 1:m hhid14 pid14 using "$ifls5\b5_fma2.dta"
drop if _merge==2


*membentuk variabel DDS
gen tipe_mpasi=0
*koding umbi-umbian
replace tipe_mpasi=1 if fmatype=="A"
*koding telur
replace tipe_mpasi=2 if fmatype=="B"
*koding daging --> ikan,daging,dan unggas
replace tipe_mpasi=3 if fmatype=="C"|fmatype=="D"
*koding susu
replace tipe_mpasi=4 if fmatype=="E"
*koding sayur2an hijau
replace tipe_mpasi=5 if fmatype=="F"
*koding buah sayur kaya vitamin A
replace tipe_mpasi=6 if fmatype=="H"|fmatype=="I"|fmatype=="J"
*koding buah lainnya
replace tipe_mpasi=7 if fmatype=="G"
label define tipe_mpasi 0 "tidak makan/lainnya" 1 "umbi-umbian" 2 "Telur" 3 "Daging" 4 "Susu" 5 "Sayur-sayuran hijau" 6 "Buah dan sayur kaya vitamin A" 7 "Buah Lainnya"
label value tipe_mpasi "tipe_mpasi"

gen frek_makan=fma03
replace frek_makan=fma03 if fma02==1
replace frek_makan=0 if fma02==3|fma02==9
*untuk yang durasi makan tidak tahu dianggap missing
replace frek_makan=. if fma03==8

bysort hhid14 pid14 tipe_mpasi:egen diversity=max(frek_makan)
bysort hhid14 pid14 tipe_mpasi : gen dup_tipe=cond(_N==1,0,_n)
drop if dup_tipe>1
drop dup_tipe

bysort hhid14 pid14 : gen div_balita=sum(diversity)
*bysort hhid14 pid14: egen dds = max(div_balita) if diversity!=.
*drop div_balita

*variabel frekuensi makan dalam hari untuk 7 jenis tipe makanan
gen frek_umbi=0 if _merge==3
replace frek_umbi=diversity if tipe_mpasi==1

gen frek_telur=0 if _merge==3
replace frek_telur=diversity if tipe_mpasi==2

gen frek_daging=0 if _merge==3
replace frek_daging=diversity if tipe_mpasi==3

gen frek_susu=0 if _merge==3
replace frek_susu = diversity if tipe_mpasi==4

gen frek_sayur=0 if _merge==3
replace frek_sayur=diversity if tipe_mpasi==5

gen frek_buahsayurA=0 if _merge==3
replace frek_buahsayurA=diversity if tipe_mpasi==6

gen frek_buah=0 if _merge==3
replace frek_buah=diversity if tipe_mpasi==7
drop _merge


bysort hhid14 pid14: egen fre_umbi=max(frek_umbi)
bysort hhid14 pid14: egen fre_telur=max(frek_telur)
bysort hhid14 pid14: egen fre_daging=max(frek_daging)
bysort hhid14 pid14: egen fre_susu=max(frek_susu)
bysort hhid14 pid14: egen fre_sayur=max(frek_sayur)
bysort hhid14 pid14: egen fre_buahsayurA=max(frek_buahsayurA)
bysort hhid14 pid14: egen fre_buah=max(frek_buah)

gen dds=fre_umbi+fre_telur+fre_daging+fre_susu+fre_sayur+fre_buahsayurA+fre_buah

*buang data duplikat
bysort hhid14 pid14 : gen dup_id=cond(_N==1,0,_n)
drop if dup_id>1

*membuat variabel DDS menjadi 3 kategori
xtile tertile_dds = dds,nquantile(3)
keep hhid14 pid14 pidlink dds fre_umbi fre_telur fre_daging fre_susu fre_sayur fre_buahsayurA fre_buah makan tertile_dds

/*--------------------------LABELLING DDS--------------------------------------*/
la var dds "Dietary diversity score"
la var makan "Frekuensi Makan"
la def makan 1 "3 kali sehari" 0 "<3 kali sehari"
la val makan makan
la var fre_umbi "Frekuensi umbi-umbian"
la var fre_telur "Frekuensi telur"
la var fre_daging "Frekuensi daging"
la var fre_susu "Frekuensi susu"
la var fre_sayur "Frekuensi sayur"
la var fre_buahsayurA "Frekuensi buah dan sayur mengandung vitamin A"
la var fre_buah "Frekuensi buah"

tempfile balita_fma14
save "`balita_fma14'",replace
/*-----------------------------------------------------------------------------*/
********************************************************************************


********************************************************************************
/*------------------------SELF RATED HEALTH------------------------------------*/
*self rated health sebulan yang lalu
use pidlink pid14 hhid14 using "$main\anthrowave45.dta" 
merge 1:1 pidlink using "$ifls5\b5_maa1.dta"
drop if _merge==2
drop _merge

drop maa0bx maa0cx maa0c maa05aa maa05ab maa05ac maa05ad maa06 version module

*generate variabel kondisi kesehatan sebulan terakhir (1=tidak sehat, 0 =sehat)
*ada 12 data yang nilainya missing

gen self_health = 0 if maa0a==1 | maa0a==2
replace self_health = 1 if maa0a==3|maa0a==4
replace self_health = . if mi(maa0a)|maa0a==9
drop  maa0a
/*--------------------------LABELLING SRH--------------------------------------*/
la var self_health "Kondisi kesehatan sebulan terakhir"
la def self_health 1 "Tidak sehat" 0 "Sehat"
la val self_health self_health
tempfile us_fma_maa
save "`us_fma_maa'",replace
/*-----------------------------------------------------------------------------*/
********************************************************************************

********************************************************************************
/*---------------------------BUKU DL PENDIDIKAN IBU----------------------------*/
use pidlink didik using "$main\balita_stunting07.dta" 
tempfile us_didik
save "`us_didik'"

/*-----------------------------------------------------------------------------*/
********************************************************************************
/*-------------------------BUKU AR KEGIATAN IBU--------------------------------*/
use pidlink pid14 hhid14 using "$main\anthrowave45.dta" 
merge 1:1 pid14 hhid14 using "$ifls5\bk_ar1"
keep if _merge==3
drop _merge

*mengambil data pid ibu ar11
keep pidlink pid14 hhid14 ar11
rename pid14 pidanak
 
*merge lagi dengan bk ar, mengambil data ar ibu
rename ar11 pid14
merge m:1 hhid14 pid14 using "$ifls5\bk_ar1"
keep if _merge==3
drop _merge
 
gen kerja=ar15c
replace kerja=0 if ar15c>1
replace kerja=1 if ar15c==1&ar15c==98
keep pidlink pid14 hhid14 kerja
/*--------------------------LABELLING --------------------------------------*/
la var kerja "Bekerja seminggu yang lalu"
la def kerja 1 "Kerja" 0 "Tidak Kerja"
la val kerja kerja
tempfile us_kerja
save "`us_kerja'",replace
/*-----------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------*/
********************************************************************************
*/
********************************************************************************
/*---------------------------BUKU AR HHSIZE------------------------------------*/
use hhid14 using "$main\anthrowave45.dta" 
bysort hhid14:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:m hhid14 using "$ifls5\bk_ar1"
*matched semua
keep if _merge==3
drop _merge

keep if ar01a==1 | ar01a==2 |ar01a==5 | ar01a==11
bysort hhid14 : gen hh_size = _N

bysort hhid14:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

keep hhid14 hh_size
tempfile hhsize
save "`hhsize'"
/*-----------------------------------------------------------------------------*/
********************************************************************************

********************************************************************************
/*----------------------------NUCLEAR/EXTENDED---------------------------------*/
use hhid14 using "$main\anthrowave45.dta" 
bysort hhid14:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:m hhid14 using "$ifls5\bk_ar1"
*matched semua
keep if _merge==3
drop _merge

keep if ar01a==1 | ar01a==2 |ar01a==5 | ar01a==11
gen flag_extended=0
replace flag_extended=1 if ar02b>4
bysort hhid14 :egen sum_extended=sum(flag_extended)
gen extended=0
replace extended=1 if sum_extended>0

bysort hhid14:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

keep hhid14 extended
/*--------------------------LABELLING --------------------------------------*/
la var extended "Nuclear/extended family"
la def extended 0 "Nuclear" 1 "Extended"
la val extended extended
/*-----------------------------------------------------------------------------*/
tempfile hh_extended
save "`hh_extended'"
/*-----------------------------------------------------------------------------*/
********************************************************************************

/*---------------------------BANTUAN PEMERINTAH--------------------------------*/
/*-----------------------------------------------------------------------------*/

/*----------------------STATUS SANITASI&MINUM----------------------------------*/
use hhid14 using "$main\anthrowave45.dta" 
bysort hhid14:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:1 hhid14 using "$ifls5\b2_kr"
drop if _merge==2
drop _merge

gen sanitasi=kr20
replace sanitasi=0 if kr20>1&kr20!=.

gen minum=kr13
replace minum=0 if kr13>2&kr13!=.

keep hhid14 sanitasi minum

/*--------------------------LABELLING -----------------------------------------*/
la var sanitasi "Status Sanitasi Rumah Tangga"
la def sanitasi 1 "Sanitasi layak" 0 "Sanitasi tidak layak"
la val sanitasi sanitasi
la var minum "Sumber air minum"
la def minum 0 "Lainnya" 1 "Ledeng" 2 "Sumur/pompa"
la val minum minum
/*-----------------------------------------------------------------------------*/
tempfile hh_sanitasiminum
save "`hh_sanitasiminum'"
********************************************************************************
*/

********************************************************************************
/*-------------------------------WILAYAH TEMPAT TINGGAL------------------------*/
use hhid14 using "$main\anthrowave45.dta" 
bysort hhid14:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:1 hhid14 using "$ifls5\bk_sc1"
keep if _merge==3
drop _merge

keep sc01_14_14 sc02_14_14 sc03_14_14 hhid14 sc05
rename sc01_14_14 kdprov
rename sc02_14_14 kdkab
rename sc03_14_14 kdkec

tempfile hh_wilayah
save "`hh_wilayah'"
/*-----------------------------------------------------------------------------*/
********************************************************************************

/*------------------------------EXPENDITURE------------------------------------*/
use hhid14 using "$main\anthrowave45.dta" 
bysort hhid14 :gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:m hhid14 using "$ifls5\b1_ks1"
*2 ruta tidak ada datanya
keep if _merge==3
drop _merge

gen jenis=1 if ks1type=="A"|ks1type=="B"|ks1type=="C"|ks1type=="D"|ks1type=="E"|ks1type=="I"|ks1type=="J"
replace jenis=2 if ks1type=="K"|ks1type=="L"|ks1type=="M"|ks1type=="N"|ks1type=="OA"
replace jenis=3 if ks1type=="F"|ks1type=="H"
replace jenis=4 if ks1type=="G"|ks1type=="OB"
replace jenis=5 if ks1type=="P"
replace jenis=6 if ks1type=="Q"
replace jenis=7 if ks1type=="Y"
replace jenis=0 if jenis==.

replace ks02=0 if ks02>900000
replace ks03=0 if ks03>900000
egen sum_jenis = rowtotal(ks02 ks03)
bysort hhid14 jenis : egen exp_jenis = sum(sum_jenis)
bysort hhid14: egen hh_food_exp = sum(sum_jenis)

gen ex_bijian =0
replace ex_bijian=exp_jenis if jenis==1
bysort hhid14 : egen exp_bijian=max(ex_bijian)

gen ex_daging = 0
replace ex_daging=exp_jenis if jenis==2
bysort hhid14 : egen exp_daging=max(ex_daging)

gen ex_buahsayur = 0
replace ex_buahsayur=exp_jenis if jenis==3
bysort hhid14 : egen exp_buahsayur=max(ex_buahsayur)

gen ex_kacang = 0
replace ex_kacang=exp_jenis if jenis==4
bysort hhid14 : egen exp_kacang=max(ex_kacang)

gen ex_telur = 0
replace ex_telur=exp_jenis if jenis==5
bysort hhid14 : egen exp_telur=max(ex_telur)

gen ex_susu = 0
replace ex_susu=exp_jenis if jenis==6
bysort hhid14 : egen exp_susu=max(ex_susu)

gen ex_minyaklemak= 0
replace ex_minyaklemak=exp_jenis if jenis==7
bysort hhid14 : egen exp_minyaklemak=max(ex_minyaklemak)

*membuat variabel pengeluaran berdasarkan 2 kelompok makanan, animal source food dan plant source food
gen jenis2=1 if ks1type=="K"|ks1type=="L"|ks1type=="M"|ks1type=="N"|ks1type=="OA"|ks1type=="P"|ks1type=="Q"
replace jenis2=2 if ks1type=="F"|ks1type=="H"|ks1type=="G"|ks1type=="OB"
replace jenis2=3 if ks1type=="A"|ks1type=="B"|ks1type=="C"|ks1type=="D"|ks1type=="E"
replace jenis2=0 if jenis2==.


bysort hhid14 jenis2 : egen plant_animal = sum(sum_jenis)
gen animal_source = 0
replace animal_source=plant_animal if jenis2==1
bysort hhid14 : egen animal_foods=max(animal_source)
gen share_animalfoods=(animal_foods/hh_food_exp)*100

gen plant_source = 0
replace plant_source=plant_animal if jenis2==2
bysort hhid14 : egen plant_foods=max(plant_source)
gen share_plantfoods=(plant_foods/hh_food_exp)*100

gen grain_source = 0
replace grain_source=plant_animal if jenis2==3
bysort hhid14 : egen grain_foods=max(grain_source)
gen share_grainfoods=(grain_foods/hh_food_exp)*100

merge m:1 hhid14 using "`hhsize'"

keep if _merge==3
drop _merge

*generate variabel pengeluaran per kapita
gen cap_bijian=exp_bijian/hh_size
gen cap_daging=exp_daging/hh_size
gen cap_buahsayur=exp_buahsayur/hh_size
gen cap_kacang=exp_kacang/hh_size
gen cap_telur=exp_telur/hh_size
gen cap_susu=exp_susu/hh_size
gen cap_minyaklemak=exp_minyaklemak/hh_size
gen cap_animalsource = animal_foods/hh_size
gen cap_plantsource = plant_foods/hh_size
gen cap_grainsource = grain_foods/hh_size

*mengambil data ruta aja
bysort hhid14:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

*generate variabel quintile pengeluaran per kapita
xtile kuin_bijian= cap_bijian,n(5)
xtile kuin_daging = cap_daging,n(5)
xtile kuin_buahsayur = cap_buahsayur,n(5)
xtile kuin_kacang = cap_kacang,n(5)
xtile kuin_telur = cap_telur,n(5)
xtile kuin_susu = cap_susu,n(5)
xtile kuin_minyaklemak = cap_minyaklemak,n(5)
xtile kuin_animal = cap_animalsource,n(5)
xtile kuin_plant = cap_plantsource,n(5)
xtile kuin_grain = cap_grainsource,n(5)

*generate variabel share pengeluaran perjenis terhadap pengeluaran makanan


la var exp_bijian "Pengeluaran Biji-Bijian,Akar-Akaran,dan Umbi-Umbian"
la var exp_daging "Pengeluaran Daging-Dagingan"
la var exp_buahsayur "Pengeluaran Buah dan Sayuran"
la var exp_kacang "Pengeluaran Kacang-Kacangan"
la var exp_telur "Pengeluran telur"
la var exp_susu "Pengeluaran Susu"
la var exp_minyaklemak "Pengeluaran Minyak dan Lemak"
la var cap_bijian "Pengeluaran Per Kapita Biji-Bijian,Akar-Akaran,dan Umbi-Umbian"
la var cap_daging "Pengeluaran Per Kapita Daging-Dagingan"
la var cap_buahsayur "Pengeluaran Per Kapita Buah dan Sayuran"
la var cap_kacang "Pengeluaran Per Kapita Kacang-Kacangan"
la var cap_telur "Pengeluaran Per Kapita Telur"
la var cap_susu "Pengeluaran Per Kapita Susu"
la var cap_minyaklemak "Pengeluaran Per Kapita Minyak dan Lemak"
la var kuin_bijian "Kuintil Pengeluaran Per Kapita Biji2an"
la var kuin_daging "Kuintil Pengeluaran Per Kapita Daging2an"
la var kuin_buahsayur "Kuintil Pengeluaran Per Kapita Buah dan Sayuran"
la var kuin_kacang "Kuintil Pengeluaran Per Kapita Kacang2an"
la var kuin_telur "Kuintil Pengeluaran Per Kapita Telur"
la var kuin_susu "Kuintil Pengeluaran Per Kapita Susu"
la var kuin_minyaklemak "Kuintil Pengeluaran Per Kapita Minyak Lemak"
la var kuin_animal "Kuintil pengeluaran makanan yang bersumber dari hewan"
la var kuin_plant "Kuintil pengeluaran makanan yang bersumber dari tumbuhan"
la var kuin_grain "Kuintil pengeluaran makanan yang bersumber dari beras dll"
la var animal_foods "Pengeluaran makanan yang bersumber dari hewan"
la var plant_foods "Pengeluaran makanan yang bersumber dari tumbuhan"
la var cap_animalsource "Pengeluaran per kapita makanan yang bersumber dari hewan"
la var cap_plantsource "Pengeluaran per kapita makanan yang bersumber dari tumbuhan"
la var cap_grainsource "Pengeluaran per kapita beras dll"
la var share_animalfoods "% Pengeluaran animal foods source terhadap pengeluaran makanan"
la var share_plantfoods "% Pengeluaran plant foods source terhadap pengeluaran makanan"
la var share_grainfoods "% Pengeluaran staple food terhadap pengeluaran makanan"
*keep hhid07 kuin_grain kuin_animal kuin_plant kuin_minyaklemak kuin_susu kuin_telur kuin_kacang kuin_buahsayur kuin_daging kuin_bijian cap_minyaklemak cap_susu cap_telur cap_kacang cap_buahsayur cap_daging cap_bijian hh_size exp_minyaklemak exp_susu exp_telur exp_kacang exp_buahsayur exp_daging exp_bijian plant_foods animal_foods cap_plantsource cap_animalsource cap_grainsource 
drop ks1type ks02x ks03x ks02 ks03 version module jenis sum_jenis exp_jenis hhid14_9

tempfile hhsize_exp
save "`hhsize_exp'",replace
/*-----------------------------------------------------------------------------*/

/*---------------------------------DATA MAKRO----------------------------------*/
use hhid14 using "$main\anthrowave45.dta" 
bysort hhid14:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:1 hhid14 using "`hh_wilayah'"
keep if _merge==3
drop _merge

merge m:1 kdprov kdkab using "$main\makro14"
keep if _merge==3
drop _merge


gen group_imun=0 if imun_lengkap>0&imun_lengkap<=50.0
replace group_imun=1 if imun_lengkap>50.0

gen group_pnol=0 if pnol>0&pnol<=20.0
replace group_pnol=1 if pnol>20.0

tempfile hh_makro
save "`hh_makro'"
/*-----------------------------------------------------------------------------*/

/*----------------------------------MERGING-----------------------------------*/
use "$main\anthrowave5.dta"
merge 1:1 pidlink using "`balita_fma14'"
keep if _merge==3
drop _merge

merge 1:1 pidlink using "`us_fma_maa'"
*keep if _merge==3
drop _merge

merge 1:1 pidlink using "`us_kerja'"
*keep if _merge==3
drop _merge

merge 1:1 pidlink using "`us_didik'"
*keep if _merge==3
drop _merge

merge m:1 hhid14 using "`hh_extended'"
*keep if _merge==3
drop _merge

merge m:1 hhid14 using "`hh_sanitasiminum'"
*keep if _merge==3
drop _merge

merge m:1 hhid14 using "`hh_wilayah'"
*keep if _merge==3
drop _merge

merge m:1 hhid14 using "`hhsize_exp'"
*keep if _merge==3
drop _merge

merge m:1 hhid14 using "`hh_makro'"
*keep if _merge==3
drop _merge
/*----------------------------------------------------------------------------*/


gen tahun=2014
save "$main\balita_stunting14.dta",replace

