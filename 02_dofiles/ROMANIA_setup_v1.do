clear
*global coviddir "D:/Programs/Dropbox/Dropbox/PROJECT COVID Europe"


cd "$coviddir/01_raw/Romania"

***** county_codes
import excel using romania_county_codes.xlsx, clear first
drop FIPS area_km2

compress
save county_code.dta, replace



*** data file: https://datelazi.ro/


**** here we use a file cleaned from a json reader

insheet using romania_cleaned.csv, clear
save romania_raw.dta, replace




drop county_

gen year  = substr(date, 7, 2)
gen month = substr(date, 4, 2)
gen day   = substr(date, 1, 2)

destring year month day, replace
replace year = year + 2000
drop date
gen date = mdy(month,day, year)
drop year month day
format date %tdDD-Mon-yyyy
order date
sort date



reshape long county_, i(date) j(cnty) string

ren county_ cases
ren cnty ISO
replace ISO = upper(ISO)


merge m:1 ISO using county_code.dta
drop _m

order nuts3_id date
sort nuts3_id date


sort nuts3_id date
bysort nuts3_id: gen cases_daily = cases - cases[_n-1]


order  nuts3_id date
sort  nuts3_id date 
compress
save "$coviddir/04_master/romania_data.dta", replace
export delimited using "$coviddir/04_master/csv/romania_data.csv", replace delim(;)


cd "$coviddir"
