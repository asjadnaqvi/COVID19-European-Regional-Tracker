clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Latvia"




*** lau codes

import excel using LAU.xlsx, clear first
drop if lau_id==""
destring _all, replace
compress
save lau_latvia.dta, replace


**** change in data structure

*** file till end of June 2021 here:


**https://data.gov.lv/dati/lv/dataset/covid-19-pa-adm-terit/resource/492931dd-0012-46d7-b415-76fe0ec7c216
import delim using "https://data.gov.lv/dati/dataset/e150cc9a-27c1-4920-a6c2-d20d10469873/resource/492931dd-0012-46d7-b415-76fe0ec7c216/download/covid_19_pa_adm_terit.csv", clear 

cap drop v6 
cap drop v7 
cap drop v8

ren v1 date
ren v2 lau_name
ren v3 lau_id
ren v4 cases
ren v5 active

drop in 1

drop if lau_id=="Nav"

replace cases = "1" if cases=="no 1 līdz 5"
replace active = "1" if active=="no 1 līdz 5"
replace active = "" if active=="..."
replace active = "" if active=="…"


gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yy
order date

gen file = 1  // first file

destring _all, replace
save latvia1.dta, replace



*** file from July 2021 here:

insheet using "https://data.gov.lv/dati/dataset/e150cc9a-27c1-4920-a6c2-d20d10469873/resource/ba1fe21e-6308-491d-a4a0-27609122b441/download/covid_19_pa_adm_terit_new.csv", clear delim(;)

cap drop v6 
cap drop v7 
cap drop v8

ren v1 date
ren v2 lau_name
ren v3 lau_id
ren v4 cases
ren v5 active

drop in 1

drop if lau_id=="Nav"

replace cases = "1" if cases=="no 1 līdz 5"
replace active = "1" if active=="no 1 līdz 5"
replace active = "" if active=="..."
replace active = "" if active=="…"


gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yy
order date

*** strip the new ids to conform with LAU names

gen lau_id_new = lau_id
replace lau_id=""

sort lau_name date

// double check this
/*
replace lau_name = subinstr(lau_name, "pilsēta", "novads", .)

replace lau_name = "Valmiera" 	if lau_name=="Valmieras novads"
replace lau_name = "Liepāja" 	if lau_name=="Liepājas novads"
replace lau_name = "Jūrmala" 	if lau_name=="Jūrmalas novads"
replace lau_name = "Daugavpils" if lau_name=="Augšdaugavas novads"
replace lau_name = "Liepāja" 	if lau_name=="Dienvidkurzemes novads"
*/


duplicates tag lau_name date, gen(tag)
tab tag

drop tag

destring _all, replace

ren cases cases2
ren active active2

*collapse (sum) cases2 active (mean) lau_id_new, by(date lau_name lau_id)

gen file = 2  // second file


compress
save latvia2.dta, replace



*** merge the two files 

use latvia1, clear
merge 1:1 date lau_name using latvia2

sort lau_name date

drop _m




*bysort lau_name: carryforward lau_id, replace


*save "$coviddir/04_master/latvia_data_original.dta", replace
*export delimited using "$coviddir/04_master/csv_original/latvia_data_original.csv", replace delim(;)



*** merge with LAUs

merge m:1 lau_id using lau_latvia

tab lau_name _m
tab lau_name if _m==1



sort lau_name date

bysort lau_name: replace cases = cases2 + cases[_n-1] if cases2!=.


collapse (sum) cases cases2 , by(date nuts3_id) 





**** check gaps in data. if dates are skipped then there will be errors in daily cases

sort nuts3_id date
bysort nuts3_id: gen check = date - date[_n-1]

tab check

sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1] if check==1

drop check


order date nuts3_id
compress
save "$coviddir/04_master/latvia_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/latvia_data.csv", replace delim(;)


cd "$coviddir"


encode nuts3_id, gen(id)
xtset id date


xtline cases, overlay


