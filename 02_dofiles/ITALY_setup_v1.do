clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Italy"




****** NUTS3 codes

import excel "Italy_nuts.xlsx", first clear
carryforward NUTS*, replace
compress
save italy_nuts.dta, replace


********** at the NUTS3 level
insheet using "https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-province/dpc-covid19-ita-province.csv", nonames clear
save "$coviddir/04_master/italy_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/italy_data_original.csv", replace delim(;)


ren v1 date
ren v2 country
ren v3 region_id
ren v4 region_name
ren v5 province_id
ren v6 province_name
ren v7 province_abbrv

ren v8 latitude
ren v9 longitude
ren v10 cases


drop in 1
destring _all, replace

gen year = substr(date,1,4)
gen month = substr(date,6,2)
gen day = substr(date,9,2)

destring year month day, replace
ren date date2
gen date = mdy(month,day, year)

order date
format date %tdDD-Mon-yyyy
sort region_id date 

drop if province_id==991
drop if province_id==996

drop v11 day month year
drop date2

ren province_name NUTS3_name

** fixing some names
replace NUTS3_name = "Massa-Carrara" if NUTS3_name == "Massa Carrara"
replace NUTS3_name = "L’Aquila" if NUTS3_name == "L'Aquila"
replace NUTS3_name = "Reggio nell’Emilia" if NUTS3_name == "Reggio nell'Emilia"
replace NUTS3_name = "Valle d’Aosta/Vallée d’Aoste" if NUTS3_name == "Aosta"
replace NUTS3_name = "Bolzano-Bozen" if NUTS3_name == "Bolzano"

ren NUTS3_name nuts3_name

merge m:1 nuts3_name using nuts3_names

tab nuts3_name if _m==1
tab nuts3_name if _m==2
drop if _m!=3





*** at 2016 definitions

replace nuts3_id = "ITG25" if nuts3_id=="ITG2D" 
replace nuts3_id = "ITG26" if nuts3_id=="ITG2E" 
replace nuts3_id = "ITG27" if nuts3_id=="ITG2F" 
replace nuts3_id = "ITG28" if nuts3_id=="ITG2G"
replace nuts3_id = "ITG28" if nuts3_id=="ITG2H"
replace nuts3_id = "" if nuts3_id==""
replace nuts3_id = "" if nuts3_id==""
replace nuts3_id = "" if nuts3_id==""

collapse (sum) cases, by(nuts3_id date)


**** check gaps in data. if dates are skipped then there will be errors in daily cases

sort nuts3_id date
bysort nuts3_id: gen check = date - date[_n-1]

tab check

sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1] if check==1
drop check

compress
save "$coviddir/04_master/italy_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/italy_data.csv", replace delim(;)


cd "$coviddir"

