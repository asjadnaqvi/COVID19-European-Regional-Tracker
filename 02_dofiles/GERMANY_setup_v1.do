clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Germany"


****** getting the region codes in order (one time setup)

/*
import excel using "LAU_NUTS3.xlsx", first clear

drop LAUNAMENATIONAL LAUNAMELATIN

ren NUTS3CODE nuts3_id
ren LAUCODE lau
ren POPULATION population
ren TOTALAREAkm2 area_km2


gen region = substr(lau,1,5) 
destring region, replace
drop if region==.
drop lau
drop area_km2
order nuts3_id region

collapse (sum) population, by(nuts3_id region)

compress
save lau_germany.dta, replace
*/

********** Deaths

import delim using "https://raw.githubusercontent.com/jgehrcke/covid-19-germany-gae/master/deaths-rki-by-ags.csv", clear


foreach x of varlist v* {
     local t : var label `x'
     ren `x' v`t'
}

ren time_iso8601 date

gen year = substr(date,1,4)
gen month = substr(date,6,2)
gen day = substr(date,9,2)

destring year month day, replace
ren date date2
gen date = mdy(month,day, year)

order date
format date %tdDD-Mon-yy
sort date 

drop date2
drop year month day
drop sum_deaths
duplicates drop date, force

reshape long v, i(date) j(region)
ren v deaths
compress
save germany_deaths, replace



********************
**** cases data ****
********************


import delim using "https://raw.githubusercontent.com/jgehrcke/covid-19-germany-gae/master/cases-rki-by-ags.csv", clear




foreach x of varlist v* {
     local t : var label `x'
     ren `x' v`t'
}

ren time_iso8601 date

gen year = substr(date,1,4)
gen month = substr(date,6,2)
gen day = substr(date,9,2)

destring year month day, replace
ren date date2
gen date = mdy(month,day, year)

order date
format date %tdDD-Mon-yy
sort date 

drop date2
drop year month day
drop sum_cases
duplicates drop date, force

reshape long v, i(date) j(region)
ren v cases

compress
save germany_cases, replace
merge 1:1 date region using germany_deaths

drop _m


save "$coviddir/04_master/germany_data_original.dta", replace
export delimited using "$coviddir/04_master/csv_original/germany_data_original.csv", replace delim(;)



merge m:1 region using lau_germany.dta

tab region if _m==1
drop if _m!=3  // Berlin is split into finer units
drop _m


**** check gaps in data. if dates are skipped then there will be errors in daily cases

sort nuts3_id date
bysort nuts3_id: gen check = date - date[_n-1]

tab check



sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1] if check==1


sort nuts3_id date
bysort nuts3_id: gen deaths_daily = deaths - deaths[_n-1] if check==1

drop check


compress
order nuts3_id date
sort nuts3_id date 
compress
save "$coviddir/04_master/germany_data.dta", replace
export delimited using "$coviddir/04_master/csv_nuts/germany_data.csv", replace delim(;)


cd "$coviddir"

