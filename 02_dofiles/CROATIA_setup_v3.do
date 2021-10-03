clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir"


*** raw data

cd "./01_raw/Croatia"


***https://www.koronavirus.hr/podaci/otvoreni-strojno-citljivi-podaci/526
** data file: https://www.koronavirus.hr/json/?action=po_danima_zupanijama


copy "https://www.koronavirus.hr/json/?action=po_danima_zupanijama" "croatia_data.txt", replace


filefilter "croatia_data.txt" "croatia_data2.txt", from({) to(\M{) replace

infix str300 line 1-600 using "croatia_data2.txt", clear
compress


split line, p(",")

drop in 1


/*
ren PodaciDetaljno__broj_zarazenih	cases
ren PodaciDetaljno__broj_umrlih		deaths	
ren PodaciDetaljno__broj_aktivni	active
ren PodaciDetaljno__Zupanija		nuts3_name

*/

gen date = line3 if ustrregexm(line, "Datum")
gen temp = 1 if ustrregexm(line, "id")==1  // this line for deleting


ren line1 region
ren line2 cases
ren line3 deaths
ren line4 active




drop line*
split date, p(`"":"')
drop date date1
ren date2 date

carryforward date, replace
drop if region==""

drop if temp==1
drop temp


split cases, p(:)
drop cases cases1
ren cases2 cases

split deaths, p(:)
drop deaths deaths1
ren deaths2 deaths

split active, p(:)
drop active active1
ren active2 active

split region, p(:)
drop region1 region
ren region2 region

replace region = subinstr(region, `""}"',"",.)
replace region = subinstr(region, "]}", "",.)
replace region = subinstr(region, "]", "",.)
replace region = subinstr(region, "", "",.)
replace region = subinstr(region, `"""',"",.)  // " = char(34)
replace region = subinstr(region, char(34),"",.)  // " = char(34)
replace region = subinstr(region, "}", "",.)
replace region = trim(region)

replace active = subinstr(active, "}", "",.)
replace active = subinstr(active, "]", "",.)


destring _all, replace


save "$coviddir/04_master/croatia_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/croatia_data_original.csv", replace delim(;)




**** clean it up

gen year  = substr(date, 2, 4)
gen month = substr(date, 7, 2)
gen day   = substr(date, 10, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yyyy
order date

destring _all, replace


ren region nuts3_name

replace nuts3_name = subinstr(nuts3_name, "`=char(10)'", " ", .)
replace nuts3_name = trim(nuts3_name)


gen nuts3_id=""

replace nuts3_id="HR047" if nuts3_name=="Bjelovarsko-bilogorska"
replace nuts3_id="HR04A" if nuts3_name=="Brodsko-posavska"
replace nuts3_id="HR037" if nuts3_name=="Dubrovačko-neretvanska"
replace nuts3_id="HR041" if nuts3_name=="Grad Zagreb"
replace nuts3_id="HR036" if nuts3_name=="Istarska"
replace nuts3_id="HR04D" if nuts3_name=="Karlovačka"
replace nuts3_id="HR045" if nuts3_name=="Koprivničko-križevačka"
replace nuts3_id="HR043" if nuts3_name=="Krapinsko-zagorska"
replace nuts3_id="HR032" if nuts3_name=="Ličko-senjska"
replace nuts3_id="HR046" if nuts3_name=="Međimurska"
replace nuts3_id="HR04B" if nuts3_name=="Osječko-baranjska"
replace nuts3_id="HR049" if nuts3_name=="Požeško-slavonska"
replace nuts3_id="HR031" if nuts3_name=="Primorsko-goranska"
replace nuts3_id="HR04E" if nuts3_name=="Sisačko-moslavačka"
replace nuts3_id="HR035" if nuts3_name=="Splitsko-dalmatinska"
replace nuts3_id="HR044" if nuts3_name=="Varaždinska"
replace nuts3_id="HR048" if nuts3_name=="Virovitičko-podravska"
replace nuts3_id="HR04C" if nuts3_name=="Vukovarsko-srijemska"
replace nuts3_id="HR033" if nuts3_name=="Zadarska"
replace nuts3_id="HR042" if nuts3_name=="Zagrebačka " | nuts3_name=="Zagrebačka"
replace nuts3_id="HR034" if nuts3_name=="Šibensko-kninska"




sort  nuts3_id date
order nuts3_id nuts3_name date

**** check gaps in data. if dates are skipped then there will be errors in daily cases

sort nuts3_id date
bysort nuts3_id: gen check = date - date[_n-1]

tab check



****
sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1] if check==1
bysort nuts3_id: gen deaths_daily = deaths - deaths[_n-1] if check==1
drop check

compress
save "$coviddir/04_master/croatia_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/croatia_data.csv", replace delim(;)


cd "$coviddir"

