/*-----------------------------STUNTING-----------------------------------------*/
/*Modul penelusuran sampel 12-59 bulan											*/
/*Berapa yang masih ada di ruta; Berapa yang hilang; Kemana yang hilang         */
/*------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------*/
********************************************************************************
/*------------------DIETARY DIVERSITY SCORE 2007-------------------------------*/
use pidlink pid07 hhid07 using "$main\anthrowave45.dta"
merge 1:m pidlink using "$ifls4\b5_fma.dta"
keep if _merge==3
keep pidlink pid07 hhid07 fma01 fma02 fma03 fmatype

*membuat variabel frekuensi makan
ta fma01,m
gen makan=fma01
replace makan=1 if fma01==1 
replace makan=0 if fma01>1&fma01!=.

*membuat variabel DDS
gen fmatype2=fmatype
replace fmatype2="K" if fmatype==""
replace fma03=0 if fma03==.
encode fmatype2,gen(jenismakanan)
drop fmatype fmatype2
reshape wide fma02 fma03,i(pidlink) j(jenismakanan) 

*1=A(umbi-umbian),2=B(telur),3=C(daging),4=D(daging),5=E(susu),
*6=F(sayuran hijau),7=G(buah lainnya),8=H(buah sayur vitA),9=I(buah sayur vitA),10=J(buah sayur vitA)
drop fma0211 fma0311

gen n_umbi=fma031
replace n_umbi=0 if n_umbi==.

gen n_telur=fma032
replace n_umbi=0 if n_telur==.

gen n_daging=fma033
replace n_daging=fma034 if fma034>fma033
replace n_daging=0 if n_daging==.

gen n_susu=fma035
replace n_susu=0 if n_susu==.

gen n_sayur=fma036
replace n_sayur=0 if n_sayur==.

gen n_buahlain=fma037
replace n_buahlain=0 if n_buahlain==.

*ini untuk ngitung DDS model 2 (6 grup makanan,umbi,daging,susu,telur,buah sayur A,buah dan sayur)
gen n_buahsayur=fma036
replace n_buahsayur=fma037 if fma037>fma036
replace n_buahsayur=0 if n_buahsayur==.

gen n_buahsayurA=fma038
replace n_buahsayurA=fma039 if (fma039>fma038)&(fma039>fma0310)
replace n_buahsayurA=fma0310 if (fma0310>fma038)&(fma0310>fma038)
replace n_buahsayurA=0 if n_buahsayurA==.

gen dds=n_umbi+n_telur+n_daging+n_susu+n_sayur+n_buahlain+n_buahsayurA
gen dds2=n_umbi+n_telur+n_daging+n_susu+n_buahsayur+n_buahsayurA

gen dds3=0
replace dds3=dds3+1 if n_umbi>2
replace dds3=dds3+1 if n_telur>2
replace dds3=dds3+1 if n_daging>2
replace dds3=dds3+1 if n_susu>2
replace dds3=dds3+1 if n_sayur>2
replace dds3=dds3+1 if n_buahlain>2
replace dds3=dds3+1 if n_buahsayurA>2

gen dds4=0
replace dds4=dds4+1 if n_umbi>2
replace dds4=dds4+1 if n_telur>2
replace dds4=dds4+1 if n_daging>2
replace dds4=dds4+1 if n_susu>2
replace dds4=dds4+1 if n_buahsayur>2
replace dds4=dds4+1 if n_buahsayurA>2

gen fvs=fma031+fma032+fma033+fma034+fma035+fma036+fma037+fma038+fma039+fma0310
xtile tertile_dds = dds,nquantile(3)
xtile tertile_dds2 = dds2,nquantile(3)
xtile tertile_dds3 = dds3,nquantile(3)
xtile tertile_dds4 = dds4,nquantile(3)
xtile tertile_fvs = fvs,nquantile(3)
keep pidlink makan pid07 hhid07 dds dds2 dds3 dds4 fvs n_umbi n_telur n_daging n_susu n_sayur n_buahlain n_buahsayurA tertile_dds tertile_dds2 tertile_dds3 tertile_dds4

/*--------------------------LABELLING DDS--------------------------------------*/
la var dds "Dietary diversity score (7 Grup)"
la var dds2 "Dietary diversity score (6 Grup)"
la var dds3 "Dietary diversity score cutpoint 3 (7 Grup)"
la var dds4 "Dietary diversity score cutpoint 3 (6 Grup)"
la var fvs "Food Variety Score"
la var makan "Frekuensi Makan"
la def makan 1 "3 kali sehari" 0 "<3 kali sehari"
la val makan makan
la var n_umbi "Frekuensi umbi-umbian"
la var n_telur "Frekuensi telur"
la var n_daging "Frekuensi daging"
la var n_susu "Frekuensi susu"
la var n_sayur "Frekuensi sayur"
la var n_buahsayurA "Frekuensi buah dan sayur mengandung vitamin A"
la var n_buahlain "Frekuensi buah"

tempfile balita_fma07
save "`balita_fma07'",replace
/*-----------------------------------------------------------------------------*/
********************************************************************************


********************************************************************************
/*----------------------------BUKU 4 ASI--------------------------------------*/
use "$ifls4\b4_ch1"
rename ch27 pidanak
rename pidlink pidlinkibu
drop if mi(pidanak)
bysort hhid07 pidanak: gen id=cond(_N==1,0,_n)
drop if id>1
drop id
tempfile chanak
save "`chanak'",replace

use pidlink pid07 hhid07 umur_bulan_07 using "$main\anthrowave45.dta" 
rename pidlink pidlinkanak 
rename pid07 pidanak

merge 1:1 hhid07 pidanak using "`chanak'"
drop if _merge==2
*ada 59 observasi yang tidak ada datanya di CH
*drop _merge

gen durasi_ASI = umur_bulan if ch24ex==96 

replace durasi_ASI = ch24e if ch24ex==5
replace durasi_ASI=umur_bulan if umur_bulan<durasi_ASI&durasi_ASI!=.
replace durasi_ASI=0 if durasi_ASI==.&ch24a==3
replace durasi_ASI=ch24c if durasi_ASI==.
gen durasi_ASI2=durasi_ASI*durasi_ASI
keep hhid07 pidanak durasi_ASI durasi_ASI2
rename pidanak pid07
/*--------------------------LABELLING DDS--------------------------------------*/
la var durasi_ASI "Durasi Menyusui"
la var durasi_ASI2 "Kuadrat Durasi Menyusui"

tempfile asi
save "`asi'",replace
/*-----------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------*/
********************************************************************************



********************************************************************************
/*-------------------------BUKU 5 IMUNISASI------------------------------------*/
use pidlink pid07 hhid07 using "$main\anthrowave45.dta"
merge 1:1 pidlink using "$ifls4\b5_rja3.dta"
*ada 8 yg ga matched
keep if _merge==3
drop _merge

*koding BCG
gen bcg=rja28adb
replace bcg=1 if rja28adb>0|rja30a==1
replace bcg=0 if rja28adb==0|rja30a==3|rja30a==8

*koding campak
gen campak=rja28adk
replace campak=1 if rja28adk>0|rja30d==1
replace campak=0 if rja28adk==0|rja30d==3|rja30d==8

*koding polio
gen polio=.
*Polio 0
replace polio=1 if rja28adc>0
*Polio 1
replace polio=polio+1 if rja28add>0
*Polio 2
replace polio=polio+1 if rja28ade>0
*Polio 3
replace polio=polio+1 if rja28adg>0
*Polio 4
replace polio=polio+1 if rja28adf>0
*dianggap lengkap jika 5 kali menerima vaksin polio
*Probing polio
replace polio=rja30bn if mi(rja28add)|mi(rja28ade)|mi(rja28adf)|mi(rja28adg)
replace polio=0 if mi(polio)|polio==98
replace polio=5 if polio>5&polio!=98

*koding hepatitis B
gen hepB=.
*hepB 1
replace hepB=1 if rja28adl>0
*hepB 2
replace hepB=hepB+1 if rja28adm>0
*hepB 3
replace hepB=hepB+1 if rja28adn>0
*Probing HepB
replace hepB=rja30en if mi(rja28adl)|mi(rja28adm)|mi(rja28adn)
replace hepB=0 if mi(hepB)|hepB==98
replace hepB=3 if hepB>3

*koding DPT
gen dpt=.
*DPT 1
replace dpt=1 if rja28adh>0
*DPT 2
replace dpt=dpt+1 if rja28adi>0
*DPT 3
replace dpt=dpt+1 if rja28adj>0
*Probing DPT
replace dpt=rja30en if mi(rja28adh)|mi(rja28adi)|mi(rja28adj)
replace dpt=0 if mi(dpt)|dpt==98
replace dpt=3 if dpt>3

gen imun=0
replace imun=1 if campak==1&bcg==1&polio==5&hepB==3&dpt==3
keep pidlink pid07 hhid07 imun
/*--------------------------LABELLING IMUN-------------------------------------*/

la var imun "Status Imunisasi Dasar"
la def imun 1 "Lengkap" 0 "Tidak Lengkap"
la val imun imun

/*-----------------------------------------------------------------------------*/

tempfile imunisasi
save "`imunisasi'",replace
/*-----------------------------------------------------------------------------*/
********************************************************************************

********************************************************************************
/*------------------------SELF RATED HEALTH------------------------------------*/
*self rated health sebulan yang lalu
use pidlink pid07 hhid07 using "$main\anthrowave45.dta" 
merge 1:1 pidlink using "$ifls4\b5_maa1.dta"
drop if _merge==2
drop _merge
drop maa0bx maa0cx maa0c maa05aa maa05ab maa05ac maa05ad

*generate variabel kondisi kesehatan sebulan terakhir (1=tidak sehat, 0 =sehat)
*ada 12 data yang nilainya missing

gen self_health = 0 if maa0a==1 | maa0a==2
replace self_health = 1 if maa0a==3|maa0a==4
replace self_health = . if mi(maa0a)|maa0a==9
drop module version maa0d maa0b maa0a
/*--------------------------LABELLING SRH--------------------------------------*/
la var self_health "Kondisi kesehatan sebulan terakhir"
la def self_health 1 "Tidak sehat" 0 "Sehat"
la val self_health self_health
tempfile us_fma_maa
save "`us_fma_maa'",replace
/*-----------------------------------------------------------------------------*/
********************************************************************************

********************************************************************************
/*-------------------------BUKU AR KEGIATAN IBU--------------------------------*/
use pidlink pid07 hhid07 using "$main\anthrowave45.dta" 
merge 1:1 hhid07 pid07 using "$ifls4\bk_ar1"
keep if _merge==3
drop _merge
*mengambil data pid ibu ar11
keep pidlink pid07 hhid07 ar11
rename pid07 pidanak
 
*merge lagi dengan bk ar, mengambil data ar ibu
rename ar11 pid07
merge m:1 hhid07 pid07 using "$ifls4\bk_ar1"
keep if _merge==3
drop _merge
 
gen kerja=ar15c
replace kerja=0 if ar15c>1
replace kerja=1 if ar15c==1&ar15c==98
keep pidlink pid07 hhid07 kerja
/*--------------------------LABELLING --------------------------------------*/
la var kerja "Bekerja seminggu yang lalu"
la def kerja 1 "Kerja" 0 "Tidak Kerja"
la val kerja kerja
tempfile us_kerja
save "`us_kerja'",replace
/*-----------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------*/
********************************************************************************


********************************************************************************
/*---------------------------BUKU DL PENDIDIKAN IBU----------------------------*/
use pidlink pid07 hhid07 using "$main\anthrowave45.dta" 
merge 1:1 hhid07 pid07 using "$ifls4\bk_ar1"
keep if _merge==3
drop _merge

*mengambil data pid ibu ar11
keep pidlink pid07 hhid07 ar11
rename pid07 pidanak


*merge lagi dengan bk ar, mengambil data ar ibu
rename ar11 pid07

merge m:1 hhid07 pid07 using "$ifls4\b3a_dl1"
drop if _merge==2
drop _merge

keep hhid07 pid07 dl06 dl07 dl04 pidanak
gen leveldl=dl06
recode leveldl (1 90 2 11 72 =0) (3 4 12 73 =1)(5 6 74 9 13 60 61 62 63=2)(else=.)
replace leveldl=leveldl if dl07==7 & leveldl!=0 
replace leveldl=leveldl-1 if dl07<7 & leveldl!=0 
replace leveldl=leveldl-1 if dl07==96 & leveldl!=0 
replace leveldl=leveldl-1 if dl07==98 & leveldl!=0 
replace leveldl=0 if dl04==3 | dl04==8 | dl04==. /*tidak pernah  sekolah*/
ta leveldl, m

tempfile leveldl

save "`leveldl'",replace
*probing level pendidikan dari ar
merge m:1 hhid07 pid07 using "$ifls4\bk_ar1"
keep if _merge==3
drop _merge
keep hhid07 pid07 leveldl ar16 ar17 pidanak
gen levelar=ar16 
recode levelar (1 90 2 11 72 =0) (3 4 12 73 =1) (5 6 15 74 9 13 60 61 62 63=2)(else=.) 
replace levelar=levelar if ar17==7  & levelar!=0 
replace levelar=levelar-1 if ar17<7 & levelar!=0 
replace levelar=levelar-1 if ar17==96 & levelar!=0 
replace levelar=levelar-1 if ar17==98 & levelar!=0 
*generate variabel didik
gen didik=leveldl
replace didik=levelar if didik==.
ta didik,m

*17 ibu pendidikan pesantren dianggap data missing
*drop if didik==.
rename pid07 pidibu
rename pidanak pid07
/*--------------------------LABELLING --------------------------------------*/
la var didik "Tingkat Pendidikan Ibu"
la def didik 0 "Rendah" 1 "Menengah" 2 "Tinggi"
la val didik didik 
la val leveldl leveldl
la var leveldl "level pendidikan dari section dl"
la var levelar "level pendidikan dari section ar"
la val levelar levelar
/*-----------------------------------------------------------------------------*/
tempfile us_didik
save "`us_didik'",replace
********************************************************************************


********************************************************************************
/*---------------------------BUKU AR HHSIZE------------------------------------*/
use hhid07 using "$main\anthrowave45.dta" 
bysort hhid07:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:m hhid07 using "$ifls4\bk_ar1"
*matched semua
keep if _merge==3
drop _merge

keep if ar01a==1 | ar01a==2 |ar01a==5 | ar01a==11
bysort hhid07 : gen hh_size = _N

bysort hhid07:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

keep hhid07 hh_size
tempfile hhsize
save "`hhsize'"
/*-----------------------------------------------------------------------------*/
********************************************************************************

********************************************************************************
/*----------------------------NUCLEAR/EXTENDED---------------------------------*/
use hhid07 using "$main\anthrowave45.dta" 
bysort hhid07:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:m hhid07 using "$ifls4\bk_ar1"
*matched semua
keep if _merge==3
drop _merge

keep if ar01a==1 | ar01a==2 |ar01a==5 | ar01a==11
gen flag_extended=0
replace flag_extended=1 if ar02b>4
bysort hhid07 :egen sum_extended=sum(flag_extended)
gen extended=0
replace extended=1 if sum_extended>0

bysort hhid07:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

keep hhid07 extended
/*--------------------------LABELLING --------------------------------------*/
la var extended "Nuclear/extended family"
la def extended 0 "Nuclear" 1 "Extended"
la val extended extended
/*-----------------------------------------------------------------------------*/
tempfile hh_extended
save "`hh_extended'"
/*-----------------------------------------------------------------------------*/
********************************************************************************

********************************************************************************
/*---------------------------BANTUAN PEMERINTAH--------------------------------*/
*Membuat variabel pernah menerima bantuan BLT, pernah menerima bantuan PKH,
*diambil dari buku 1 (b1_ks1) dan buku 2 (b2_kr)

use hhid07 using "$main\anthrowave45.dta" 
bysort hhid07:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:m hhid07 using "$ifls4\b1_ksr1"
*2 ruta tidak matched
keep if _merge==3

encode ksr3type,gen(tipebantuan)
drop _merge version module _merge ksr3type
reshape wide ksr17 ksr18m ksr18y ksr19 ksr20x ksr21x ksr22m ksr22y ksr23x ksr20 ksr21 ksr23,i(hhid07) j(tipebantuan)

gen pernah_BLT=ksr171
*ada 1 yg missing value (9) --> dikoding tidak pernah BLT
recode pernah_BLT(3 9 =0)

gen pernah_PKH=ksr172
*ada 1 yg missing value (9) --> dikoding tidak pernah BLT
recode pernah_PKH (3 6 9=0)

gen pernah_BLTsetahun=ksr21x1
recode pernah_BLTsetahun (6 8 9 . = 0)

gen pernah_PKHsetahun=ksr21x2
recode pernah_PKHsetahun (6 9 . = 0)

gen pernah_subsidi=1 if pernah_BLT==1|pernah_PKH==1
replace pernah_subsidi=0 if pernah_subsidi==.

gen pernah_subsidisetahun=1 if pernah_BLTsetahun==1|pernah_PKHsetahun==1
replace pernah_subsidisetahun=0 if pernah_subsidisetahun==.
keep hhid07 pernah_BLT pernah_PKH pernah_BLTsetahun pernah_PKHsetahun pernah_subsidi pernah_subsidisetahun
tempfile bantuan1
save "`bantuan1'"
*-------------------------------------------------------------------------------*
use hhid07 using "$main\anthrowave45.dta" 
bysort hhid07:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:1 hhid07 using "$ifls4\b2_kr"
*2 ruta tidak matched
keep if _merge==3

gen kartu_sehat=kr26
recode kartu_sehat (3 9 = 0)

gen kartu_subsidi=kr27b
recode kartu_subsidi (3 8 = 0)
keep hhid07 kartu_sehat kartu_subsidi
merge 1:1 hhid07 using "`bantuan1'"
drop _merge
/*--------------------------LABELLING -----------------------------------------*/
la var pernah_BLT "Pernah Menerima BLT"
la def pernah_BLT 0 "Tidak" 1 "Pernah"
la val pernah_BLT pernah_BLT

la var pernah_PKH "Pernah Menerima PKH"
la def pernah_PKH 0 "Tidak" 1 "Pernah"
la val pernah_PKH pernah_PKH

la var pernah_PKHsetahun "Pernah Menerima PKH Setahun terakhir"
la def pernah_PKHsetahun 0 "Tidak" 1 "Pernah"
la val pernah_PKHsetahun pernah_PKHsetahun

la var pernah_BLTsetahun "Pernah Menerima BLT Setahun terakhir"
la def pernah_BLTsetahun 0 "Tidak" 1 "Pernah"
la val pernah_BLTsetahun pernah_BLTsetahun

la var pernah_subsidi "Pernah Menerima Bantuan Subsidi"
la def pernah_subsidi 0 "Tidak" 1 "Pernah"
la val pernah_subsidi pernah_subsidi

la var pernah_subsidisetahun "Pernah Menerima Bantuan Subsidi Setahun Terakhir"
la def pernah_subsidisetahun 0 "Tidak" 1 "Pernah"
la val pernah_subsidisetahun pernah_subsidisetahun

la var kartu_sehat "Memiliki Kartu Jaminan Kesehatan Untuk Org Miskin (ASKESKIN/Jamkesmas/BPJS/JKN)"
la def kartu_sehat 0 "Tidak" 1 "Punya"
la val kartu_sehat kartu_sehat

la var kartu_subsidi "Memiliki Kartu PKPS/BBM/BLT"
la def kartu_subsidi 0 "Tidak" 1 "Punya"
la val kartu_subsidi kartu_subsidi
/*-----------------------------------------------------------------------------*/
tempfile bantuan
save "`bantuan'"
/*-----------------------------------------------------------------------------*/
********************************************************************************

/*----------------------STATUS SANITASI&MINUM----------------------------------*/
use hhid07 using "$main\anthrowave45.dta" 
bysort hhid07:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:1 hhid07 using "$ifls4\b2_kr"
drop if _merge==2
drop _merge

gen sanitasi=0 if kr20!=1
replace sanitasi=1 if kr20==1

gen grup_sanitasi=0 if kr20==1|kr20==2
replace grup_sanitasi=1 if kr20==3|kr20==4
replace grup_sanitasi=2 if kr20>4&kr20!=.

gen minum=0
replace minum=1 if kr13==1
replace minum=2 if kr13==2
keep hhid07 sanitasi minum grup_sanitasi

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

********************************************************************************
/*-------------------------------WILAYAH TEMPAT TINGGAL------------------------*/
use hhid07 using "$main\anthrowave45.dta" 
bysort hhid07:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:1 hhid07 using "$ifls4\bk_sc"
keep if _merge==3
drop _merge

keep sc010707 sc020707 sc030707 hhid07 sc05
rename sc010707 kd_prov
rename sc020707 kd_kab
rename sc030707 kdkec
la var sc05 "Perkotaan/Perdesaan"
la def sc05 1 "Perkotaan" 0 "Perdesaan"
la val sc05 sc05

tempfile hh_wilayah
save "`hh_wilayah'"
/*-----------------------------------------------------------------------------*/
********************************************************************************

/*------------------------------EXPENDITURE------------------------------------*/
use hhid07 using "$main\anthrowave45.dta" 
bysort hhid07:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:m hhid07 using "$ifls4\b1_ks4"
*2 ruta tidak ada datanya
keep if _merge==3
drop _merge

keep if ks4type=="A"
keep hhid07 ks15

merge 1:m hhid07 using "$ifls4\b1_ks1"
keep if _merge==3
drop _merge

replace ks02=ks15/4 if ks1type=="A"&ks02==0

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
bysort hhid07 jenis : egen exp_jenis = sum(sum_jenis)
bysort hhid07: egen hh_food_exp = sum(sum_jenis)

gen ex_bijian =0
replace ex_bijian=exp_jenis if jenis==1
bysort hhid07 : egen exp_bijian=max(ex_bijian)

gen ex_daging = 0
replace ex_daging=exp_jenis if jenis==2
bysort hhid07 : egen exp_daging=max(ex_daging)

gen ex_buahsayur = 0
replace ex_buahsayur=exp_jenis if jenis==3
bysort hhid07 : egen exp_buahsayur=max(ex_buahsayur)

gen ex_kacang = 0
replace ex_kacang=exp_jenis if jenis==4
bysort hhid07 : egen exp_kacang=max(ex_kacang)

gen ex_telur = 0
replace ex_telur=exp_jenis if jenis==5
bysort hhid07 : egen exp_telur=max(ex_telur)

gen ex_susu = 0
replace ex_susu=exp_jenis if jenis==6
bysort hhid07 : egen exp_susu=max(ex_susu)

gen ex_minyaklemak= 0
replace ex_minyaklemak=exp_jenis if jenis==7
bysort hhid07 : egen exp_minyaklemak=max(ex_minyaklemak)

*membuat variabel pengeluaran berdasarkan 2 kelompok makanan, animal source food dan plant source food
gen jenis2=1 if ks1type=="K"|ks1type=="L"|ks1type=="M"
replace jenis2=2 if ks1type=="F"|ks1type=="H"|ks1type=="G"|ks1type=="OB"
replace jenis2=3 if ks1type=="A"|ks1type=="B"|ks1type=="C"|ks1type=="D"|ks1type=="E"|ks1type=="I"|ks1type=="J"
replace jenis2=4 if ks1type=="P"|ks1type=="Q"
replace jenis2=0 if jenis2==.


bysort hhid07 jenis2 : egen plant_animal = sum(sum_jenis)
gen animal_source = 0
replace animal_source=plant_animal if jenis2==1
bysort hhid07 : egen animal_foods=max(animal_source)
gen share_animalfoods=(animal_foods/hh_food_exp)*100

gen plant_source = 0
replace plant_source=plant_animal if jenis2==2
bysort hhid07 : egen plant_foods=max(plant_source)
gen share_plantfoods=(plant_foods/hh_food_exp)*100

gen grain_source = 0
replace grain_source=plant_animal if jenis2==3
bysort hhid07 : egen grain_foods=max(grain_source)
gen share_grainfoods=(grain_foods/hh_food_exp)*100

gen dairy_source = 0
replace dairy_source=plant_animal if jenis2==4
bysort hhid07 : egen dairy_foods=max(dairy_source)

merge m:1 hhid07 using "`hhsize'"

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
gen cap_foodexp = hh_food_exp/hh_size
gen cap_dairy = dairy_foods/hh_size

*mengambil data ruta aja
bysort hhid07:gen id=cond(_N==1,0,_n)
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
xtile kuin_foodexp = cap_foodexp,n(5)

*generate variabel share pengeluaran perjenis terhadap pengeluaran makanan
gen sharecap_animal = (cap_animalsource/cap_foodexp)*100
gen sharecap_plant = (cap_plantsource/cap_foodexp)*100
gen sharecap_grain = (cap_grainsource/cap_foodexp)*100
gen sharecap_susu = (cap_susu/cap_foodexp)*100
gen sharecap_telur = (cap_telur/cap_foodexp)*100
gen sharecap_daging = (cap_daging/cap_foodexp)*100
gen sharecap_dairy = (cap_dairy/cap_foodexp)*100

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
la var sharecap_animal "% Pengeluaran Per Kapita Animal Foods Source "
la var sharecap_plant "% Pengeluaran Per Kapita Plant Foods Source "
la var sharecap_grain "% Pengeluaran Per Kapita Grain Foods Source "

*keep hhid07 kuin_grain kuin_animal kuin_plant kuin_minyaklemak kuin_susu kuin_telur kuin_kacang kuin_buahsayur kuin_daging kuin_bijian cap_minyaklemak cap_susu cap_telur cap_kacang cap_buahsayur cap_daging cap_bijian hh_size exp_minyaklemak exp_susu exp_telur exp_kacang exp_buahsayur exp_daging exp_bijian plant_foods animal_foods cap_plantsource cap_animalsource cap_grainsource 
drop ks1type ks02x ks03x ks02 ks03 version module jenis sum_jenis exp_jenis

tempfile hhsize_exp
save "`hhsize_exp'",replace
/*-----------------------------------------------------------------------------*/

/*------------------------------EXPENDITURE 2----------------------------------*/
use hhid07 using "$main\anthrowave45.dta" 
bysort hhid07:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:m hhid07 using "`hhsize_exp'"
keep if _merge==3
drop _merge

keep hhid07 hh_food_exp hh_size
generate hh_food_exp_month = hh_food_exp*30/7 
tempfile food_month
save "`food_month'"

/*pengeluaran non makanan*/
use "$ifls4/b1_ks2"
replace ks06=0 if ks06==99999998
bysort hhid07: egen hh_nonfood=total(ks06)
bysort hhid07: keep if _n==1
merge 1:1 hhid07 using "`food_month'"
drop if _merge==1

egen hh_exp07=rowtotal(hh_food_exp_month hh_nonfood)
tempfile ks1_2_07
save "`ks1_2_07'"

gen exp_cap07=hh_exp07/hh_size
gen food_cap_month= hh_food_exp_month/hh_size
gen ratio_food=food_cap_month/ exp_cap07*100
keep hhid07 ratio_food
tempfile share_foodexp
save "`share_foodexp'"

/*---------------------------------DATA MAKRO----------------------------------*/
use hhid07 using "$main\anthrowave45.dta" 
bysort hhid07:gen id=cond(_N==1,0,_n)
drop if id>1
drop id

merge 1:1 hhid07 using "`hh_wilayah'"
keep if _merge==3
drop _merge

merge m:1 kd_prov kd_kab using "$main\makro07"
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
use "$main\anthrowave4.dta"
merge 1:1 pidlink using "`balita_fma07'"
keep if _merge==3
drop _merge

merge 1:1 pidlink using "`us_fma_maa'"
keep if _merge==3
drop _merge

merge 1:1 pidlink using "`imunisasi'"
keep if _merge==3
drop _merge

merge 1:1 hhid07 pid07 using "`asi'"
keep if _merge==3
drop _merge

merge 1:1 pidlink using "`us_kerja'"
keep if _merge==3
drop _merge

merge 1:1 hhid07 pid07 using "`us_didik'"
keep if _merge==3
drop _merge

merge m:1 hhid07 using "`hh_extended'"
keep if _merge==3
drop _merge

merge m:1 hhid07 using "`hh_sanitasiminum'"
keep if _merge==3
drop _merge

merge m:1 hhid07 using "`hh_wilayah'"
keep if _merge==3
drop _merge

merge m:1 hhid07 using "`hhsize_exp'"
keep if _merge==3
drop _merge

merge m:1 hhid07 using "`hh_makro'"
keep if _merge==3
drop _merge

merge m:1 hhid07 using "`bantuan'"
keep if _merge==3
drop _merge

merge m:1 hhid07 using "`share_foodexp'"
keep if _merge==3
drop _merge
/*----------------------------------------------------------------------------*/


gen tahun=2007
save "$main\balita_stunting07.dta",replace

