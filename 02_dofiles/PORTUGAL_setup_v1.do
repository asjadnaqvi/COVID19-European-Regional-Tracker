clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01 raw/Portugal"


** IDs

import excel using "https://github.com/bruno-leal/covid19-portugal-data/blob/master/portugal_municipalities.xlsx?raw=true", clear first
compress
save PT_regions.dta, replace




**** for old data to fill the gaps:
*insheet using "https://raw.githubusercontent.com/dssg-pt/covid19pt-data/master/data_concelhos.csv", clear non
*compress
*save PT_Data1.dta, replace


*for latest data:
**https://github.com/dssg-pt/covid19pt-data/blob/master/data_concelhos.csv

import excel using "https://github.com/bruno-leal/covid19-portugal-data/blob/master/time_series_covid19_portugal_confirmados_concelhos.xlsx?raw=true", clear first
save portugal_raw.dta, replace
export delimited using portugal_raw.csv, replace delim(;)



ren codigo code_lau


merge 1:1 code_lau using PT_regions

order code_nuts3
*ren code_nuts3 nuts3_id
drop code_district_island- _merge
compress

*save ./extracted/PT_Data2.dta, replace

foreach x of varlist _all {
	local header : var label `x'
	local header = subinstr("`header'","/","_", .)
	cap ren `x' y`header'
}

ren ycode_nuts3  nuts3_id 
ren ydistrito_ilha  distrito_ilha
ren ycodigo  code_lau
ren yconcelho concelho


destring _all, replace

reshape long y, i(nuts3_id distrito_ilha code_lau concelho) j(date) string

ren y cases   




gen year = substr(date,1,4)
gen month = substr(date,6,2)
gen day = substr(date,9,2)

destring year month day, replace
ren date date2
gen date = mdy(month,day, year)

order date
format date %tdDD-Mon-yyyy
sort date 

drop date2
drop year month day


collapse (sum) cases, by(nuts3_id date)

sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1] // there are some negative values in cases


*** last update to data was 26th Oct. Check.


order  nuts3_id date
sort  nuts3_id date 
compress
save "$coviddir/04 master/portugal_data.dta", replace
export delimited using "$coviddir/04 master/csv/portugal_data.csv", replace delim(;)



cd "$coviddir"

