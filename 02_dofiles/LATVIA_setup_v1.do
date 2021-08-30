clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Latvia"




*** lau codes

import excel using LAU.xlsx, clear first
drop if lau_id==""
destring _all, replace
compress
save lau_latvia.dta, replace



// new file post July 2021 that still needs to be incorporated:
*insheet using "https://data.gov.lv/dati/dataset/e150cc9a-27c1-4920-a6c2-d20d10469873/resource/ba1fe21e-6308-491d-a4a0-27609122b441/download/covid_19_pa_adm_terit_new.csv", clear delim(;)


// original file

**https://data.gov.lv/dati/lv/dataset/covid-19-pa-adm-terit/resource/492931dd-0012-46d7-b415-76fe0ec7c216
import delim using "https://data.gov.lv/dati/dataset/e150cc9a-27c1-4920-a6c2-d20d10469873/resource/492931dd-0012-46d7-b415-76fe0ec7c216/download/covid_19_pa_adm_terit.csv", clear 


save "$coviddir/04_master/latvia_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/latvia_data_original.csv", replace delim(;)


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


destring _all, replace


merge m:1 lau_id using lau_latvia



gen year  = substr(date, 1, 4)
gen month = substr(date, 6, 2)
gen day   = substr(date, 9, 2)

destring year month day, replace
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yy
order date



collapse (sum) cases , by(date nuts3_id) 


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
