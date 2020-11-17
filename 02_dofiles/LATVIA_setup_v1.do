clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Latvia"




*** lau codes

import excel using LAU.xlsx, clear first
drop if lau_id==""
destring _all, replace
compress
save lau_latvia.dta, replace


**https://data.gov.lv/dati/lv/dataset/covid-19-pa-adm-terit/resource/492931dd-0012-46d7-b415-76fe0ec7c216
insheet using "https://data.gov.lv/dati/dataset/e150cc9a-27c1-4920-a6c2-d20d10469873/resource/492931dd-0012-46d7-b415-76fe0ec7c216/download/covid_19_pa_adm_terit.csv", clear delim(;)
save latvia_raw.dta, replace
export delimited using latvia_raw.csv, replace delim(;)


cap drop v6 v7 v8

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

destring _all, replace


merge m:1 lau_id using lau_latvia



gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yyyy
order date



collapse (sum) cases , by(date nuts3_id) cw

sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1]


order date nuts3_id
compress
save "$coviddir/04_master/latvia_data.dta", replace
export delimited using "$coviddir/04_master/csv/latvia_data.csv", replace delim(;)


cd "$coviddir"
